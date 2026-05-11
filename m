Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159814D90AC
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535265; cv=none; b=Ez4K/zFFHrMOOjGR8yGWEmuZKzxrEr8sc4N2UoZjfL1+3d2WEpGkLdu6t8wk+ZDaM6BtHqjg/6T+aW7Dha+GnHsXHSaRVCsdMYyZS3OSRuFoOg1Bx9ui+wdVF3UxX/RyTNPuKOC4BdvaqGPHvDFz/7Pjyw5nFqBuiB/ie7iqI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535265; c=relaxed/simple;
	bh=6+IGvwlFjEEmOj8HIFTbLcNrHalAEsV63HYv/LNHIQM=;
	h=Date:To:From:Subject:Message-Id; b=EqtJLZSffuTKQ0TlAnmld76NfMdTQBwh3sO9XBDsOKQRR6Sv2kyghznVaMCrpn2H0tjdwT78g9xfTR0kaQLy2nsjRz6T67uQQPWtx7O6qyT0se++pTk19yngtA7mjlSqHRiCO3EhhfU6T/JZM+YZFI9yB8tRV7MrNBGdxZM31cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Laq0Bc7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Laq0Bc7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD16EC2BCB0;
	Mon, 11 May 2026 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535264;
	bh=6+IGvwlFjEEmOj8HIFTbLcNrHalAEsV63HYv/LNHIQM=;
	h=Date:To:From:Subject:From;
	b=Laq0Bc7AOYx3ObU7cdtBcLBpSNvzusFmMhbXF3dF+RHkvaku+KTXWKrzWjlL/7WV0
	 VXB8GWK3S8tp7aZAQxa2FfU+lGDRvsGm2X74JHi0+w+muuYRIoATsNlY+Pe+2XM+sb
	 5IClhXHPDMEhdGdccwtQO8E2zdrC7AwUbwvNNl9s=
Date: Mon, 11 May 2026 14:34:24 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-use-kselftest-framework.patch added to mm-new branch
Message-Id: <20260511213424.CD16EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: use kselftest framework
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-protection_keys-use-kselftest-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-use-kselftest-framework.patch

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
Subject: selftests/mm: protection_keys: use kselftest framework
Date: Mon, 11 May 2026 19:28:01 +0300

Convert protection_keys test to use kselftest framework for reporting and
tracking successful and failing runs.

Adjust dprintf0() printouts to use "#" in the beginning of the line for
TAP compatibility.

Link: https://lore.kernel.org/20260511162840.375890-18-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h    |   15 +++++----
 tools/testing/selftests/mm/protection_keys.c |   26 +++++++++--------
 2 files changed, 23 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-protection_keys-use-kselftest-framework
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -71,13 +71,14 @@ static inline void sigsafe_printf(const
 extern void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
-		dprintf0("assert() at %s::%d test_nr: %d iteration: %d\n", \
-				__FILE__, __LINE__,	\
-				test_nr, iteration_nr);	\
-		dprintf0("errno at assert: %d", errno);	\
-		abort_hooks();			\
-		exit(__LINE__);			\
-	}					\
+		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
+			 __FILE__, __LINE__,				\
+			 test_nr, iteration_nr);			\
+		dprintf0("# errno at assert: %d\n", errno);		\
+		abort_hooks();						\
+		ksft_exit_fail_msg("test %d (iteration %d)\n",		\
+				   test_nr, iteration_nr);		\
+	}								\
 } while (0)
 
 #define barrier() __asm__ __volatile__("": : :"memory")
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-use-kselftest-framework
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -136,6 +136,7 @@ static void tracing_off(void)
 
 void abort_hooks(void)
 {
+	fflush(stdout);
 	fprintf(stderr, "running %s()...\n", __func__);
 	tracing_off();
 #ifdef SLEEP_ON_ABORT
@@ -370,8 +371,8 @@ static void signal_handler(int signum, s
 	if ((si->si_code == SEGV_MAPERR) ||
 	    (si->si_code == SEGV_ACCERR) ||
 	    (si->si_code == SEGV_BNDERR)) {
-		printf("non-PK si_code, exiting...\n");
-		exit(4);
+		dprintf0("# non-PK si_code: %d, exiting...\n", si->si_code);
+		exit(1);
 	}
 
 	si_pkey_ptr = siginfo_get_pkey_ptr(si);
@@ -719,7 +720,7 @@ static void setup_hugetlbfs(void)
 	long hpagesz_mb;
 
 	if (geteuid() != 0) {
-		fprintf(stderr, "WARNING: not run as root, can not do hugetlb test\n");
+		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
@@ -855,7 +856,7 @@ void expected_pkey_fault(int pkey)
 
 #define do_not_expect_pkey_fault(msg)	do {			\
 	if (last_pkey_faults != pkey_faults)			\
-		dprintf0("unexpected PKey fault: %s\n", msg);	\
+		dprintf0("# unexpected PKey fault: %s\n", msg);	\
 	pkey_assert(last_pkey_faults == pkey_faults);		\
 } while (0)
 
@@ -1753,7 +1754,7 @@ static void run_tests_once(void)
 		tracing_off();
 		close_test_fds();
 
-		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
+		ksft_test_result_pass("test %s (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
 		dprintf1("======================\n\n");
 	}
 	iteration_nr++;
@@ -1773,27 +1774,30 @@ int main(void)
 
 	setup_handlers();
 
-	printf("has pkeys: %d\n", pkeys_supported);
+	ksft_print_header();
 
 	if (!pkeys_supported) {
 		int size = PAGE_SIZE;
 		int *ptr;
 
-		printf("running PKEY tests for unsupported CPU/OS\n");
+		ksft_set_plan(1);
+		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 		assert(ptr != (void *)-1);
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
-		exit(0);
+		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
+		ksft_finished();
 	}
 
+	ksft_set_plan(ARRAY_SIZE(pkey_tests) * nr_iterations);
+
 	pkey_setup_shadow();
-	printf("startup pkey_reg: %016llx\n", read_pkey_reg());
+	ksft_print_msg("startup pkey_reg: %016llx\n", read_pkey_reg());
 	setup_hugetlbfs();
 
 	while (nr_iterations-- > 0)
 		run_tests_once();
 
-	printf("done (all tests OK)\n");
-	return 0;
+	ksft_finished();
 }
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

