Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95418190473
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717764; cv=none; b=NwTx5bHHxbXwFtE8bHwvebIu4VWS2zdciILVTotm6KztsvHbVlbKyzRYPozpBNj5satIbHFWHBHsFNka6/YWJqCcj4xHz1tMV/Z6sUKtN6Sm3vVF0iR1E8fQrhjyVB9X80wszPD6MVYQmPMltAN69pHyQiFSQxwNd2DCXR26NTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717764; c=relaxed/simple;
	bh=QiJEu00p7HSgTC0ppqh+CcPWf1F8DW9ls59YCsFzIfo=;
	h=Date:To:From:Subject:Message-Id; b=CVXUWaenEVRq/P+Tqq0cfVrkQQQlQdoRkQkVEcZUSbN36x34MyTyQ+pALTuqAebuwaZEuPJR/j3RNFnZJFru2sQR4L6ejoT+YT5+EzDk7c9cO7iN8i5/pwu9cDTvJFRVPUMhdGmkq4/clltUxgIT7glsKVk6MHkgJl3Q/oThj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGG+/ltt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGG+/ltt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A24C19425;
	Thu, 14 May 2026 00:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717764;
	bh=QiJEu00p7HSgTC0ppqh+CcPWf1F8DW9ls59YCsFzIfo=;
	h=Date:To:From:Subject:From;
	b=HGG+/ltt4OibQa7ZMML/FnKUsWrGozx1oBMrLRzHL23g6KFjzyMCgaMMKiQ5D0DO5
	 gip9l8Tg3iseEIghm7B/LTdPT/AwdldwYhG25iI/E9dwG9fGQtkxLzQzQgw2oOWuYh
	 UtM8cQiFJrVA4VWBae76b1hXa+Pc5xP7ZM0F30IM=
Date: Wed, 13 May 2026 17:16:03 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,thomas.weissschuh@linutronix.de,glaubitz@physik.fu-berlin.de,geert+renesas@glider.be,dalias@libc.org,contact@artur-rojek.eu,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] sh-fix-fallout-from-zero_page-consolidation.patch removed from -mm tree
Message-Id: <20260514001604.07A24C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh: fix fallout from ZERO_PAGE consolidation
has been removed from the -mm tree.  Its filename was
     sh-fix-fallout-from-zero_page-consolidation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: fix fallout from ZERO_PAGE consolidation
Date: Fri, 17 Apr 2026 13:32:07 +0300

Consolidation of empty_zero_page declarations broke boot on sh.

sh stores its initial boot parameters in a page reserved in
arch/sh/kernel/head_32.S.  Before commit 6215d9f4470f ("arch, mm:
consolidate empty_zero_page") this page was referenced in C code as an
array and after that commit it is referenced as a pointer.

This causes wrong code generation and boot hang.

Declare boot_params_page as an array to fix the issue.

Link: https://lore.kernel.org/20260417103208.1217010-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Fixes: 6215d9f4470f ("arch, mm: consolidate empty_zero_page")
Reported-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/include/asm/setup.h~sh-fix-fallout-from-zero_page-consolidation
+++ a/arch/sh/include/asm/setup.h
@@ -7,7 +7,7 @@
 /*
  * This is set up by the setup-routine at boot-time
  */
-extern unsigned char *boot_params_page;
+extern unsigned char boot_params_page[];
 #define PARAM boot_params_page
 
 #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-khugepaged-use-ksefltest-framework-fix.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch
userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch

