From: akpm@linux-foundation.org
Subject: [merged] mm-remove-compressed-copy-from-zram-in-memory.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:01 -0700
Message-ID: <51db11d1.IFlDiOnhAu1IM9we%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GHTYC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, shli@kernel.org, ngupta@vflare.org, konrad@darnok.org, hughd@google.com, dan.magenheimer@oracle.com, artem.savkov@gmail.com, minchan@kernel.org

Subject: [merged] mm-remove-compressed-copy-from-zram-in-memory.patch removed from -mm tree
To: minchan@kernel.org,artem.savkov@gmail.com,dan.magenheimer@oracle.com,hughd@google.com,konrad@darnok.org,ngupta@vflare.org,shli@kernel.org,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:01 -0700


The patch titled
     Subject: mm: remove compressed copy from zram in-memory
has been removed from the -mm tree.  Its filename was
     mm-remove-compressed-copy-from-zram-in-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove compressed copy from zram in-memory

Swap subsystem does lazy swap slot free with expecting the page would be
swapped out again so we can avoid unnecessary write.

But the problem in in-memory swap(ex, zram) is that it consumes memory
space until vm_swap_full(ie, used half of all of swap device) condition
meet.  It could be bad if we use multiple swap device, small in-memory
swap and big storage swap or in-memory swap alone.

This patch makes swap subsystem free swap slot as soon as swap-read is
completed and make the swapcache page dirty so the page should be written
out the swap device to reclaim it.  It means we never lose it.

I tested this patch with kernel compile workload.

1. before

compile time : 9882.42
zram max wasted space by fragmentation: 13471881 byte
memory space consumed by zram: 174227456 byte
the number of slot free notify: 206684

2. after

compile time : 9653.90
zram max wasted space by fragmentation: 11805932 byte
memory space consumed by zram: 154001408 byte
the number of slot free notify: 426972

[akpm@linux-foundation.org: tweak comment text]
[artem.savkov@gmail.com: fix BUG due to non-swapcache pages in end_swap_bio_read()]
[akpm@linux-foundation.org: invert unlikely() test, augment comment, 80-col cleanup]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff -puN mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory mm/page_io.c
--- a/mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory
+++ a/mm/page_io.c
@@ -21,6 +21,7 @@
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
 #include <linux/aio.h>
+#include <linux/blkdev.h>
 #include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
@@ -80,9 +81,54 @@ void end_swap_bio_read(struct bio *bio,
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
-	} else {
-		SetPageUptodate(page);
+		goto out;
 	}
+
+	SetPageUptodate(page);
+
+	/*
+	 * There is no guarantee that the page is in swap cache - the software
+	 * suspend code (at least) uses end_swap_bio_read() against a non-
+	 * swapcache page.  So we must check PG_swapcache before proceeding with
+	 * this optimization.
+	 */
+	if (likely(PageSwapCache(page))) {
+		struct swap_info_struct *sis;
+
+		sis = page_swap_info(page);
+		if (sis->flags & SWP_BLKDEV) {
+			/*
+			 * The swap subsystem performs lazy swap slot freeing,
+			 * expecting that the page will be swapped out again.
+			 * So we can avoid an unnecessary write if the page
+			 * isn't redirtied.
+			 * This is good for real swap storage because we can
+			 * reduce unnecessary I/O and enhance wear-leveling
+			 * if an SSD is used as the as swap device.
+			 * But if in-memory swap device (eg zram) is used,
+			 * this causes a duplicated copy between uncompressed
+			 * data in VM-owned memory and compressed data in
+			 * zram-owned memory.  So let's free zram-owned memory
+			 * and make the VM-owned decompressed page *dirty*,
+			 * so the page should be swapped out somewhere again if
+			 * we again wish to reclaim it.
+			 */
+			struct gendisk *disk = sis->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify) {
+				swp_entry_t entry;
+				unsigned long offset;
+
+				entry.val = page_private(page);
+				offset = swp_offset(entry);
+
+				SetPageDirty(page);
+				disk->fops->swap_slot_free_notify(sis->bdev,
+						offset);
+			}
+		}
+	}
+
+out:
 	unlock_page(page);
 	bio_put(bio);
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

