From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch added
 to -mm tree
Date: Thu, 28 Apr 2016 14:20:28 -0700
Message-ID: <57227e9c.xITdYdGUsbX264q8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbcD1VU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 17:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix

mm/page_alloc.c:995: warning: 'free_pages_prepare' declared inline after being called
mm/page_alloc.c:995: warning: previous declaration of 'free_pages_prepare' was here

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  111 ++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 57 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix
+++ a/mm/page_alloc.c
@@ -991,8 +991,60 @@ out:
 	return ret;
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order,
-			       bool check_free);
+static __always_inline bool free_pages_prepare(struct page *page,
+					unsigned int order, bool check_free)
+{
+	int bad = 0;
+
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	trace_mm_page_free(page, order);
+	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
+
+	/*
+	 * Check tail pages before head page information is cleared to
+	 * avoid checking PageCompound for order-0 pages.
+	 */
+	if (unlikely(order)) {
+		bool compound = PageCompound(page);
+		int i;
+
+		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
+
+		for (i = 1; i < (1 << order); i++) {
+			if (compound)
+				bad += free_tail_pages_check(page, page + i);
+			if (unlikely(free_pages_check(page + i))) {
+				bad++;
+				continue;
+			}
+			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		}
+	}
+	if (PageAnonHead(page))
+		page->mapping = NULL;
+	if (check_free)
+		bad += free_pages_check(page);
+	if (bad)
+		return false;
+
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	reset_page_owner(page, order);
+
+	if (!PageHighMem(page)) {
+		debug_check_no_locks_freed(page_address(page),
+					   PAGE_SIZE << order);
+		debug_check_no_obj_freed(page_address(page),
+					   PAGE_SIZE << order);
+	}
+	arch_free_page(page, order);
+	kernel_poison_pages(page, 1 << order, 0);
+	kernel_map_pages(page, 1 << order, 0);
+
+	return true;
+}
 
 #ifdef CONFIG_DEBUG_VM
 static inline bool free_pcp_prepare(struct page *page)
@@ -1179,61 +1231,6 @@ void __meminit reserve_bootmem_region(un
 	}
 }
 
-static __always_inline bool free_pages_prepare(struct page *page,
-					unsigned int order, bool check_free)
-{
-	int bad = 0;
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
-	trace_mm_page_free(page, order);
-	kmemcheck_free_shadow(page, order);
-	kasan_free_pages(page, order);
-
-	/*
-	 * Check tail pages before head page information is cleared to
-	 * avoid checking PageCompound for order-0 pages.
-	 */
-	if (unlikely(order)) {
-		bool compound = PageCompound(page);
-		int i;
-
-		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
-
-		for (i = 1; i < (1 << order); i++) {
-			if (compound)
-				bad += free_tail_pages_check(page, page + i);
-			if (unlikely(free_pages_check(page + i))) {
-				bad++;
-				continue;
-			}
-			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		}
-	}
-	if (PageAnonHead(page))
-		page->mapping = NULL;
-	if (check_free)
-		bad += free_pages_check(page);
-	if (bad)
-		return false;
-
-	page_cpupid_reset_last(page);
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-	reset_page_owner(page, order);
-
-	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page),
-					   PAGE_SIZE << order);
-		debug_check_no_obj_freed(page_address(page),
-					   PAGE_SIZE << order);
-	}
-	arch_free_page(page, order);
-	kernel_poison_pages(page, 1 << order, 0);
-	kernel_map_pages(page, 1 << order, 0);
-
-	return true;
-}
-
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

