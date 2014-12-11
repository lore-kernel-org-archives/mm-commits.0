From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:56:53 -0800
Message-ID: <5489e8f5.NZzje+0SoGbqnSX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbaLKS4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: update mem_cgroup_page_lruvec() documentation
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

