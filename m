Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF802DF717
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535272; cv=none; b=qrP+/ayDlou2ut+t6Cpdyxo4b5oL9Xl/6Ui4agbOda5oUzZvog7ht+GCzjW5Rr58qG0GYr+McITUxMGtvgfpl4EgNiios8Wj77SaIB3uYTS9lFrJE1gngYXDErlZbo1vgURRdj9leg801k3j1EsIVf+3OHI3a/SpUlgEzgOLQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535272; c=relaxed/simple;
	bh=20wa2ay8lecYgmvjg1eLL/A3bMArEK/10ey44YyJg2A=;
	h=Date:To:From:Subject:Message-Id; b=FPksY9+gZk/Xy8tewH11yzUAwChBvmS7t+ChkcA0k9o+omkI+kJ0Q0rhEVjlsOLGiPDJQXs0dgxeI+3BM3A+tiFC0nulyTz5qBcx+FJP+1ryCjybtkNcByeSFG08TIZUd1bUb5GG9n8NGFOq1D6ONq0oUfwnAUCtchE581YMT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHSXrhR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHSXrhR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F05C2BCB0;
	Mon, 11 May 2026 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535272;
	bh=20wa2ay8lecYgmvjg1eLL/A3bMArEK/10ey44YyJg2A=;
	h=Date:To:From:Subject:From;
	b=wHSXrhR34DDoK207X1YxhrLc0DXRsdlIR02QMcI7sYqtwNa1QblbgOvgkY7PyObK+
	 LvQSQvB3p9nkHSamU+s5PlVWZTA5VNuS7Y1O1O/vvcRjzv63ha3qd4N2xWBV1gF+9Y
	 3zsnOogAQh0HDaz4OIFaWlJLl/KSeP5VAi6CAqLM=
Date: Mon, 11 May 2026 14:34:31 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-unit-tests-use-kselftest-framework.patch added to mm-new branch
Message-Id: <20260511213432.16F05C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: uffd-unit-tests: use kselftest framework
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-unit-tests-use-kselftest-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-unit-tests-use-kselftest-framework.patch

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
Subject: selftests/mm: uffd-unit-tests: use kselftest framework
Date: Mon, 11 May 2026 19:28:04 +0300

Convert uffd-unit-tests to use kselftest framework for reporting and
tracking successful and failing runs.

Link: https://lore.kernel.org/20260511162840.375890-21-rppt@kernel.org
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

 tools/testing/selftests/mm/uffd-unit-tests.c |  105 ++++++++---------
 1 file changed, 52 insertions(+), 53 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-tests-use-kselftest-framework
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -86,47 +86,28 @@ typedef struct {
 	uffd_test_case_ops_t *test_case_ops;
 } uffd_test_case_t;
 
-static void uffd_test_report(void)
-{
-	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
-	       ksft_get_pass_cnt(),
-	       ksft_get_xskip_cnt(),
-	       ksft_get_fail_cnt(),
-	       ksft_test_num());
-}
+static char current_test[256];
 
 static void uffd_test_pass(void)
 {
-	printf("done\n");
-	ksft_inc_pass_cnt();
+	ksft_test_result_pass("%s\n", current_test);
 }
 
 #define  uffd_test_start(...)  do {		\
-		printf("Testing ");		\
-		printf(__VA_ARGS__);		\
-		printf("... ");			\
-		fflush(stdout);			\
+		snprintf(current_test, sizeof(current_test), __VA_ARGS__); \
 	} while (0)
 
-#define  uffd_test_fail(...)  do {		\
-		printf("failed [reason: ");	\
-		printf(__VA_ARGS__);		\
-		printf("]\n");			\
-		ksft_inc_fail_cnt();		\
+#define  uffd_test_fail(fmt, ...)  do {					\
+		ksft_print_msg("failed reason: [" fmt "]\n", ##__VA_ARGS__); \
+		ksft_test_result_fail("%s\n", current_test);		\
 	} while (0)
 
 static void uffd_test_skip(const char *message)
 {
-	printf("skipped [reason: %s]\n", message);
-	ksft_inc_xskip_cnt();
+	ksft_test_result_skip("%s (%s)\n", current_test, message);
 }
 
-/*
- * Returns 1 if specific userfaultfd supported, 0 otherwise.  Note, we'll
- * return 1 even if some test failed as long as uffd supported, because in
- * that case we still want to proceed with the rest uffd unit tests.
- */
-static int test_uffd_api(bool use_dev)
+static void test_uffd_api(bool use_dev)
 {
 	struct uffdio_api uffdio_api;
 	int uffd;
@@ -140,7 +121,7 @@ static int test_uffd_api(bool use_dev)
 		uffd = uffd_open_sys(UFFD_FLAGS);
 	if (uffd < 0) {
 		uffd_test_skip("cannot open userfaultfd handle");
-		return 0;
+		return;
 	}
 
 	/* Test wrong UFFD_API */
@@ -177,8 +158,6 @@ static int test_uffd_api(bool use_dev)
 	uffd_test_pass();
 out:
 	close(uffd);
-	/* We have a valid uffd handle */
-	return 1;
 }
 
 
@@ -1701,6 +1680,26 @@ static void usage(const char *prog)
 	exit(KSFT_FAIL);
 }
 
+static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
+{
+	uffd_test_case_t *test;
+	int i, j, count = 0;
+
+	if (!test_filter)
+		count += 2;	/* test_uffd_api(false) + test_uffd_api(true) */
+
+	for (i = 0; i < n_tests; i++) {
+		test = &uffd_tests[i];
+		if (test_filter && !strstr(test->name, test_filter))
+			continue;
+		for (j = 0; j < n_mems; j++)
+			if (test->mem_targets & mem_types[j].mem_flag)
+				count++;
+	}
+
+	return count;
+}
+
 int main(int argc, char *argv[])
 {
 	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
@@ -1711,8 +1710,7 @@ int main(int argc, char *argv[])
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
 	const char *errmsg;
-	int has_uffd, opt;
-	int i, j;
+	int i, j, opt;
 
 	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
 		switch (opt) {
@@ -1730,24 +1728,28 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!test_filter && !list_only) {
-		has_uffd = test_uffd_api(false);
-		has_uffd |= test_uffd_api(true);
-
-		if (!has_uffd) {
-			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
-			exit(KSFT_SKIP);
+	if (list_only) {
+		for (i = 0; i < n_tests; i++) {
+			test = &uffd_tests[i];
+			if (test_filter && !strstr(test->name, test_filter))
+				continue;
+			printf("%s\n", test->name);
 		}
+		return KSFT_PASS;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
+
+	if (!test_filter) {
+		test_uffd_api(false);
+		test_uffd_api(true);
 	}
 
 	for (i = 0; i < n_tests; i++) {
 		test = &uffd_tests[i];
 		if (test_filter && !strstr(test->name, test_filter))
 			continue;
-		if (list_only) {
-			printf("%s\n", test->name);
-			continue;
-		}
 		for (j = 0; j < n_mems; j++) {
 			mem_type = &mem_types[j];
 
@@ -1758,6 +1760,10 @@ int main(int argc, char *argv[])
 			uffd_test_ops = mem_type->mem_ops;
 			uffd_test_case_ops = test->test_case_ops;
 
+			if (!(test->mem_targets & mem_type->mem_flag))
+				continue;
+
+			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
 				gopts.page_size = default_huge_page_size();
 				if (gopts.page_size == 0) {
@@ -1777,10 +1783,6 @@ int main(int argc, char *argv[])
 			/* Initialize test arguments */
 			args.mem_type = mem_type;
 
-			if (!(test->mem_targets & mem_type->mem_flag))
-				continue;
-
-			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
@@ -1794,10 +1796,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!list_only)
-		uffd_test_report();
-
-	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
+	ksft_finished();
 }
 
 #else /* __NR_userfaultfd */
@@ -1806,8 +1805,8 @@ int main(int argc, char *argv[])
 
 int main(void)
 {
-	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
-	return KSFT_SKIP;
+	ksft_print_header();
+	ksft_exit_skip("missing __NR_userfaultfd definition\n");
 }
 
 #endif /* __NR_userfaultfd */
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

