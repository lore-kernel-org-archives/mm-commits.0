From: akpm@linux-foundation.org
Subject: [merged] thp-memcg-huge-memory.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:36 -0800
Message-ID: <201101142250.p0EMoQio005410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885Ab1ANWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: memcg huge memory
has been removed from the -mm tree.  Its filename was
     thp-memcg-huge-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: memcg huge memory
From: Andrea Arcangeli <aarcange@redhat.com>

Add memcg charge/uncharge to hugepage faults in huge_memory.c.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-memcg-huge-memory mm/huge_memory.c
--- a/mm/huge_memory.c~thp-memcg-huge-memory
+++ a/mm/huge_memory.c
@@ -233,6 +233,7 @@ static int __do_huge_pmd_anonymous_page(
 	VM_BUG_ON(!PageCompound(page));
 	pgtable = pte_alloc_one(mm, haddr);
 	if (unlikely(!pgtable)) {
+		mem_cgroup_uncharge_page(page);
 		put_page(page);
 		return VM_FAULT_OOM;
 	}
@@ -243,6 +244,7 @@ static int __do_huge_pmd_anonymous_page(
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_none(*pmd))) {
 		spin_unlock(&mm->page_table_lock);
+		mem_cgroup_uncharge_page(page);
 		put_page(page);
 		pte_free(mm, pgtable);
 	} else {
@@ -286,6 +288,10 @@ int do_huge_pmd_anonymous_page(struct mm
 		page = alloc_hugepage(transparent_hugepage_defrag(vma));
 		if (unlikely(!page))
 			goto out;
+		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
+			put_page(page);
+			goto out;
+		}
 
 		return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page);
 	}
@@ -402,9 +408,17 @@ static int do_huge_pmd_wp_page_fallback(
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		pages[i] = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
 					  vma, address);
-		if (unlikely(!pages[i])) {
-			while (--i >= 0)
+		if (unlikely(!pages[i] ||
+			     mem_cgroup_newpage_charge(pages[i], mm,
+						       GFP_KERNEL))) {
+			if (pages[i])
 				put_page(pages[i]);
+			mem_cgroup_uncharge_start();
+			while (--i >= 0) {
+				mem_cgroup_uncharge_page(pages[i]);
+				put_page(pages[i]);
+			}
+			mem_cgroup_uncharge_end();
 			kfree(pages);
 			ret |= VM_FAULT_OOM;
 			goto out;
@@ -455,8 +469,12 @@ out:
 
 out_free_pages:
 	spin_unlock(&mm->page_table_lock);
-	for (i = 0; i < HPAGE_PMD_NR; i++)
+	mem_cgroup_uncharge_start();
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		mem_cgroup_uncharge_page(pages[i]);
 		put_page(pages[i]);
+	}
+	mem_cgroup_uncharge_end();
 	kfree(pages);
 	goto out;
 }
@@ -501,14 +519,22 @@ int do_huge_pmd_wp_page(struct mm_struct
 		goto out;
 	}
 
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+		put_page(new_page);
+		put_page(page);
+		ret |= VM_FAULT_OOM;
+		goto out;
+	}
+
 	copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
 	spin_lock(&mm->page_table_lock);
 	put_page(page);
-	if (unlikely(!pmd_same(*pmd, orig_pmd)))
+	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
+		mem_cgroup_uncharge_page(new_page);
 		put_page(new_page);
-	else {
+	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
 		entry = mk_pmd(new_page, vma->vm_page_prot);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

