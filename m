From: akpm@linux-foundation.org
Subject: [folded] mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch removed from -mm tree
Date: Mon, 01 Mar 2010 15:31:57 -0800
Message-ID: <201003012331.o21NVvNX006274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235Ab0CAXcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 18:32:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ngupta@vflare.org, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm-add-swap-slot-free-callback-to-block_device_operations-fix
has been removed from the -mm tree.  Its filename was
     mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch

This patch was dropped because it was folded into mm-add-swap-slot-free-callback-to-block_device_operations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-swap-slot-free-callback-to-block_device_operations-fix
From: Nitin Gupta <ngupta@vflare.org>

A block device makes swap_slot_free_notify() callback when the last
reference to a swap slot is dropped.

This callback is made under swap_lock and sometimes page table lock.  This
is a note of warning for registered callback function which must meet
these constraints.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations-fix include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations-fix
+++ a/include/linux/blkdev.h
@@ -1310,6 +1310,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
_

Patches currently in -mm which might be from ngupta@vflare.org are

mm-add-swap-slot-free-callback-to-block_device_operations.patch
mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch
linux-next.patch
mm-swapfilec-fix-swapon-size-off-by-one.patch

