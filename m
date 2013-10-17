From: akpm@linux-foundation.org
Subject: [merged] swap-fix-set_blocksize-race-during-swapon-swapoff.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:29 -0700
Message-ID: <526028c9.D6AJEInUE4ssgNzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab3JQSNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang.kh@gmail.com, shli@fusionio.com, minchan@kernel.org, konrad.wilk@oracle.com, hughd@google.com, bob.liu@oracle.com, k.kozlowski@samsung.com

Subject: [merged] swap-fix-set_blocksize-race-during-swapon-swapoff.patch removed from -mm tree
To: k.kozlowski@samsung.com,bob.liu@oracle.com,hughd@google.com,konrad.wilk@oracle.com,minchan@kernel.org,shli@fusionio.com,weijie.yang.kh@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:29 -0700


The patch titled
     Subject: swap: fix set_blocksize race during swapon/swapoff
has been removed from the -mm tree.  Its filename was
     swap-fix-set_blocksize-race-during-swapon-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: swap: fix set_blocksize race during swapon/swapoff

Fix race between swapoff and swapon.  Swapoff used old_block_size from
swap_info outside of swapon_mutex so it could be overwritten by concurrent
swapon.

The race has visible effect only if more than one swap block device exists
with different block sizes (e.g.  /dev/sda1 with block size 4096 and
/dev/sdb1 with 512).  In such case it leads to setting the blocksize of
swapped off device with wrong blocksize.

The bug can be triggered with multiple concurrent swapoff and swapon:
0. Swap for some device is on.
1. swapoff:
First the swapoff is called on this device and "struct swap_info_struct
*p" is assigned. This is done under swap_lock however this lock is
released for the call try_to_unuse().

2. swapon:
After the assignment above (and before acquiring swapon_mutex &
swap_lock by swapoff) the swapon is called on the same device.
The p->old_block_size is assigned to the value of block_size the device.
This block size should be the same as previous but sometimes it is not.
The swapon ends successfully.

3. swapoff:
Swapoff resumes, grabs the locks and mutex and continues to disable this
swap device. Now it sets the block size to value taken from swap_info
which was overwritten by swapon in 2.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~swap-fix-set_blocksize-race-during-swapon-swapoff mm/swapfile.c
--- a/mm/swapfile.c~swap-fix-set_blocksize-race-during-swapon-swapoff
+++ a/mm/swapfile.c
@@ -1824,6 +1824,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct filename *pathname;
 	int i, type, prev;
 	int err;
+	unsigned int old_block_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1914,6 +1915,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 
 	swap_file = p->swap_file;
+	old_block_size = p->old_block_size;
 	p->swap_file = NULL;
 	p->max = 0;
 	swap_map = p->swap_map;
@@ -1938,7 +1940,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
-		set_blocksize(bdev, p->old_block_size);
+		set_blocksize(bdev, old_block_size);
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	} else {
 		mutex_lock(&inode->i_mutex);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
frontswap-enable-call-to-invalidate-area-on-swapoff.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch

