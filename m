Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0494F88B
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711997982; cv=none; b=Qk0quldBXmQ5Qaa3hXlAzfdEVxoWL+PLF6D8ej+IS16s3ftMBUJ9GcVWrjWkzGVqnUEA19z17NTVMTyA3DMz6yI436/aI7tBlhA/i1cTBI2paYMX5NlT0I/7rddYz1FYRMPdKiBKHvyOQ7zpX0j5k02wTJTVJfsBeqAk1sEbbaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711997982; c=relaxed/simple;
	bh=vgz7GtEowdiJzQVXcI9o11RCGWVxwzhCiTK5QPvuwGs=;
	h=Date:To:From:Subject:Message-Id; b=QvGv4P3WTHvabTyRuIfdMiPcd7yDElDC/dq9I/FBrZbhfV0vdZXD4s2/O8oz9aQKNTUVfg+ReQ6vQsx4gPhk5rf0xfblWqx2pBOTeLonjfEa+zJUsfpNWQoTS8Io6Ga+771a3IGwvOJp7CsHrXW9U//e00UQraUme2NiKxiUUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgeDMypL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgeDMypL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C279C43390;
	Mon,  1 Apr 2024 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711997981;
	bh=vgz7GtEowdiJzQVXcI9o11RCGWVxwzhCiTK5QPvuwGs=;
	h=Date:To:From:Subject:From;
	b=IgeDMypLJum5xWgqsvVYWUvo9bJgASEKwvIprVeOzxZUoj1dFuVPB3O+7aLyoa+lY
	 BeNsbPaTvVCaE29d6v88qB7OzucaT2tlWw3M+Zj4tcXGA6GXniPGj30ygGQHuOQQX9
	 yOfouL6IO11rG7egw+kj0/1jzKocOuvmUVYaI2Wc=
Date: Mon, 01 Apr 2024 11:59:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kaleshsingh@google.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch added to mm-unstable branch
Message-Id: <20240401185941.9C279C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: optimize execution time from minutes to seconds using chunkwise memcmp
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: mremap_test: optimize execution time from minutes to seconds using chunkwise memcmp
Date: Sat, 30 Mar 2024 23:05:56 +0530

Mismatch index is currently being checked by a brute force iteration over
the buffer.  Instead, break the comparison into O(sqrt(n)) number of
chunks, with the chunk size of this order only, where n is the size of the
buffer.  Do a brute-force iteration to print to stdout only when the
highly optimized memcmp() library function returns a mismatch in the
chunk.  The time complexity of this algorithm is O(sqrt(n)) * t, where t
is the time taken by memcmp(); for our test conditions, it is safe to
assume t to be small.

Link: https://lkml.kernel.org/r/20240330173557.2697684-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  112 +++++++++++++++++----
 1 file changed, 91 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -70,6 +70,27 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/* compute square root using binary search */
+static unsigned long get_sqrt(unsigned long val)
+{
+	unsigned long low = 1;
+
+	/* assuming rand_size is less than 1TB */
+	unsigned long high = (1UL << 20);
+
+	while (low <= high) {
+		unsigned long mid = low + (high - low) / 2;
+		unsigned long temp = mid * mid;
+
+		if (temp == val)
+			return mid;
+		if (temp < val)
+			low = mid + 1;
+		high = mid - 1;
+	}
+	return low;
+}
+
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.
@@ -355,14 +376,14 @@ out:
 
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
-			      unsigned int pattern_seed, char *rand_addr)
+			      char *rand_addr)
 {
 	void *addr, *src_addr, *dest_addr, *dest_preamble_addr;
-	int d;
-	unsigned long long t;
+	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
 	unsigned long long threshold;
+	unsigned long num_chunks;
 
 	if (threshold_mb == VALIDATION_NO_THRESHOLD)
 		threshold = c.region_size;
@@ -430,15 +451,42 @@ static long long remap_region(struct con
 		goto clean_up_dest_preamble;
 	}
 
-	/* Verify byte pattern after remapping */
-	srand(pattern_seed);
-	for (t = 0; t < threshold; t++) {
-		char c = (char) rand();
+	/*
+	 * Verify byte pattern after remapping. Employ an algorithm with a
+	 * square root time complexity in threshold: divide the range into
+	 * chunks, if memcmp() returns non-zero, only then perform an
+	 * iteration in that chunk to find the mismatch index.
+	 */
+	num_chunks = get_sqrt(threshold);
+	for (unsigned long i = 0; i < num_chunks; ++i) {
+		size_t chunk_size = threshold / num_chunks;
+		unsigned long shift = i * chunk_size;
+
+		if (!memcmp(dest_addr + shift, rand_addr + shift, chunk_size))
+			continue;
+
+		/* brute force iteration only over mismatch segment */
+		for (t = shift; t < shift + chunk_size; ++t) {
+			if (((char *) dest_addr)[t] != rand_addr[t]) {
+				ksft_print_msg("Data after remap doesn't match at offset %llu\n",
+						t);
+				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
+						((char *) dest_addr)[t] & 0xff);
+				ret = -1;
+				goto clean_up_dest;
+			}
+		}
+	}
 
-		if (((char *) dest_addr)[t] != c) {
+	/*
+	 * if threshold is not divisible by num_chunks, then check the
+	 * last chunk
+	 */
+	for (t = num_chunks * (threshold / num_chunks); t < threshold; ++t) {
+		if (((char *) dest_addr)[t] != rand_addr[t]) {
 			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-				       t);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
+					t);
+			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
 					((char *) dest_addr)[t] & 0xff);
 			ret = -1;
 			goto clean_up_dest;
@@ -446,22 +494,44 @@ static long long remap_region(struct con
 	}
 
 	/* Verify the dest preamble byte pattern after remapping */
-	if (c.dest_preamble_size) {
-		srand(pattern_seed);
-		for (d = 0; d < c.dest_preamble_size; d++) {
-			char c = (char) rand();
-
-			if (((char *) dest_preamble_addr)[d] != c) {
-				ksft_print_msg("Preamble data after remap doesn't match at offset %d\n",
-					       d);
-				ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
-					       ((char *) dest_preamble_addr)[d] & 0xff);
+	if (!c.dest_preamble_size)
+		goto no_preamble;
+
+	num_chunks = get_sqrt(c.dest_preamble_size);
+
+	for (unsigned long i = 0; i < num_chunks; ++i) {
+		size_t chunk_size = c.dest_preamble_size / num_chunks;
+		unsigned long shift = i * chunk_size;
+
+		if (!memcmp(dest_preamble_addr + shift, rand_addr + shift,
+			    chunk_size))
+			continue;
+
+		/* brute force iteration only over mismatched segment */
+		for (d = shift; d < shift + chunk_size; ++d) {
+			if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
+				ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
+						d);
+				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
+						((char *) dest_preamble_addr)[d] & 0xff);
 				ret = -1;
 				goto clean_up_dest;
 			}
 		}
 	}
 
+	for (d = num_chunks * (c.dest_preamble_size / num_chunks); d < c.dest_preamble_size; ++d) {
+		if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
+			ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
+					d);
+			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
+					((char *) dest_preamble_addr)[d] & 0xff);
+			ret = -1;
+			goto clean_up_dest;
+		}
+	}
+
+no_preamble:
 	start_ns = t_start.tv_sec * NS_PER_SEC + t_start.tv_nsec;
 	end_ns = t_end.tv_sec * NS_PER_SEC + t_end.tv_nsec;
 	ret = end_ns - start_ns;
@@ -563,7 +633,7 @@ static void run_mremap_test_case(struct
 				 unsigned int pattern_seed, char *rand_addr)
 {
 	long long remap_time = remap_region(test_case.config, threshold_mb,
-					    pattern_seed, rand_addr);
+					    rand_addr);
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch
selftests-mm-parse-vma-range-in-one-go.patch
selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy.patch
selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch
selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

