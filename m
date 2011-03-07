From: akpm@linux-foundation.org
Subject: + sys_swapon-simplify-error-flow-in-alloc_swap_info.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:09:57 -0800
Message-ID: <201103072209.p27M9wYc029981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab1CGWK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org


The patch titled
     sys_swapon: simplify error flow in alloc_swap_info()
has been added to the -mm tree.  Its filename is
     sys_swapon-simplify-error-flow-in-alloc_swap_info.patch

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
Subject: sys_swapon: simplify error flow in alloc_swap_info()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-flow-in-alloc_swap_info mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-flow-in-alloc_swap_info
+++ a/mm/swapfile.c
@@ -1848,7 +1848,6 @@ static struct swap_info_struct *alloc_sw
 {
 	struct swap_info_struct *p;
 	unsigned int type;
-	int error;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -1859,11 +1858,10 @@ static struct swap_info_struct *alloc_sw
 		if (!(swap_info[type]->flags & SWP_USED))
 			break;
 	}
-	error = -EPERM;
 	if (type >= MAX_SWAPFILES) {
 		spin_unlock(&swap_lock);
 		kfree(p);
-		goto out;
+		return ERR_PTR(-EPERM);
 	}
 	if (type >= nr_swapfiles) {
 		p->type = type;
@@ -1889,9 +1887,6 @@ static struct swap_info_struct *alloc_sw
 	spin_unlock(&swap_lock);
 
 	return p;
-
-out:
-	return ERR_PTR(error);
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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

