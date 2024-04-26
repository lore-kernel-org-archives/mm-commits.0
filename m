Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBC780632
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104116; cv=none; b=r/jcW2ZKAmWkWcPhD16x5AD44OMySoIRyg+6I6CyyzjxrZpeyb5Y53UbG/X8QoFIlKNpG6h6is3mc6LorpvTaYyXgvwvzvtfKkXNvm40l2Gfi5R9XCT0aJX2wc8t9O/x9I5ap5lb1uPHPTPiOeQx3IAPFVQpzRdSH3yPGqSCRIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104116; c=relaxed/simple;
	bh=37c1KdxDKi2RXzRUl1mGgO0/2giMDyVE6jVmwnmiX5k=;
	h=Date:To:From:Subject:Message-Id; b=s68qUgwt/7IyCLk2Ii0oNoz23aMyQmCIsN48jktxBb2c1fxahKBYsZj22CkAKXiieoLCARvrHoxDlFeXCdxCXyzH8fzvP5HudxKWQ8Iy8CObYElBcUv14jYVEW8elP7NCOmLy1DMEPs4H+hYBGTnEjwPBiLs2ykv6Cm4Izb5l3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zurWQJ3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zurWQJ3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DB1C113CD;
	Fri, 26 Apr 2024 04:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104116;
	bh=37c1KdxDKi2RXzRUl1mGgO0/2giMDyVE6jVmwnmiX5k=;
	h=Date:To:From:Subject:From;
	b=zurWQJ3knY2r4FmXVKUdTU+QhJQ1wdXApRU8dtBYcnTcn0z/7x62L3phwebct/FH+
	 QMDvRmbzDG/VR2SgNFdZzPiWa1+L7cDYQT3QSecJVE2Lb40W1IUAysxLw1CeNN8M1U
	 xKd/xT/iYcxYKCa5SyzBDq2lAvHAG6G3soSmaAqs=
Date: Thu, 25 Apr 2024 21:01:56 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kaleshsingh@google.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch removed from -mm tree
Message-Id: <20240426040156.A0DB1C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_test: optimize execution time from minutes to seconds using chunkwise memcmp
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


