From: akpm@linux-foundation.org
Subject: + mm-thp-fix-collapsing-of-hugepages-on-madvise.patch added to
 -mm tree
Date: Wed, 15 Oct 2014 14:30:35 -0700
Message-ID: <543ee77b.RiQ1+AzQ2nytlcOg%akpm__3943.31239299408$1413408649$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaJOVag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 17:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, suleiman@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix collapsing of hugepages on madvise
has been added to the -mm tree.  Its filename is
     mm-thp-fix-collapsing-of-hugepages-on-madvise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-collapsing-of-hugepages-on-madvise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-collapsing-of-hugepages-on-madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: fix collapsing of hugepages on madvise

If an anonymous mapping is not allowed to fault thp memory and then
madvise(MADV_HUGEPAGE) is used after fault, khugepaged will never collapse
this memory into thp memory.

This occurs because the madvise(2) handler for thp, hugepage_madvise(),
clears VM_NOHUGEPAGE on the stack and it isn't stored in vma->vm_flags
until the final action of madvise_behavior().  This causes the
khugepaged_enter_vma_merge() to be a no-op in hugepage_madvise() when the
vma had previously had VM_NOHUGEPAGE set.

Fix this by passing the correct vma flags to the khugepaged mm slot
handler.  There's no chance khugepaged can run on this vma until after
madvise_behavior() returns since we hold mm->mmap_sem.

It would be possible to clear VM_NOHUGEPAGE directly from vma->vm_flags in
hugepage_advise(), but I didn't want to introduce special case behavior
into madvise_behavior().  I think it's best to just let it always set
vma->vm_flags itself.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Suleiman Souhlal <suleiman@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |   17 ++++++++++-------
 mm/huge_memory.c           |   11 ++++++-----
 mm/mmap.c                  |    8 ++++----
 3 files changed, 20 insertions(+), 16 deletions(-)

diff -puN include/linux/khugepaged.h~mm-thp-fix-collapsing-of-hugepages-on-madvise include/linux/khugepaged.h
--- a/include/linux/khugepaged.h~mm-thp-fix-collapsing-of-hugepages-on-madvise
+++ a/include/linux/khugepaged.h
@@ -6,7 +6,8 @@
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern int __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma);
+extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+				      unsigned long vm_flags);
 
 #define khugepaged_enabled()					       \
 	(transparent_hugepage_flags &				       \
@@ -35,13 +36,13 @@ static inline void khugepaged_exit(struc
 		__khugepaged_exit(mm);
 }
 
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
-		     (khugepaged_req_madv() &&
-		      vma->vm_flags & VM_HUGEPAGE)) &&
-		    !(vma->vm_flags & VM_NOHUGEPAGE))
+		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
+		    !(vm_flags & VM_NOHUGEPAGE))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
@@ -54,11 +55,13 @@ static inline int khugepaged_fork(struct
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	return 0;
 }
-static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+					     unsigned long vm_flags)
 {
 	return 0;
 }
diff -puN mm/huge_memory.c~mm-thp-fix-collapsing-of-hugepages-on-madvise mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-collapsing-of-hugepages-on-madvise
+++ a/mm/huge_memory.c
@@ -803,7 +803,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
-	if (unlikely(khugepaged_enter(vma)))
+	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
 	if (!(flags & FAULT_FLAG_WRITE) &&
 			transparent_hugepage_use_zero_page()) {
@@ -1970,7 +1970,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (unlikely(khugepaged_enter_vma_merge(vma)))
+		if (unlikely(khugepaged_enter_vma_merge(vma, *vm_flags)))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
@@ -2071,7 +2071,8 @@ int __khugepaged_enter(struct mm_struct
 	return 0;
 }
 
-int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+			       unsigned long vm_flags)
 {
 	unsigned long hstart, hend;
 	if (!vma->anon_vma)
@@ -2083,11 +2084,11 @@ int khugepaged_enter_vma_merge(struct vm
 	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	VM_BUG_ON_VMA(vma->vm_flags & VM_NO_THP, vma);
+	VM_BUG_ON_VMA(vm_flags & VM_NO_THP, vma);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
-		return khugepaged_enter(vma);
+		return khugepaged_enter(vma, vm_flags);
 	return 0;
 }
 
diff -puN mm/mmap.c~mm-thp-fix-collapsing-of-hugepages-on-madvise mm/mmap.c
--- a/mm/mmap.c~mm-thp-fix-collapsing-of-hugepages-on-madvise
+++ a/mm/mmap.c
@@ -1080,7 +1080,7 @@ struct vm_area_struct *vma_merge(struct
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev);
+		khugepaged_enter_vma_merge(prev, vm_flags);
 		return prev;
 	}
 
@@ -1099,7 +1099,7 @@ struct vm_area_struct *vma_merge(struct
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area);
+		khugepaged_enter_vma_merge(area, vm_flags);
 		return area;
 	}
 
@@ -2208,7 +2208,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(vma->vm_mm);
 	return error;
 }
@@ -2277,7 +2277,7 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(vma->vm_mm);
 	return error;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
mm-free-compound-page-with-correct-order.patch
mm-thp-fix-collapsing-of-hugepages-on-madvise.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-verify-compound-order-when-freeing-a-page.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
freezer-check-oom-kill-while-being-frozen.patch
freezer-remove-obsolete-comments-in-__thaw_task.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch
mm-utilc-add-kstrimdup.patch

