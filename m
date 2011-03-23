From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-remove-bdev-variable.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:30 -0700
Message-ID: <201103232041.p2NKf6qi028603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200Ab1CWUzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: remove bdev variable
has been removed from the -mm tree.  Its filename was
     sys_swapon-remove-bdev-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove bdev variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The bdev variable is always equivalent to (S_ISBLK(inode->i_mode) ?
p->bdev : NULL), as long as it being set is moved to a bit earlier. Use
this fact to remove the bdev variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-bdev-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-bdev-variable
+++ a/mm/swapfile.c
@@ -1893,7 +1893,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 {
 	struct swap_info_struct *p;
 	char *name;
-	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
 	int i, prev;
@@ -1944,19 +1943,19 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	if (S_ISBLK(inode->i_mode)) {
-		bdev = bdgrab(I_BDEV(inode));
-		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+		p->bdev = bdgrab(I_BDEV(inode));
+		error = blkdev_get(p->bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
 				   sys_swapon);
 		if (error < 0) {
-			bdev = NULL;
+			p->bdev = NULL;
 			error = -EINVAL;
 			goto bad_swap;
 		}
-		p->old_block_size = block_size(bdev);
-		error = set_blocksize(bdev, PAGE_SIZE);
+		p->old_block_size = block_size(p->bdev);
+		error = set_blocksize(p->bdev, PAGE_SIZE);
 		if (error < 0)
 			goto bad_swap;
-		p->bdev = bdev;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
@@ -2140,9 +2139,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = 0;
 	goto out;
 bad_swap:
-	if (bdev) {
-		set_blocksize(bdev, p->old_block_size);
-		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	if (S_ISBLK(inode->i_mode) && p->bdev) {
+		set_blocksize(p->bdev, p->old_block_size);
+		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

