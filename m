From: akpm@linux-foundation.org
Subject: + mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch added to -mm tree
Date: Tue, 08 Nov 2011 13:39:34 -0800
Message-ID: <201111082139.pA8LdY9R016474@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1KHVkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 16:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: memcg: remove optimization of keeping the root_mem_cgroup LRU lists empty
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch

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
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove optimization of keeping the root_mem_cgroup LRU lists empty

root_mem_cgroup, lacking a configurable limit, was never subject to limit
reclaim, so the pages charged to it could be kept off its LRU lists.  They
would be found on the global per-zone LRU lists upon physical memory
pressure and it made sense to avoid uselessly linking them to both lists.

The global per-zone LRU lists are about to go away on memcg-enabled
kernels, with all pages being exclusively linked to their respective
per-memcg LRU lists.  As a result, pages of the root_mem_cgroup must also
be linked to its LRU lists again.  This is purely about the LRU list,
root_mem_cgroup is still not charged.

The overhead is temporary until the double-LRU scheme is going away
completely.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty
+++ a/mm/memcontrol.c
@@ -965,8 +965,6 @@ void mem_cgroup_del_lru_list(struct page
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
 }
@@ -991,13 +989,11 @@ void mem_cgroup_rotate_reclaimable_page(
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/* unused or root page is not rotated. */
+	/* unused page is not rotated. */
 	if (!PageCgroupUsed(pc))
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
 }
@@ -1011,13 +1007,11 @@ void mem_cgroup_rotate_lru_list(struct p
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/* unused or root page is not rotated. */
+	/* unused page is not rotated. */
 	if (!PageCgroupUsed(pc))
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move(&pc->lru, &mz->lists[lru]);
 }
@@ -1049,8 +1043,6 @@ void mem_cgroup_add_lru_list(struct page
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
 
_
Subject: Subject: mm: memcg: remove optimization of keeping the root_mem_cgroup LRU lists empty

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

