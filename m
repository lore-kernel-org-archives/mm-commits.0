Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F95238D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753138009; cv=none; b=UQLW+x7PtuQoYSVJ8XuP8l8z8mjYMt3UskurbUhO6BQZgIeDEK1q6tnWdkeBvqBQuxx7JI9qje4GX4SV2OGrxZ6xK0VdnI9HNsoCj/NS0hNLmcaiZa30dlKKT/yCZlalhl4jdSqdfNfVeJb1v4nxKFOwzV5s5sAewjoduT+8PDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753138009; c=relaxed/simple;
	bh=BLvizgtl2Xj5GJsxbWsEaMGjRCdLmGiedp4zkeuSqfk=;
	h=Date:To:From:Subject:Message-Id; b=hm2EAW2E+VeC1xh7zkFn9MhE3RV7a0NKBn2IoRegtMkSwdRFUO5pb0Y7KjHpTw9/EtFzfYvIX/NMjoeET/yVvSNdBF2YlYUoTSkNVfZ22FJqWODFXNa4nYbZqh430p/7CzB3bUAvdvcDMfZzp0+B6CBsqP5MW4cvBpmXqQHUxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXzCZLjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXzCZLjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C544C4CEED;
	Mon, 21 Jul 2025 22:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753138009;
	bh=BLvizgtl2Xj5GJsxbWsEaMGjRCdLmGiedp4zkeuSqfk=;
	h=Date:To:From:Subject:From;
	b=OXzCZLjZqP4/jcOI3E1jd/GlgRWC+R0TriV0oKnmX9ADflIRlRwT9BaDI3XmOSZFH
	 gdn5+lFg/NuiITocR7gt8vCZGNjqM66L1YGdi4wWhLSN0bSlFUK1JR4re3o0cXyIOo
	 zKWDY3lWMiQ2BolsLxIj+NErTqmVCV8WwrabHCJQ=
Date: Mon, 21 Jul 2025 15:46:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch added to mm-unstable branch
Message-Id: <20250721224649.0C544C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add mremap() shrink test for multiple VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch

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
Subject: tools/testing/selftests: add mremap() shrink test for multiple VMAs
Date: Mon, 21 Jul 2025 18:33:25 +0100

Patch series "tools/testing: expand mremap testing".

Expand our mremap() testing to further assert that behaviour is as
expected.

There is a poorly documented mremap() feature whereby it is possible to
mremap() multiple VMAs (even with gaps) when shrinking, as long as the
resultant shrunk range spans only a single VMA.

So we start by asserting this behaviour functions correctly both with an
in-place shrink and a shrink/move.

Next, we further test the newly introduced ability to mremap() multiple
VMAs when performing a MAP_FIXED move (that is without the size being
changed), firstly by asserting that MREMAP_DONTUNMAP has no bearing on
this behaviour.

Finally, we explicitly test that such moves, when splitting source VMAs,
function correctly.


This patch (of 3):

There is an apparently little-known feature of mremap() whereby, in stark
contrast to other modes (other than the recently introduced capacity to
move multiple VMAs), the input source range span multiple VMAs with gaps
between.

This is, when shrinking a VMA, whether moving it or not, and the shrink
would reduce the range to a single VMA - this is permitted, as the shrink
is actioned by an unmap.

This patch adds tests to assert that this behaves as expected.

Link: https://lkml.kernel.org/r/cover.1753119043.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/f08122893a26092a2bec6e69443e87f468ffdbed.1753119043.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   83 ++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -523,6 +523,85 @@ out:
 		ksft_test_result_fail("%s\n", test_name);
 }
 
+static void mremap_shrink_multiple_vmas(unsigned long page_size,
+					bool inplace)
+{
+	char *test_name = "mremap shrink multiple vmas";
+	const size_t size = 10 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	void *res;
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
+	tgt_ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+	if (munmap(tgt_ptr, size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap so we end up with:
+	 *
+	 *  0   2   4   6   8   10 offset in buffer
+	 * |*| |*| |*| |*| |*| |*|
+	 * |*| |*| |*| |*| |*| |*|
+	 */
+	for (i = 1; i < 10; i += 2) {
+		if (munmap(&ptr[i * page_size], page_size)) {
+			perror("munmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	/*
+	 * Shrink in-place across multiple VMAs and gaps so we end up with:
+	 *
+	 *  0
+	 * |*|
+	 * |*|
+	 */
+	if (inplace)
+		res = mremap(ptr, size, page_size, 0);
+	else
+		res = mremap(ptr, size, page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
+			     tgt_ptr);
+
+	if (res == MAP_FAILED) {
+		perror("mremap");
+		success = false;
+		goto out_unmap;
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out:
+	if (success)
+		ksft_test_result_pass("%s%s\n", test_name,
+				      inplace ? " [inplace]" : "");
+	else
+		ksft_test_result_fail("%s%s\n", test_name,
+				      inplace ? " [inplace]" : "");
+}
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -864,7 +943,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 3;
+	int num_misc_tests = 5;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -992,6 +1071,8 @@ int main(int argc, char **argv)
 	mremap_move_within_range(pattern_seed, rand_addr);
 	mremap_move_1mb_from_start(pattern_seed, rand_addr);
 	mremap_move_multiple_vmas(pattern_seed, page_size);
+	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
+	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
 
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

