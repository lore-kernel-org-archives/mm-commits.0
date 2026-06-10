Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE261A6829
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2026 01:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781054058; cv=none; b=Ua/9o2JWuMnWQ3s9e9HBiLv5MZBb3l2O+LyBnXMqZEIMHBA4RSQtHdZfCksNXAhDl4Qcx7As0tkSTaOFDETn2HIari9sNVp+GFdK1dy3F/EDjhXtts4iRU0oLMT2lYLhOkngcwRsARxyD/q5A6Omz5ud7zZqsKdRhjQDCf1ykSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781054058; c=relaxed/simple;
	bh=Jr/6QGCnyhqli5pAPUyZAG6fLuaXmhGxROVn9DSBBiQ=;
	h=Date:To:From:Subject:Message-Id; b=s0kEJF1+htTjR2MHzgaVe+FzMzGboqD9a90/9bdtwP/BvCzkPpxcEFdu2Retcdsyn9z2RNNfuh4qpEdH2+JR/LFcuRD95aiRG5Wx0LbXp1J+uOmKY1czHzuIjS2Jp+AFwZmPO0ZhWHrHCHwZG4o6eeSGJqUhwSV+DUrTFm9JnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CK8QcCpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CK8QcCpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CD11F00893;
	Wed, 10 Jun 2026 01:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781054057;
	bh=8Doy1W5GmYNwknn7cq3m74PMcGutUmsgOnz1PN81p2o=;
	h=Date:To:From:Subject;
	b=CK8QcCpCztpi1R9aBKVXGffcs4LDNobwsLb2tHkNyq9ZolhhqxVy7vXbdu8O0nyEd
	 kjvZb1290m9/+7cKJwe5MIx8kEbGlAvJr0MT11YV7B6JX7xJ2QvXZk0f1EZcNSXKbj
	 xJ3cL3KJCnmbZLaOss5sC1bWi0t7c3XHqakGUB2Y=
Date: Tue, 09 Jun 2026 18:14:16 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree_test-validate-benchmark-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20260610011417.24CD11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: interval_tree_test: validate benchmark parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree_test-validate-benchmark-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree_test-validate-benchmark-parameters.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: lib: interval_tree_test: validate benchmark parameters
Date: Tue, 9 Jun 2026 00:54:47 +0000

The interval tree runtime test accepts module parameters that are later
used as divisors while generating randomized intervals and while reporting
average timings.  For example, max_endpoint=1 makes the generated interval
end value zero and the next modulo operation divides by that zero value.

Reject non-positive counts and require max_endpoint to provide at least
one non-zero generated endpoint before the test allocates state or starts
the benchmark.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Link: https://lore.kernel.org/20260609005446.1241288.1525a5964698.interval-tree-test-small-max-endpoint-div0@trailofbits.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/lib/interval_tree_test.c~lib-interval_tree_test-validate-benchmark-parameters
+++ a/lib/interval_tree_test.c
@@ -311,6 +311,27 @@ static inline int span_iteration_check(v
 
 static int interval_tree_test_init(void)
 {
+	if (nnodes <= 0) {
+		pr_warn("nnodes must be positive\n");
+		return -EINVAL;
+	}
+	if (nsearches <= 0) {
+		pr_warn("nsearches must be positive\n");
+		return -EINVAL;
+	}
+	if (perf_loops <= 0) {
+		pr_warn("perf_loops must be positive\n");
+		return -EINVAL;
+	}
+	if (search_loops <= 0) {
+		pr_warn("search_loops must be positive\n");
+		return -EINVAL;
+	}
+	if (max_endpoint < 2) {
+		pr_warn("max_endpoint must be at least 2\n");
+		return -EINVAL;
+	}
+
 	nodes = kmalloc_objs(struct interval_tree_node, nnodes);
 	if (!nodes)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch
lib-test_firmware-allocate-the-configured-into_buf-size.patch
lib-interval_tree_test-validate-benchmark-parameters.patch

