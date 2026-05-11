Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFC52DF717
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535262; cv=none; b=GiOxXrrpjLo1t4fzOcNU1i0HdeDM/My7OXg1gzD+Kwt6FG09vRhvt2bGkaFS1eoBEtb4UU8lcxjq9WXmc2YNUfQucCvYQWaDZ5namatjbsAArBjK3P4RP31bWGQCdxUveKtO/ZqIsMw21dyJOykVYxAKVIM3JGYms3Dc1x5c7sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535262; c=relaxed/simple;
	bh=hRA8DGrJHKA9kIjFcoMjUf7eprl20rMZbmYU4pM2zBc=;
	h=Date:To:From:Subject:Message-Id; b=CxjYLluImhWwlRjcKx2R2cGNUHUZrLX1m/TCH45cZP5FpGEdZQTn/hPDArWcLOOc4IBJaF7ZFbeJJy1mgMXthnOWSLC/eopmDmVm/LozTtHPjoa8FAfCJJq6LYqFtHWolPoNDJCzY2a9NjbWO0EvXR60Xn2Egz1KUSVmVosTYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xv1Gn2ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xv1Gn2ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BA6C2BCF5;
	Mon, 11 May 2026 21:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535262;
	bh=hRA8DGrJHKA9kIjFcoMjUf7eprl20rMZbmYU4pM2zBc=;
	h=Date:To:From:Subject:From;
	b=Xv1Gn2lli1Za6YVQG5cKoLStLvwB5FnXj5Rxs1eiIwRyQ8LWV2ysx/srFBSiQNmXI
	 8ayz9jDQ6lSE/UTNmgyaQ4ZsizZxDxYH+QuVLxddb8g2qtEaxZYx7U7XD6tV7HvtyN
	 xBwOTziiDoVgupfR9ffLkRQ8hFkwW+rM1ffFFMhk=
Date: Mon, 11 May 2026 14:34:22 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch added to mm-new branch
Message-Id: <20260511213422.84BA6C2BCF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: use descriptive test names in the output
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: protection_keys: use descriptive test names in the output
Date: Mon, 11 May 2026 19:28:00 +0300

Replace the numeric test index in TAP output with the actual test function
name.

Use a structure containing function pointer and its name rather than only
the function pointer in the pkey_tests array.

Link: https://lore.kernel.org/20260511162840.375890-17-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |   55 +++++++++--------
 1 file changed, 31 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-use-descriptive-test-names-in-the-output
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1692,29 +1692,36 @@ static void test_mprotect_pkey_on_unsupp
 	pkey_assert(sret < 0);
 }
 
-static void (*pkey_tests[])(int *ptr, u16 pkey) = {
-	test_read_of_write_disabled_region,
-	test_read_of_access_disabled_region,
-	test_read_of_access_disabled_region_with_page_already_mapped,
-	test_write_of_write_disabled_region,
-	test_write_of_write_disabled_region_with_page_already_mapped,
-	test_write_of_access_disabled_region,
-	test_write_of_access_disabled_region_with_page_already_mapped,
-	test_kernel_write_of_access_disabled_region,
-	test_kernel_write_of_write_disabled_region,
-	test_kernel_gup_of_access_disabled_region,
-	test_kernel_gup_write_to_write_disabled_region,
-	test_executing_on_unreadable_memory,
-	test_implicit_mprotect_exec_only_memory,
-	test_mprotect_with_pkey_0,
-	test_ptrace_of_child,
-	test_pkey_init_state,
-	test_pkey_syscalls_on_non_allocated_pkey,
-	test_pkey_syscalls_bad_args,
-	test_pkey_alloc_exhaust,
-	test_pkey_alloc_free_attach_pkey0,
+struct pkey_test {
+	void (*func)(int *ptr, u16 pkey);
+	const char *name;
+};
+
+#define PKEY_TEST(fn) { fn, #fn }
+
+static struct pkey_test pkey_tests[] = {
+	PKEY_TEST(test_read_of_write_disabled_region),
+	PKEY_TEST(test_read_of_access_disabled_region),
+	PKEY_TEST(test_read_of_access_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_write_of_write_disabled_region),
+	PKEY_TEST(test_write_of_write_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_write_of_access_disabled_region),
+	PKEY_TEST(test_write_of_access_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_kernel_write_of_access_disabled_region),
+	PKEY_TEST(test_kernel_write_of_write_disabled_region),
+	PKEY_TEST(test_kernel_gup_of_access_disabled_region),
+	PKEY_TEST(test_kernel_gup_write_to_write_disabled_region),
+	PKEY_TEST(test_executing_on_unreadable_memory),
+	PKEY_TEST(test_implicit_mprotect_exec_only_memory),
+	PKEY_TEST(test_mprotect_with_pkey_0),
+	PKEY_TEST(test_ptrace_of_child),
+	PKEY_TEST(test_pkey_init_state),
+	PKEY_TEST(test_pkey_syscalls_on_non_allocated_pkey),
+	PKEY_TEST(test_pkey_syscalls_bad_args),
+	PKEY_TEST(test_pkey_alloc_exhaust),
+	PKEY_TEST(test_pkey_alloc_free_attach_pkey0),
 #if defined(__i386__) || defined(__x86_64__) || defined(__aarch64__)
-	test_ptrace_modifies_pkru,
+	PKEY_TEST(test_ptrace_modifies_pkru),
 #endif
 };
 
@@ -1735,7 +1742,7 @@ static void run_tests_once(void)
 		dprintf1("test %d starting with pkey: %d\n", test_nr, pkey);
 		ptr = malloc_pkey(PAGE_SIZE, prot, pkey);
 		dprintf1("test %d starting...\n", test_nr);
-		pkey_tests[test_nr](ptr, pkey);
+		pkey_tests[test_nr].func(ptr, pkey);
 		dprintf1("freeing test memory: %p\n", ptr);
 		free_pkey_malloc(ptr);
 		sys_pkey_free(pkey);
@@ -1746,7 +1753,7 @@ static void run_tests_once(void)
 		tracing_off();
 		close_test_fds();
 
-		printf("test %2d PASSED (iteration %d)\n", test_nr, iteration_nr);
+		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
 		dprintf1("======================\n\n");
 	}
 	iteration_nr++;
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
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

