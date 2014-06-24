From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
 removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:35 -0700
Message-ID: <53a9cb4b.qzPQFcvkIQkdwhpC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaFXTCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, davej@redhat.com, kirill.shutemov@linux.intel.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix DEBUG_PAGEALLOC oops in copy_page_rep()
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: thp: fix DEBUG_PAGEALLOC oops in copy_page_rep()

Trinity has for over a year been reporting a CONFIG_DEBUG_PAGEALLOC oops
in copy_page_rep() called from copy_user_huge_page() called from
do_huge_pmd_wp_page().

I believe this is a DEBUG_PAGEALLOC false positive, due to the source page
being split, and a tail page freed, while copy is in progress; and not a
problem without DEBUG_PAGEALLOC, since the pmd_same() check will prevent a
miscopy from being made visible.

Fix by adding get_user_huge_page() and put_user_huge_page(): reducing to
the usual get_page() and put_page() on head page in the usual config; but
get and put references to all of the tail pages when DEBUG_PAGEALLOC.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep
+++ a/mm/huge_memory.c
@@ -941,6 +941,37 @@ unlock:
 	spin_unlock(ptl);
 }
 
+/*
+ * Save CONFIG_DEBUG_PAGEALLOC from faulting falsely on tail pages
+ * during copy_user_huge_page()'s copy_page_rep(): in the case when
+ * the source page gets split and a tail freed before copy completes.
+ * Called under pmd_lock of checked pmd, so safe from splitting itself.
+ */
+static void get_user_huge_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
+		struct page *endpage = page + HPAGE_PMD_NR;
+
+		atomic_add(HPAGE_PMD_NR, &page->_count);
+		while (++page < endpage)
+			get_huge_page_tail(page);
+	} else {
+		get_page(page);
+	}
+}
+
+static void put_user_huge_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
+		struct page *endpage = page + HPAGE_PMD_NR;
+
+		while (page < endpage)
+			put_page(page++);
+	} else {
+		put_page(page);
+	}
+}
+
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -1074,7 +1105,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
-	get_page(page);
+	get_user_huge_page(page);
 	spin_unlock(ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
@@ -1095,7 +1126,7 @@ alloc:
 				split_huge_page(page);
 				ret |= VM_FAULT_FALLBACK;
 			}
-			put_page(page);
+			put_user_huge_page(page);
 		}
 		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
@@ -1105,7 +1136,7 @@ alloc:
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
-			put_page(page);
+			put_user_huge_page(page);
 		} else
 			split_huge_page_pmd(vma, address, pmd);
 		ret |= VM_FAULT_FALLBACK;
@@ -1127,7 +1158,7 @@ alloc:
 
 	spin_lock(ptl);
 	if (page)
-		put_page(page);
+		put_user_huge_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(ptl);
 		mem_cgroup_uncharge_page(new_page);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

