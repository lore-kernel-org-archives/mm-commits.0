From: akpm@linux-foundation.org
Subject: + sys_swapon-remove-did_down-variable.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:04 -0800
Message-ID: <201103072210.p27MA4ND030004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756646Ab1CGWNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     sys_swapon: remove did_down variable
has been added to the -mm tree.  Its filename is
     sys_swapon-remove-did_down-variable.patch

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
Subject: sys_swapon: remove did_down variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since mutex_lock(&inode->i_mutex) is called just after setting inode,
did_down is always equivalent to (inode && S_ISREG(inode->i_mode)).

Use this fact to remove the did_down variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-did_down-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-did_down-variable
+++ a/mm/swapfile.c
@@ -1907,7 +1907,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
-	int did_down = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1962,7 +1961,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-		did_down = 1;
 		if (IS_SWAPFILE(inode)) {
 			error = -EBUSY;
 			goto bad_swap;
@@ -2163,7 +2161,7 @@ out:
 	}
 	if (name)
 		putname(name);
-	if (did_down) {
+	if (inode && S_ISREG(inode->i_mode)) {
 		if (!error)
 			inode->i_flags |= S_SWAPFILE;
 		mutex_unlock(&inode->i_mutex);
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

