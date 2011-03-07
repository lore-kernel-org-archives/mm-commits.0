From: akpm@linux-foundation.org
Subject: + sys_swapon-separate-bdev-claim-and-inode-lock.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:12 -0800
Message-ID: <201103072210.p27MACjw030016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1CGWPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:15:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     sys_swapon: separate bdev claim and inode lock
has been added to the -mm tree.  Its filename is
     sys_swapon-separate-bdev-claim-and-inode-lock.patch

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

sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch

