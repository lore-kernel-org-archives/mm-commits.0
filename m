Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA4D4D9F84
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623252; cv=none; b=gTJrrbr4v6D/ntHH5/behaWsNnuKz58KxgbWgv8mcGJcbTzhEO41ecB00F5idsgT8BQci/tbFZpWKQwzJA/L6RKiK7EFjXcDozoIr28wo8d+Lnyhk8vdQSzdmXL2F3oSuqtfyV8f+yCLOK6xiFoXWUkLQAzZOiv7KnID5bzm2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623252; c=relaxed/simple;
	bh=HQcrEDi3Biv/kdgc/RILZCfATg6DaShSVJOgVZX8BKQ=;
	h=Date:To:From:Subject:Message-Id; b=MYIZ334xsEPzJHzMyAzjAoNatt31vvDRPDoelnWKyFqunUF+T5pw9z5jU9XCdFWWxANI96Q95Ynttk9nLDDcj9mMeWRN44b6qy1NzBmsofOKAo+7csMm7z4UAdYucn6U6Mrs/O+YEpydnrlc4ntxIDFstLnY5Ecrtj2JT+hYeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwmArh8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwmArh8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4A71F000FF;
	Mon, 28 Sep 2026 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790623250;
	bh=Z4ncwOoI8iODylp1xSX48X2s3b7/boky1sTxf0uCUiY=;
	h=Date:To:From:Subject;
	b=YwmArh8wH5/Zf7OL1gZwG8DUYeqtmuUZjsb6RgzUj0CE5JdL1ihfzb9Ad3BnPRjj1
	 ysI70JEVlm2Q1frflS3FpMWQHf0wAkLrlL2c4VYNiyaoLz4+5e9Byi7nDSZ/4GQR0s
	 PSpCc0MdRhRd/FqZP0dfliSVzbd9b7D1tUdBzioM=
Date: Mon, 28 Sep 2026 12:20:49 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-move-__check_safe_pte_update-fix.patch added to mm-unstable branch
Message-Id: <20260928192050.1C4A71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64-mm-move-__check_safe_pte_update-fix
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-move-__check_safe_pte_update-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-move-__check_safe_pte_update-fix.patch

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

selftests-mm-khugepaged-remove-str_dup-usage.patch
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
arm64-mm-move-__check_safe_pte_update-fix.patch

