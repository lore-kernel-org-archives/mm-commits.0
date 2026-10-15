Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0595148423C;
	Thu, 15 Oct 2026 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105111; cv=none; b=Dd8xiKCq6LxBGdJJ5n/w8rYrXOFVcS2qtkJxYPld/8WunAIWoFkHxknVQYP2xv05hi+7vW5gKiXLlTaMk2Y2lQLzrJaiSy798VqY4XeICWzZtAMQVqHgY+Pcd8axaVq+7yl0vfkBcsOHIuFgj7wCKd+s/5hIvmmYDFw10cDXcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105111; c=relaxed/simple;
	bh=IydqVruno6RNq8IlH5sEDYdTe+Ul8nzuR5H0/IZlKDo=;
	h=Date:To:From:Subject:Message-Id; b=LXih8oyGdm1Ryqx9SWrol2Ab1F2285nT/0qn5K/HvZirk2w27M+7LO35ClbttcrD0DBJvnF2x2Zctf9vaNkyUzVEDAyxbRb57jbCz/IkvCq6uWmOb/nAeDM39Wy3XJYBHqm+OEtTz2dH6F+3D3wgOulpe4BGi9fMnRhthmPSNmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Go3Q/NCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Go3Q/NCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA52E1F000C4;
	Thu, 15 Oct 2026 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105107;
	bh=vCHO3FmBQTMc2ZZl8xAePg3Zkte0ZLkM96zB8fFSQP0=;
	h=Date:To:From:Subject;
	b=Go3Q/NCKEJLbscTDKrnM3dHP5WNmP4aZCR1EcII33eGgh4AEYsxaMlMyYKSgT9jkz
	 LsBe3ojj7SQBlXDdOQ1+NNajoY+pmsTUjICPFu9aq9B35ccHvfUblhm/fhYC8qSHC9
	 UtmT2Ma9R4Vjc7NSsuLwrbAAW7f1SkNXqU1yWLKg=
Date: Thu, 15 Oct 2026 15:58:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225827.BA52E1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
Date: Thu, 15 Oct 2026 18:07:13 +0200

The whole uffd handling when a VMA is unregistered from UFFD is shaky:
there are still some scenarios where we might have stale uffd PTE bits
in VMAs no longer registered for UFFD, which confuses other code.

Let's just tolerate that for now and simply clear the PTE bit. Add a
TODO to really clean up any uffd leftovers when unregistering a VMA from
userfaultfd.

The handling is now more similar to what we have in handle_pte_fault().

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-7-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes
+++ a/mm/hugetlb.c
@@ -6138,16 +6138,20 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * NUMA hinting), so let normal hugetlb fault handling proceed.
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
-	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+	    huge_pte_uffd(vmf.orig_pte)) {
 		spinlock_t *ptl;
 		pte_t pte;
 
 		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
-		if (!userfaultfd_rwp_async(vma))
+		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
 			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
 
 		ptl = huge_pte_lock(h, mm, vmf.pte);
 		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
 			unsigned int shift = huge_page_shift(h);
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch
mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch
mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch
mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch
arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch
mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch
mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch

