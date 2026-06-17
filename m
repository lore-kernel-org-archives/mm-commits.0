Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31C639E185
	for <mm-commits@vger.kernel.org>; Wed, 17 Jun 2026 22:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735911; cv=none; b=f3jjDV5xzQBQe3sIs7SG9uUIDXOJbp2PlsrfO3/xulnVTYYUTEpeOeF24tY8nvO/HUzNhKyAow9LRojqcWag3bcoYh8O09Uf/2nMZEs3DrHRTFAP8T5xAoU7T8wBz5V5JPbZ0h20RBa82t6b5sbdMvYPXWwu1KjQrohv7Kn21BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735911; c=relaxed/simple;
	bh=ZI/QVxYX5+1ZhwyMNn5R0Wn7f1L2qH7fJ/Ws7e3L6Mk=;
	h=Date:To:From:Subject:Message-Id; b=m2WmVMSUgTb5rgDnDkwnZyPLGQkmyenSFtU1il4eDbVdudfHkxnwlq5KpEMTRzj3i+OK6Z3gX2K2cLURelqs/T04PxUfEJMlhd16Q0lW9NaFGNU8uzQjDgjxBV66OPEeabszlq3AQt60ZH0sLcxRy8T8I0MBKSACCCsI9Gk72Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ZOu2Zfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ZOu2Zfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BEB1F00A3A;
	Wed, 17 Jun 2026 22:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735909;
	bh=W/DA009J7jCQatz3pQ46lmBc0JPnga2QxgshvgDyTBE=;
	h=Date:To:From:Subject;
	b=2ZOu2ZfdeSp5ImnoDdP+QihFXH0iqtgMkr/7SebFNnXGBXrcq/nC3bs5fUNXSZKIy
	 wYYaGdUTYUFj5D8bKQvtLZGdPCAWuOmYrAPhQahOfS1y7ySnv08C4rpVBNs8WVpLHN
	 n8xiDL1aKxBzmcoyzCPB7bjeP2GcJtWwCt558S5M=
Date: Wed, 17 Jun 2026 15:38:29 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree_test-validate-benchmark-parameters.patch removed from -mm tree
Message-Id: <20260617223829.A4BEB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: interval_tree_test: validate benchmark parameters
has been removed from the -mm tree.  Its filename was
     lib-interval_tree_test-validate-benchmark-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: include printk.h for pr_warn()]
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Link: https://lore.kernel.org/20260609005446.1241288.1525a5964698.interval-tree-test-small-max-endpoint-div0@trailofbits.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/lib/interval_tree_test.c~lib-interval_tree_test-validate-benchmark-parameters
+++ a/lib/interval_tree_test.c
@@ -4,6 +4,7 @@
 #include <linux/interval_tree.h>
 #include <linux/prandom.h>
 #include <linux/slab.h>
+#include <linux/printk.h>
 #include <asm/timex.h>
 #include <linux/bitmap.h>
 #include <linux/maple_tree.h>
@@ -311,6 +312,27 @@ static inline int span_iteration_check(v
 
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
mm-gup_test-reject-wrapped-user-ranges.patch

