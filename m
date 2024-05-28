Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63517966C
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928925; cv=none; b=FTDCsHImlucla5kbb+Qg1Dk3CCsGsXLzZ76d4xGPe/qKYgxOPN7/yJTTWd6OVqyoi154eEpBk7YR4643hbxU2WlT8+6xd9JD0WWdZI27R/66GvbK6pK7OIVwYLYoAdjzFBiNn2KinDf/C14cbpWSdJodngYPyE+Fi3pF3IvaJ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928925; c=relaxed/simple;
	bh=s4OFxTtr5K7Kj0Bx4KuoeOUK0JQimqCPENMmbcMzeBQ=;
	h=Date:To:From:Subject:Message-Id; b=IuNkk0Czv/1c5Ayf0KW9tHRDkptWuENJj4XswJT3Ly3jx4xyEGgUEzbjjzyiGwRWF3Lp9lBbBn7Az5MquFdi+5/nLQKZsQaLwHPcZTCPcMX98N/dida2muY05AaIxOm6/vvfP60dMLge3xFYq+Y6IhF9H46V1yKukmWiSYQHf0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQQzCVbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQQzCVbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9CAC3277B;
	Tue, 28 May 2024 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928925;
	bh=s4OFxTtr5K7Kj0Bx4KuoeOUK0JQimqCPENMmbcMzeBQ=;
	h=Date:To:From:Subject:From;
	b=CQQzCVboqNFTVQhy9bAWdMeg3P8QLVg7KgIJ8F4rqc0FGhcNnm96MCJKY22D/oKzu
	 ZlCuPg4Sa/kasZjrt5HB2GZoU5WNjoL9JlkhJkzhUibgJfpn8uqKTemqw1cOYtqLdR
	 SRZF+tqmcltH0ooIUUVv/HnVrLgdWD/1vnMZx2wE=
Date: Tue, 28 May 2024 13:42:04 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch added to mm-nonmm-unstable branch
Message-Id: <20240528204205.2A9CAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_sort: add a testcase to ensure code coverage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/test_sort: add a testcase to ensure code coverage
Date: Tue, 28 May 2024 04:30:11 +0800

The addition of an if statement in lib/sort to handle the final unsorted 2
or 3 elements is not covered by existing test cases, leading to incomplete
test coverage.  To ensure comprehensive testing and maintain 100% code
coverage, add a new testcase for scenarios where the if statement is
triggered.

Since the if statement is only triggered when the array length is odd and
the first element is greater than the second element, a testcase is
created using an array length of TEST_LEN - 1 and a suitable random seed
to maintain full code coverage.

Link: https://lkml.kernel.org/r/20240527203011.1644280-5-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sort.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/lib/test_sort.c~lib-test_sort-add-a-testcase-to-ensure-code-coverage
+++ a/lib/test_sort.c
@@ -29,7 +29,19 @@ static void test_sort(struct kunit *test
 
 	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
 
-	for (i = 0; i < TEST_LEN-1; i++)
+	for (i = 0; i < TEST_LEN - 1; i++)
+		KUNIT_ASSERT_LE(test, a[i], a[i + 1]);
+
+	r = 48;
+
+	for (i = 0; i < TEST_LEN - 1; i++) {
+		r = (r * 725861) % 6599;
+		a[i] = r;
+	}
+
+	sort(a, TEST_LEN - 1, sizeof(*a), cmpint, NULL);
+
+	for (i = 0; i < TEST_LEN - 2; i++)
 		KUNIT_ASSERT_LE(test, a[i], a[i + 1]);
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

