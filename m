Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA4179BC
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719042; cv=none; b=Mh4XC0f50sIqCJ/Dd04P6FBp5bAfxF0Jo1+q4CSU3Hi1ai0+Y6MtjowT+hn8oZI/MYBGvp1uGeF1PX4/p4cc4M9h40gKF4xkKUHiuSi/v6LX69kJcj8DfyErKBZypyfGepU9g3fXSCskQ5R/NUlqbn2vovyIEenIvlZgi0626lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719042; c=relaxed/simple;
	bh=Aa47ScPCwrQgCWNSfxSTpz51pzlahh13fj2FO11t0iA=;
	h=Date:To:From:Subject:Message-Id; b=dxkmzlTTMnTXj1xl3gm53hTEXqamtmx7DXqHw3h3UwTsw5CuNckoPJfpUL+1WnMHAhUvfaK3GhWapp10Fy0sN3GL1xeYEHUe2DUVm0mulkEWs1JrOP6XP2JkMQDsiTVfEmoNdSby5vpCbo6Yp3ziglXILja1pZK8ScK/Tbcoq/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdcOPIrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdcOPIrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF51DC4CEE9;
	Tue, 11 Mar 2025 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741719039;
	bh=Aa47ScPCwrQgCWNSfxSTpz51pzlahh13fj2FO11t0iA=;
	h=Date:To:From:Subject:From;
	b=NdcOPIrpnV/vOj7uD0fr0QvJ+xsUZU0nbNGBmDDTacEpPQpcMNREKan/IG+sDEequ
	 +jelvqb4q+H5qbEnV8F8TmNdtSJ3hrY4ITawN1dvkYBoDXz/b0mOjh80nKWNjuT3MG
	 b0l7XIvLICg0CP720bJa8XxaFBPWO94m59ahgHEQ=
Date: Tue, 11 Mar 2025 11:50:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtree-split-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20250311185039.CF51DC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rbtree: split tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rbtree-split-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rbtree-split-tests.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/rbtree: split tests
Date: Mon, 10 Mar 2025 07:49:33 +0000

Current tests are gathered in one big function.

Split tests into its own function for better understanding and also it
is a preparation for introducing new test cases.

Link: https://lkml.kernel.org/r/20250310074938.26756-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |   50 ++++++++++++++++++++++++++-----------
 lib/rbtree_test.c        |   29 +++++++++++++++++----
 2 files changed, 59 insertions(+), 20 deletions(-)

--- a/lib/interval_tree_test.c~lib-rbtree-split-tests
+++ a/lib/interval_tree_test.c
@@ -59,26 +59,13 @@ static void init(void)
 		queries[i] = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
 }
 
-static int interval_tree_test_init(void)
+static int basic_check(void)
 {
 	int i, j;
-	unsigned long results;
 	cycles_t time1, time2, time;
 
-	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
-			      GFP_KERNEL);
-	if (!nodes)
-		return -ENOMEM;
-
-	queries = kmalloc_array(nsearches, sizeof(int), GFP_KERNEL);
-	if (!queries) {
-		kfree(nodes);
-		return -ENOMEM;
-	}
-
 	printk(KERN_ALERT "interval tree insert/remove");
 
-	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
@@ -96,8 +83,19 @@ static int interval_tree_test_init(void)
 	time = div_u64(time, perf_loops);
 	printk(" -> %llu cycles\n", (unsigned long long)time);
 
+	return 0;
+}
+
+static int search_check(void)
+{
+	int i, j;
+	unsigned long results;
+	cycles_t time1, time2, time;
+
 	printk(KERN_ALERT "interval tree search");
 
+	init();
+
 	for (j = 0; j < nnodes; j++)
 		interval_tree_insert(nodes + j, &root);
 
@@ -120,6 +118,30 @@ static int interval_tree_test_init(void)
 	printk(" -> %llu cycles (%lu results)\n",
 	       (unsigned long long)time, results);
 
+	for (j = 0; j < nnodes; j++)
+		interval_tree_remove(nodes + j, &root);
+
+	return 0;
+}
+
+static int interval_tree_test_init(void)
+{
+	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
+			      GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
+
+	queries = kmalloc_array(nsearches, sizeof(int), GFP_KERNEL);
+	if (!queries) {
+		kfree(nodes);
+		return -ENOMEM;
+	}
+
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
+
+	basic_check();
+	search_check();
+
 	kfree(queries);
 	kfree(nodes);
 
--- a/lib/rbtree_test.c~lib-rbtree-split-tests
+++ a/lib/rbtree_test.c
@@ -239,19 +239,14 @@ static void check_augmented(int nr_nodes
 	}
 }
 
-static int __init rbtree_test_init(void)
+static int basic_check(void)
 {
 	int i, j;
 	cycles_t time1, time2, time;
 	struct rb_node *node;
 
-	nodes = kmalloc_array(nnodes, sizeof(*nodes), GFP_KERNEL);
-	if (!nodes)
-		return -ENOMEM;
-
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
@@ -343,6 +338,14 @@ static int __init rbtree_test_init(void)
 		check(0);
 	}
 
+	return 0;
+}
+
+static int augmented_check(void)
+{
+	int i, j;
+	cycles_t time1, time2, time;
+
 	printk(KERN_ALERT "augmented rbtree testing");
 
 	init();
@@ -390,6 +393,20 @@ static int __init rbtree_test_init(void)
 		check_augmented(0);
 	}
 
+	return 0;
+}
+
+static int __init rbtree_test_init(void)
+{
+	nodes = kmalloc_array(nnodes, sizeof(*nodes), GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
+
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
+
+	basic_check();
+	augmented_check();
+
 	kfree(nodes);
 
 	return -EAGAIN; /* Fail will directly unload the module */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-round_up-to-align-movable-range.patch
mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch
mm-mm_initc-use-round_up-to-calculate-usermap-size.patch
lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

