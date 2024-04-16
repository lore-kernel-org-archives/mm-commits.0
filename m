Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FBD137C49
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295297; cv=none; b=TboJe72fhBurOprOte3h/DuGPySXs2JC2pxgNF9xgLlKj7PhmLbVMHuFdPkwezpGt5LjYtXzXYqrkne5GQEYu6exIHjVdCdwoAgexrZs11+hdZ+7A7AQBk8+wXhm4yJ4Ym+XwkZZUvABYbO7xE1IOtiqCmnCKjdsOOyP2Q2qqUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295297; c=relaxed/simple;
	bh=2KtflPl+/v3w7uW2Hcif20Bw0w6Gz9Qd9EqNs6vYM1c=;
	h=Date:To:From:Subject:Message-Id; b=E+S+m2K80H7+0k5zUFcsWTMgI83yZ5EkWErN916rJeDEnAFqj7Lu+/m4Jh1/4W49vnmMXeAPjTqUmW0xPFr5zB0Kj966/JqkPGO7mlELkSjLbx8NwGoBjyU4sSvlqBmZtULBG3j03mmLqWeQzUGlaCldUQQdJLVF2mFuRBQaVOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FtotGCwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FtotGCwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40449C113CE;
	Tue, 16 Apr 2024 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713295297;
	bh=2KtflPl+/v3w7uW2Hcif20Bw0w6Gz9Qd9EqNs6vYM1c=;
	h=Date:To:From:Subject:From;
	b=FtotGCwQ6r/99A5k/EFyP36GSBEnJm44fgPSpecPOAH5N0s5y5yjwa/WK/r9eUsce
	 kOrPY7g8YbwO4dv5/YbdK6M3ZBqxHUp0lW2shZACFj9JHUAQ586y+BdUV7T74F2OKd
	 N1LKZnfFEHVdhBhHs+KmgWRILwy3JvMAj/EddIDs=
Date: Tue, 16 Apr 2024 12:21:36 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,miguel.ojeda.sandonis@gmail.com,kernel@xen0n.name,chenhuacai@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch removed from -mm tree
Message-Id: <20240416192137.40449C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/loongarch/include/asm/tlb.h: remove __tlb_remove_tlb_entry()
has been removed from the -mm tree.  Its filename was
     include-asm-generic-tlbh-629-10-error-parameter-ptep-set-but-not-used.patch

This patch was dropped because an alternative patch was or shall be merged

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
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

