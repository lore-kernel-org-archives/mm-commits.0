Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFD323C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837035; cv=none; b=F+SUr+yp6IJHpUcVqQEFhsekOY4gseoxTso5qSu82mbQIZAzRa8kN1wZtimxzo46NF5l4WEaKXJh1EfhHUGDbJrxIZbeEdlm4ndbo6s7ziEohAg9UGnn0pFq55LeV5pXXz1z+/HgmHKVEwF/DXFlaOCP5UEqxLDXJDl/w+VDq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837035; c=relaxed/simple;
	bh=/C2jgiN9ibGqIFsKHijFpQCeK/prP4rjlXLn3kZL0Z8=;
	h=Date:To:From:Subject:Message-Id; b=IOUz1V38pjO1UTVZGT3qTP3i6siZSsb/882e+NiJuvtPtnAvyFJLUiMW+AOkzV+TRzlQsbRLhRoTd5i5PR3+hTSA4g9swM/BIGNtKkacEkSnUAIr9HWIWzF+2pllR14QGTH0qtHrU41MHhavs+ihwgdN7LQl02VFC3b9hCgbeoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fNCG+BPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fNCG+BPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01741C4CEDD;
	Tue, 14 Jan 2025 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837035;
	bh=/C2jgiN9ibGqIFsKHijFpQCeK/prP4rjlXLn3kZL0Z8=;
	h=Date:To:From:Subject:From;
	b=fNCG+BPSFowY+u4llUdvCp+wOn5fFUy2XXgB2G3J8kctlNZ0FRnbEwL0X+os2dyfF
	 f6uyW1LrIumVR1YWeioCGn+l68XPfXtSdcKoQBhi0brq5Iyf/iJKJ78t5zoWP4GBR2
	 6cxx47bLM7wwJ+MYTiIb9buirBTSZ/0XQvD6QzK8=
Date: Mon, 13 Jan 2025 22:43:54 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch removed from -mm tree
Message-Id: <20250114064355.01741C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_test: Remove unused variable and type mismatches
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mremap_test: Remove unused variable and type mismatches
Date: Mon, 9 Dec 2024 23:56:24 +0500

Remove unused variable and fix type mismatches.

Link: https://lkml.kernel.org/r/20241209185624.2245158-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -34,7 +34,7 @@ struct config {
 	unsigned long long dest_alignment;
 	unsigned long long region_size;
 	int overlapping;
-	int dest_preamble_size;
+	unsigned int dest_preamble_size;
 };
 
 struct test {
@@ -328,7 +328,7 @@ static void mremap_move_within_range(uns
 {
 	char *test_name = "mremap mremap move within range";
 	void *src, *dest;
-	int i, success = 1;
+	unsigned int i, success = 1;
 
 	size_t size = SIZE_MB(20);
 	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
@@ -569,7 +569,7 @@ static void mremap_move_1mb_from_start(u
 {
 	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
 	void *src = NULL, *dest = NULL;
-	int i, success = 1;
+	unsigned int i, success = 1;
 
 	/* Config to reuse get_source_mapping() to do an aligned mmap. */
 	struct config c = {
@@ -636,7 +636,7 @@ out:
 
 static void run_mremap_test_case(struct test test_case, int *failures,
 				 unsigned int threshold_mb,
-				 unsigned int pattern_seed, char *rand_addr)
+				 char *rand_addr)
 {
 	long long remap_time = remap_region(test_case.config, threshold_mb,
 					    rand_addr);
@@ -708,7 +708,8 @@ static int parse_args(int argc, char **a
 int main(int argc, char **argv)
 {
 	int failures = 0;
-	int i, run_perf_tests;
+	unsigned int i;
+	int run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 
 	/* hard-coded test configs */
@@ -831,7 +832,7 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
-				     pattern_seed, rand_addr);
+				     rand_addr);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
@@ -853,7 +854,7 @@ int main(int argc, char **argv)
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
 		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
 			run_mremap_test_case(perf_test_cases[i], &failures,
-					     threshold_mb, pattern_seed,
+					     threshold_mb,
 					     rand_addr);
 	}
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-remove-argc-and-argv-unused-parameters.patch
selftests-mm-fix-unused-parameter-warnings.patch
selftests-mm-fix-type-mismatch-warnings.patch
selftests-mm-kselftest_harness-fix-warnings.patch
selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch
selftests-mm-hmm-tests-remove-always-false-expressions.patch
selftests-mm-guard-pages-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch
selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch
selftests-mm-khugepaged-fix-type-mismatch-warnings.patch
selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch
selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch
selftests-mm-uffd-fix-all-type-mismatch-warnings.patch
selftests-mm-makefile-add-the-compiler-flags.patch

