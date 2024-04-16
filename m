Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D1137C49
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294015; cv=none; b=ZvaRpLkbzFu6qsnCF6t8j0Co9s+vpypeZC9Ni53L5zoDAz7cW/Hogeqg/KpHBXBny4Cr0ZSWdubQbzgd5Wk/fmEHOot4cfzNbR0tggVvbHNR3KwP6cT0R9UpK9ZIz28s3ZLofRrGtsfo85McODSwDIkQFxU2ergfGmAOFslOM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294015; c=relaxed/simple;
	bh=pg6+mOLgDcyOxD3spJdxsTGhC+SSzsG4svTZM7sK2kw=;
	h=Date:To:From:Subject:Message-Id; b=jWdJvYBbZIRPcNfU4ZVyhCaUI0SZ/n9XQJan+e3E7TcjratRh69uJToZ3YUJsgkxPTO0IblqwHT97pB4JTAhntO1eQpVUAZ9PERy+kLFRVeMftyxRdXhknWyh7nHTk/gmcG3anqkMMJbW+S8W8GCx3HeBxbl2Q+VZMYstUFIn40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m60UrgXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m60UrgXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32460C113CE;
	Tue, 16 Apr 2024 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713294015;
	bh=pg6+mOLgDcyOxD3spJdxsTGhC+SSzsG4svTZM7sK2kw=;
	h=Date:To:From:Subject:From;
	b=m60UrgXRTMdEgSI0sejMy2CsvMk730j2ZkQPF1z8187U9JvADKIUYUTt8UMUQ/JJt
	 NTBBbFqpcM2cf+iiV6R6Vl3Cf/HANCwdhtpOkzHAw9yubV1Kip5Qyo52ENDTN4qzA2
	 PbGodxeUI2ijTryym3HBH36UEimF58yjhirrJpCg=
Date: Tue, 16 Apr 2024 12:00:14 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,miguel.ojeda.sandonis@gmail.com,kernel@xen0n.name,chenhuacai@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch added to mm-nonmm-unstable branch
Message-Id: <20240416190015.32460C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/loongarch/include/asm/tlb.h: remove __tlb_remove_tlb_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch

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
Subject: arch/loongarch/include/asm/tlb.h: remove __tlb_remove_tlb_entry()
Date: Tue, 16 Apr 2024 15:51:30 +0200

In preparation for enabling -Wextra, remove this and rely upon the
asm-generic version.

Fixes this warning:

    ./include/asm-generic/tlb.h:629:10: error: parameter 'ptep' set
but not used [-Werror,-Wunused-but-set-parameter]
      629 |                 pte_t *ptep, unsigned int nr, unsigned long address)
          |                        ^


Link: https://lkml.kernel.org/r/c82af143-b620-44d9-8647-f52096b851ab@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/tlb.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/loongarch/include/asm/tlb.h~include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used
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
include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch

