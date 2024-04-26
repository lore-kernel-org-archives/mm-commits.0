Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65188120A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104490; cv=none; b=tuC4evMyxqR9nUDCvs0kVA6De3sQ0RydX73DZkprukWh3yt3aMmHvKTxnF2A88+vxHuKjV2Hc2ckFTfyuS1v08s7Xn5kNbR1nYCY9JBxwYAxadrMvIYWVEOIC6F/I8Dk90xUogiPmBaeeNTTrVsW6Fk1Vh7r75+XntTGSXodsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104490; c=relaxed/simple;
	bh=4MiQYnvZ50P8tBvCRDBFzYetw6qPuzfLNtuGxjA8lCM=;
	h=Date:To:From:Subject:Message-Id; b=Mp14ZGuAlINcCM8OzWw6ysknRsCC5cMlZ88p/IQzoKe9qgzKpsIox/U3drxROVP59me4aATYBDv0KgydSNwrv+VMceQQSm6nRFRQDXtDdNW6rMAg/YtAG10zbpgSd91/r0ZcNy81HY7ixq8MCJHE21jSY5ejFZhrjP/CneR31G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gaYl3K92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gaYl3K92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA9C113CD;
	Fri, 26 Apr 2024 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104490;
	bh=4MiQYnvZ50P8tBvCRDBFzYetw6qPuzfLNtuGxjA8lCM=;
	h=Date:To:From:Subject:From;
	b=gaYl3K92vQu5BvktlxElXVCwLJRQxIh6Dqg5wDB9lrCS8jgb4jHXbOtfS86vi5PvB
	 8kaqQT3+SeUfZSoGacAafReBpamrflXORIlgKVwfYOBHvu+3Y5Z/4ij2KIRM8rtsfW
	 ZfO1/ZtZ9uy5J1BTY3/ESNrhXw/n1CEFEPnhRkjE=
Date: Thu, 25 Apr 2024 21:08:10 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,nathan@kernel.org,miguel.ojeda.sandonis@gmail.com,kernel@xen0n.name,chenhuacai@kernel.org,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch removed from -mm tree
Message-Id: <20240426040810.9CEA9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: LoongArch/tlb: fix "error: parameter 'ptep' set but not used" due to __tlb_remove_tlb_entry()
has been removed from the -mm tree.  Its filename was
     loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Miguel Ojeda <ojeda@kernel.org>
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

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
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
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch

