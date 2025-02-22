Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE9EC4
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183060; cv=none; b=LMeIsoum9VhXGfRSCuFqQdAiz7VUr1cVtODWtlCzThzwmHrZNMPVdHIJWJmyfPZG28ZLXQcJ+5uL3qpj9X2KUhb6X2/tYklSkgyuQHr1YADIkzdZ5kxpUG6CJwWCRQ7swyWRTvwuSS5a0P9wCMFaOUFnptNUGuP0xr+giktPq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183060; c=relaxed/simple;
	bh=CmmDP2ZGGBw78gtWjXeRbE7VQM1ceEUMTYQrT04VjrM=;
	h=Date:To:From:Subject:Message-Id; b=TXKq7CckfEd0qofWsLZJ1Ul8v2UI/l1Nocz8gdfWKzPVy/Hyj1vi30IHwUYzj6oCyJw1P37TK18ka6Lw+s4HvAZVtR8NYAQ5MkQRtDHSnsxmiA7J6WsC4t3kyCHfXIDO0Sks3zkkRhERipQzywdspgblx6pkxFn6YtVOrk6dLkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=whRZvTLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="whRZvTLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9B2C4CED6;
	Sat, 22 Feb 2025 00:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183060;
	bh=CmmDP2ZGGBw78gtWjXeRbE7VQM1ceEUMTYQrT04VjrM=;
	h=Date:To:From:Subject:From;
	b=whRZvTLlf3wFtwVZlYTMFPf0nF2uPWClyMN5N/YZpLHy8ODfNP6xS/2KNKlslieRd
	 jAWscdNwAltYJNEGZzQcExJllhHoTiW2aCDJPFp3ZHgr1oEsBeUPRjgvw383vUZ7xd
	 64IJxbfDaLkPkUBPXqR97pDa/SF353YxcfHa3Iq4=
Date: Fri, 21 Feb 2025 16:11:00 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch added to mm-unstable branch
Message-Id: <20250222001100.7E9B2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: report errno when things fail in gup_longterm
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: report errno when things fail in gup_longterm
Date: Fri, 21 Feb 2025 18:25:40 +0000

Patch series "selftests/mm: Some cleanups from trying to run them", v2.

I never had much luck running mm selftests so I spent a couple of hours
digging into why.

Looks like most of the reason is missing SKIP checks, so this series is
just adding a bunch of those that I found.  I did not do anything like all
of them, just the ones I spotted in gup_longterm, gup_test, mmap,
userfaultfd and memfd_secret.

It's a bit unfortunate to have to skip those tests when ftruncate() fails,
but I don't have time to dig deep enough into it to actually make them
pass - I observed these issues on both 9p and virtiofs.  Probably it
requires digging into the filesystem implementation

(An alternative might just be to mount a tmpfs in the test script).

I am also seeing some failures to allocate hugetlb pages in uffd-mp-mremap
that I have not had time to fully understand, you can see those here:

https://gist.github.com/bjackman/af74c3a6e60975e6ff0d760cba1e05d2#file-userfaultfd-log


This patch (of 9):

Just reporting failure doesn't tell you what went wrong.  This can fail in
different ways so report errno to help the reader get started debugging.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-0-28c4d66383c5@google.com
Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-1-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   37 +++++++++++---------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-report-errno-when-things-fail-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -96,13 +96,13 @@ static void do_test(int fd, size_t size,
 	int ret;
 
 	if (ftruncate(fd, size)) {
-		ksft_test_result_fail("ftruncate() failed\n");
+		ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
 		return;
 	}
 
 	if (fallocate(fd, 0, 0, size)) {
 		if (size == pagesize)
-			ksft_test_result_fail("fallocate() failed\n");
+			ksft_test_result_fail("fallocate() failed (%s)\n", strerror(errno));
 		else
 			ksft_test_result_skip("need more free huge pages\n");
 		return;
@@ -112,7 +112,7 @@ static void do_test(int fd, size_t size,
 		   shared ? MAP_SHARED : MAP_PRIVATE, fd, 0);
 	if (mem == MAP_FAILED) {
 		if (size == pagesize || shared)
-			ksft_test_result_fail("mmap() failed\n");
+			ksft_test_result_fail("mmap() failed (%s)\n", strerror(errno));
 		else
 			ksft_test_result_skip("need more free huge pages\n");
 		return;
@@ -130,7 +130,7 @@ static void do_test(int fd, size_t size,
 		 */
 		ret = mprotect(mem, size, PROT_READ);
 		if (ret) {
-			ksft_test_result_fail("mprotect() failed\n");
+			ksft_test_result_fail("mprotect() failed (%s)\n", strerror(errno));
 			goto munmap;
 		}
 		/* FALLTHROUGH */
@@ -165,18 +165,20 @@ static void do_test(int fd, size_t size,
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_test_result_skip("PIN_LONGTERM_TEST_START failed\n");
+			ksft_test_result_skip("PIN_LONGTERM_TEST_START failed (EINVAL)n");
 			break;
 		} else if (ret && errno == EFAULT) {
 			ksft_test_result(!should_work, "Should have failed\n");
 			break;
 		} else if (ret) {
-			ksft_test_result_fail("PIN_LONGTERM_TEST_START failed\n");
+			ksft_test_result_fail("PIN_LONGTERM_TEST_START failed (%s)\n",
+					      strerror(errno));
 			break;
 		}
 
 		if (ioctl(gup_fd, PIN_LONGTERM_TEST_STOP))
-			ksft_print_msg("[INFO] PIN_LONGTERM_TEST_STOP failed\n");
+			ksft_print_msg("[INFO] PIN_LONGTERM_TEST_STOP failed (%s)\n",
+				       strerror(errno));
 
 		/*
 		 * TODO: if the kernel ever supports long-term R/W pinning on
@@ -202,7 +204,8 @@ static void do_test(int fd, size_t size,
 		/* Skip on errors, as we might just lack kernel support. */
 		ret = io_uring_queue_init(1, &ring, 0);
 		if (ret < 0) {
-			ksft_test_result_skip("io_uring_queue_init() failed\n");
+			ksft_test_result_skip("io_uring_queue_init() failed (%s)\n",
+					      strerror(errno));
 			break;
 		}
 		/*
@@ -215,13 +218,15 @@ static void do_test(int fd, size_t size,
 		/* Only new kernels return EFAULT. */
 		if (ret && (errno == ENOSPC || errno == EOPNOTSUPP ||
 			    errno == EFAULT)) {
-			ksft_test_result(!should_work, "Should have failed\n");
+			ksft_test_result(!should_work, "Should have failed (%s)\n",
+					 strerror(errno));
 		} else if (ret) {
 			/*
 			 * We might just lack support or have insufficient
 			 * MEMLOCK limits.
 			 */
-			ksft_test_result_skip("io_uring_register_buffers() failed\n");
+			ksft_test_result_skip("io_uring_register_buffers() failed (%s)\n",
+					      strerror(errno));
 		} else {
 			ksft_test_result(should_work, "Should have worked\n");
 			io_uring_unregister_buffers(&ring);
@@ -249,7 +254,7 @@ static void run_with_memfd(test_fn fn, c
 
 	fd = memfd_create("test", 0);
 	if (fd < 0) {
-		ksft_test_result_fail("memfd_create() failed\n");
+		ksft_test_result_fail("memfd_create() failed (%s)\n", strerror(errno));
 		return;
 	}
 
@@ -266,13 +271,13 @@ static void run_with_tmpfile(test_fn fn,
 
 	file = tmpfile();
 	if (!file) {
-		ksft_test_result_fail("tmpfile() failed\n");
+		ksft_test_result_fail("tmpfile() failed (%s)\n", strerror(errno));
 		return;
 	}
 
 	fd = fileno(file);
 	if (fd < 0) {
-		ksft_test_result_fail("fileno() failed\n");
+		ksft_test_result_fail("fileno() failed (%s)\n", strerror(errno));
 		goto close;
 	}
 
@@ -290,12 +295,12 @@ static void run_with_local_tmpfile(test_
 
 	fd = mkstemp(filename);
 	if (fd < 0) {
-		ksft_test_result_fail("mkstemp() failed\n");
+		ksft_test_result_fail("mkstemp() failed (%s)\n", strerror(errno));
 		return;
 	}
 
 	if (unlink(filename)) {
-		ksft_test_result_fail("unlink() failed\n");
+		ksft_test_result_fail("unlink() failed (%s)\n", strerror(errno));
 		goto close;
 	}
 
@@ -317,7 +322,7 @@ static void run_with_memfd_hugetlb(test_
 
 	fd = memfd_create("test", flags);
 	if (fd < 0) {
-		ksft_test_result_skip("memfd_create() failed\n");
+		ksft_test_result_skip("memfd_create() failed (%s)\n", strerror(errno));
 		return;
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

