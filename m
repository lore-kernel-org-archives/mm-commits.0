Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA708C1B
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031253; cv=none; b=tGCcQaYYM5zSakP8koiEs8iAwnDlAFzko4KBfIZgdZWpH2v5t6ipgQ8ynLSe/pqnfxypnxv/igwSr7GTRV1zX1Bb4C2w/2O4JX6XX+QW4FXgmnF+SycZFOsTjEAZACni4h/tCh7PBpwheWb22VKByj4wgzAUFozM7apW+GZEs2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031253; c=relaxed/simple;
	bh=k7Y2hflrEaTsDPueY/W47WDqKfmdUMtq7DWSJlNx2Nk=;
	h=Date:To:From:Subject:Message-Id; b=JOE22WZZXJ2jzYJf+UFzR+dOfVR0/2IV1TY/2IiZ4cyOg7d6IuH4sBlLHk5x0/9kCuq/n/2D88NEdh4cxeQVV1IdsqPmYihWI+O+jYybqnLKfkPQGgOGO0tgotL7lW5aBBYuHJh+0hMFjyoXog5ZvUQLYAdbrS5urs9i8+Njesk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L+MovTfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+MovTfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1FEC43394;
	Sun,  4 Feb 2024 07:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031253;
	bh=k7Y2hflrEaTsDPueY/W47WDqKfmdUMtq7DWSJlNx2Nk=;
	h=Date:To:From:Subject:From;
	b=L+MovTfiN2oevV33D3MGWGFeALAx2owUx5rsHcdzUGBh39afaLHT9LyMyDK44C6AL
	 Ik/yLYrJFxkvEQl8aw32GkvkDhkailfeQHmob5hjaOmo9/8vQPmF+cUdvBM881siyV
	 skH1QTsvVJu9cSp81+41n7n+dgIYrt7P0gUhwQNQ=
Date: Sat, 03 Feb 2024 23:20:52 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch added to mm-unstable branch
Message-Id: <20240204072053.1B1FEC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: split_huge_page_test: conform test to TAP format output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch

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
Subject: selftests/mm: split_huge_page_test: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:15 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-9-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |  161 +++++-------
 1 file changed, 69 insertions(+), 92 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-split_huge_page_test-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -17,6 +17,7 @@
 #include <malloc.h>
 #include <stdbool.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -50,21 +51,19 @@ int is_backed_by_thp(char *vaddr, int pa
 	return 0;
 }
 
-static int write_file(const char *path, const char *buf, size_t buflen)
+static void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
 	ssize_t numwritten;
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		return 0;
+		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
 	close(fd);
 	if (numwritten < 1)
-		return 0;
-
-	return (unsigned int) numwritten;
+		ksft_exit_fail_msg("Write failed\n");
 }
 
 static void write_debugfs(const char *fmt, ...)
@@ -77,15 +76,10 @@ static void write_debugfs(const char *fm
 	ret = vsnprintf(input, INPUT_MAX, fmt, argp);
 	va_end(argp);
 
-	if (ret >= INPUT_MAX) {
-		printf("%s: Debugfs input is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= INPUT_MAX)
+		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
 
-	if (!write_file(SPLIT_DEBUGFS, input, ret + 1)) {
-		perror(SPLIT_DEBUGFS);
-		exit(EXIT_FAILURE);
-	}
+	write_file(SPLIT_DEBUGFS, input, ret + 1);
 }
 
 void split_pmd_thp(void)
@@ -95,39 +89,30 @@ void split_pmd_thp(void)
 	size_t i;
 
 	one_page = memalign(pmd_pagesize, len);
-
-	if (!one_page) {
-		printf("Fail to allocate memory\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!one_page)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
 	madvise(one_page, len, MADV_HUGEPAGE);
 
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
-		printf("No THP is allocated\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+		ksft_exit_fail_msg("No THP is allocated\n");
 
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len);
 
 	for (i = 0; i < len; i++)
-		if (one_page[i] != (char)i) {
-			printf("%ld byte corrupted\n", i);
-			exit(EXIT_FAILURE);
-		}
+		if (one_page[i] != (char)i)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize)) {
-		printf("Still AnonHugePages not split\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
-	printf("Split huge pages successful\n");
+	ksft_test_result_pass("Split huge pages successful\n");
 	free(one_page);
 }
 
@@ -143,36 +128,29 @@ void split_pte_mapped_thp(void)
 	int pagemap_fd;
 	int kpageflags_fd;
 
-	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0) {
-		perror("get pagemap proc error");
-		exit(EXIT_FAILURE);
-	}
-	pagemap_fd = open(pagemap_proc, O_RDONLY);
+	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0)
+		ksft_exit_fail_msg("get pagemap proc error: %s\n", strerror(errno));
 
-	if (pagemap_fd == -1) {
-		perror("read pagemap:");
-		exit(EXIT_FAILURE);
-	}
+	pagemap_fd = open(pagemap_proc, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
 
 	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
-
-	if (kpageflags_fd == -1) {
-		perror("read kpageflags:");
-		exit(EXIT_FAILURE);
-	}
+	if (kpageflags_fd == -1)
+		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
 
 	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (one_page == MAP_FAILED)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
 
 	madvise(one_page, len, MADV_HUGEPAGE);
 
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
-		printf("No THP is allocated\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+		ksft_exit_fail_msg("No THP is allocated\n");
 
 	/* remap the first pagesize of first THP */
 	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
@@ -183,10 +161,8 @@ void split_pte_mapped_thp(void)
 				     pagesize, pagesize,
 				     MREMAP_MAYMOVE|MREMAP_FIXED,
 				     pte_mapped + pagesize * i);
-		if (pte_mapped2 == (char *)-1) {
-			perror("mremap failed");
-			exit(EXIT_FAILURE);
-		}
+		if (pte_mapped2 == MAP_FAILED)
+			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
 	}
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
@@ -196,10 +172,8 @@ void split_pte_mapped_thp(void)
 		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
 			thp_size++;
 
-	if (thp_size != 4) {
-		printf("Some THPs are missing during mremap\n");
-		exit(EXIT_FAILURE);
-	}
+	if (thp_size != 4)
+		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
 
 	/* split all remapped THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
@@ -208,21 +182,18 @@ void split_pte_mapped_thp(void)
 	/* smap does not show THPs after mremap, use kpageflags instead */
 	thp_size = 0;
 	for (i = 0; i < pagesize * 4; i++) {
-		if (pte_mapped[i] != (char)i) {
-			printf("%ld byte corrupted\n", i);
-			exit(EXIT_FAILURE);
-		}
+		if (pte_mapped[i] != (char)i)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+
 		if (i % pagesize == 0 &&
 		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
 			thp_size++;
 	}
 
-	if (thp_size) {
-		printf("Still %ld THPs not split\n", thp_size);
-		exit(EXIT_FAILURE);
-	}
+	if (thp_size)
+		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
 
-	printf("Split PTE-mapped huge pages successful\n");
+	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
 	munmap(one_page, len);
 	close(pagemap_fd);
 	close(kpageflags_fd);
@@ -238,24 +209,21 @@ void split_file_backed_thp(void)
 	char testfile[INPUT_MAX];
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 
-	printf("Please enable pr_debug in split_huge_pages_in_file() if you need more info.\n");
+	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
 
-	if (status) {
-		printf("Unable to create a tmpfs for testing\n");
-		exit(EXIT_FAILURE);
-	}
+	if (status)
+		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
-		printf("Fail to create file-backed THP split testing file\n");
-		goto cleanup;
+		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
 	}
 
 	fd = open(testfile, O_CREAT|O_WRONLY);
 	if (fd == -1) {
-		perror("Cannot open testing file\n");
+		ksft_perror("Cannot open testing file");
 		goto cleanup;
 	}
 
@@ -264,7 +232,7 @@ void split_file_backed_thp(void)
 	close(fd);
 
 	if (num_written < 1) {
-		printf("Fail to write data to testing file\n");
+		ksft_perror("Fail to write data to testing file");
 		goto cleanup;
 	}
 
@@ -272,42 +240,51 @@ void split_file_backed_thp(void)
 	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end);
 
 	status = unlink(testfile);
-	if (status)
-		perror("Cannot remove testing file\n");
+	if (status) {
+		ksft_perror("Cannot remove testing file");
+		goto cleanup;
+	}
 
-cleanup:
 	status = umount(tmpfs_loc);
 	if (status) {
-		printf("Unable to umount %s\n", tmpfs_loc);
-		exit(EXIT_FAILURE);
+		rmdir(tmpfs_loc);
+		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
 	}
+
 	status = rmdir(tmpfs_loc);
-	if (status) {
-		perror("cannot remove tmp dir");
-		exit(EXIT_FAILURE);
-	}
+	if (status)
+		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
 
-	printf("file-backed THP split test done, please check dmesg for more information\n");
+	ksft_print_msg("Please check dmesg for more information\n");
+	ksft_test_result_pass("File-backed THP split test done\n");
+	return;
+
+cleanup:
+	umount(tmpfs_loc);
+	rmdir(tmpfs_loc);
+	ksft_exit_fail_msg("Error occurred\n");
 }
 
 int main(int argc, char **argv)
 {
+	ksft_print_header();
+
 	if (geteuid() != 0) {
-		printf("Please run the benchmark as root\n");
-		exit(EXIT_FAILURE);
+		ksft_print_msg("Please run the benchmark as root\n");
+		ksft_finished();
 	}
 
+	ksft_set_plan(3);
+
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
 	pmd_pagesize = read_pmd_pagesize();
-	if (!pmd_pagesize) {
-		printf("Reading PMD pagesize failed\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
 	split_pmd_thp();
 	split_pte_mapped_thp();
 	split_file_backed_thp();
 
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thp_settings-conform-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

