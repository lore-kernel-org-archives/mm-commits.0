Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411B1E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160840; cv=none; b=GE5d8s3oVg/ey3MNVBPZOb7W531hJUbY6Ux32wrgTYbJAbPZTIqpezEbVW+LtUIF90lhZHr2gEbgWa/QS8KacdyomPu3tqm/b+dBPL5PZeTy2ONEHMf/L3wPz0X6DVQ57UxA5wHZQL4p76PujHgOOcBzfm2ghzJdBTfcXLjQjS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160840; c=relaxed/simple;
	bh=EseUfLxPs2ITu/k2fFpvl+4433lV/+dSCrkeLvlFVdU=;
	h=Date:To:From:Subject:Message-Id; b=YCqhg37vo5VbG16r2RF8pE+yFuGy8WP2zpUcQS6Adux166PcW0BrWRqoBIX1EMUVYt3mgEDLPNQswnIJn4ldTvqH0d5PTsgsKXc2mYxsIElok3gGylmuOzqhxwGfxvU2s3gHW4fUkMfFpZcdr43UQSo4oQfJzeJVH0ivCEvSsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHO27rDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHO27rDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E27C4CEEF;
	Sat,  2 Aug 2025 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160840;
	bh=EseUfLxPs2ITu/k2fFpvl+4433lV/+dSCrkeLvlFVdU=;
	h=Date:To:From:Subject:From;
	b=CHO27rDIyFcw4zv1Y/q+LuM5Uo/ErNrcT07KH5I0gU58D6aic6P+ERHGcfXYrrq6G
	 sGJEnrR9mWQXuSPPbWNtOJJz9KFVvA2BtYLdh4uSfYsAOj5WdqfG9LxUJyWqLupuOd
	 jn6gM3fAf/vfS5PQm7+3ZfdOx7PRmQew74ia7Ukw=
Date: Sat, 02 Aug 2025 11:53:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,nphamcs@gmail.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,suresh.k.chandrappa@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch removed from -mm tree
Message-Id: <20250802185400.57E27C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: cachestat: add tests for mmap, refactor and enhance mmap test for cachestat validation
has been removed from the -mm tree.  Its filename was
     selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suresh K C <suresh.k.chandrappa@gmail.com>
Subject: selftests: cachestat: add tests for mmap, refactor and enhance mmap test for cachestat validation
Date: Wed, 9 Jul 2025 23:16:57 +0530

Add a cohesive test case that verifies cachestat behavior with
memory-mapped files using mmap().  Also refactor the test logic to reduce
redundancy, improve error reporting, and clarify failure messages for both
shmem and mmap file types.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/20250709174657.6916-1-suresh.k.chandrappa@gmail.com
Signed-off-by: Suresh K C <suresh.k.chandrappa@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Tested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   62 +++++++++--
 1 file changed, 54 insertions(+), 8 deletions(-)

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
@@ -201,8 +206,20 @@ out1:
 out:
 	return ret;
 }
+const char *file_type_str(enum file_type type)
+{
+	switch (type) {
+	case FILE_SHMEM:
+		return "shmem";
+	case FILE_MMAP:
+		return "mmap";
+	default:
+		return "unknown";
+	}
+}
 
-bool test_cachestat_shmem(void)
+
+bool run_cachestat_test(enum file_type type)
 {
 	size_t PS = sysconf(_SC_PAGESIZE);
 	size_t filesize = PS * 512 * 2; /* 2 2MB huge pages */
@@ -212,27 +229,50 @@ bool test_cachestat_shmem(void)
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
+		ksft_print_msg("Unable to create %s file.\n",
+				file_type_str(type));
 		ret = false;
 		goto out;
 	}
 
 	if (ftruncate(fd, filesize)) {
-		ksft_print_msg("Unable to truncate shmem file.\n");
+		ksft_print_msg("Unable to truncate %s file.\n",file_type_str(type));
 		ret = false;
 		goto close_fd;
 	}
+	switch (type) {
+	case FILE_SHMEM:
+		if (!write_exactly(fd, filesize)) {
+			ksft_print_msg("Unable to write to file.\n");
+			ret = false;
+			goto close_fd;
+		}
+		break;
+	case FILE_MMAP:
+		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+				 MAP_SHARED, fd, 0);
 
-	if (!write_exactly(fd, filesize)) {
-		ksft_print_msg("Unable to write to shmem file.\n");
+		if (map == MAP_FAILED) {
+			ksft_print_msg("mmap failed.\n");
+			ret = false;
+			goto close_fd;
+		}
+		for (int i = 0; i < filesize; i++)
+			map[i] = 'A';
+		break;
+	default:
+		ksft_print_msg("Unsupported file type.\n");
 		ret = false;
 		goto close_fd;
 	}
-
 	syscall_ret = syscall(__NR_cachestat, fd, &cs_range, &cs, 0);
 
 	if (syscall_ret) {
@@ -308,12 +348,18 @@ int main(void)
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


