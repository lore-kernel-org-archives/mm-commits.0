Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB039242D72
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753138010; cv=none; b=Cx9hMkWZ4ALteHjfz4UXZdq8DSythf6M33siVTzC42LTk/byOn5r7kSugX3r2og2KFQDXX9YiKzbEKTUO0S+p0lzc79vYSxkN2nevGbRNv084R/B0UASpD6ltH5DWXPjhFBaGYJhZNIUflKUeHNryDiUysaRrOS5mLOPPpJ8kwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753138010; c=relaxed/simple;
	bh=zXHI27V8Y7hA8wRxG5gqqS05+VJdAjOBqvoO15AUmj0=;
	h=Date:To:From:Subject:Message-Id; b=MmdWZBychJafTC1gzV6ZFymWrdQ56cn3QUkEc8r7eNdD/BznaKFBy8q9vvv1ekGDFBhYWW2E1Q0jkGGWgd0H2bgxzlLstt1zuzMkyEStdB4uWK8dEhmgQcTJWvoJNXvBqykkh76MuBawY8yK2k9CXmAMbIe/AcZPhnM/IaEI1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNfbjIfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNfbjIfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E675C4CEF4;
	Mon, 21 Jul 2025 22:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753138010;
	bh=zXHI27V8Y7hA8wRxG5gqqS05+VJdAjOBqvoO15AUmj0=;
	h=Date:To:From:Subject:From;
	b=eNfbjIfaC5GGrG4Dgk9XBFoZtrsW+d6zECeOc9sblPwKbU5xlqU1JxR2mE010EJUL
	 wglbAxPZj81k+BrDl5oLyspoCMbLYfMukO5RvM7zm+5/HffvH+fT9A+EqiNeSRTHyp
	 eZgzK63/Wi3C7fak0D6tt0Ld8fW3ECqMqy1Acf6w=
Date: Mon, 21 Jul 2025 15:46:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch added to mm-unstable branch
Message-Id: <20250721224650.3E675C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: test MREMAP_DONTUNMAP on multiple VMA move
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch

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

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-check-remap-conditions-earlier-fix.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch

