Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98208A2D
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468142; cv=none; b=PsiCFI+gI5QyDI1xLlOmULH2DxjTVQgEkWo5LA8z1OIPU7uImiXSc5rMBtlMVARMC+ZiCWmDvwDEo0kF2ZtJsyx3LPt3Z6kRSqNQAOdOBGv0cTKMQxIazupYwyrv4Ir86FjQeJWKOd6JC3SAlE9OKhHgUPg8sqB8BFUztkm2vfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468142; c=relaxed/simple;
	bh=KxTUFM3v2+9hA6YDcI1d+9K8TbpEIUW2q4vVPY7cHj4=;
	h=Date:To:From:Subject:Message-Id; b=mtNEZPscCw7ffkzlSfkNMWP57VwLrDMQ3iBGoifr76PH6uJ+DANmfmKhuYuOI6mvMTwcfqlr4ue7DPdHCPogGYHTxrHIvtt02eeOVg5Ui6ikAro+NH7KytQ54gr7l++fc3/9mp65haZh53wWgBhb6YW4nosCesmI+cKZX2wgOXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krCcuCbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krCcuCbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268C4C4CED2;
	Fri, 10 Jan 2025 00:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468142;
	bh=KxTUFM3v2+9hA6YDcI1d+9K8TbpEIUW2q4vVPY7cHj4=;
	h=Date:To:From:Subject:From;
	b=krCcuCbL/NjskkeJZGLBCcH819Kh9jrZfbqZ3KQ1lTLcaSu9D75Yeh1NoOUghoMJz
	 1vmBHlzDaruqhZ/4qy5yaBavogGoK+t5+nRe+DsZ0H7Xd9fN5kEoVZ55O+WpjLmzJm
	 htAjGgW48x0jNmWwYvjVUtuefhuL2gN2NRRMQj44=
Date: Thu, 09 Jan 2025 16:15:41 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001542.268C4C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-type-mismatch-warnings.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:30 +0500

Fix type mismatch warnings in different tests.

Link: https://lkml.kernel.org/r/20250109173842.1142376-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c          |    2 +-
 tools/testing/selftests/mm/gup_longterm.c             |    3 ++-
 tools/testing/selftests/mm/hugetlb_dio.c              |    2 +-
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |    2 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c      |    2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c     |    6 +++---
 tools/testing/selftests/mm/mlock-random-test.c        |    4 ++--
 tools/testing/selftests/mm/pkey_sighandler_tests.c    |    2 +-
 tools/testing/selftests/mm/soft-dirty.c               |    2 +-
 9 files changed, 13 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -134,7 +134,7 @@ int check_compaction(unsigned long mem_f
 	lseek(fd, 0, SEEK_SET);
 
 	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
+	    != (signed long int)strlen(init_nr_hugepages)) {
 		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
 			       strerror(errno));
 		goto close_fd;
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -446,7 +446,8 @@ static int tests_per_test_case(void)
 
 int main(void)
 {
-	int i, err;
+	unsigned int i;
+	int err;
 
 	pagesize = getpagesize();
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -63,7 +63,7 @@ void run_dio_using_hugetlb(unsigned int
 	memset(buffer, 'A', writesize);
 
 	/* Write the buffer to the file */
-	if (write(fd, buffer, writesize) != (writesize)) {
+	if (write(fd, buffer, writesize) != (signed int)writesize) {
 		munmap(orig_buffer, h_pagesize);
 		close(fd);
 		ksft_exit_fail_perror("Error writing to file\n");
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -88,7 +88,7 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1)
+		if (huge_ptr == MAP_FAILED)
 			ksft_exit_skip("Failed to allocated huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -100,7 +100,7 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1) {
+		if (huge_ptr == MAP_FAILED) {
 			ksft_test_result_fail("Failed to allocate huge page\n");
 			return KSFT_FAIL;
 		}
--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -306,7 +306,7 @@ static void test_unmerge_zero_pages(void
 
 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
 	pages_expected = size / pagesize;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if ((signed long)pages_expected != get_my_ksm_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
 		goto unmap;
 	}
@@ -319,7 +319,7 @@ static void test_unmerge_zero_pages(void
 
 	/* Check if ksm_zero_pages is updated correctly after unmerging */
 	pages_expected /= 2;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if ((signed long)pages_expected != get_my_ksm_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
 		goto unmap;
 	}
@@ -625,7 +625,7 @@ static void test_prot_none(void)
 {
 	const unsigned int size = 2 * MiB;
 	char *map;
-	int i;
+	unsigned int i;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -138,7 +138,7 @@ static void test_mlock_within_limit(char
 	int page_size = 0;
 
 	getrlimit(RLIMIT_MEMLOCK, &cur);
-	if (cur.rlim_cur < alloc_size)
+	if (cur.rlim_cur < (unsigned int)alloc_size)
 		ksft_exit_fail_msg("alloc_size[%d] < %u rlimit,lead to mlock failure\n",
 				   alloc_size, (unsigned int)cur.rlim_cur);
 
@@ -204,7 +204,7 @@ static void test_mlock_outof_limit(char
 	struct rlimit cur;
 
 	getrlimit(RLIMIT_MEMLOCK, &cur);
-	if (cur.rlim_cur >= alloc_size)
+	if (cur.rlim_cur >= (unsigned int)alloc_size)
 		ksft_exit_fail_msg("alloc_size[%d] >%u rlimit, violates test condition\n",
 				   alloc_size, (unsigned int)cur.rlim_cur);
 
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -530,7 +530,7 @@ static void (*pkey_tests[])(void) = {
 
 int main(void)
 {
-	int i;
+	unsigned int i;
 
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(pkey_tests));
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -77,7 +77,7 @@ static void test_vma_reuse(int pagemap_f
 static void test_hugepage(int pagemap_fd)
 {
 	char *map;
-	int i, ret;
+	unsigned int i, ret;
 	size_t hpage_len = read_pmd_pagesize();
 
 	if (!hpage_len)
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch
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

