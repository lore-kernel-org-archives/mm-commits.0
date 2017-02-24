From: akpm@linux-foundation.org
Subject: [patch 073/124] mm/autonuma: don't use set_pte_at when updating
 protnone ptes
Date: Fri, 24 Feb 2017 14:59:13 -0800
Message-ID: <58b0bac1.oACZJMxdP+mT41P9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdBXW7O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, riel@redhat.com

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/autonuma: don't use set_pte_at when updating protnone ptes

Architectures like ppc64, use privilege access bit to mark pte non
accessible.  This implies that kernel can do a copy_to_user to an address
marked for numa fault.  This also implies that there can be a parallel
hardware update for the pte.  set_pte_at cannot be used in such scenarios.
Hence switch the pte update to use ptep_get_and_clear and set_pte_at
combination.

[akpm@linux-foundation.org: remove unwanted ppc change, per Aneesh]
Link: http://lkml.kernel.org/r/1486400776-28114-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

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
