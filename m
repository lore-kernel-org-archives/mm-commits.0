From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:45 -0800
Message-ID: <20120113203245.E1DB910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:50902 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:47 -0500
Received: by qcsc20 with SMTP id c20so97309qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove optimization of keeping the root_mem_cgroup LRU lists empty
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1031,8 +1031,6 @@ void mem_cgroup_del_lru_list(struct page
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
 }
@@ -1057,13 +1055,11 @@ void mem_cgroup_rotate_reclaimable_page(
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
@@ -1077,13 +1073,11 @@ void mem_cgroup_rotate_lru_list(struct p
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
@@ -1115,8 +1109,6 @@ void mem_cgroup_add_lru_list(struct page
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
-	if (mem_cgroup_is_root(pc->mem_cgroup))
-		return;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

