From: akpm@linux-foundation.org
Subject: [folded] thp-mremap-support-and-tlb-optimization-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:43:39 -0700
Message-ID: <201110312343.p9VNhec6014516@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42315 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1JaXns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-mremap-support-and-tlb-optimization-fix
has been removed from the -mm tree.  Its filename was
     thp-mremap-support-and-tlb-optimization-fix.patch

This patch was dropped because it was folded into thp-mremap-support-and-tlb-optimization.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-mremap-support-and-tlb-optimization-fix

coding-style nitpicking

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 mm/mremap.c      |    6 +++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mremap-support-and-tlb-optimization-fix
+++ a/mm/huge_memory.c
@@ -1065,15 +1065,14 @@ int move_huge_pmd(struct vm_area_struct 
 	if ((old_addr & ~HPAGE_PMD_MASK) ||
 	    (new_addr & ~HPAGE_PMD_MASK) ||
 	    (old_addr + HPAGE_PMD_SIZE) > old_end ||
-	    new_vma->vm_flags & VM_NOHUGEPAGE)
+	    (new_vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
 	 */
-	if (!pmd_none(*new_pmd)) {
-		WARN_ON(1);
+	if (!WARN_ON(pmd_none(*new_pmd))) {
 		VM_BUG_ON(pmd_trans_huge(*new_pmd));
 		goto out;
 	}
@@ -1091,9 +1090,9 @@ int move_huge_pmd(struct vm_area_struct 
 			spin_unlock(&mm->page_table_lock);
 			ret = 1;
 		}
-	} else
+	} else {
 		spin_unlock(&mm->page_table_lock);
-
+	}
 out:
 	return ret;
 }
diff -puN mm/mremap.c~thp-mremap-support-and-tlb-optimization-fix mm/mremap.c
--- a/mm/mremap.c~thp-mremap-support-and-tlb-optimization-fix
+++ a/mm/mremap.c
@@ -155,13 +155,13 @@ unsigned long move_page_tables(struct vm
 			if (err > 0) {
 				need_flush = true;
 				continue;
-			} else if (!err)
+			} else if (!err) {
 				split_huge_page_pmd(vma->vm_mm, old_pmd);
+			}
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
 		if (pmd_none(*new_pmd) && __pte_alloc(new_vma->vm_mm, new_vma,
-						      new_pmd,
-						      new_addr))
+						      new_pmd, new_addr))
 			break;
 		next = (new_addr + PMD_SIZE) & PMD_MASK;
 		if (extent > next - new_addr)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

