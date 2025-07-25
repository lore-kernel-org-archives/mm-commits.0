Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C716715E90
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409744; cv=none; b=LVYp5o6qrwygCcX3OQBn53CtXaURjYt4W90q6ASMbMgO8cnGXxoeodHxsqvpq4cJ1tjh5Qx4QCkKcs1M7M0kfD+OSiq7hNhKlkz4l4w0ajxHDYPZNyWovesxR60m4pd9QST1A/0L8tYs5ggGgV4UxT9ou8y7URc8Oj+LRIHTEpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409744; c=relaxed/simple;
	bh=Y2WBYPfsF+qIYW3H5N685fKdiKkS0IEjJljrpc97p5Y=;
	h=Date:To:From:Subject:Message-Id; b=O5U+Al6wFt3oxh5emV+OgaiK+QeXiCuYh0DMcCweWqTfGl9gAqws0y1qWsaSWecE18H2uHVr+qQUYWUDTnWdmbWD0rb00TNb+4PrCH34SDJS2Vl9qUiG2KZTMLzLDUXcSdlx7KzNKtLT0fAY6cvOjVLoCTjFx4WyTqgQfrw59eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qnC4xm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qnC4xm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A39C4CEED;
	Fri, 25 Jul 2025 02:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409744;
	bh=Y2WBYPfsF+qIYW3H5N685fKdiKkS0IEjJljrpc97p5Y=;
	h=Date:To:From:Subject:From;
	b=0qnC4xm9Z7olGHHkkfs+Ygn/rD1PsRz2gU8CtJDF9lWhxWFAI7Au+EbX6aXVT6BdM
	 7lKnHCQIRVHzcKhh7q1HB47eJenjpApvNcwnu6Yi2OYdPBKv65YjtqyUAx1ydZK/AA
	 Vgy8mAyxveCePm2ecMk5F3DrX4bhCK3pl7kWKMOI=
Date: Thu, 24 Jul 2025 19:15:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch removed from -mm tree
Message-Id: <20250725021544.47A39C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: test MREMAP_DONTUNMAP on multiple VMA move
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: test MREMAP_DONTUNMAP on multiple VMA move
Date: Mon, 21 Jul 2025 18:33:26 +0100

We support MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_DONTUNMAP for moving
multiple VMAs via mremap(), so assert that the tests pass with both
MREMAP_DONTUNMAP set and not set.

Additionally, add success = false settings when mremap() fails.  This is
something that cannot realistically happen, so in no way impacted test
outcome, but it is incorrect to indicate a test pass when something has
failed.

Link: https://lkml.kernel.org/r/d7359941981e4e44c774753b3e364d1c54928e6a.1753119043.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   29 +++++++++++++--------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -406,14 +406,19 @@ static bool is_multiple_vma_range_ok(uns
 }
 
 static void mremap_move_multiple_vmas(unsigned int pattern_seed,
-				      unsigned long page_size)
+				      unsigned long page_size,
+				      bool dont_unmap)
 {
+	int mremap_flags = MREMAP_FIXED | MREMAP_MAYMOVE;
 	char *test_name = "mremap move multiple vmas";
 	const size_t size = 11 * page_size;
 	bool success = true;
 	char *ptr, *tgt_ptr;
 	int i;
 
+	if (dont_unmap)
+		mremap_flags |= MREMAP_DONTUNMAP;
+
 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (ptr == MAP_FAILED) {
@@ -467,8 +472,7 @@ static void mremap_move_multiple_vmas(un
 	}
 
 	/* First, just move the whole thing. */
-	if (mremap(ptr, size, size,
-		   MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr) == MAP_FAILED) {
+	if (mremap(ptr, size, size, mremap_flags, tgt_ptr) == MAP_FAILED) {
 		perror("mremap");
 		success = false;
 		goto out_unmap;
@@ -480,9 +484,10 @@ static void mremap_move_multiple_vmas(un
 	}
 
 	/* Move next to itself. */
-	if (mremap(tgt_ptr, size, size,
-		   MREMAP_MAYMOVE | MREMAP_FIXED, &tgt_ptr[size]) == MAP_FAILED) {
+	if (mremap(tgt_ptr, size, size, mremap_flags,
+		   &tgt_ptr[size]) == MAP_FAILED) {
 		perror("mremap");
+		success = false;
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
@@ -500,8 +505,9 @@ static void mremap_move_multiple_vmas(un
 	}
 	/* Move and overwrite. */
 	if (mremap(&tgt_ptr[size], size, size,
-		   MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr) == MAP_FAILED) {
+		   mremap_flags, tgt_ptr) == MAP_FAILED) {
 		perror("mremap");
+		success = false;
 		goto out_unmap;
 	}
 	/* Check that the move is ok. */
@@ -518,9 +524,11 @@ out_unmap:
 
 out:
 	if (success)
-		ksft_test_result_pass("%s\n", test_name);
+		ksft_test_result_pass("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
 	else
-		ksft_test_result_fail("%s\n", test_name);
+		ksft_test_result_fail("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
 }
 
 static void mremap_shrink_multiple_vmas(unsigned long page_size,
@@ -943,7 +951,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 5;
+	int num_misc_tests = 6;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1070,9 +1078,10 @@ int main(int argc, char **argv)
 
 	mremap_move_within_range(pattern_seed, rand_addr);
 	mremap_move_1mb_from_start(pattern_seed, rand_addr);
-	mremap_move_multiple_vmas(pattern_seed, page_size);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
+	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

