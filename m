Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05F80632
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104115; cv=none; b=jmXJMQ+wAefxRVpaJ1T0cvnpIZbvPf5KGsU0ztEQoeQR0h8+lHsRcAkgnE59nsFLwUBf7SOVHn0PyFZ76wqcd35x4KXNnvmd44z2A5c7wnhGcd9dKo3YxANHp1T6GbSdxH4eAu7H2JfQ7E1wDVW1YI0VvHFlemWvT+Hgdy/EX9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104115; c=relaxed/simple;
	bh=ixu2BzErWJegfUK0MNjfJzUrY/W061ye9dcxuahcJLU=;
	h=Date:To:From:Subject:Message-Id; b=N8w8dJmEfHi5nQCe1zLdwF81mxEw8tCTaUmO/rjUhRNbZ/8bq7S/6CVvdl9/bKS7KJqEYmIaSX5NLWEHILZqRIZK66R9QgVG/aqLyXexI/kv6ZxLVDgkLz3mjsnxlUfbVKvrqbqPyyS+IG0B//z3fOknzqujZ/E48jB5gi3rr50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHPkhFOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHPkhFOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B02C113CD;
	Fri, 26 Apr 2024 04:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104115;
	bh=ixu2BzErWJegfUK0MNjfJzUrY/W061ye9dcxuahcJLU=;
	h=Date:To:From:Subject:From;
	b=DHPkhFOrH07U1jpNcICRPq5DpMAIfW75pxZJVOEsAq+PJdLtGVV7+Ihu78n8GWN1/
	 0umuKJCiNG0i2Cxa9QWYLjPVYXB84YY1ju1aOY59yhXiicV7i324pjlexUEJDkUO2u
	 u0c9/SkX5l0IQVcC0IDjdRW2RlFJTnvwOXZ1W/l8=
Date: Thu, 25 Apr 2024 21:01:55 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kaleshsingh@google.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy.patch removed from -mm tree
Message-Id: <20240426040155.91B02C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_test: optimize using pre-filled random array and memcpy
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: mremap_test: optimize using pre-filled random array and memcpy
Date: Sat, 30 Mar 2024 23:05:55 +0530

Patch series "selftests/mm: mremap_test: Optimizations and style fixes".

The mremap_test, in a worst case controlled by the -t flag, does a for
loop iteration in orders of GB.  Without compromising on the stdout
report, the aim is to reduce this time.

A pre-filled random buffer is allocated based on the seed, replacing
repetitive rand() calls.  The byte pattern in the memory locations is set
through memcpy() from the random buffer.

Replacing the loop for printing the mismatch index to stdout, employ an
efficient algorithm by breaking the comparison into chunks, use the highly
optimized memcmp() library function, and when a mismatch does occur, only
then do a brute force iteration.

Also, use sscanf() to parse /proc/self/maps for consistency across files.

Execution time results (x86 system):
./mremap_test
Original: 3 seconds
After change: 0.8 seconds

./mremap_test -t100
Original: 17 seconds
After change: 2 seconds

./mremap_test -t0 (worst case):
Original: 9:40 minutes
After change: 45 seconds


This patch (of 3):

Allocate a pre-filled random buffer using the seed.  Replace iterative
copying of the random sequence to buffers using the highly optimized
library function memcpy().

Link: https://lkml.kernel.org/r/20240330173557.2697684-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20240330173557.2697684-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   78 ++++++++++++++-------
 1 file changed, 53 insertions(+), 25 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -23,6 +23,7 @@
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#define MAX(X, Y) ((X) > (Y) ? (X) : (Y))
 #define SIZE_MB(m) ((size_t)m * (1024 * 1024))
 #define SIZE_KB(k) ((size_t)k * 1024)
 
@@ -296,7 +297,7 @@ out:
  *
  * |DDDDddddSSSSssss|
  */
-static void mremap_move_within_range(char pattern_seed)
+static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 {
 	char *test_name = "mremap mremap move within range";
 	void *src, *dest;
@@ -316,10 +317,7 @@ static void mremap_move_within_range(cha
 	src = (void *)((unsigned long)src & ~(SIZE_MB(2) - 1));
 
 	/* Set byte pattern for source block. */
-	srand(pattern_seed);
-	for (i = 0; i < SIZE_MB(2); i++) {
-		((char *)src)[i] = (char) rand();
-	}
+	memcpy(src, rand_addr, SIZE_MB(2));
 
 	dest = src - SIZE_MB(2);
 
@@ -357,7 +355,7 @@ out:
 
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
-			      char pattern_seed)
+			      unsigned int pattern_seed, char *rand_addr)
 {
 	void *addr, *src_addr, *dest_addr, *dest_preamble_addr;
 	int d;
@@ -378,9 +376,7 @@ static long long remap_region(struct con
 	}
 
 	/* Set byte pattern for source block. */
-	srand(pattern_seed);
-	for (t = 0; t < threshold; t++)
-		memset((char *) src_addr + t, (char) rand(), 1);
+	memcpy(src_addr, rand_addr, threshold);
 
 	/* Mask to zero out lower bits of address for alignment */
 	align_mask = ~(c.dest_alignment - 1);
@@ -420,9 +416,7 @@ static long long remap_region(struct con
 		}
 
 		/* Set byte pattern for the dest preamble block. */
-		srand(pattern_seed);
-		for (d = 0; d < c.dest_preamble_size; d++)
-			memset((char *) dest_preamble_addr + d, (char) rand(), 1);
+		memcpy(dest_preamble_addr, rand_addr, c.dest_preamble_size);
 	}
 
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
@@ -494,7 +488,8 @@ out:
  * the beginning of the mapping just because the aligned
  * down address landed on a mapping that maybe does not exist.
  */
-static void mremap_move_1mb_from_start(char pattern_seed)
+static void mremap_move_1mb_from_start(unsigned int pattern_seed,
+				       char *rand_addr)
 {
 	char *test_name = "mremap move 1mb from start at 1MB+256KB aligned src";
 	void *src = NULL, *dest = NULL;
@@ -520,10 +515,7 @@ static void mremap_move_1mb_from_start(c
 	}
 
 	/* Set byte pattern for source block. */
-	srand(pattern_seed);
-	for (i = 0; i < SIZE_MB(2); i++) {
-		((char *)src)[i] = (char) rand();
-	}
+	memcpy(src, rand_addr, SIZE_MB(2));
 
 	/*
 	 * Unmap the beginning of dest so that the aligned address
@@ -568,10 +560,10 @@ out:
 
 static void run_mremap_test_case(struct test test_case, int *failures,
 				 unsigned int threshold_mb,
-				 unsigned int pattern_seed)
+				 unsigned int pattern_seed, char *rand_addr)
 {
 	long long remap_time = remap_region(test_case.config, threshold_mb,
-					    pattern_seed);
+					    pattern_seed, rand_addr);
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
@@ -642,7 +634,15 @@ int main(int argc, char **argv)
 	int failures = 0;
 	int i, run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
+
+	/* hard-coded test configs */
+	size_t max_test_variable_region_size = _2GB;
+	size_t max_test_constant_region_size = _2MB;
+	size_t dest_preamble_size = 10 * _4MB;
+
 	unsigned int pattern_seed;
+	char *rand_addr;
+	size_t rand_size;
 	int num_expand_tests = 2;
 	int num_misc_tests = 2;
 	struct test test_cases[MAX_TEST] = {};
@@ -659,6 +659,31 @@ int main(int argc, char **argv)
 	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
 		       threshold_mb, pattern_seed);
 
+	/*
+	 * set preallocated random array according to test configs; see the
+	 * functions for the logic of setting the size
+	 */
+	if (!threshold_mb)
+		rand_size = MAX(max_test_variable_region_size,
+				max_test_constant_region_size);
+	else
+		rand_size = MAX(MIN(threshold_mb * _1MB,
+				    max_test_variable_region_size),
+				max_test_constant_region_size);
+	rand_size = MAX(dest_preamble_size, rand_size);
+
+	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
+				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (rand_addr == MAP_FAILED) {
+		perror("mmap");
+		ksft_exit_fail_msg("cannot mmap rand_addr\n");
+	}
+
+	/* fill stream of random bytes */
+	srand(pattern_seed);
+	for (unsigned long i = 0; i < rand_size; ++i)
+		rand_addr[i] = (char) rand();
+
 	page_size = sysconf(_SC_PAGESIZE);
 
 	/* Expected mremap failures */
@@ -730,13 +755,13 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
-				     pattern_seed);
+				     pattern_seed, rand_addr);
 
 	maps_fp = fopen("/proc/self/maps", "r");
 
 	if (maps_fp == NULL) {
-		ksft_print_msg("Failed to read /proc/self/maps: %s\n", strerror(errno));
-		exit(KSFT_FAIL);
+		munmap(rand_addr, rand_size);
+		ksft_exit_fail_msg("Failed to read /proc/self/maps: %s\n", strerror(errno));
 	}
 
 	mremap_expand_merge(maps_fp, page_size);
@@ -744,17 +769,20 @@ int main(int argc, char **argv)
 
 	fclose(maps_fp);
 
-	mremap_move_within_range(pattern_seed);
-	mremap_move_1mb_from_start(pattern_seed);
+	mremap_move_within_range(pattern_seed, rand_addr);
+	mremap_move_1mb_from_start(pattern_seed, rand_addr);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
 		for (i = 0; i < ARRAY_SIZE(perf_test_cases); i++)
 			run_mremap_test_case(perf_test_cases[i], &failures,
-					     threshold_mb, pattern_seed);
+					     threshold_mb, pattern_seed,
+					     rand_addr);
 	}
 
+	munmap(rand_addr, rand_size);
+
 	if (failures > 0)
 		ksft_exit_fail();
 	else
_

Patches currently in -mm which might be from dev.jain@arm.com are


