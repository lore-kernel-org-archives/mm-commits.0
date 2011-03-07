From: akpm@linux-foundation.org
Subject: + sys_swapon-do-not-depend-on-type-after-allocation.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:09:50 -0800
Message-ID: <201103072209.p27M9o3v029972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540Ab1CGWKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:10:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujisu.com, penberg@kernel.org


The patch titled
     sys_swapon: do not depend on "type" after allocation
has been added to the -mm tree.  Its filename is
     sys_swapon-do-not-depend-on-type-after-allocation.patch

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
Subject: sys_swapon: do not depend on "type" after allocation
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Within sys_swapon, after the swap_info entry has been allocated, we
always have type == p->type and swap_info[type] == p. Use this fact to
reduce the dependency on the "type" local variable within the function,
as a preparation to move the allocation of the swap_info entry to a
separate function.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-do-not-depend-on-type-after-allocation mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-do-not-depend-on-type-after-allocation
+++ a/mm/swapfile.c
@@ -1927,7 +1927,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
-		if (i == type || !q->swap_file)
+		if (q == p || !q->swap_file)
 			continue;
 		if (mapping == q->swap_file->f_mapping)
 			goto bad_swap;
@@ -2062,7 +2062,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		}
 	}
 
-	error = swap_cgroup_swapon(type, maxpages);
+	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
 		goto bad_swap;
 
@@ -2120,9 +2120,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 	p->next = i;
 	if (prev < 0)
-		swap_list.head = swap_list.next = type;
+		swap_list.head = swap_list.next = p->type;
 	else
-		swap_info[prev]->next = type;
+		swap_info[prev]->next = p->type;
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
@@ -2136,7 +2136,7 @@ bad_swap:
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
-	swap_cgroup_swapoff(type);
+	swap_cgroup_swapoff(p->type);
 bad_swap_2:
 	spin_lock(&swap_lock);
 	p->swap_file = NULL;
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

