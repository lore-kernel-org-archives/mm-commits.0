Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E0137939
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295209; cv=none; b=MgVsF6UghJnYYU0HRVnCIrRljW0xcUx/a52sH0RlAxysn84CUshDTjzne/LhF6avm+9DqULyGM6KYRjrGpIUNWxWVySH57o5SwKXVliG6KMmgsl/F/j1zN2r09mYsIXVQ86VhvrEF/1QPB/eXL+L2+GYUynV14Oj5lu6Wbk7rk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295209; c=relaxed/simple;
	bh=EwY/9XBNdtMreH1tSX75SXnOcQogXb6tFMPhefVpx2U=;
	h=Date:To:From:Subject:Message-Id; b=O8bn5zLu6jOet7+6cvll9DVt6nbR3aTjI1bbn8nfLSgfA+jQl7s2rA/+m0ftEWRdvY6JWmf1KQVMIYScFrboQoqyCLeBXiE1rMLasI/mziE8OMFDfGhIat4tJEa+Cx2XH0gINconmYZDSi30c6bbGOBYWYpsrwX/MzWgX5ZwjZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMIPmibb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMIPmibb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E3C113CE;
	Tue, 16 Apr 2024 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713295208;
	bh=EwY/9XBNdtMreH1tSX75SXnOcQogXb6tFMPhefVpx2U=;
	h=Date:To:From:Subject:From;
	b=GMIPmibboMMrtNqW07rrlO5c56PpVZWDc68uXEKeDDrBt/a4bzVHoJMHzqvmHeT2K
	 i2+VojP3gPM3pO4LNou+jDWHvmywq0oARZH4vyeDfRsQ4D5hjKT0uxNUsedHQFkOyC
	 gXlCOtzIJThM4x/yyx00Eu/NC/vkkJPV9SaCRIKI=
Date: Tue, 16 Apr 2024 12:20:07 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,miguel.ojeda.sandonis@gmail.com,kernel@xen0n.name,chenhuacai@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20240416192008.5B3E3C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LoongArch/tlb: fix "error: parameter 'ptep' set but not used" due to __tlb_remove_tlb_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Hildenbrand <david@redhat.com>
Subject: LoongArch/tlb: fix "error: parameter 'ptep' set but not used" due to __tlb_remove_tlb_entry()
Date: Tue, 16 Apr 2024 16:49:26 +0200

With LLVM=1 and W=1 we get:

  ./include/asm-generic/tlb.h:629:10: error: parameter 'ptep' set
  but not used [-Werror,-Wunused-but-set-parameter]

We fixed a similar issue via Arnd in the introducing commit, missed the
loongarch variant. Turns out, there is no need for loongarch to have a
custom variant, so let's just drop it and rely on the asm-generic one.

Link: https://lkml.kernel.org/r/20240416144926.599101-1-david@redhat.com
Fixes: 4d5bf0b6183f ("mm/mmu_gather: add tlb_remove_tlb_entries()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Closes: https://lkml.kernel.org/r/CANiq72mQh3O9S4umbvrKBgMMorty48UMwS01U22FR0mRyd3cyQ@mail.gmail.com
Tested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/tlb.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/loongarch/include/asm/tlb.h~loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry
+++ a/arch/loongarch/include/asm/tlb.h
@@ -132,8 +132,6 @@ static __always_inline void invtlb_all(u
 		);
 }
 
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
-
 static void tlb_flush(struct mmu_gather *tlb);
 
 #define tlb_flush tlb_flush
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch
include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch

