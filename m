From: akpm@linux-foundation.org
Subject: +
 mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch added to
 -mm tree
Date: Mon, 06 Feb 2017 15:18:24 -0800
Message-ID: <58990440.Ol6MwbiDgkpnA46y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdBFXSZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/autonuma: don't use set_pte_at when updating protnone ptes
has been added to the -mm tree.  Its filename is
     mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch

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
Subject: mm/autonuma: don't use set_pte_at when updating protnone ptes

Architectures like ppc64, use privilege access bit to mark pte non
accessible.  This implies that kernel can do a copy_to_user to an address
marked for numa fault.  This also implies that there can be a parallel
hardware update for the pte.  set_pte_at cannot be used in such scenarios.
Hence switch the pte update to use ptep_get_and_clear and set_pte_at
combination.

Link: http://lkml.kernel.org/r/1486400776-28114-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    7 +------
 mm/memory.c               |   18 +++++++++---------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes
+++ a/arch/powerpc/mm/pgtable.c
@@ -186,12 +186,7 @@ static pte_t set_access_flags_filter(pte
 void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte)
 {
-	/*
-	 * When handling numa faults, we already have the pte marked
-	 * _PAGE_PRESENT, but we can be sure that it is not in hpte.
-	 * Hence we can use set_pte_at for them.
-	 */
-	VM_WARN_ON(pte_present(*ptep) && !pte_protnone(*ptep));
+	VM_WARN_ON(pte_present(*ptep));
 
 	/*
 	 * Add the pte bit when tryint set a pte
diff -puN mm/memory.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes mm/memory.c
--- a/mm/memory.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes
+++ a/mm/memory.c
@@ -3400,32 +3400,32 @@ static int do_numa_page(struct vm_fault
 	int last_cpupid;
 	int target_nid;
 	bool migrated = false;
-	pte_t pte = vmf->orig_pte;
-	bool was_writable = pte_write(pte);
+	pte_t pte;
+	bool was_writable = pte_write(vmf->orig_pte);
 	int flags = 0;
 
 	/*
 	 * The "pte" at this point cannot be used safely without
 	 * validation through pte_unmap_same(). It's of NUMA type but
 	 * the pfn may be screwed if the read is non atomic.
-	 *
-	 * We can safely just do a "set_pte_at()", because the old
-	 * page table entry is not accessible, so there would be no
-	 * concurrent hardware modifications to the PTE.
 	 */
 	vmf->ptl = pte_lockptr(vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
-	if (unlikely(!pte_same(*vmf->pte, pte))) {
+	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto out;
 	}
 
-	/* Make it present again */
+	/*
+	 * Make it present again, Depending on how arch implementes non
+	 * accessible ptes, some can allow access by kernel mode.
+	 */
+	pte = ptep_modify_prot_start(vma->vm_mm, vmf->address, vmf->pte);
 	pte = pte_modify(pte, vma->vm_page_prot);
 	pte = pte_mkyoung(pte);
 	if (was_writable)
 		pte = pte_mkwrite(pte);
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	ptep_modify_prot_commit(vma->vm_mm, vmf->address, vmf->pte, pte);
 	update_mmu_cache(vma, vmf->address, vmf->pte);
 
 	page = vm_normal_page(vma, vmf->address, pte);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch

