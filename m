Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C1227599
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343218; cv=none; b=CLjHFCav6lfcVyipwmOZJHNF1ywN6u4mtW+kja0+H1KtYi2e+APLVcUSq1V4UhL3Y2ZoJA5jMbEIt77d7lRjqPcQ0UgceTGw5nHrz4OnDkR+PpXu6upuA1fY2JhBrl7fgjefMa/467gURIH3+wHF2cSYYaRWMuJBY6g9BT1Qujg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343218; c=relaxed/simple;
	bh=ODvBM3OGMJjBDYk0Mj5/kHFWuoPkUr4ToYCs1G674DI=;
	h=Date:To:From:Subject:Message-Id; b=UZbx1kiJwca3PCERMARehTr3Zd2BzC0vbBCt/FHYpq5avchoDA8/Bh2MKjOChYiycq4d6o5uUBZMQz1dwhhWxPBGY7CVVO3tgpUzLVUTlZA7+D97jCXykMm+P0ru86TlDoasDrDcjSIOSsi/KzIG5wPD/lAm+OygrG8geZ5Ef2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zuYNgluO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zuYNgluO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E003CC113D0;
	Mon, 17 Nov 2025 01:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343218;
	bh=ODvBM3OGMJjBDYk0Mj5/kHFWuoPkUr4ToYCs1G674DI=;
	h=Date:To:From:Subject:From;
	b=zuYNgluOI6uJVvFbOgha4bMhM4nJzEi51RuXxAaFQSyHn7LAMwkFPiMXSQNH0xJG/
	 Di6MI3vMtyjVwg6Kq25w4cZ/6fqm5Z+ruIIl7lhB3aL5ER6/Q5/uAmF92/akvmM1UZ
	 EYhOaBvBGSS++w2oXIPZZCUzMJZzlfVJ/6yi5yKs=
Date: Sun, 16 Nov 2025 17:33:37 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-use-ptdesc-when-freeing-pmd-pages.patch removed from -mm tree
Message-Id: <20251117013337.E003CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: use 'ptdesc' when freeing PMD pages
has been removed from the -mm tree.  Its filename was
     x86-mm-use-ptdesc-when-freeing-pmd-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


