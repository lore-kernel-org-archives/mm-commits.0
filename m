From: akpm@linux-foundation.org
Subject: + zram-revive-swap_slot_free_notify.patch added to -mm tree
Date: Mon, 21 Mar 2016 13:37:54 -0700
Message-ID: <56f05ba2.RRoL+r+f+pFRLciM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbcCUUhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 16:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, chan.jeong@lge.com, karam.lee@lge.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: revive swap_slot_free_notify
has been added to the -mm tree.  Its filename is
     zram-revive-swap_slot_free_notify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-revive-swap_slot_free_notify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-revive-swap_slot_free_notify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: revive swap_slot_free_notify

b430e9d1c6d4 ("remove compressed copy from zram in-memory") applied
swap_slot_free_notify call in *end_swap_bio_read* to remove duplicated
memory between zram and memory.

However, with the introduction of rw_page in zram: 8c7f01025f7b ("zram:
implement rw_page operation of zram"), it became void because rw_page
doesn't need bio.

This patch restores the function for rw_page.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: karam.lee <karam.lee@lge.com>
Cc: <sangseok.lee@lge.com>
Cc: Chan Jeong <chan.jeong@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   93 ++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff -puN mm/page_io.c~zram-revive-swap_slot_free_notify mm/page_io.c
--- a/mm/page_io.c~zram-revive-swap_slot_free_notify
+++ a/mm/page_io.c
@@ -66,6 +66,54 @@ void end_swap_bio_write(struct bio *bio)
 	bio_put(bio);
 }
 
+static void swap_slot_free_notify(struct page *page)
+{
+	struct swap_info_struct *sis;
+	struct gendisk *disk;
+
+	/*
+	 * There is no guarantee that the page is in swap cache - the software
+	 * suspend code (at least) uses end_swap_bio_read() against a non-
+	 * swapcache page.  So we must check PG_swapcache before proceeding with
+	 * this optimization.
+	 */
+	if (unlikely(!PageSwapCache(page)))
+		return;
+
+	sis = page_swap_info(page);
+	if (!(sis->flags & SWP_BLKDEV))
+		return;
+
+	/*
+	 * The swap subsystem performs lazy swap slot freeing,
+	 * expecting that the page will be swapped out again.
+	 * So we can avoid an unnecessary write if the page
+	 * isn't redirtied.
+	 * This is good for real swap storage because we can
+	 * reduce unnecessary I/O and enhance wear-leveling
+	 * if an SSD is used as the as swap device.
+	 * But if in-memory swap device (eg zram) is used,
+	 * this causes a duplicated copy between uncompressed
+	 * data in VM-owned memory and compressed data in
+	 * zram-owned memory.  So let's free zram-owned memory
+	 * and make the VM-owned decompressed page *dirty*,
+	 * so the page should be swapped out somewhere again if
+	 * we again wish to reclaim it.
+	 */
+	disk = sis->bdev->bd_disk;
+	if (disk->fops->swap_slot_free_notify) {
+		swp_entry_t entry;
+		unsigned long offset;
+
+		entry.val = page_private(page);
+		offset = swp_offset(entry);
+
+		SetPageDirty(page);
+		disk->fops->swap_slot_free_notify(sis->bdev,
+				offset);
+	}
+}
+
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -81,49 +129,7 @@ static void end_swap_bio_read(struct bio
 	}
 
 	SetPageUptodate(page);
-
-	/*
-	 * There is no guarantee that the page is in swap cache - the software
-	 * suspend code (at least) uses end_swap_bio_read() against a non-
-	 * swapcache page.  So we must check PG_swapcache before proceeding with
-	 * this optimization.
-	 */
-	if (likely(PageSwapCache(page))) {
-		struct swap_info_struct *sis;
-
-		sis = page_swap_info(page);
-		if (sis->flags & SWP_BLKDEV) {
-			/*
-			 * The swap subsystem performs lazy swap slot freeing,
-			 * expecting that the page will be swapped out again.
-			 * So we can avoid an unnecessary write if the page
-			 * isn't redirtied.
-			 * This is good for real swap storage because we can
-			 * reduce unnecessary I/O and enhance wear-leveling
-			 * if an SSD is used as the as swap device.
-			 * But if in-memory swap device (eg zram) is used,
-			 * this causes a duplicated copy between uncompressed
-			 * data in VM-owned memory and compressed data in
-			 * zram-owned memory.  So let's free zram-owned memory
-			 * and make the VM-owned decompressed page *dirty*,
-			 * so the page should be swapped out somewhere again if
-			 * we again wish to reclaim it.
-			 */
-			struct gendisk *disk = sis->bdev->bd_disk;
-			if (disk->fops->swap_slot_free_notify) {
-				swp_entry_t entry;
-				unsigned long offset;
-
-				entry.val = page_private(page);
-				offset = swp_offset(entry);
-
-				SetPageDirty(page);
-				disk->fops->swap_slot_free_notify(sis->bdev,
-						offset);
-			}
-		}
-	}
