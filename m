Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4272E403
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957145; cv=none; b=HDI/Dd1ubhViYcCm2cI1p0aidNkTAGe4s/iPf9YUv/l3pVPUPfkCuHnYrrGk52/ER7XguRcH79cdn/bv30OI0rWEiu+EY0fWA8RmDBpGK9igH68z2ca2X1OO23LUdevc+nPt0jIKTHzvSrJ2rifHZol7wzIsWM18JMO9YSHIA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957145; c=relaxed/simple;
	bh=rYMGWOm50I4zOvFa72i7omyFOkpHzzP6lh9wJXZqRMs=;
	h=Date:To:From:Subject:Message-Id; b=CT38s5M7J+7QvnnwNMHaWHuRKfbFzz5eh6zNf8ErLjkjrSBfNseO9RLXZSEqG+b/z5p2aThff4tFUZ7tdpPuiHVWW4B/tpdho003bkcYx7CkoYOwxievTFYZZdZAFDnuqnp6oBZ17J4I6+QlJhW6DRjQDnRAyovgSadFJ5AtSv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4z4ZllG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4z4ZllG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC42C113CC;
	Mon,  6 May 2024 00:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957145;
	bh=rYMGWOm50I4zOvFa72i7omyFOkpHzzP6lh9wJXZqRMs=;
	h=Date:To:From:Subject:From;
	b=f4z4ZllGQYM7Bk+a0sBnEI7wOP2Etq7ADjP15EY3CnTfftdqy+zYFADCQ36C1lmo5
	 YqurSAog6FAp8Gi4HEoDOnNt6p1Fjhs3UiKMGqAXRYFgKmWVy6rDY7X6SZ0oM+0pqJ
	 D4D3K9Wie/mFwtZ0SXAq0tjxIW8kKgrc0fH642K8=
Date: Sun, 05 May 2024 17:59:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch removed from -mm tree
Message-Id: <20240506005904.DEC42C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL
Date: Thu, 2 May 2024 10:52:58 +0200

Patch series "selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL".

The failing hugetlb vmsplice() COW tests keep confusing people, and having
tests that have been failing for years and likely will keep failing for
years to come because nobody cares enough is rather suboptimal.  Let's
mark them as XFAIL and document why fixing them is not that easy as it
would appear at first sight.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/


This patch (of 2):

The vmsplice() hugetlb tests have been failing right from the start, and
we documented that in the introducing commit 7dad331be781 ("selftests/vm:
anon_cow: hugetlb tests"):

	Note that some tests cases still fail. This will, for example, be
	fixed once vmsplice properly uses FOLL_PIN instead of FOLL_GET for
	pinning. With 2 MiB and 1 GiB hugetlb on x86_64, the expected
	failures are:

Until vmsplice() is changed, these tests will likely keep failing: hugetlb
COW reuse logic is harder to change, because using the same COW reuse
logic as we use for !hugetlb could harm other (sane) users when running
out of free hugetlb pages.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

These (expected) failures keep confusing people, so flag them accordingly.

Before:
	$ ./cow
	[...]
	Bail out! 8 out of 778 tests failed
	# Totals: pass:769 fail:8 xfail:0 xpass:0 skip:1 error:0
	$ echo $?
	1

After:
	$ ./cow
	[...]
	# Totals: pass:769 fail:0 xfail:8 xpass:0 skip:1 error:0
	$ echo $?
	0

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/

Link: https://lkml.kernel.org/r/20240502085259.103784-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240502085259.103784-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |  106 +++++++++++++++++++----------
 1 file changed, 71 insertions(+), 35 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail
+++ a/tools/testing/selftests/mm/cow.c
@@ -199,7 +199,7 @@ static int child_vmsplice_memcmp_fn(char
 typedef int (*child_fn)(char *mem, size_t size, struct comm_pipes *comm_pipes);
 
 static void do_test_cow_in_parent(char *mem, size_t size, bool do_mprotect,
-				  child_fn fn)
+		child_fn fn, bool xfail)
 {
 	struct comm_pipes comm_pipes;
 	char buf;
@@ -247,33 +247,47 @@ static void do_test_cow_in_parent(char *
 	else
 		ret = -EINVAL;
 
-	ksft_test_result(!ret, "No leak from parent into child\n");
+	if (!ret) {
+		ksft_test_result_pass("No leak from parent into child\n");
+	} else if (xfail) {
+		/*
+		 * With hugetlb, some vmsplice() tests are currently expected to
+		 * fail because (a) harder to fix and (b) nobody really cares.
+		 * Flag them as expected failure for now.
+		 */
+		ksft_test_result_xfail("Leak from parent into child\n");
+	} else {
+		ksft_test_result_fail("Leak from parent into child\n");
+	}
 close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_cow_in_parent(char *mem, size_t size)
+static void test_cow_in_parent(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, false, child_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_memcmp_fn, false);
 }
 
-static void test_cow_in_parent_mprotect(char *mem, size_t size)
+static void test_cow_in_parent_mprotect(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, true, child_memcmp_fn);
+	do_test_cow_in_parent(mem, size, true, child_memcmp_fn, false);
 }
 
-static void test_vmsplice_in_child(char *mem, size_t size)
+static void test_vmsplice_in_child(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, false, child_vmsplice_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_vmsplice_memcmp_fn,
+			      is_hugetlb);
 }
 
-static void test_vmsplice_in_child_mprotect(char *mem, size_t size)
+static void test_vmsplice_in_child_mprotect(char *mem, size_t size,
+		bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, true, child_vmsplice_memcmp_fn);
+	do_test_cow_in_parent(mem, size, true, child_vmsplice_memcmp_fn,
+			      is_hugetlb);
 }
 
 static void do_test_vmsplice_in_parent(char *mem, size_t size,
-				       bool before_fork)
+				       bool before_fork, bool xfail)
 {
 	struct iovec iov = {
 		.iov_base = mem,
@@ -355,8 +369,18 @@ static void do_test_vmsplice_in_parent(c
 		}
 	}
 
-	ksft_test_result(!memcmp(old, new, transferred),
-			 "No leak from child into parent\n");
+	if (!memcmp(old, new, transferred)) {
+		ksft_test_result_pass("No leak from child into parent\n");
+	} else if (xfail) {
+		/*
+		 * With hugetlb, some vmsplice() tests are currently expected to
+		 * fail because (a) harder to fix and (b) nobody really cares.
+		 * Flag them as expected failure for now.
+		 */
+		ksft_test_result_xfail("Leak from child into parent\n");
+	} else {
+		ksft_test_result_fail("Leak from child into parent\n");
+	}
 close_pipe:
 	close(fds[0]);
 	close(fds[1]);
@@ -367,14 +391,14 @@ free:
 	free(new);
 }
 
-static void test_vmsplice_before_fork(char *mem, size_t size)
+static void test_vmsplice_before_fork(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_vmsplice_in_parent(mem, size, true);
+	do_test_vmsplice_in_parent(mem, size, true, is_hugetlb);
 }
 
-static void test_vmsplice_after_fork(char *mem, size_t size)
+static void test_vmsplice_after_fork(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_vmsplice_in_parent(mem, size, false);
+	do_test_vmsplice_in_parent(mem, size, false, is_hugetlb);
 }
 
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -529,12 +553,12 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_iouring_ro(char *mem, size_t size)
+static void test_iouring_ro(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_iouring(mem, size, false);
 }
 
-static void test_iouring_fork(char *mem, size_t size)
+static void test_iouring_fork(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_iouring(mem, size, true);
 }
@@ -678,37 +702,41 @@ free_tmp:
 	free(tmp);
 }
 
-static void test_ro_pin_on_shared(char *mem, size_t size)
+static void test_ro_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_shared(char *mem, size_t size)
+static void test_ro_fast_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, true);
 }
 
-static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size)
+static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size)
+static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, true);
 }
 
-static void test_ro_pin_on_ro_exclusive(char *mem, size_t size)
+static void test_ro_pin_on_ro_exclusive(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, false);
 }
 
-static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size)
+static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, true);
 }
 
-typedef void (*test_fn)(char *mem, size_t size);
+typedef void (*test_fn)(char *mem, size_t size, bool hugetlb);
 
 static void do_run_with_base_page(test_fn fn, bool swapout)
 {
@@ -740,7 +768,7 @@ static void do_run_with_base_page(test_f
 		}
 	}
 
-	fn(mem, pagesize);
+	fn(mem, pagesize, false);
 munmap:
 	munmap(mem, pagesize);
 }
@@ -904,7 +932,7 @@ static void do_run_with_thp(test_fn fn,
 		break;
 	}
 
-	fn(mem, size);
+	fn(mem, size, false);
 munmap:
 	munmap(mmap_mem, mmap_size);
 	if (mremap_mem != MAP_FAILED)
@@ -997,7 +1025,7 @@ static void run_with_hugetlb(test_fn fn,
 	}
 	munmap(dummy, hugetlbsize);
 
-	fn(mem, hugetlbsize);
+	fn(mem, hugetlbsize, true);
 munmap:
 	munmap(mem, hugetlbsize);
 }
@@ -1036,7 +1064,7 @@ static const struct test_case anon_test_
 	 */
 	{
 		"vmsplice() + unmap in child",
-		test_vmsplice_in_child
+		test_vmsplice_in_child,
 	},
 	/*
 	 * vmsplice() test, but do an additional mprotect(PROT_READ)+
@@ -1044,7 +1072,7 @@ static const struct test_case anon_test_
 	 */
 	{
 		"vmsplice() + unmap in child with mprotect() optimization",
-		test_vmsplice_in_child_mprotect
+		test_vmsplice_in_child_mprotect,
 	},
 	/*
 	 * vmsplice() [R/O GUP] in parent before fork(), unmap in parent after
@@ -1322,23 +1350,31 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_anon_thp_collapse_unshared(char *mem, size_t size)
+static void test_anon_thp_collapse_unshared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UNSHARED);
 }
 
-static void test_anon_thp_collapse_fully_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_fully_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_FULLY_SHARED);
 }
 
-static void test_anon_thp_collapse_lower_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_lower_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_LOWER_SHARED);
 }
 
-static void test_anon_thp_collapse_upper_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_upper_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UPPER_SHARED);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


