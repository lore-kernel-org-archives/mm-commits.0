Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792781045;
	b=dieaLxxt95PeoZf3Ch4AmnU2lci4k2tB8YoLE3fVvCESQFQBYZUr5JInAR6U2QoeW4h3
	 TX4mM/HKlt+3hwIBJ1jqusxSGOmq1iKuPwXU34Esqy6rcICNoewdXrUF54ItG5In2f228
	 pi7zY2K1Ov9lUi/dqHHG1QScGzo/6uFL8SVoHh8og5J5z/GaUZ2sdC8H+YZPbezpuYmBk
	 eFgavxT/ytTfOSPxVyitA2Fd7A/kmn2/cfP/spM6ReyizpmIdMHAWv/Z2oI/nPjndpPXc
	 d37Lpx3ft0yEONP2StK1eNDQEF33rNzJx+nNmGYYh5vo/GT8ka2w9myRSFfetL1OhcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781045;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=g5A1ri2GF8L9E68ZWCDKheCuHTXXyMzXD+47Nx1Mk0s=;
	b=dW0SHjzLA0sGsN3UO+bIv8Blof2U2O3h0qpWh2LFK2cl8MgTdPLaacy0DRPB/6RtYl5/
	 eZqKweO23gHk67ZCiQT7hmneSV5105d3ZszHsdQLUkUghiu6PM02Dv0iFLqQ8M4XIomDG
	 WHFvdkZ/qGdq16Xv2WG3delZJmD1NiJ86sQFxeIfK1e2nqPc7QDi2vUr1Nmgs9YEBYx52
	 LPrRztSfEUIYzgcXZ78vc6ABtMVtk87ekG/vAbF9KurPAR2N8+ZXE6jk9XRIQhWD0bxNC
	 RbH19xQpJeWp8lgiPrK0xy4SDviMpbQ0Ln//gLHpX7T7Lz4PTE24qBxDLu7n98H+UWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="X+/iGQYy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AFC606A325;
	Fri, 23 Oct 2026 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X+/iGQYy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA381F01825;
	Fri, 23 Oct 2026 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792781044;
	bh=g5A1ri2GF8L9E68ZWCDKheCuHTXXyMzXD+47Nx1Mk0s=;
	h=Date:To:From:Subject;
	b=X+/iGQYyjOKoeFfE/tnGYUTonb5qKY5Lu94XURyjejnCreuIR6tuQp3berqM+iwQX
	 WySzh/wLUYA9NNtNo20HVql4OCe8IzsM6ZvikbEVXoBWlrtCMbt5AXv6KkjM7EfFbP
	 yOLO+v4oasoXLShxNbw3Y5bBP0c5cjOs7JlL8XPA=
Date: Fri, 23 Oct 2026 11:44:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,jannh@google.com,dave@stgolabs.net,ccross@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch added to mm-unstable branch
Message-Id: <20261023184404.CAA381F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Fri, 23 Oct 2026 14:47:29 +0100

When changing the anonymous VMA name, madvise_update_vma() calls
vma_modify_name() to possibly merge with adjacent VMAs. We don't call
vma_modify_flags() and consequently don't obtain the new VMA flags.

Later in the function we update the VMA flags to the stale new_vma_flags
we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
flag set on a VMA we just merged with.

There is no need to update the VMA flags at all, so just exit early. This
skips calling khugepaged_enter_vma(), but since the flags didn't change
this is fine.

[ljs@kernel.org: minor edit of commit message, rebased]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names
+++ a/mm/madvise.c
@@ -177,6 +177,9 @@ static int madvise_update_vma(vm_flags_t
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vma_overwrite_flags(vma, new_vma_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
@@ -186,9 +189,6 @@ static int madvise_update_vma(vm_flags_t
 	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
 		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
 
-	if (set_new_anon_name)
-		return replace_anon_vma_name(vma, anon_name);
-
 	return 0;
 }
 
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
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

