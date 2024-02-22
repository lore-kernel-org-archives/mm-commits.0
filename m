Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D56E5F1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644485; cv=none; b=jOQso+QbTrludKqP8+tIXLbCgfxLeCzzErsL2MaG/5QVEMsnhpmjs/5AQ2p3KaaSLgd6dgRmYG1y8lZfMgGvxEzsZBA7+ftAPELwJY0Pc5YLFSF7yARfL2RoQ7QKKFyz4iuJQsPjbHTFeRzIoTs8twGvnPkld5eBniyhN5EsmqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644485; c=relaxed/simple;
	bh=vmwfIOkXg9SLKNU+3SNNA3WeNjbGV3BH605TVhyeFbg=;
	h=Date:To:From:Subject:Message-Id; b=hQ5V5iGmz6JCmuwYk0ZyP6tlNwYarvi12QqMsVwOfVRMlEP5vR0oDaeZ7iFdIP3dFqdp6qXa+xd0+qyoXUxIkVYPhgIJMqA4VOYaC4tKygs6p8U5/e91I5n9ifShlfTMx4DlAmNLeE70ZFxqtU+OZZKt1GvYtxeK5aZi8uhOqEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gt3I1a5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gt3I1a5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144C5C433F1;
	Thu, 22 Feb 2024 23:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644485;
	bh=vmwfIOkXg9SLKNU+3SNNA3WeNjbGV3BH605TVhyeFbg=;
	h=Date:To:From:Subject:From;
	b=gt3I1a5EBNn6E5e31pE51eRHwozqImUDCvyQrEiH1n/4O5tKkNLP67pKp9oRawXLT
	 lVJCQovdOxP25MWIp5ElOS94akntqT0OaYEhuS+AOHz5gXdFV6lzAQ0IAG5fQuZ1vG
	 lTbiGtKg19SFqxAffzq1XTJMuo1PwJ3HcabUH5iE=
Date: Thu, 22 Feb 2024 15:28:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-batch-collapse-pmd-with-set_ptes.patch removed from -mm tree
Message-Id: <20240222232805.144C5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: batch-collapse PMD with set_ptes()
has been removed from the -mm tree.  Its filename was
     mm-thp-batch-collapse-pmd-with-set_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: batch-collapse PMD with set_ptes()
Date: Thu, 15 Feb 2024 10:31:49 +0000

Refactor __split_huge_pmd_locked() so that a present PMD can be collapsed
to PTEs in a single batch using set_ptes().

This should improve performance a little bit, but the real motivation is
to remove the need for the arm64 backend to have to fold the contpte
entries.  Instead, since the ptes are set as a batch, the contpte blocks
can be initially set up pre-folded (once the arm64 contpte support is
added in the next few patches).  This leads to noticeable performance
improvement during split.

Link: https://lkml.kernel.org/r/20240215103205.2607016-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   58 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~mm-thp-batch-collapse-pmd-with-set_ptes
+++ a/mm/huge_memory.c
@@ -2579,15 +2579,16 @@ static void __split_huge_pmd_locked(stru
 
 	pte = pte_offset_map(&_pmd, haddr);
 	VM_BUG_ON(!pte);
-	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-		pte_t entry;
-		/*
-		 * Note that NUMA hinting access restrictions are not
-		 * transferred to avoid any possibility of altering
-		 * permissions across VMAs.
-		 */
-		if (freeze || pmd_migration) {
+
+	/*
+	 * Note that NUMA hinting access restrictions are not transferred to
+	 * avoid any possibility of altering permissions across VMAs.
+	 */
+	if (freeze || pmd_migration) {
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			pte_t entry;
 			swp_entry_t swp_entry;
+
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
@@ -2606,25 +2607,32 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_swp_mkuffd_wp(entry);
-		} else {
-			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
-			if (write)
-				entry = pte_mkwrite(entry, vma);
-			if (!young)
-				entry = pte_mkold(entry);
-			/* NOTE: this may set soft-dirty too on some archs */
-			if (dirty)
-				entry = pte_mkdirty(entry);
-			if (soft_dirty)
-				entry = pte_mksoft_dirty(entry);
-			if (uffd_wp)
-				entry = pte_mkuffd_wp(entry);
+
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
 		}
-		VM_BUG_ON(!pte_none(ptep_get(pte)));
-		set_pte_at(mm, addr, pte, entry);
-		pte++;
+	} else {
+		pte_t entry;
+
+		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		if (write)
+			entry = pte_mkwrite(entry, vma);
+		if (!young)
+			entry = pte_mkold(entry);
+		/* NOTE: this may set soft-dirty too on some archs */
+		if (dirty)
+			entry = pte_mkdirty(entry);
+		if (soft_dirty)
+			entry = pte_mksoft_dirty(entry);
+		if (uffd_wp)
+			entry = pte_mkuffd_wp(entry);
+
+		for (i = 0; i < HPAGE_PMD_NR; i++)
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+
+		set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
 	}
-	pte_unmap(pte - 1);
+	pte_unmap(pte);
 
 	if (!pmd_migration)
 		folio_remove_rmap_pmd(folio, page, vma);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


