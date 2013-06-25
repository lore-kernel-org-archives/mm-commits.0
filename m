From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch removed from -mm tree
Date: Tue, 25 Jun 2013 12:23:04 -0700
Message-ID: <51c9ee18.givEhvB1oLPs/pm3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYTXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@gibson.dropbear.id.au, benh@kernel.crashing.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,aarcange@redhat.com,benh@kernel.crashing.org,david@gibson.dropbear.id.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:04 -0700


The patch titled
     Subject: mm/THP: deposit the transpare huge pgtable before set_pmd
has been removed from the -mm tree.  Its filename was
     mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch

