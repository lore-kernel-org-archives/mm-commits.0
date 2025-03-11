Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F7262800
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714603; cv=none; b=uI/T0igH22h4dsk5eyPWAw1mCej2x8zd3RDlrA9nuDKLujJ+FnadC6QUBfTZL+sYLprsEb6Oyl26uFT397k50aq1+WHyMA/R7X2MtcNlG3iA14OH25uJT+2ilShSzxOs72CJ81H6yFBGI2OxBAAf4IiPkN8NlpyI0K8Esqd2S4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714603; c=relaxed/simple;
	bh=8cheXJmjzc6m1Bdd/j+JkxxZRqVqctF7r/oqVpWdCPQ=;
	h=Date:To:From:Subject:Message-Id; b=IYWmvLDNgwJFs620Z9XE6VSLY4ckJz58+bw6GypTrw7NEDE8MXuQVTG4DaK37b+orxPnLkzrDIWZi+NhYNzeZlecnmU2+Rx5QvKPQfkFq6O37k9X3SHFKyaMCeyFIjmKpvRBBc7rLevnWWvNpkdnWqKAnJjVQumHK59QDFMRaBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFwrBiIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFwrBiIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B744C4CEE9;
	Tue, 11 Mar 2025 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714603;
	bh=8cheXJmjzc6m1Bdd/j+JkxxZRqVqctF7r/oqVpWdCPQ=;
	h=Date:To:From:Subject:From;
	b=NFwrBiIAHCysLOOfEVeeAJDV1LHvDgFUay7zeK7LgFEtIRMDxz7yvy8QRmfK2xS/M
	 voCr04POi015wtTyQ9caHYgrEZcUKPexAfLuywm4M8Y5i2YA5FsAoY7I9+smIkgTrG
	 C7ZMz6AtHJGhQ9RtMxr52PTVShB7S9wLZlWtzukc=
Date: Tue, 11 Mar 2025 10:36:42 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch added to mm-unstable branch
Message-Id: <20250311173643.2B744C4CEE9@smtp.kernel.org>
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
Date: Tue, 11 Mar 2025 13:18:12 +0000

Patch series "selftests/mm: Some cleanups from trying to run them", v4.

I never had much luck running mm selftests so I spent a few hours digging
into why.

Looks like most of the reason is missing SKIP checks, so this series is
just adding a bunch of those that I found.  I did not do anything like all
of them, just the ones I spotted in gup_longterm, gup_test, mmap,
userfaultfd and memfd_secret.

It's a bit unfortunate to have to skip those tests when ftruncate() fails,
but I don't have time to dig deep enough into it to actually make them
pass.  I have observed the issue on 9pfs and heard rumours that NFS has a
similar problem.

I'm now able to run these test groups successfully:

- mmap
- gup_test
- compaction
- migration
- page_frag
- userfaultfd
- mlock

I've never gone past "Waiting for hugetlb memory to get depleted", in the
hugetlb tests.  I don't know if they are stuck or if they would eventually
work if I was patient enough (testing on a 1G machine).  I have not
investigated further.

I had some issues with mlock tests failing due to -ENOSRCH from mlock2(),
I can no longer reproduce that though, things work OK now.

Of the remaining tests there may be others that work fine, but there's no
convenient way to survey the whole output of run_vmtests.sh so I'm just
going test by test here.

In my spare moments I am slowly chipping away at a setup to run these
tests continuously in a reasonably hermetic QEMU environment via
virtme-ng:

https://github.com/bjackman/linux/blob/5fad4b9c592290f38e0f8bc73c9abb9c99d8787c/README.md

Hopefully that will eventually offer a way to provide a "canned"
environment where the tests are known to work, which can be fairly easily
reproduced by any developer.


This patch (of 12):

Just reporting failure doesn't tell you what went wrong.  This can fail in
different ways so report errno to help the reader get started debugging.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-0-dec210a658f5@google.com
Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-1-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
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
+					      strerror(-ret));
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
+					      strerror(-ret));
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
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

