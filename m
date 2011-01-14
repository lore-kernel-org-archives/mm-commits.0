From: akpm@linux-foundation.org
Subject: [merged] thp-madvisemadv_hugepage.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:27 -0800
Message-ID: <201101142250.p0EMoHlb005398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab1ANWu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: madvise(MADV_HUGEPAGE)
has been removed from the -mm tree.  Its filename was
     thp-madvisemadv_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: madvise(MADV_HUGEPAGE)
From: Andrea Arcangeli <aarcange@redhat.com>

Add madvise MADV_HUGEPAGE to mark regions that are important to be
hugepage backed.  Return -EINVAL if the vma is not of an anonymous type,
or the feature isn't built into the kernel.  Never silently return
success.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ++++++
 mm/huge_memory.c        |   16 ++++++++++++++++
 mm/madvise.c            |    8 ++++++++
 3 files changed, 30 insertions(+)

diff -puN include/linux/huge_mm.h~thp-madvisemadv_hugepage include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-madvisemadv_hugepage
+++ a/include/linux/huge_mm.h
@@ -97,6 +97,7 @@ extern void __split_huge_page_pmd(struct
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
+extern int hugepage_madvise(unsigned long *vm_flags);
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
@@ -113,6 +114,11 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
+static inline int hugepage_madvise(unsigned long *vm_flags)
+{
+	BUG();
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/huge_memory.c~thp-madvisemadv_hugepage mm/huge_memory.c
--- a/mm/huge_memory.c~thp-madvisemadv_hugepage
+++ a/mm/huge_memory.c
@@ -896,6 +896,22 @@ out:
 	return ret;
 }
 
+int hugepage_madvise(unsigned long *vm_flags)
+{
+	/*
+	 * Be somewhat over-protective like KSM for now!
+	 */
+	if (*vm_flags & (VM_HUGEPAGE | VM_SHARED  | VM_MAYSHARE   |
+			 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
+			 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
+			 VM_MIXEDMAP | VM_SAO))
+		return -EINVAL;
+
+	*vm_flags |= VM_HUGEPAGE;
+
+	return 0;
+}
+
 void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
 {
 	struct page *page;
diff -puN mm/madvise.c~thp-madvisemadv_hugepage mm/madvise.c
--- a/mm/madvise.c~thp-madvisemadv_hugepage
+++ a/mm/madvise.c
@@ -71,6 +71,11 @@ static long madvise_behavior(struct vm_a
 		if (error)
 			goto out;
 		break;
+	case MADV_HUGEPAGE:
+		error = hugepage_madvise(&new_flags);
+		if (error)
+			goto out;
+		break;
 	}
 
 	if (new_flags == vma->vm_flags) {
@@ -283,6 +288,9 @@ madvise_behavior_valid(int behavior)
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	case MADV_HUGEPAGE:
+#endif
 		return 1;
 
 	default:
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

