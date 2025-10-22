Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356632F0C69
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159729; cv=none; b=o+Drf2i2ZE7t06z0OOx6LOARwP7n9uTo9uJOVMjiInSWN9o2zj/urYBzrngCKna5SWcjW5aNbFmJc+o32jnGce1rpObhbhEIY3BQS3Ed0Hps7D1/R5+KQ7Mkz7CTxptbVpBuWturuUrbWYdCFwyLiOW2jlmZQ6N7JHW4RJhyil4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159729; c=relaxed/simple;
	bh=00yOVY2talwHu4Xap1ijMKv6qiaSFB0C3StvBf1Sei4=;
	h=Date:To:From:Subject:Message-Id; b=tRgpNfYqtdOMmx4tpD0DwaW1M6ljhTyxdykyn40ApgUfJw98giTA/Zegitv+SjT0MF9IXrjt9PLbUBKCHwFbIuO/HNmPCMkudcP9PLFyP2z/tQ5Y81aqerigHFI7b0cXON3820nRETlip2dNfxBHpLr6/mZUYeckYbajQNW+pu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0/MwDFBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0/MwDFBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D842C4CEE7;
	Wed, 22 Oct 2025 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159727;
	bh=00yOVY2talwHu4Xap1ijMKv6qiaSFB0C3StvBf1Sei4=;
	h=Date:To:From:Subject:From;
	b=0/MwDFBP9FXt2UftC2KcfP/6rJSnCvISBy9mxivmMqD4fu4M2WeAynEbok3aoFvh4
	 jTvioc5PfC4DYGrU+GY1KdigkgqnCpZU8ES0GNbCCAPasyN/zea2ausFXKrrnSPRb0
	 hcxKQZ85PhB5cQfIX76godrkpmC6EcyHvuGK1aFE=
Date: Wed, 22 Oct 2025 12:02:07 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-use-ptdesc-when-freeing-pmd-pages.patch added to mm-new branch
Message-Id: <20251022190207.8D842C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: use 'ptdesc' when freeing PMD pages
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-use-ptdesc-when-freeing-pmd-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-use-ptdesc-when-freeing-pmd-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: x86/mm: use 'ptdesc' when freeing PMD pages
Date: Wed, 22 Oct 2025 16:26:30 +0800

There are a billion ways to refer to a physical memory address.  One of
the x86 PMD freeing code location chooses to use a 'pte_t *' to point to a
PMD page and then call a PTE-specific freeing function for it.  That's a
bit wonky.

Just use a 'struct ptdesc *' instead.  Its entire purpose is to refer to
page table pages.  It also means being able to remove an explicit cast.

Right now, pte_free_kernel() is a one-liner that calls
pagetable_dtor_free().  Effectively, all this patch does is remove one
superfluous __pa(__va(paddr)) conversion and then call
pagetable_dtor_free() directly instead of through a helper.

Link: https://lkml.kernel.org/r/20251022082635.2462433-5-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/pgtable.c~x86-mm-use-ptdesc-when-freeing-pmd-pages
+++ a/arch/x86/mm/pgtable.c
@@ -729,7 +729,7 @@ int pmd_clear_huge(pmd_t *pmd)
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 {
 	pmd_t *pmd, *pmd_sv;
-	pte_t *pte;
+	struct ptdesc *pt;
 	int i;
 
 	pmd = pud_pgtable(*pud);
@@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsign
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd_sv[i])) {
-			pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
-			pte_free_kernel(&init_mm, pte);
+			pt = page_ptdesc(pmd_page(pmd_sv[i]));
+			pagetable_dtor_free(pt);
 		}
 	}
 
@@ -772,15 +772,15 @@ int pud_free_pmd_page(pud_t *pud, unsign
  */
 int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 {
-	pte_t *pte;
+	struct ptdesc *pt;
 
-	pte = (pte_t *)pmd_page_vaddr(*pmd);
+	pt = page_ptdesc(pmd_page(*pmd));
 	pmd_clear(pmd);
 
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	pte_free_kernel(&init_mm, pte);
+	pagetable_dtor_free(pt);
 
 	return 1;
 }
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch
mm-actually-mark-kernel-page-table-pages.patch
x86-mm-use-ptdesc-when-freeing-pmd-pages.patch
mm-introduce-pure-page-table-freeing-function.patch
mm-introduce-deferred-freeing-for-kernel-page-tables.patch

