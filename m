Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4A424292E
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946611; cv=none; b=R4ZOKo/S+2062A16AC5K9ffNLiR16uwj/Gdqm3TGfmD6mnL2qEFYKu3URtvg/C4epsZ0GjwNtLUCM1IVmXehiwgy3L69O8N61NqVRdnvsCXSS8rFZQm/oHlpVhUyGL6d9EujlGAhXYO93qGw2iSkQPuDd3Xc5dtiNubSNk3yKBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946611; c=relaxed/simple;
	bh=YUpdu9XZoUmJAoppUk10s+9Wcn2BRuXBfpmLhekCTO0=;
	h=Date:To:From:Subject:Message-Id; b=fN9IKCUPEpMtALowOQnS5NdI+zdmuR+C5OgbMNtqmibK427/n4GvxuVPp6q02EZ60Vl2GPdrrFC3kykh1v2fbz7o/7/74cCqavQ3EQTdVGkB5BhfsBkn7hSudxjQ0b0A2OsEVqy7jbDbFro+giHwikny2IODBh+t0PVyLRYHZGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjArIAZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjArIAZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C31C4CEE4;
	Thu, 22 May 2025 20:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747946611;
	bh=YUpdu9XZoUmJAoppUk10s+9Wcn2BRuXBfpmLhekCTO0=;
	h=Date:To:From:Subject:From;
	b=hjArIAZhX8MjMWTggr0MuV/HaEvtYuJIxdZNJG1pT52GGmq1e/0m3ZjXQwvo4P/PE
	 P+ZEoyryP1dcGI+J4XAtUKS/yCz8bEPaLIhosBcWHcOKKcvQ0AWmN3i85Xxl5X4B4O
	 LCA7XVDnHjKBxNXOb8B1oZzRPGWoPUhZPY5OmGD0=
Date: Thu, 22 May 2025 13:43:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-test-result-reporting-in-gup_longterm.patch added to mm-new branch
Message-Id: <20250522204330.E1C31C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix test result reporting in gup_longterm
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: fix test result reporting in gup_longterm
Date: Thu, 22 May 2025 18:38:53 +0100

The kselftest framework uses the string logged when a test result is
reported as the unique identifier for a test, using it to track test
results between runs. The gup_longterm test fails to follow this
pattern, it runs a single test function repeatedly with various
parameters but each result report is a string logging an error message
which is fixed between runs.

Since the code already logs each test uniquely before it starts refactor
to also print this to a buffer, then use that name as the test result.
This isn't especially pretty but is relatively straightforward and is a
great help to tooling.

Link: https://lkml.kernel.org/r/20250522-selftests-mm-cow-dedupe-v1-4-713cee2fdd6d@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |  150 ++++++++++++--------
 1 file changed, 94 insertions(+), 56 deletions(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-fix-test-result-reporting-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -93,33 +93,48 @@ static void do_test(int fd, size_t size,
 	__fsword_t fs_type = get_fs_type(fd);
 	bool should_work;
 	char *mem;
+	int result = KSFT_PASS;
 	int ret;
 
+	if (fd < 0) {
+		result = KSFT_FAIL;
+		goto report;
+	}
+
 	if (ftruncate(fd, size)) {
 		if (errno == ENOENT) {
 			skip_test_dodgy_fs("ftruncate()");
 		} else {
-			ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+			ksft_print_msg("ftruncate() failed (%s)\n",
+				       strerror(errno));
+			result = KSFT_FAIL;
+			goto report;
 		}
 		return;
 	}
 
 	if (fallocate(fd, 0, 0, size)) {
-		if (size == pagesize)
-			ksft_test_result_fail("fallocate() failed (%s)\n", strerror(errno));
-		else
-			ksft_test_result_skip("need more free huge pages\n");
-		return;
+		if (size == pagesize) {
+			ksft_print_msg("fallocate() failed (%s)\n", strerror(errno));
+			result = KSFT_FAIL;
+		} else {
+			ksft_print_msg("need more free huge pages\n");
+			result = KSFT_SKIP;
+		}
+		goto report;
 	}
 
 	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   shared ? MAP_SHARED : MAP_PRIVATE, fd, 0);
 	if (mem == MAP_FAILED) {
-		if (size == pagesize || shared)
-			ksft_test_result_fail("mmap() failed (%s)\n", strerror(errno));
-		else
-			ksft_test_result_skip("need more free huge pages\n");
-		return;
+		if (size == pagesize || shared) {
+			ksft_print_msg("mmap() failed (%s)\n", strerror(errno));
+			result = KSFT_FAIL;
+		} else {
+			ksft_print_msg("need more free huge pages\n");
+			result = KSFT_SKIP;
+		}
+		goto report;
 	}
 
 	/* Fault in the page such that GUP-fast can pin it directly. */
@@ -134,7 +149,8 @@ static void do_test(int fd, size_t size,
 		 */
 		ret = mprotect(mem, size, PROT_READ);
 		if (ret) {
-			ksft_test_result_fail("mprotect() failed (%s)\n", strerror(errno));
+			ksft_print_msg("mprotect() failed (%s)\n", strerror(errno));
+			result = KSFT_FAIL;
 			goto munmap;
 		}
 		/* FALLTHROUGH */
@@ -147,12 +163,14 @@ static void do_test(int fd, size_t size,
 				type == TEST_TYPE_RW_FAST;
 
 		if (gup_fd < 0) {
-			ksft_test_result_skip("gup_test not available\n");
+			ksft_print_msg("gup_test not available\n");
+			result = KSFT_SKIP;
 			break;
 		}
 
 		if (rw && shared && fs_is_unknown(fs_type)) {
-			ksft_test_result_skip("Unknown filesystem\n");
+			ksft_print_msg("Unknown filesystem\n");
+			result = KSFT_SKIP;
 			return;
 		}
 		/*
@@ -169,14 +187,19 @@ static void do_test(int fd, size_t size,
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_test_result_skip("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			result = KSFT_SKIP;
 			break;
 		} else if (ret && errno == EFAULT) {
-			ksft_test_result(!should_work, "Should have failed\n");
+			if (should_work)
+				result = KSFT_FAIL;
+			else
+				result = KSFT_PASS;
 			break;
 		} else if (ret) {
-			ksft_test_result_fail("PIN_LONGTERM_TEST_START failed (%s)\n",
-					      strerror(errno));
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (%s)\n",
+				       strerror(errno));
+			result = KSFT_FAIL;
 			break;
 		}
 
@@ -189,7 +212,10 @@ static void do_test(int fd, size_t size,
 		 * some previously unsupported filesystems, we might want to
 		 * perform some additional tests for possible data corruptions.
 		 */
-		ksft_test_result(should_work, "Should have worked\n");
+		if (should_work)
+			result = KSFT_PASS;
+		else
+			result = KSFT_FAIL;
 		break;
 	}
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -199,8 +225,9 @@ static void do_test(int fd, size_t size,
 
 		/* io_uring always pins pages writable. */
 		if (shared && fs_is_unknown(fs_type)) {
-			ksft_test_result_skip("Unknown filesystem\n");
-			return;
+			ksft_print_msg("Unknown filesystem\n");
+			result = KSFT_SKIP;
+			goto report;
 		}
 		should_work = !shared ||
 			      fs_supports_writable_longterm_pinning(fs_type);
@@ -208,8 +235,9 @@ static void do_test(int fd, size_t size,
 		/* Skip on errors, as we might just lack kernel support. */
 		ret = io_uring_queue_init(1, &ring, 0);
 		if (ret < 0) {
-			ksft_test_result_skip("io_uring_queue_init() failed (%s)\n",
-					      strerror(-ret));
+			ksft_print_msg("io_uring_queue_init() failed (%s)\n",
+				       strerror(-ret));
+			result = KSFT_SKIP;
 			break;
 		}
 		/*
@@ -222,17 +250,28 @@ static void do_test(int fd, size_t size,
 		/* Only new kernels return EFAULT. */
 		if (ret && (errno == ENOSPC || errno == EOPNOTSUPP ||
 			    errno == EFAULT)) {
-			ksft_test_result(!should_work, "Should have failed (%s)\n",
-					 strerror(errno));
+			if (should_work) {
+				ksft_print_msg("Should have failed (%s)\n",
+					       strerror(errno));
+				result = KSFT_FAIL;
+			} else {
+				result = KSFT_PASS;
+			}
 		} else if (ret) {
 			/*
 			 * We might just lack support or have insufficient
 			 * MEMLOCK limits.
 			 */
-			ksft_test_result_skip("io_uring_register_buffers() failed (%s)\n",
-					      strerror(-ret));
+			ksft_print_msg("io_uring_register_buffers() failed (%s)\n",
+				       strerror(-ret));
+			result = KSFT_SKIP;
 		} else {
-			ksft_test_result(should_work, "Should have worked\n");
+			if (should_work) {
+				result = KSFT_PASS;
+			} else {
+				ksft_print_msg("Should have worked\n");
+				result = KSFT_FAIL;
+			}
 			io_uring_unregister_buffers(&ring);
 		}
 
@@ -246,6 +285,8 @@ static void do_test(int fd, size_t size,
 
 munmap:
 	munmap(mem, size);
+report:
+	log_test_result(result);
 }
 
 typedef void (*test_fn)(int fd, size_t size);
@@ -254,13 +295,11 @@ static void run_with_memfd(test_fn fn, c
 {
 	int fd;
 
-	ksft_print_msg("[RUN] %s ... with memfd\n", desc);
+	log_test_start("%s ... with memfd", desc);
 
 	fd = memfd_create("test", 0);
-	if (fd < 0) {
-		ksft_test_result_fail("memfd_create() failed (%s)\n", strerror(errno));
-		return;
-	}
+	if (fd < 0)
+		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
 
 	fn(fd, pagesize);
 	close(fd);
@@ -271,23 +310,23 @@ static void run_with_tmpfile(test_fn fn,
 	FILE *file;
 	int fd;
 
-	ksft_print_msg("[RUN] %s ... with tmpfile\n", desc);
+	log_test_start("%s ... with tmpfile", desc);
 
 	file = tmpfile();
 	if (!file) {
-		ksft_test_result_fail("tmpfile() failed (%s)\n", strerror(errno));
-		return;
-	}
-
-	fd = fileno(file);
-	if (fd < 0) {
-		ksft_test_result_fail("fileno() failed (%s)\n", strerror(errno));
-		goto close;
+		ksft_print_msg("tmpfile() failed (%s)\n", strerror(errno));
+		fd = -1;
+	} else {
+		fd = fileno(file);
+		if (fd < 0) {
+			ksft_print_msg("fileno() failed (%s)\n", strerror(errno));
+		}
 	}
 
 	fn(fd, pagesize);
-close:
-	fclose(file);
+
+	if (file)
+		fclose(file);
 }
 
 static void run_with_local_tmpfile(test_fn fn, const char *desc)
@@ -295,22 +334,22 @@ static void run_with_local_tmpfile(test_
 	char filename[] = __FILE__"_tmpfile_XXXXXX";
 	int fd;
 
-	ksft_print_msg("[RUN] %s ... with local tmpfile\n", desc);
+	log_test_start("%s ... with local tmpfile", desc);
 
 	fd = mkstemp(filename);
-	if (fd < 0) {
-		ksft_test_result_fail("mkstemp() failed (%s)\n", strerror(errno));
-		return;
-	}
+	if (fd < 0)
+		ksft_print_msg("mkstemp() failed (%s)\n", strerror(errno));
 
 	if (unlink(filename)) {
-		ksft_test_result_fail("unlink() failed (%s)\n", strerror(errno));
-		goto close;
+		ksft_print_msg("unlink() failed (%s)\n", strerror(errno));
+		close(fd);
+		fd = -1;
 	}
 
 	fn(fd, pagesize);
-close:
-	close(fd);
+
+	if (fd >= 0)
+		close(fd);
 }
 
 static void run_with_memfd_hugetlb(test_fn fn, const char *desc,
@@ -319,15 +358,14 @@ static void run_with_memfd_hugetlb(test_
 	int flags = MFD_HUGETLB;
 	int fd;
 
-	ksft_print_msg("[RUN] %s ... with memfd hugetlb (%zu kB)\n", desc,
+	log_test_start("%s ... with memfd hugetlb (%zu kB)", desc,
 		       hugetlbsize / 1024);
 
 	flags |= __builtin_ctzll(hugetlbsize) << MFD_HUGE_SHIFT;
 
 	fd = memfd_create("test", flags);
 	if (fd < 0) {
-		ksft_test_result_skip("memfd_create() failed (%s)\n", strerror(errno));
-		return;
+		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
 	}
 
 	fn(fd, hugetlbsize);
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch
selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch
selftest-mm-add-helper-for-logging-test-start-and-results.patch
selftests-mm-report-unique-test-names-for-each-cow-test.patch
selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

