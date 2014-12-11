From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:57:52 -0800
Message-ID: <5489e930.YlQw1B6KI3a9+eVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, iamjoonsoo.kim@lge.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page->mem_cgroup bad page handling into generic code
has been removed from the -mm tree.  Its filename was
     mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: move page->mem_cgroup bad page handling into generic code

Now that the external page_cgroup data structure and its lookup is
gone, let the generic bad_page() check for page->mem_cgroup sanity.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 -----------------
 init/Kconfig               |   12 ------------
 mm/debug.c                 |    5 ++++-
 mm/memcontrol.c            |   15 ---------------
 mm/page_alloc.c            |   12 ++++++++----
 5 files changed, 12 insertions(+), 49 deletions(-)

diff -puN include/linux/memcontrol.h~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/include/linux/memcontrol.h
@@ -173,10 +173,6 @@ static inline void mem_cgroup_count_vm_e
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
-#ifdef CONFIG_DEBUG_VM
-bool mem_cgroup_bad_page_check(struct page *page);
-void mem_cgroup_print_bad_page(struct page *page);
-#endif
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
@@ -346,19 +342,6 @@ void mem_cgroup_count_vm_event(struct mm
 }
 #endif /* CONFIG_MEMCG */
 
-#if !defined(CONFIG_MEMCG) || !defined(CONFIG_DEBUG_VM)
-static inline bool
-mem_cgroup_bad_page_check(struct page *page)
-{
-	return false;
-}
-
-static inline void
-mem_cgroup_print_bad_page(struct page *page)
-{
-}
-#endif
-
 enum {
 	UNDER_LIMIT,
 	SOFT_LIMIT,
diff -puN init/Kconfig~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code init/Kconfig
--- a/init/Kconfig~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/init/Kconfig
@@ -983,18 +983,6 @@ config MEMCG
 	  Provides a memory resource controller that manages both anonymous
 	  memory and page cache. (See Documentation/cgroups/memory.txt)
 
-	  Note that setting this option increases fixed memory overhead
-	  associated with each page of memory in the system. By this,
-	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
-	  usage tracking struct at boot. Total amount of this is printed out
-	  at boot.
-
-	  Only enable when you're ok with these trade offs and really
-	  sure you need the memory resource controller. Even when you enable
-	  this, you can set "cgroup_disable=memory" at your boot option to
-	  disable memory resource controller and you can avoid overheads.
-	  (and lose benefits of memory resource controller)
-
 config MEMCG_SWAP
 	bool "Memory Resource Controller Swap Extension"
 	depends on MEMCG && SWAP
diff -puN mm/debug.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/debug.c
--- a/mm/debug.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/debug.c
@@ -95,7 +95,10 @@ void dump_page_badflags(struct page *pag
 		dump_flags(page->flags & badflags,
 				pageflag_names, ARRAY_SIZE(pageflag_names));
 	}
-	mem_cgroup_print_bad_page(page);
+#ifdef CONFIG_MEMCG
+	if (page->mem_cgroup)
+		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
+#endif
 }
 
 void dump_page(struct page *page, const char *reason)
diff -puN mm/memcontrol.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/memcontrol.c
@@ -3157,21 +3157,6 @@ static inline int mem_cgroup_move_swap_a
 }
 #endif
 
-#ifdef CONFIG_DEBUG_VM
-bool mem_cgroup_bad_page_check(struct page *page)
-{
-	if (mem_cgroup_disabled())
-		return false;
-
-	return page->mem_cgroup != NULL;
-}
-
-void mem_cgroup_print_bad_page(struct page *page)
-{
-	pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
-}
-#endif
-
 static DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
diff -puN mm/page_alloc.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/page_alloc.c
@@ -640,8 +640,10 @@ static inline int free_pages_check(struc
 		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_FREE;
 	}
-	if (unlikely(mem_cgroup_bad_page_check(page)))
-		bad_reason = "cgroup check failed";
+#ifdef CONFIG_MEMCG
+	if (unlikely(page->mem_cgroup))
+		bad_reason = "page still charged to cgroup";
+#endif
 	if (unlikely(bad_reason)) {
 		bad_page(page, bad_reason, bad_flags);
 		return 1;
@@ -900,8 +902,10 @@ static inline int check_new_page(struct
 		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_PREP;
 	}
-	if (unlikely(mem_cgroup_bad_page_check(page)))
-		bad_reason = "cgroup check failed";
+#ifdef CONFIG_MEMCG
+	if (unlikely(page->mem_cgroup))
+		bad_reason = "page still charged to cgroup";
+#endif
 	if (unlikely(bad_reason)) {
 		bad_page(page, bad_reason, bad_flags);
 		return 1;
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

