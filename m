Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE4F23DE
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939924; cv=none; b=J90aU1iH4DSzATYMrluaGu9LgxfydvNGzDw9eyy+H39MsD23M6QmqzqxYXo2hJC8P7+QmR9aEjdadUALkfRTvOsx6b8eUYx8Cl1EaeLpJPQDn5MURqeXZzEdNw4C58K5ttdcuvYatZKSv/6n2+KHLg3s8wgotNiBMZ1CnuJC89A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939924; c=relaxed/simple;
	bh=ZcODc6gNCwq9elqNrxxxBvZgthricgcX7JD5AkVE0gs=;
	h=Date:To:From:Subject:Message-Id; b=eCYtNhHAuHCJx6Kg4gkjJwJrKlq9BIrE2/9t5x5DcVLq7XzLqiqhVjtHL3b2a2pe2qZXI+30keQIYAvqU0gg7ETiK17rjeLJJNKBRsjY4O9qOo/WqELtrQZN/SNMqBmPxFSjbHIP8QYkeGd3eACuN3GIgxP9k9BZkJ6Mndx3pw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wEpUhI8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wEpUhI8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BF2C4CEE3;
	Tue,  8 Jul 2025 01:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939923;
	bh=ZcODc6gNCwq9elqNrxxxBvZgthricgcX7JD5AkVE0gs=;
	h=Date:To:From:Subject:From;
	b=wEpUhI8+vKEHnuuPyhgirtb1aM0UzFP9ox7E3c3omRzUOfEt7yVZF3f9WwduKp33G
	 bDPAXwOmheS196rnfz05RnAKng+8aQ2aBmwbjHHrUBkogG2HMK54a4gOXb5MVeTltJ
	 QU62aZ077m0dD7Z8raFGv9523xMXxzUj2g3rJhF0=
Date: Mon, 07 Jul 2025 18:58:42 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch added to mm-new branch
Message-Id: <20250708015843.49BF2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: extend mremap_test to test multi-VMA mremap
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: extend mremap_test to test multi-VMA mremap
Date: Mon, 7 Jul 2025 06:27:53 +0100

Now that we have added the ability to move multiple VMAs at once, assert
that this functions correctly, both overwriting VMAs and moving backwards
and forwards with merge and VMA invalidation.

Additionally assert that page tables are correctly propagated by setting
random data and reading it back.

Link: https://lkml.kernel.org/r/fc6dd9a3ecde5e7b1808dcb275ca8cf843f0e0e6.1751865330.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |  145 ++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -380,6 +380,148 @@ out:
 		ksft_test_result_fail("%s\n", test_name);
 }
 
+static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
+				     char *ptr, unsigned long page_size)
+{
+	int i;
+
+	srand(pattern_seed);
+	for (i = 0; i <= 10; i += 2) {
+		int j;
+		char *buf = &ptr[i * page_size];
+		size_t size = i == 4 ? 2 * page_size : page_size;
+
+		for (j = 0; j < size; j++) {
+			char chr = rand();
+
+			if (chr != buf[j]) {
+				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
+					       i, j, chr, buf[j]);
+				return false;
+			}
+		}
+	}
+
+	return true;
+}
+
+static void mremap_move_multiple_vmas(unsigned int pattern_seed,
+				      unsigned long page_size)
+{
+	char *test_name = "mremap move multiple vmas";
+	const size_t size = 11 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	int i;
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+
+	tgt_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+
+	/*
+	 * Unmap so we end up with:
+	 *
+	 *  0   2   4 5 6   8   10 offset in buffer
+	 * |*| |*| |*****| |*| |*|
+	 * |*| |*| |*****| |*| |*|
+	 *  0   1   2 3 4   5   6  pattern offset
+	 */
+	for (i = 1; i < 10; i += 2) {
+		if (i == 5)
+			continue;
+
+		if (munmap(&ptr[i * page_size], page_size)) {
+			perror("munmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	srand(pattern_seed);
+
+	/* Set up random patterns. */
+	for (i = 0; i <= 10; i += 2) {
+		int j;
+		size_t size = i == 4 ? 2 * page_size : page_size;
+		char *buf = &ptr[i * page_size];
+
+		for (j = 0; j < size; j++)
+			buf[j] = rand();
+	}
+
+	/* First, just move the whole thing. */
+	if (mremap(ptr, size, size,
+		   MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr) == MAP_FAILED) {
+		perror("mremap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Check move was ok. */
+	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+		success = false;
+		goto out_unmap;
+	}
+
+	goto out_unmap;
+
+	/* Move next to itself. */
+	if (mremap(tgt_ptr, size, size,
+		   MREMAP_MAYMOVE | MREMAP_FIXED, &tgt_ptr[size]) == MAP_FAILED) {
+		perror("mremap");
+		goto out_unmap;
+	}
+	/* Check that the move is ok. */
+	if (!is_multiple_vma_range_ok(pattern_seed, &tgt_ptr[size], page_size)) {
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Map a range to overwrite. */
+	if (mmap(tgt_ptr, size, PROT_NONE,
+		 MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0) == MAP_FAILED) {
+		perror("mmap tgt");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Move and overwrite. */
+	if (mremap(&tgt_ptr[size], size, size,
+		   MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr) == MAP_FAILED) {
+		perror("mremap");
+		goto out_unmap;
+	}
+	/* Check that the move is ok. */
+	if (!is_multiple_vma_range_ok(pattern_seed, tgt_ptr, page_size)) {
+		success = false;
+		goto out_unmap;
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, 2 * size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+
+out:
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -721,7 +863,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 2;
+	int num_misc_tests = 3;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -848,6 +990,7 @@ int main(int argc, char **argv)
 
 	mremap_move_within_range(pattern_seed, rand_addr);
 	mremap_move_1mb_from_start(pattern_seed, rand_addr);
+	mremap_move_multiple_vmas(pattern_seed, page_size);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

