Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C423B28D
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719235; cv=none; b=VL59pR3YaSrOjFJxs3PsSWDIvmSokaO82qqlHO0XuZYho6UZFG6WHbzAt3jZf3on3gdlgpJR3lE3Mf6L1j//WcA5rcylx/w7Y3hTw32pzBE0Bwi9vg9vXiGI7X/ZxK8DbhVEn6N/zfziSpe7NwFl/CqRjzjtfz0j13PDP906e0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719235; c=relaxed/simple;
	bh=aH5cDMMN96bWshHCZGzpV7Jh5w980ES6vhkTEH8ldYQ=;
	h=Date:To:From:Subject:Message-Id; b=nC+/l22qtn5quyTuAoobbIeKNawSO1mkBcTTSIMKATOq0g8edXjmsrqQ7ZWC3dn8JF2Uv1GofUMEaHKQdLHpPk8JH1k/BVbrQbrEFbjEhIgzKRLXEdb/XgBKNyoozIHVqs3bOxn9HRN2or/adVudPmZvgOGm5Fa34Cy5EFkvpvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPWaamT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPWaamT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA04BC19425;
	Thu, 14 May 2026 00:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719234;
	bh=aH5cDMMN96bWshHCZGzpV7Jh5w980ES6vhkTEH8ldYQ=;
	h=Date:To:From:Subject:From;
	b=VPWaamT2yTB3J5wsWdvNXJgbqfiBwpG2EUPx8+584IJdj4nF+il/2tVgi8ac97Vjo
	 qQKsVrIXXJQxoIZ9QIvYoT3awQ8EXm/Rf8HnUmREI5S7bXsJr8L4c7zExnOxl/ZiCU
	 NofEzYYF1/bBxmOtStH/XTfYj5kwQiR4QWRl2qG8=
Date: Wed, 13 May 2026 17:40:34 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,pratyush@kernel.org,pasha.tatashin@soleen.com,ebiederm@xmission.com,baoquan.he@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-kexec-list-to-live-update-entry.patch removed from -mm tree
Message-Id: <20260514004034.CA04BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY
has been removed from the -mm tree.  Its filename was
     maintainers-add-kexec-list-to-live-update-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY
Date: Tue, 28 Apr 2026 15:48:33 +0300

Link: https://lore.kernel.org/20260428124833.1903302-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
Acked-by: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-kexec-list-to-live-update-entry
+++ a/MAINTAINERS
@@ -14897,6 +14897,7 @@ LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pratyush Yadav <pratyush@kernel.org>
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
_

Patches currently in -mm which might be from rppt@kernel.org are

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

