From: akpm@linux-foundation.org
Subject: + mm-memcg-fix-last_dead_count-memory-wastage.patch added to -mm
 tree
Date: Tue, 14 Jan 2014 16:14:34 -0800
Message-ID: <52d5d2ea.SQ1SyO4Uj/mB3LnM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaAOAOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 19:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: + mm-memcg-fix-last_dead_count-memory-wastage.patch added to -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 16:14:34 -0800


The patch titled
     Subject: mm/memcg: fix last_dead_count memory wastage
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-last_dead_count-memory-wastage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-last_dead_count-memory-wastage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-last_dead_count-memory-wastage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: fix last_dead_count memory wastage

Shorten mem_cgroup_reclaim_iter.last_dead_count from unsigned long to int:
it's assigned from an int and compared with an int, and adjacent to an
unsigned int: so there's no point to it being unsigned long, which wasted
104 bytes in every mem_cgroup_per_zone.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-fix-last_dead_count-memory-wastage mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-last_dead_count-memory-wastage
+++ a/mm/memcontrol.c
@@ -147,7 +147,7 @@ struct mem_cgroup_reclaim_iter {
 	 * matches memcg->dead_count of the hierarchy root group.
 	 */
 	struct mem_cgroup *last_visited;
-	unsigned long last_dead_count;
+	int last_dead_count;
 
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
_

Patches currently in -mm which might be from hughd@google.com are

mm-remove-bug_on-from-mlock_vma_page.patch
fsnotify-do-not-share-events-between-notification-groups-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-memcg-fix-last_dead_count-memory-wastage.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

