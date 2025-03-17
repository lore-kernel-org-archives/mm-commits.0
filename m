Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6442192F1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189576; cv=none; b=FQhBgjRa6LJJ79Es/aakPcYXLNwdnARtFXAjYbbPU3iFZvrXQmjJ8hh+fIg9PoI9iWxeOlArsWaqXuHItkRl6aZ6mnFwU0EOm4Y91eEcClNip5qM7kNQRWwuJtGgaFxg4wClIYiKGWQCNqVULT8GX8s7cSyXkHSJhHT7/G8KW40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189576; c=relaxed/simple;
	bh=y7+mCsFVbybsHT4+zCbovQvqhSCjkL5pZqXD2d3gSGM=;
	h=Date:To:From:Subject:Message-Id; b=A26Z04CBL2BXwV3OggWSPqQkks3N14DXia58kb1y1WQLVJCpxpi/bn4YZki4W56UIDKU4Ei7SSTgKj/ThIwat0FAtDlc4Tuutdn/PG7lO/IpW49F+DW7vPxzathM0XXOuVArxXv/WTLdFw+3HYO1aT/rE6ihsETbAd+LlbTKg0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kLd3DSqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kLd3DSqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9370EC4CEEC;
	Mon, 17 Mar 2025 05:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189576;
	bh=y7+mCsFVbybsHT4+zCbovQvqhSCjkL5pZqXD2d3gSGM=;
	h=Date:To:From:Subject:From;
	b=kLd3DSqnW0/oCpqqqlhbdHTZ41lNJkVNTsoge6sMb0BnECqdM3mlaw5rBbfQfHO5z
	 IzTPAd8TYgo5H3oAbFGErgyGthFa0wvMILH+6wZmCKM6hYeRnZOZ1hD3pvN4VZpGlG
	 cPxp6hs8An/yuLZh/eMMAuo6W9x32R2rirvvHf7Q=
Date: Sun, 16 Mar 2025 22:32:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rbtree-split-tests.patch removed from -mm tree
Message-Id: <20250317053256.9370EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rbtree: split tests
has been removed from the -mm tree.  Its filename was
     lib-rbtree-split-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


