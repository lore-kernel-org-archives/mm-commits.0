From: akpm@linux-foundation.org
Subject: + sys_swapoff-change-order-to-match-sys_swapon.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:32 -0800
Message-ID: <201103072210.p27MAWGM030049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1CGWQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:16:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org


The patch titled
     sys_swapoff: change order to match sys_swapon
has been added to the -mm tree.  Its filename is
     sys_swapoff-change-order-to-match-sys_swapon.patch

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
Subject: sys_swapoff: change order to match sys_swapon
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(), except
for the order of the operations within the lock. Since the order should
not matter, arbitrarily change sys_swapoff to match sys_swapon, in
preparation to making both share the same code.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/swapfile.c~sys_swapoff-change-order-to-match-sys_swapon mm/swapfile.c
--- a/mm/swapfile.c~sys_swapoff-change-order-to-match-sys_swapon
+++ a/mm/swapfile.c
@@ -1625,6 +1625,10 @@ SYSCALL_DEFINE1(swapoff, const char __us
 		spin_lock(&swap_lock);
 		if (p->prio < 0)
 			p->prio = --least_priority;
+		p->flags |= SWP_WRITEOK;
+		nr_swap_pages += p->pages;
+		total_swap_pages += p->pages;
+
 		prev = -1;
 		for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
 			if (p->prio >= swap_info[i]->prio)
@@ -1636,9 +1640,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 			swap_list.head = swap_list.next = type;
 		else
 			swap_info[prev]->next = type;
-		nr_swap_pages += p->pages;
-		total_swap_pages += p->pages;
-		p->flags |= SWP_WRITEOK;
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
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

