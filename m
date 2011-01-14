From: akpm@linux-foundation.org
Subject: [merged] thp-export-maybe_mkwrite.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:40 -0800
Message-ID: <201101142249.p0EMnUlT005300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: export maybe_mkwrite
has been removed from the -mm tree.  Its filename was
     thp-export-maybe_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: export maybe_mkwrite
From: Andrea Arcangeli <aarcange@redhat.com>

huge_memory.c needs it too when it fallbacks in copying hugepages into
regular fragmented pages if hugepage allocation fails during COW.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++++++
 mm/memory.c        |   13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/mm.h~thp-export-maybe_mkwrite include/linux/mm.h
--- a/include/linux/mm.h~thp-export-maybe_mkwrite
+++ a/include/linux/mm.h
@@ -430,6 +430,19 @@ static inline void set_compound_order(st
 }
 
 /*
+ * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
+ * servicing faults for write access.  In the normal case, do always want
+ * pte_mkwrite.  But get_user_pages can cause write faults for mappings
+ * that do not have writing enabled, when used by access_process_vm.
+ */
+static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
+{
+	if (likely(vma->vm_flags & VM_WRITE))
+		pte = pte_mkwrite(pte);
+	return pte;
+}
+
+/*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
  * zeroes, and text pages of executables and shared libraries have
diff -puN mm/memory.c~thp-export-maybe_mkwrite mm/memory.c
--- a/mm/memory.c~thp-export-maybe_mkwrite
+++ a/mm/memory.c
@@ -2083,19 +2083,6 @@ static inline int pte_unmap_same(struct 
 	return same;
 }
 
-/*
- * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
- * servicing faults for write access.  In the normal case, do always want
- * pte_mkwrite.  But get_user_pages can cause write faults for mappings
- * that do not have writing enabled, when used by access_process_vm.
- */
-static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
-{
-	if (likely(vma->vm_flags & VM_WRITE))
-		pte = pte_mkwrite(pte);
-	return pte;
-}
