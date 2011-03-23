From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-separate-bdev-claim-and-inode-lock.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:36 -0700
Message-ID: <201103232041.p2NKfCso028615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933409Ab1CWUlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: separate bdev claim and inode lock
has been removed from the -mm tree.  Its filename was
     sys_swapon-separate-bdev-claim-and-inode-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: separate bdev claim and inode lock
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the code which claims the bdev (S_ISBLK) or locks the inode
(S_ISREG) to a separate function. Only code movement, no functional
changes.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   64 +++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-separate-bdev-claim-and-inode-lock mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-separate-bdev-claim-and-inode-lock
+++ a/mm/swapfile.c
@@ -1889,6 +1889,43 @@ static struct swap_info_struct *alloc_sw
 	return p;
 }
 
+static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
+{
+	int error;
+
+	if (S_ISBLK(inode->i_mode)) {
+		p->bdev = bdgrab(I_BDEV(inode));
+		error = blkdev_get(p->bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+				   sys_swapon);
+		if (error < 0) {
+			p->bdev = NULL;
+			error = -EINVAL;
+			goto bad_swap;
+		}
+		p->old_block_size = block_size(p->bdev);
+		error = set_blocksize(p->bdev, PAGE_SIZE);
+		if (error < 0)
+			goto bad_swap;
+		p->flags |= SWP_BLKDEV;
+	} else if (S_ISREG(inode->i_mode)) {
+		p->bdev = inode->i_sb->s_bdev;
+		mutex_lock(&inode->i_mutex);
+		if (IS_SWAPFILE(inode)) {
+			error = -EBUSY;
+			goto bad_swap;
+		}
+	} else {
+		error = -EINVAL;
+		goto bad_swap;
+	}
+
+	return 0;
+
+bad_swap:
+	return error;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -1942,32 +1979,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
-	if (S_ISBLK(inode->i_mode)) {
-		p->bdev = bdgrab(I_BDEV(inode));
-		error = blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
-		if (error < 0) {
-			p->bdev = NULL;
-			error = -EINVAL;
-			goto bad_swap;
-		}
-		p->old_block_size = block_size(p->bdev);
-		error = set_blocksize(p->bdev, PAGE_SIZE);
-		if (error < 0)
-			goto bad_swap;
-		p->flags |= SWP_BLKDEV;
-	} else if (S_ISREG(inode->i_mode)) {
-		p->bdev = inode->i_sb->s_bdev;
-		mutex_lock(&inode->i_mutex);
-		if (IS_SWAPFILE(inode)) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	} else {
-		error = -EINVAL;
+	error = claim_swapfile(p, inode);
+	if (unlikely(error))
 		goto bad_swap;
-	}
 
 	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

