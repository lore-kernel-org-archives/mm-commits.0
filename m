From: akpm@linux-foundation.org
Subject: + mm-remove-compressed-copy-from-zram-in-memory.patch added to -mm tree
Date: Thu, 09 May 2013 11:25:45 -0700
Message-ID: <20130509182545.91A505A4137@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40303 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EISZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:25:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so342302qae.1
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:25:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, dan.magenheimer@oracle.com, hughd@google.com, konrad@darnok.org, ngupta@vflare.org, shli@kernel.org, sjenning@linux.vnet.ibm.com


The patch titled
     Subject: mm: remove compressed copy from zram in-memory
has been added to the -mm tree.  Its filename is
     mm-remove-compressed-copy-from-zram-in-memory.patch

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

* changelog from v3
  * Rebased on next-20130508

* changelog from v1
  * Add more comment

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

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
@@ -81,8 +82,42 @@ void end_swap_bio_read(struct bio *bio,
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
 	} else {
+		struct swap_info_struct *sis;
+
 		SetPageUptodate(page);
+		sis = page_swap_info(page);
+		if (sis->flags & SWP_BLKDEV) {
+			/*
+			 * Swap subsystem does lazy swap slot free with
+			 * expecting the page would be swapped out again
+			 * so we can avoid unnecessary write if the page
+			 * isn't redirty.
+			 * It's good for real swap storage  because we can
+			 * reduce unnecessary I/O and enhance wear-leveling
+			 * if you use SSD as swap device.
+			 * But if you use in-memory swap device(ex, zram),
+			 * it causes duplicated copy between uncompressed
+			 * data in VM-owned memory and compressed data in
+			 * zram-owned memory. So let's free zram-owned memory
+			 * and make the VM-owned decompressed page *dirty*
+			 * so the page should be swap out somewhere again if
+			 * we want to reclaim it, again.
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
 	}
+
 	unlock_page(page);
 	bio_put(bio);
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

