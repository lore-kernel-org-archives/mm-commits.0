From: akpm@linux-foundation.org
Subject: + mm-dont-free-swap-slots-on-page-deactivation.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:46:11 -0800
Message-ID: <200902262046.n1QKkBH3020713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZBZUrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hugh@veritas.com, riel@redhat.com


The patch titled
     mm: don't free swap slots on page deactivation
has been added to the -mm tree.  Its filename is
     mm-dont-free-swap-slots-on-page-deactivation.patch

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
Subject: mm: don't free swap slots on page deactivation
From: Johannes Weiner <hannes@cmpxchg.org>

The pagevec_swap_free() at the end of shrink_active_list() was introduced
in 68a22394 "vmscan: free swap space on swap-in/activation" when
shrink_active_list() was still rotating referenced active pages.

In 7e9cd48 "vmscan: fix pagecache reclaim referenced bit check" this was
changed, the rotating removed but the pagevec_swap_free() after the
rotation loop was forgotten, applying now to the pagevec of the
deactivation loop instead.

Now swap space is freed for deactivated pages.  And only for those that
happen to be on the pagevec after the deactivation loop.

Complete 7e9cd48 and remove the rest of the swap freeing.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/vmscan.c~mm-dont-free-swap-slots-on-page-deactivation mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-free-swap-slots-on-page-deactivation
+++ a/mm/vmscan.c
@@ -1303,9 +1303,6 @@ static void shrink_active_list(unsigned 
 	spin_unlock_irq(&zone->lru_lock);
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
-	if (vm_swap_full())
-		pagevec_swap_free(&pvec);
-
 	pagevec_release(&pvec);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
md-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

