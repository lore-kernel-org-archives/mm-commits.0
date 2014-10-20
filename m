From: akpm@linux-foundation.org
Subject: + mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:52:26 -0700
Message-ID: <5445841a.Aq1fLW0/tR9OriYz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaJTVw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: update mem_cgroup_page_lruvec() documentation
has been added to the -mm tree.  Its filename is
     mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: update mem_cgroup_page_lruvec() documentation

7512102cf64d ("memcg: fix GPF when cgroup removal races with last exit")
added a pc->mem_cgroup reset into mem_cgroup_page_lruvec() to prevent a
crash where an anon page gets uncharged on unmap, the memcg is released,
and then the final LRU isolation on free dereferences the stale
pc->mem_cgroup pointer.

But since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API"), pages are
only uncharged AFTER that final LRU isolation, which guarantees the
memcg's lifetime until then.  pc->mem_cgroup now only needs to be reset
for swapcache readahead pages.

Update the comment and callsite requirements accordingly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-update-mem_cgroup_page_lruvec-documentation mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-update-mem_cgroup_page_lruvec-documentation
+++ a/mm/memcontrol.c
@@ -1262,9 +1262,13 @@ out:
 }
 
 /**
- * mem_cgroup_page_lruvec - return lruvec for adding an lru page
+ * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
  * @zone: zone of the page
+ *
+ * This function is only safe when following the LRU page isolation
+ * and putback protocol: the LRU lock must be held, and the page must
+ * either be PageLRU() or the caller must have isolated/allocated it.
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 {
@@ -1282,13 +1286,9 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	memcg = pc->mem_cgroup;
 
 	/*
-	 * Surreptitiously switch any uncharged offlist page to root:
-	 * an uncharged page off lru does nothing to secure
-	 * its former mem_cgroup from sudden removal.
-	 *
-	 * Our caller holds lru_lock, and PageCgroupUsed is updated
-	 * under page_cgroup lock: between them, they make all uses
-	 * of pc->mem_cgroup safe.
+	 * Swapcache readahead pages are added to the LRU - and
+	 * possibly migrated - before they are charged.  Ensure
+	 * pc->mem_cgroup is sane.
 	 */
 	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
 		pc->mem_cgroup = memcg = root_mem_cgroup;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
debugging-keep-track-of-page-owners.patch

