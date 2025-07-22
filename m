Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41FB284B5D
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753222873; cv=none; b=lvUMMVEHBm/ZzO2j2VzCxzKXy+LjVaMLWSvTcHrhn44H1LjhqmvpKhMNzrAU/rPy5BsEfoolXC6+AIjzvfFzWptb3alXTzawWImIqrqAcfWbV6UKcsCYcAkEPVGyYfrkstg1ZzlFijnuVytXgI5Kyuv6aWOzjONEX39mKAXkhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753222873; c=relaxed/simple;
	bh=fuiBNBQU1QQCzI7XJh1I1m3nbjkd8NBc2BEu6CW2G1g=;
	h=Date:To:From:Subject:Message-Id; b=DiMt7rt7Mtn29ytxLK5bcn3V7GbThNFqNXZ5zECR7K8LJow1zrmrSv3+DQytNMUJ6bt37GU0bPuLYI9Nlqu9D83xCiXIhE5YtkCReJLgDTyhJVaREhZrQWVrn9xiusqL5QbwlzsCqarjC8hEhcPHr4W3e2qVbNQrLIfyjcuBDmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SyOK3QKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SyOK3QKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F1BC4CEEB;
	Tue, 22 Jul 2025 22:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753222872;
	bh=fuiBNBQU1QQCzI7XJh1I1m3nbjkd8NBc2BEu6CW2G1g=;
	h=Date:To:From:Subject:From;
	b=SyOK3QKZYzAboJafTxgWxf3fgg+ECrhsuj7Kpa1GzB0pcEQxQPYC+ek0ZsByJQv51
	 ePmfAzuy/6I46FTVaz/9jHosACzrUpxQuyQLzOtb2Ao9vylfszz67pZBDWcAMoQwg9
	 vhlsrwj/RQmyPQ9uVMWHFTBx2W03UH0c9E/XL1tQ=
Date: Tue, 22 Jul 2025 15:21:12 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,nphamcs@gmail.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,suresh.k.chandrappa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch added to mm-new branch
Message-Id: <20250722222112.A7F1BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: cachestat: add tests for mmap, refactor and enhance mmap test for cachestat validation
has been added to the -mm mm-new branch.  Its filename is
     selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Suresh K C <suresh.k.chandrappa@gmail.com>
Subject: selftests: cachestat: add tests for mmap, refactor and enhance mmap test for cachestat validation
Date: Wed, 9 Jul 2025 23:16:57 +0530

Add a cohesive test case that verifies cachestat behavior with
memory-mapped files using mmap().  Also refactor the test logic to reduce
redundancy, improve error reporting, and clarify failure messages for both
shmem and mmap file types.

Link: https://lkml.kernel.org/r/20250709174657.6916-1-suresh.k.chandrappa@gmail.com
Signed-off-by: Suresh K C <suresh.k.chandrappa@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Tested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   66 +++++++++--
 1 file changed, 55 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -33,6 +33,11 @@ void print_cachestat(struct cachestat *c
 	cs->nr_evicted, cs->nr_recently_evicted);
 }
 
+enum file_type {
+	FILE_MMAP,
+	FILE_SHMEM
+};
+
 bool write_exactly(int fd, size_t filesize)
 {
 	int random_fd = open("/dev/urandom", O_RDONLY);
@@ -201,8 +206,19 @@ out1:
 out:
 	return ret;
 }
+const char* file_type_str(enum file_type type) {
+	switch (type) {
+		case FILE_SHMEM:
+			return "shmem";
+		case FILE_MMAP:
+			return "mmap";
+		default:
+			return "unknown";
+	}
+}
+
 
-bool test_cachestat_shmem(void)
+bool run_cachestat_test(enum file_type type)
 {
 	size_t PS = sysconf(_SC_PAGESIZE);
 	size_t filesize = PS * 512 * 2; /* 2 2MB huge pages */
@@ -212,27 +228,49 @@ bool test_cachestat_shmem(void)
 	char *filename = "tmpshmcstat";
 	struct cachestat cs;
 	bool ret = true;
+	int fd;
 	unsigned long num_pages = compute_len / PS;
-	int fd = shm_open(filename, O_CREAT | O_RDWR, 0600);
+	if (type == FILE_SHMEM)
+		fd = shm_open(filename, O_CREAT | O_RDWR, 0600);
+	else
+		fd = open(filename, O_RDWR | O_CREAT | O_TRUNC, 0666);
 
 	if (fd < 0) {
-		ksft_print_msg("Unable to create shmem file.\n");
+		ksft_print_msg("Unable to create %s file.\n",file_type_str(type));
 		ret = false;
 		goto out;
 	}
 
 	if (ftruncate(fd, filesize)) {
-		ksft_print_msg("Unable to truncate shmem file.\n");
+		ksft_print_msg("Unable to truncate %s file.\n",file_type_str(type));
 		ret = false;
 		goto close_fd;
 	}
-
-	if (!write_exactly(fd, filesize)) {
-		ksft_print_msg("Unable to write to shmem file.\n");
-		ret = false;
-		goto close_fd;
+	switch (type){
+		case FILE_SHMEM:
+			if (!write_exactly(fd, filesize)) {
+				ksft_print_msg("Unable to write to file.\n");
+				ret = false;
+				goto close_fd;
+			}
+			break;
+		case FILE_MMAP:
+			char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+			if (map == MAP_FAILED) {
+				ksft_print_msg("mmap failed.\n");
+				ret = false;
+				goto close_fd;
+			}
+			for (int i = 0; i < filesize; i++) {
+				map[i] = 'A';
+			}
+			break;
+		default:
+			ksft_print_msg("Unsupported file type.\n");
+			ret = false;
+			goto close_fd;
+			break;
 	}
-
 	syscall_ret = syscall(__NR_cachestat, fd, &cs_range, &cs, 0);
 
 	if (syscall_ret) {
@@ -308,12 +346,18 @@ int main(void)
 		break;
 	}
 
-	if (test_cachestat_shmem())
+	if (run_cachestat_test(FILE_SHMEM))
 		ksft_test_result_pass("cachestat works with a shmem file\n");
 	else {
 		ksft_test_result_fail("cachestat fails with a shmem file\n");
 		ret = 1;
 	}
 
+	if (run_cachestat_test(FILE_MMAP))
+		ksft_test_result_pass("cachestat works with a mmap file\n");
+	else {
+		ksft_test_result_fail("cachestat fails with a mmap file\n");
+		ret = 1;
+	}
 	return ret;
 }
_

Patches currently in -mm which might be from suresh.k.chandrappa@gmail.com are

selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch

