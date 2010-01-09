From: akpm@linux-foundation.org
Subject: + mm-add-swap-slot-free-callback-to-block_device_operations.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:10:02 -0800
Message-ID: <201001090010.o090A2WE022645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab0AIALL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:11:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ngupta@vflare.org, andi@firstfloor.org, greg@kroah.com, hch@infradead.org, hugh.dickins@tiscali.co.uk, jens.axboe@oracle.com, penberg@cs.helsinki.fi, viro@ZenIV.linux.org.uk


The patch titled
     mm: add swap slot free callback to block_device_operations
has been added to the -mm tree.  Its filename is
     mm-add-swap-slot-free-callback-to-block_device_operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    1 +
 mm/swapfile.c          |    3 +++
 2 files changed, 4 insertions(+)

diff -puN include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/include/linux/blkdev.h
@@ -1296,6 +1296,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
 
diff -puN mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations mm/swapfile.c
--- a/mm/swapfile.c~mm-add-swap-slot-free-callback-to-block_device_operations
+++ a/mm/swapfile.c
@@ -575,6 +575,7 @@ static unsigned char swap_entry_free(str
 
 	/* free if no reference */
 	if (!usage) {
+		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -584,6 +585,8 @@ static unsigned char swap_entry_free(str
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (disk->fops->swap_slot_free_notify)
+			disk->fops->swap_slot_free_notify(p->bdev, offset);
 	}
 
 	return usage;
_

Patches currently in -mm which might be from ngupta@vflare.org are

mm-add-swap-slot-free-callback-to-block_device_operations.patch
ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch

