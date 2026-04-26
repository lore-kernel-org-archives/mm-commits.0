Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11A629D26C
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777232787; cv=none; b=a3Yw6vH0w9mGxcoim9x2/8Tvx51Jj+cMuMa4BgFdz6BItTz0MOd0oTNgrTE7gT0bc8p78BiC0jUrPThE/Ii5GzYaLJA4pfYecxrGR6h6ty8MBXUAfBZux1+Xt8mkNPLGUdZNF1BH+URcFVQPET74VKXUyCRVLqtcPSzLw1CZ0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777232787; c=relaxed/simple;
	bh=XtRd7if2srXiFyjrGdVX8+quKclKnAeG/IkfMLL8Vbs=;
	h=Date:To:From:Subject:Message-Id; b=eqDaDBXhCuhOt/WLcB0G5hQCEDsybVVWk2gOACLpr7ci0dJ3LVSawRrRBtSRcTHZct6dqXqJQzs9Cy4UJQdmSybfczZnygkZHeXkc05QaTnQjUCHW5LqEXREYwvBEwHCcLFWJ+Ae8i43NMImiF2uoL+uP98ZLT98ealLGAIlePY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IPPFod62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IPPFod62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BD8C2BCB4;
	Sun, 26 Apr 2026 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777232786;
	bh=XtRd7if2srXiFyjrGdVX8+quKclKnAeG/IkfMLL8Vbs=;
	h=Date:To:From:Subject:From;
	b=IPPFod62O3ILIqaz3lEIgVJ5/5W20bs1ix3Apq3nGBErnU52Z+QZomS04GFkX6uPe
	 R9I1T3ADQ7y5FfLuBUwVtZEJ+yFGpEZHXy1v/y0GtGTLor3RkYtjEAdVo4OmgJCr6/
	 5RBMPobxZESRgs8fjyLfArHUZEqou7/PmFSEHiss=
Date: Sun, 26 Apr 2026 12:46:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch added to mm-new branch
Message-Id: <20260426194626.B6BD8C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: simplify byte pattern checking in mremap_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: simplify byte pattern checking in mremap_test
Date: Wed, 15 Apr 2026 10:15:09 +0530

The original version of mremap_test (7df666253f26: "kselftests: vm: add
mremap tests") validated remapped contents byte-by-byte and printed a
mismatch index in case the bytes streams didn't match.  That was rather
inefficient, especially also if the test passed.

Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution
time from minutes to seconds using chunkwise memcmp") used memcmp() on
bigger chunks, to fallback to byte-wise scanning to detect the problematic
index only if it discovered a problem.

However, the implementation is overly complicated (e.g., get_sqrt() is
currently not optimal) and we don't really have to report the exact index:
whoever debugs the failing test can figure that out.

Let's simplify by just comparing both byte streams with memcmp() and not
detecting the exact failed index.

Link: https://lore.kernel.org/20260415044509.579428-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  109 +--------------------
 1 file changed, 10 insertions(+), 99 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-simplify-byte-pattern-checking-in-mremap_test
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -76,27 +76,6 @@ enum {
 	.expect_failure = should_fail				\
 }
 
-/* compute square root using binary search */
-static unsigned long get_sqrt(unsigned long val)
-{
-	unsigned long low = 1;
-
-	/* assuming rand_size is less than 1TB */
-	unsigned long high = (1UL << 20);
-
-	while (low <= high) {
-		unsigned long mid = low + (high - low) / 2;
-		unsigned long temp = mid * mid;
-
-		if (temp == val)
-			return mid;
-		if (temp < val)
-			low = mid + 1;
-		high = mid - 1;
-	}
-	return low;
-}
-
 /*
  * Returns false if the requested remap region overlaps with an
  * existing mapping (e.g text, stack) else returns true.
@@ -995,11 +974,9 @@ static long long remap_region(struct con
 			      char *rand_addr)
 {
 	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
-	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
 	unsigned long long threshold;
-	unsigned long num_chunks;
 
 	if (threshold_mb == VALIDATION_NO_THRESHOLD)
 		threshold = c.region_size;
@@ -1068,87 +1045,21 @@ static long long remap_region(struct con
 		goto clean_up_dest_preamble;
 	}
 
-	/*
-	 * Verify byte pattern after remapping. Employ an algorithm with a
-	 * square root time complexity in threshold: divide the range into
-	 * chunks, if memcmp() returns non-zero, only then perform an
-	 * iteration in that chunk to find the mismatch index.
-	 */
-	num_chunks = get_sqrt(threshold);
-	for (unsigned long i = 0; i < num_chunks; ++i) {
-		size_t chunk_size = threshold / num_chunks;
-		unsigned long shift = i * chunk_size;
-
-		if (!memcmp(dest_addr + shift, rand_addr + shift, chunk_size))
-			continue;
-
-		/* brute force iteration only over mismatch segment */
-		for (t = shift; t < shift + chunk_size; ++t) {
-			if (((char *) dest_addr)[t] != rand_addr[t]) {
-				ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-						t);
-				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
-						((char *) dest_addr)[t] & 0xff);
-				ret = -1;
-				goto clean_up_dest;
-			}
-		}
-	}
-
-	/*
-	 * if threshold is not divisible by num_chunks, then check the
-	 * last chunk
-	 */
-	for (t = num_chunks * (threshold / num_chunks); t < threshold; ++t) {
-		if (((char *) dest_addr)[t] != rand_addr[t]) {
-			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
-					t);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[t] & 0xff,
-					((char *) dest_addr)[t] & 0xff);
-			ret = -1;
-			goto clean_up_dest;
-		}
+	/* Verify byte pattern after remapping */
+	if (memcmp(dest_addr, rand_addr, threshold)) {
+		ksft_print_msg("Data after remap doesn't match\n");
+		ret = -1;
+		goto clean_up_dest;
 	}
 
 	/* Verify the dest preamble byte pattern after remapping */
-	if (!c.dest_preamble_size)
-		goto no_preamble;
-
-	num_chunks = get_sqrt(c.dest_preamble_size);
-
-	for (unsigned long i = 0; i < num_chunks; ++i) {
-		size_t chunk_size = c.dest_preamble_size / num_chunks;
-		unsigned long shift = i * chunk_size;
-
-		if (!memcmp(dest_preamble_addr + shift, rand_addr + shift,
-			    chunk_size))
-			continue;
-
-		/* brute force iteration only over mismatched segment */
-		for (d = shift; d < shift + chunk_size; ++d) {
-			if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
-				ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
-						d);
-				ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
-						((char *) dest_preamble_addr)[d] & 0xff);
-				ret = -1;
-				goto clean_up_dest;
-			}
-		}
-	}
-
-	for (d = num_chunks * (c.dest_preamble_size / num_chunks); d < c.dest_preamble_size; ++d) {
-		if (((char *) dest_preamble_addr)[d] != rand_addr[d]) {
-			ksft_print_msg("Preamble data after remap doesn't match at offset %llu\n",
-					d);
-			ksft_print_msg("Expected: %#x\t Got: %#x\n", rand_addr[d] & 0xff,
-					((char *) dest_preamble_addr)[d] & 0xff);
-			ret = -1;
-			goto clean_up_dest;
-		}
+	if (c.dest_preamble_size &&
+	    memcmp(dest_preamble_addr, rand_addr, c.dest_preamble_size)) {
+		ksft_print_msg("Preamble data after remap doesn't match\n");
+		ret = -1;
+		goto clean_up_dest;
 	}
 
-no_preamble:
 	start_ns = t_start.tv_sec * NS_PER_SEC + t_start.tv_nsec;
 	end_ns = t_end.tv_sec * NS_PER_SEC + t_end.tv_nsec;
 	ret = end_ns - start_ns;
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-khugepaged-generalize-alloc_charge_folio.patch
selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch

