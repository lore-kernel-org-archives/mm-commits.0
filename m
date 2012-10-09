From: akpm@linux-foundation.org
Subject: [merged] thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:00 -0700
Message-ID: <20121009180801.1C8205C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54463 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:03 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so362949lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
has been removed from the -mm tree.  Its filename was
     thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page

They are used to abstract the difference between NUMA enabled and NUMA
disabled to make the code more readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  166 ++++++++++++++++++++++++++-------------------
 1 file changed, 98 insertions(+), 68 deletions(-)

diff -puN mm/huge_memory.c~thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page
+++ a/mm/huge_memory.c
@@ -1827,28 +1827,34 @@ static void __collapse_huge_page_copy(pt
 	}
 }
 
-static void collapse_huge_page(struct mm_struct *mm,
-			       unsigned long address,
-			       struct page **hpage,
-			       struct vm_area_struct *vma,
-			       int node)
+static void khugepaged_alloc_sleep(void)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd, _pmd;
-	pte_t *pte;
-	pgtable_t pgtable;
-	struct page *new_page;
-	spinlock_t *ptl;
-	int isolated;
-	unsigned long hstart, hend;
+	wait_event_freezable_timeout(khugepaged_wait, false,
+			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+}
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-#ifndef CONFIG_NUMA
-	up_read(&mm->mmap_sem);
-	VM_BUG_ON(!*hpage);
-	new_page = *hpage;
-#else
+#ifdef CONFIG_NUMA
+static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
+{
+	if (IS_ERR(*hpage)) {
+		if (!*wait)
+			return false;
+
+		*wait = false;
+		khugepaged_alloc_sleep();
+	} else if (*hpage) {
+		put_page(*hpage);
+		*hpage = NULL;
+	}
+
+	return true;
+}
+
+static struct page
+*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+		       struct vm_area_struct *vma, unsigned long address,
+		       int node)
+{
 	VM_BUG_ON(*hpage);
 	/*
 	 * Allocate the page while the vma is still valid and under
@@ -1860,7 +1866,7 @@ static void collapse_huge_page(struct mm
 	 * mmap_sem in read mode is good idea also to allow greater
 	 * scalability.
 	 */
-	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
+	*hpage  = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
 				      node, __GFP_OTHER_NODE);
 
 	/*
@@ -1868,15 +1874,81 @@ static void collapse_huge_page(struct mm
 	 * preparation for taking it in write mode.
 	 */
 	up_read(&mm->mmap_sem);
-	if (unlikely(!new_page)) {
+	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
-		return;
+		return NULL;
 	}
-	*hpage = new_page;
+
 	count_vm_event(THP_COLLAPSE_ALLOC);
+	return *hpage;
+}
+#else
+static struct page *khugepaged_alloc_hugepage(bool *wait)
+{
+	struct page *hpage;
+
+	do {
+		hpage = alloc_hugepage(khugepaged_defrag());
+		if (!hpage) {
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+			if (!*wait)
+				return NULL;
+
+			*wait = false;
+			khugepaged_alloc_sleep();
+		} else
+			count_vm_event(THP_COLLAPSE_ALLOC);
+	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
+
+	return hpage;
+}
+
+static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
+{
+	if (!*hpage)
+		*hpage = khugepaged_alloc_hugepage(wait);
+
+	if (unlikely(!*hpage))
+		return false;
+
+	return true;
+}
+
+static struct page
+*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+		       struct vm_area_struct *vma, unsigned long address,
+		       int node)
+{
+	up_read(&mm->mmap_sem);
+	VM_BUG_ON(!*hpage);
+	return  *hpage;
+}
 #endif
 
+static void collapse_huge_page(struct mm_struct *mm,
+				   unsigned long address,
+				   struct page **hpage,
+				   struct vm_area_struct *vma,
+				   int node)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd, _pmd;
+	pte_t *pte;
+	pgtable_t pgtable;
+	struct page *new_page;
+	spinlock_t *ptl;
+	int isolated;
+	unsigned long hstart, hend;
+
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+
+	/* release the mmap_sem read lock. */
+	new_page = khugepaged_alloc_page(hpage, mm, vma, address, node);
+	if (!new_page)
+		return;
+
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
 		return;
 
@@ -2215,34 +2287,6 @@ static int khugepaged_wait_event(void)
 		kthread_should_stop();
 }
 
-static void khugepaged_alloc_sleep(void)
-{
-	wait_event_freezable_timeout(khugepaged_wait, false,
-			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
-}
-
-#ifndef CONFIG_NUMA
-static struct page *khugepaged_alloc_hugepage(bool *wait)
-{
-	struct page *hpage;
-
-	do {
-		hpage = alloc_hugepage(khugepaged_defrag());
-		if (!hpage) {
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-			if (!*wait)
-				return NULL;
-
-			*wait = false;
-			khugepaged_alloc_sleep();
-		} else
-			count_vm_event(THP_COLLAPSE_ALLOC);
-	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
-
-	return hpage;
-}
-#endif
-
 static void khugepaged_do_scan(void)
 {
 	struct page *hpage = NULL;
@@ -2253,23 +2297,9 @@ static void khugepaged_do_scan(void)
 	barrier(); /* write khugepaged_pages_to_scan to local stack */
 
 	while (progress < pages) {
-#ifndef CONFIG_NUMA
-		if (!hpage)
-			hpage = khugepaged_alloc_hugepage(&wait);
-
-		if (unlikely(!hpage))
+		if (!khugepaged_prealloc_page(&hpage, &wait))
 			break;
-#else
-		if (IS_ERR(hpage)) {
-			if (!wait)
-				break;
-			wait = false;
-			khugepaged_alloc_sleep();
-		} else if (hpage) {
-			put_page(hpage);
-			hpage = NULL;
-		}
-#endif
+
 		cond_resched();
 
 		if (unlikely(kthread_should_stop() || freezing(current)))
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

