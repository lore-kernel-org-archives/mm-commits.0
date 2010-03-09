From: akpm@linux-foundation.org
Subject: [nacked] mm-add-swap-slot-free-callback-to-block_device_operations.patch removed from -mm tree
Date: Tue, 09 Mar 2010 14:30:27 -0800
Message-ID: <201003092230.o29MUSRB008857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab0CIWbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 17:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ngupta@vflare.org, andi@firstfloor.org, greg@kroah.com, hch@infradead.org, hugh.dickins@tiscali.co.uk, jens.axboe@oracle.com, penberg@cs.helsinki.fi, viro@ZenIV.linux.org.uk, mm-commi


The patch titled
     mm: add swap slot free callback to block_device_operations
has been removed from the -mm tree.  Its filename was
     mm-add-swap-slot-free-callback-to-block_device_operations.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add swap slot free callback to block_device_operations
From: Nitin Gupta <ngupta@vflare.org>

This callback is required when RAM based devices are used as swap disks. 
One such device is ramzswap[1] which is used as compressed in-memory swap
disk.  For such devices, we need a callback as soon as a swap slot is no
longer used to allow freeing memory allocated for this slot.  Without this
callback, stale data can quickly accumulate in memory defeating the whole
purpose of such devices.

Another user of this callback will be "preswap" as introduced by
"Transcendent Memory" patches: http://lwn.net/Articles/367286/ (I intend
to integrade preswap with ramzswap).

[1] ramzswap: http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    2 ++
 mm/swapfile.c          |    3 +++
 2 files changed, 5 insertions(+)

diff -puN include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/include/linux/blkdev.h
@@ -1310,6 +1310,8 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and sometimes page table lock held */
+	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
 
diff -puN mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations mm/swapfile.c
--- a/mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/mm/swapfile.c
@@ -574,6 +574,7 @@ static unsigned char swap_entry_free(str
 
 	/* free if no reference */
 	if (!usage) {
+		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -583,6 +584,8 @@ static unsigned char swap_entry_free(str
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (disk->fops->swap_slot_free_notify)
+			disk->fops->swap_slot_free_notify(p->bdev, offset);
 	}
 
 	return usage;
_

Patches currently in -mm which might be from ngupta@vflare.org are

linux-next.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch

