From: akpm@linux-foundation.org
Subject: + thp-cleanup-introduce-mk_huge_pmd.patch added to -mm tree
Date: Thu, 18 Oct 2012 13:11:43 -0700
Message-ID: <20121018201144.11E405C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33893 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2JRULq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 16:11:46 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so130854wib.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 13:11:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     Subject: thp: cleanup: introduce mk_huge_pmd()
has been added to the -mm tree.  Its filename is
     thp-cleanup-introduce-mk_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: cleanup: introduce mk_huge_pmd()

Introduce mk_huge_pmd() to simplify the code

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-introduce-mk_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-introduce-mk_huge_pmd
+++ a/mm/huge_memory.c
@@ -607,6 +607,15 @@ static inline pmd_t maybe_pmd_mkwrite(pm
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
@@ -630,9 +639,7 @@ static int __do_huge_pmd_anonymous_page(
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
@@ -1020,9 +1027,7 @@ int do_huge_pmd_wp_page(struct mm_struct
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
@@ -2086,9 +2091,7 @@ static void collapse_huge_page(struct mm
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

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-introduce-hugepage_get_pmd.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch

