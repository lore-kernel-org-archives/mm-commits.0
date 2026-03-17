Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4D229D26C
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767532; cv=none; b=muScCnJBrHURp4ChjsezjpXyoVaKkS7AYwfjIm+S5zgNL3Kz3ZBMDfza+KX9Xnfj1+oxlYqJC1OKnSm9XotMUoFgV5b5qYOmaIoWVylB/0YNhQHHKKu3bmLvygSgpA4xChULJ/ddRypOt6ZpYVf2NibD9shMkcNc7Q4pcL1YNIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767532; c=relaxed/simple;
	bh=//9gXbLitBqlyqEEub8r+gSApE309ShBirIQjiYMRf0=;
	h=Date:To:From:Subject:Message-Id; b=sfqzHxRP0m0i0y2CkWiVhrUnRKoz+7jtXydwm35fVJmQ+cwH3nSSveh0QmBtICM/30VA6YZgoveDBBxdcmW+S58ENqpgl48X8APLpC386pSU/Dtjh8QR55VfOMYUr9lOTWbP2hdG+2UM91vbKYAQmT7uJplctqKwKCnT+c5JNnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHjYtsuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHjYtsuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E29C4CEF7;
	Tue, 17 Mar 2026 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773767532;
	bh=//9gXbLitBqlyqEEub8r+gSApE309ShBirIQjiYMRf0=;
	h=Date:To:From:Subject:From;
	b=eHjYtsuK8jCGQRek8l/IHwHBJFCiESf5LHyMsUz2DjR3t2ytjDo1C8KP4R/EupME3
	 jBCEQliaUBdFO9vrhW27pNsS++YdTM0ZKLqv1Hvvc5IPLIajRt5WnOK3Oc85q74Ax1
	 XcZ9BH69mdxoh3Q0BNCYHYdQlCaoxDwTJ48o1R4o=
Date: Tue, 17 Mar 2026 10:12:11 -0700
To: mm-commits@vger.kernel.org,mathieu.desnoyers@efficios.com,broonie@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons-fix.patch added to mm-unstable branch
Message-Id: <20260317171211.F0E29C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: skip percpu_counter_tree boundary kunit tests on single-CPU
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Carlier <devnexen@gmail.com>
Subject: lib: skip percpu_counter_tree boundary kunit tests on single-CPU
Date: Tue, 17 Mar 2026 15:39:15 +0000

On single-CPU topologies, accuracy_multiplier is zero, making both
approx_accuracy_range.under and .over zero.  The boundary tests in
hpcc_test_compare_value_boundaries and
hpcc_test_compare_counter_boundaries then degenerate to comparing 0 vs 0,
which correctly returns 0 (equal) but the tests expect nonzero results.

Skip these boundary tests with kunit_skip() when accuracy is zero, since
approximation boundaries are meaningless without multi-CPU carry
propagation.  Use percpu_counter_tree_items_size() as the topology check
before any allocations to avoid leaking memory on skip.

Link: https://lkml.kernel.org/r/20260317153915.43559-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/percpu_counter_tree_kunit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/tests/percpu_counter_tree_kunit.c~lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons-fix
+++ a/lib/tests/percpu_counter_tree_kunit.c
@@ -93,6 +93,9 @@ static void hpcc_test_compare_value_boun
 	unsigned long under = 0, over = 0;
 	int ret;
 
+	if (!percpu_counter_tree_items_size())
+		kunit_skip(test, "no approximation accuracy on single-CPU topology");
+
 	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
 	KUNIT_ASSERT_PTR_NE(test, counter_items, NULL);
 	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
@@ -197,6 +200,9 @@ static void hpcc_test_compare_counter_bo
 	unsigned long combined;
 	int ret;
 
+	if (!percpu_counter_tree_items_size())
+		kunit_skip(test, "no approximation accuracy on single-CPU topology");
+
 	counter_items = kzalloc(percpu_counter_tree_items_size() * 2,
 				GFP_KERNEL);
 	KUNIT_ASSERT_PTR_NE(test, counter_items, NULL);
_

Patches currently in -mm which might be from devnexen@gmail.com are

lib-introduce-hierarchical-per-cpu-counters-fix.patch
lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons.patch
lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons-fix.patch

