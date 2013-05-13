From: akpm@linux-foundation.org
Subject: + mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch added to -mm tree
Date: Mon, 13 May 2013 16:14:08 -0700
Message-ID: <20130513231408.D597631C276@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60365 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3EMXOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:14:10 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so670338yho.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:14:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au


The patch titled
     Subject: mm/THP: deposit the transpare huge pgtable before set_pmd
has been added to the -mm tree.  Its filename is
     mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/THP: deposit the transpare huge pgtable before set_pmd

Architectures like powerpc use the deposited pgtable to store hash index
values.  We need to make the deposted pgtable is visible to other cpus
before we are ready to take a hash fault.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd
+++ a/mm/huge_memory.c
@@ -729,8 +729,8 @@ static int __do_huge_pmd_anonymous_page(
 		pmd_t entry;
 		entry = mk_huge_pmd(page, vma);
 		page_add_new_anon_rmap(page, vma, haddr);
-		set_pmd_at(mm, haddr, pmd, entry);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		set_pmd_at(mm, haddr, pmd, entry);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
@@ -771,8 +771,8 @@ static bool set_huge_zero_page(pgtable_t
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
-	set_pmd_at(mm, haddr, pmd, entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	set_pmd_at(mm, haddr, pmd, entry);
 	mm->nr_ptes++;
 	return true;
 }
@@ -916,8 +916,8 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
-	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 	dst_mm->nr_ptes++;
 
 	ret = 0;
@@ -2367,9 +2367,9 @@ static void collapse_huge_page(struct mm
 	spin_lock(&mm->page_table_lock);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
 	*hpage = NULL;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

