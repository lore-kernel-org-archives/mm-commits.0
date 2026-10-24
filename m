Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792829902;
	b=EHM2lKweadvZBGWKWqy3U/h64bHN6m+BGFssVJjif/CQZ6RA87T/Y8VP2UW+7NfyKKOs
	 7zCYMcnwOCUjgz254vWGsgxSbqxzQy1dHMcklf2uVW9Cx0w/YfonuzAmETDJiaRQfQonZ
	 ZKdNFg7Yak+01KwKLjVJp/rLLNGlQNVce82IJrsM19JnfT8S6vSBZsow6yXFK/yX0n2NF
	 JaB02IGx7OHoqIytuNIoF/pHPItV2jUOWhxCrM86P0EbXbyf2djgzQpbbiEWl4hbTSfN4
	 smL1rgBfKCN+EV9cUsX0M+iUJT8sQMc7Xa81di8QQu2hMYpi8FDfoLtaivT5ydUTHcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792829902;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eLp1hpUHMTocVqhTPzUs4L9AlZH5SoZa3fdaThA1oT0=;
	b=GtxBy79NW4MGTEHQRNrONWiiLS4A/80wWWXHsWaVSelDxURu6d2UHAfjMveM0LZs7CU5
	 qDtwLsnqJHaFzPIUOp4J2ZzJqbjgxbT5bL8ki5eKslyeLqRA/MYV+2h8xDCoiNw/8+Jbm
	 y1MrAfFvKBVxKGcc8r5h7A2QmmNd0awcO2pRpqRnnJQDk8N0UBy8golBB68ISWpg4nwQL
	 MFy/4gl38mccNmnrprR2JP2ERP+F8KtNi/9YRL4dTdTt3MWoQ7kNGdCrc6FtLndhx6pLn
	 q9dLFRfUtS1e6htLVNE/A1rfG9yZIqhdj9uX3Mf8y4E1pBNAlk8/ID8tzy1OZRFbnMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2QFwXtlY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D7606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2QFwXtlY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC4A1F01825;
	Sat, 24 Oct 2026 08:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792829901;
	bh=eLp1hpUHMTocVqhTPzUs4L9AlZH5SoZa3fdaThA1oT0=;
	h=Date:To:From:Subject;
	b=2QFwXtlY7n7QV307C1n0IY1qEZeXPToMJOa1oKQCe5uqHZugK+zJKQy/SnWmRGTJx
	 +cpMfj1xgyL9C8PgN5Dcfq/8KDguWuy/uE+QUCUrQitgK7zx8/d+qNrBu3oM9RphnM
	 iJf7rutSPDPfeMK+IaMVVmaTMWQVvoh6Y2I5Gnug=
Date: Sat, 24 Oct 2026 01:18:20 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-mm-move-__check_safe_pte_update-fix.patch removed from -mm tree
Message-Id: <20261024081821.3FC4A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: arm64-mm-move-__check_safe_pte_update-fix
has been removed from the -mm tree.  Its filename was
     arm64-mm-move-__check_safe_pte_update-fix.patch

This patch was dropped because it was folded into arm64-mm-move-__check_safe_pte_update.patch

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: arm64-mm-move-__check_safe_pte_update-fix
Date: Mon, 28 Sep 2026 09:42:06 +0200

fix this:

>> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
>> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
>> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
>> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
>> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
>> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow

Link: https://lore.kernel.org/99023678-fd8a-4eef-8e43-a07b504e3e96@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---

 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-move-__check_safe_pte_update-fix
+++ a/arch/arm64/mm/mmu.c
@@ -2392,6 +2392,7 @@ int arch_set_user_pkey_access(int pkey,
 
 	return 0;
 }
+#endif
 
 /*
  * PTE bits configuration in the presence of hardware Dirty Bit Management
@@ -2436,4 +2437,3 @@ void __check_safe_pte_update(struct mm_s
 		     __func__, pte_val(old_pte), pte_val(pte));
 }
 #endif /* CONFIG_DEBUG_VM */
-#endif
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch
mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch
mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch
mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch
arm64-mm-move-__check_safe_pte_update.patch
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

