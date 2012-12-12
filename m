From: akpm@linux-foundation.org
Subject: [merged] thp-cleanup-introduce-mk_huge_pmd.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:17 -0800
Message-ID: <20121212195717.C693F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46245 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:18 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so115750yhl.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup: introduce mk_huge_pmd()
has been removed from the -mm tree.  Its filename was
     thp-cleanup-introduce-mk_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: cleanup: introduce mk_huge_pmd()

Introduce mk_huge_pmd() to simplify the code

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-introduce-mk_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-introduce-mk_huge_pmd
+++ a/mm/huge_memory.c
@@ -606,6 +606,15 @@ static inline pmd_t maybe_pmd_mkwrite(pm
 	return pmd;
 }
 
+static inline pmd_t mk_huge_pmd(struct page *page, struct vm_area_struct *vma)
+{
+	pmd_t entry;
+	entry = mk_pmd(page, vma->vm_page_prot);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = pmd_mkhuge(entry);
+	return entry;
+}
+
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long haddr, pmd_t *pmd,
@@ -629,9 +638,7 @@ static int __do_huge_pmd_anonymous_page(
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
-		entry = mk_pmd(page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		entry = pmd_mkhuge(entry);
+		entry = mk_huge_pmd(page, vma);
 		/*
 		 * The spinlocking to take the lru_lock inside
 		 * page_add_new_anon_rmap() acts as a full memory
@@ -951,9 +958,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
-		entry = mk_pmd(new_page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		entry = pmd_mkhuge(entry);
+		entry = mk_huge_pmd(new_page, vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -2000,9 +2005,7 @@ static void collapse_huge_page(struct mm
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_pmd(new_page, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-	_pmd = pmd_mkhuge(_pmd);
+	_pmd = mk_huge_pmd(new_page, vma);
 
 	/*
 	 * spin_lock() below is not the equivalent of smp_wmb(), so
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
hotplug-update-nodemasks-management-fix.patch
linux-next.patch

