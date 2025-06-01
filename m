Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5A0156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756870; cv=none; b=keO3a0BVEe3ZBcxjNnum3yQvIw6fh4t8C0Ya/JqYTJIvA91cp3L5iTOvvnQd/r8O8cH4Bpf4eeKr4iPkwhr0dYpCV2Ftey8ASRVcXTLwPS5e4F0gVlcnvRwx887hhno6KsxX03KzmO292qCqDAzTaNgK6JbZKOhfgPd+SVBRujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756870; c=relaxed/simple;
	bh=m0TOye4ltLWz1vZb2wRTuQhIJ+Z+msMssME1lnv+pgA=;
	h=Date:To:From:Subject:Message-Id; b=Det24bZI/xkSsCwwhGTPN2X61XZ/PE6g9wjaT3hy6yz78ksWREzzLJ+0Q5UAd/17FNWgLonVezFuBTtecF+2p/AHIYZkFNUm9djH72K3TT//FQCl+QDy6CxH9s9Mubn8yyM2xGuXgcOpsGnPxk7hKqUYFj8CuEYTXla1IFhDkEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EX9vKQeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EX9vKQeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3136C4CEED;
	Sun,  1 Jun 2025 05:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756869;
	bh=m0TOye4ltLWz1vZb2wRTuQhIJ+Z+msMssME1lnv+pgA=;
	h=Date:To:From:Subject:From;
	b=EX9vKQePBuYovuHt/jvjIzHQZDYqg9Y5M93Ddt9JnZmD/iwWqyXqfi0UGpOXFxNId
	 EN1gNC4RPgeLupN+/LAIbizDiSYs2s6TXIPFNRNh/v2WQRHpQFGQwS+r84H0zXuQH9
	 P9mSCdFJxGeCdesYDVpukVMqiTWJXiuut5nVMALI=
Date: Sat, 31 May 2025 22:47:49 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-test-result-reporting-in-gup_longterm.patch removed from -mm tree
Message-Id: <20250601054749.D3136C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix test result reporting in gup_longterm
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: fix test result reporting in gup_longterm
Date: Tue, 27 May 2025 17:04:48 +0100

The kselftest framework uses the string logged when a test result is
reported as the unique identifier for a test, using it to track test
results between runs.  The gup_longterm test fails to follow this pattern,
it runs a single test function repeatedly with various parameters but each
result report is a string logging an error message which is fixed between
runs.

Since the code already logs each test uniquely before it starts refactor
to also print this to a buffer, then use that name as the test result. 
This isn't especially pretty but is relatively straightforward and is a
great help to tooling.

Link: https://lkml.kernel.org/r/20250527-selftests-mm-cow-dedupe-v2-4-ff198df8e38e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


