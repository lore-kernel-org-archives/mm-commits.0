Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D061A08DA
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 21:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719265070; cv=none; b=Lsc8Wx+Wv+VCc8Ovqqfbn4w70pmkYDiQdvaWscZccy/G8lrT1+Bye3qFb9R5zg2K6JGzfJmupl29DawlNEbHO8zBALrGgaa7kNtUPQZSSo2P1Y7GBxjBdmORMDAuxFjwujFdTg6Guj0fabxpHrPTjB1jGMg417VGtQrFj6T3ag4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719265070; c=relaxed/simple;
	bh=yOFxY6mujruDaj77/ahvxzn5o3rAYNkqLcEyBCoBBto=;
	h=Date:To:From:Subject:Message-Id; b=SHBr5LBH0Mhnb1/kxOuRcl963EgmJ2GfkR3K/Bv0EN9fIHPO1Ikgvn4sExyRbLWPlMDYZag9sKI20VjYMk1UzLwR+7hKe/TcCUrTqJ14Mduu7Fq8OBFFn4O2s09FGH/9z7Q7G76BF9Ze+e3fgacma5qFqJcxaogUBKg1GgU5HiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6hd+I8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6hd+I8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C12C32781;
	Mon, 24 Jun 2024 21:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719265070;
	bh=yOFxY6mujruDaj77/ahvxzn5o3rAYNkqLcEyBCoBBto=;
	h=Date:To:From:Subject:From;
	b=D6hd+I8K1qMHNpjBmhK1Cqji7o/HBkq+OEdWkTl3qxapieTcfLeif/iXKJYsjvqo7
	 lCoog3I1TFWcDx4TVseAIZg8owxkFTOMcP1kBsex6GkRvXA36Y1wxc4KuLtnWHn0oq
	 0eoHKtFtiWGWwu7NDCquvnlDMLK4J+UoEIFDYvZ0=
Date: Mon, 24 Jun 2024 14:37:49 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-enable_soft_offline-behaviors-v5.patch added to mm-unstable branch
Message-Id: <20240624213749.E6C12C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest-mm-test-enable_soft_offline-behaviors-v5
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-enable_soft_offline-behaviors-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-enable_soft_offline-behaviors-v5.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: selftest-mm-test-enable_soft_offline-behaviors-v5
Date: Mon, 24 Jun 2024 16:33:47 +0000

refactor selftest to use what is available in kselftest.h

Link: https://lkml.kernel.org/r/20240624163348.1751454-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-soft-offline.c |  126 +++++-------
 1 file changed, 62 insertions(+), 64 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftest-mm-test-enable_soft_offline-behaviors-v5
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -24,63 +24,58 @@
 #include <sys/statfs.h>
 #include <sys/types.h>
 
+#include "../kselftest.h"
+
 #ifndef MADV_SOFT_OFFLINE
 #define MADV_SOFT_OFFLINE 101
 #endif
 
-#define PREFIX " ... "
 #define EPREFIX " !!! "
 
-enum test_status {
-	TEST_PASS = 0,
-	TEST_FAILED = 1,
-	// From ${ksft_skip} in run_vmtests.sh.
-	TEST_SKIPPED = 4,
-};
-
-static enum test_status do_soft_offline(int fd, size_t len, int expect_ret)
+static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
 	char *hwp_addr = NULL;
 	const unsigned long pagesize = getpagesize();
 	int ret = 0;
-	enum test_status status = TEST_SKIPPED;
 
 	if (ftruncate(fd, len) < 0) {
-		perror(EPREFIX "ftruncate to len failed");
-		return status;
+		ksft_perror(EPREFIX "ftruncate to len failed");
+		return -1;
 	}
 
 	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
 		       MAP_SHARED | MAP_POPULATE, fd, 0);
 	if (filemap == MAP_FAILED) {
-		perror(EPREFIX "mmap failed");
+		ksft_perror(EPREFIX "mmap failed");
+		ret = -1;
 		goto untruncate;
 	}
 
 	memset(filemap, 0xab, len);
-	printf(PREFIX "Allocated %#lx bytes of hugetlb pages\n", len);
+	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
 
 	hwp_addr = filemap + len / 2;
 	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
-	printf(PREFIX "MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
-	       hwp_addr, ret, errno);
+	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
+		       hwp_addr, ret, errno);
 	if (ret != 0)
-		perror(EPREFIX "madvise failed");
+		ksft_perror(EPREFIX "madvise failed");
 
-	if (errno == expect_ret)
-		status = TEST_PASS;
+	if (errno == expect_errno)
+		ret = 0;
 	else {
-		printf(EPREFIX "MADV_SOFT_OFFLINE should ret %d\n", expect_ret);
-		status = TEST_FAILED;
+		ksft_print_msg("MADV_SOFT_OFFLINE should ret %d\n",
+			       expect_errno);
+		ret = -1;
 	}
 
 	munmap(filemap, len);
 untruncate:
 	if (ftruncate(fd, 0) < 0)
-		perror(EPREFIX "ftruncate back to 0 failed");
+		ksft_perror(EPREFIX "ftruncate back to 0 failed");
 
-	return status;
+	return ret;
 }
 
 static int set_enable_soft_offline(int value)
@@ -95,9 +90,9 @@ static int set_enable_soft_offline(int v
 	cmdfile = popen(cmd, "r");
 
 	if (cmdfile)
-		printf(PREFIX "enable_soft_offline => %d\n", value);
+		ksft_print_msg("enable_soft_offline => %d\n", value);
 	else {
-		perror(EPREFIX "failed to set enable_soft_offline");
+		ksft_perror(EPREFIX "failed to set enable_soft_offline");
 		return errno;
 	}
 
@@ -116,12 +111,12 @@ static int read_nr_hugepages(unsigned lo
 	FILE *cmdfile = popen(cmd, "r");
 
 	if (cmdfile == NULL) {
-		perror(EPREFIX "failed to popen nr_hugepages");
+		ksft_perror(EPREFIX "failed to popen nr_hugepages");
 		return -1;
 	}
 
 	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
-		perror(EPREFIX "failed to read nr_hugepages");
+		ksft_perror(EPREFIX "failed to read nr_hugepages");
 		pclose(cmdfile);
 		return -1;
 	}
@@ -137,17 +132,17 @@ static int create_hugetlbfs_file(struct
 
 	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
 	if (fd < 0) {
-		perror(EPREFIX "could not open hugetlbfs file");
+		ksft_perror(EPREFIX "could not open hugetlbfs file");
 		return -1;
 	}
 
 	memset(file_stat, 0, sizeof(*file_stat));
 	if (fstatfs(fd, file_stat)) {
-		perror(EPREFIX "fstatfs failed");
+		ksft_perror(EPREFIX "fstatfs failed");
 		goto close;
 	}
 	if (file_stat->f_type != HUGETLBFS_MAGIC) {
-		printf(EPREFIX "not hugetlbfs file\n");
+		ksft_print_msg(EPREFIX "not hugetlbfs file\n");
 		goto close;
 	}
 
@@ -157,73 +152,76 @@ close:
 	return -1;
 }
 
-static enum test_status test_soft_offline_common(int enable_soft_offline)
+static void test_soft_offline_common(int enable_soft_offline)
 {
 	int fd;
-	int expect_ret = enable_soft_offline ? 0 : EOPNOTSUPP;
+	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
 	struct statfs file_stat;
 	unsigned long hugepagesize_kb = 0;
 	unsigned long nr_hugepages_before = 0;
 	unsigned long nr_hugepages_after = 0;
-	enum test_status status = TEST_SKIPPED;
+	int ret;
 
-	printf("Test soft-offline when enabled_soft_offline=%d\n",
-		enable_soft_offline);
+	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
+		       enable_soft_offline);
 
 	fd = create_hugetlbfs_file(&file_stat);
 	if (fd < 0) {
-		printf(EPREFIX "Failed to create hugetlbfs file\n");
-		return status;
+		ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
+		return;
 	}
 
 	hugepagesize_kb = file_stat.f_bsize / 1024;
-	printf(PREFIX "Hugepagesize is %ldkB\n", hugepagesize_kb);
+	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline))
-		return TEST_FAILED;
+	if (set_enable_soft_offline(enable_soft_offline)) {
+		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
+		return;
+	}
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0)
-		return TEST_FAILED;
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+		return;
+	}
 
-	printf(PREFIX "Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
-		nr_hugepages_before);
+	ksft_print_msg("Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
+		       nr_hugepages_before);
 
-	status = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_ret);
+	ret = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_errno);
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0)
-		return TEST_FAILED;
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+		return;
+	}
 
-	printf(PREFIX "After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
+	ksft_print_msg("After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
 		nr_hugepages_after);
 
 	if (enable_soft_offline) {
 		if (nr_hugepages_before != nr_hugepages_after + 1) {
-			printf(EPREFIX "MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
-			return TEST_FAILED;
+			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
+			return;
 		}
 	} else {
 		if (nr_hugepages_before != nr_hugepages_after) {
-			printf(EPREFIX "MADV_SOFT_OFFLINE reduced %lu hugepages\n",
+			ksft_test_result_fail("MADV_SOFT_OFFLINE reduced %lu hugepages\n",
 				nr_hugepages_before - nr_hugepages_after);
-			return TEST_FAILED;
+			return;
 		}
 	}
 
-	return status;
+	ksft_test_result(ret == 0,
+			 "Test soft-offline when enabled_soft_offline=%d\n",
+			 enable_soft_offline);
 }
 
-int main(void)
+int main(int argc, char **argv)
 {
-	enum test_status status;
-
-	status = test_soft_offline_common(1);
-	if (status != TEST_PASS)
-		return status;
+	ksft_print_header();
+	ksft_set_plan(2);
 
-	status = test_soft_offline_common(0);
-	if (status != TEST_PASS)
-		return status;
+	test_soft_offline_common(1);
+	test_soft_offline_common(0);
 
-	printf("Soft-offline tests all good!\n");
-	return TEST_PASS;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v5.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v5.patch
docs-mm-add-enable_soft_offline-sysctl.patch

