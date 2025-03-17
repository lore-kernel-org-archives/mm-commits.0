Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354202192F1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189578; cv=none; b=O8CwTNSoGZv8e95aVJgpbH+dqeDnwMAvNId62LtUy1Oe9rYob1yaKt6VgjFmn53ZCbjQMZRav2Ues1SpKZBKJHkL1Ywwavw9gIzPcrtFRCN0y7+pvEaszCVEcGLuYqKKFBr1dh3ApLMCDdzJtBDIgqqCJXJ4FASCCR1agecKiVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189578; c=relaxed/simple;
	bh=fQsZbihwPGLeSLJMBvf/jT59ntFOM+Hzqd4H4ue4lK0=;
	h=Date:To:From:Subject:Message-Id; b=FUEVe7ogbNlfNj2GOj3PxnxWF2eh6boRCmE0Y0RQBhjYf0EmDaxK0IgqSxqLdaDc5vPkzzZHHp/Sa2xRdcyIiRcdsqo+aq3+e6o8FMpRvh51X6syRp1+yuuXdYEbEVPELYMiidB/0o/juIxQufIigoQtT4eFgerGcmxS6i3qH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ccrXizs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ccrXizs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6574C4CEEC;
	Mon, 17 Mar 2025 05:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189577;
	bh=fQsZbihwPGLeSLJMBvf/jT59ntFOM+Hzqd4H4ue4lK0=;
	h=Date:To:From:Subject:From;
	b=ccrXizs9Rb1qh5pBN2davrky4sDLN2tAB5CLAmqpFW/CmFoPCGvi82o7WP0XY+Hzs
	 w3qZqYc7XkGUMPwW7TxmZqPF71FwpJ7JYernQwePBlq0MOhHM5nmCqayQQ36j9hBx6
	 ofWU8w19sR7MB3H7Q1DiOAy13ScmwzpOCyF+vu7U=
Date: Sun, 16 Mar 2025 22:32:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rbtree-add-random-seed.patch removed from -mm tree
Message-Id: <20250317053257.A6574C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rbtree: add random seed
has been removed from the -mm tree.  Its filename was
     lib-rbtree-add-random-seed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/rbtree: add random seed
Date: Mon, 10 Mar 2025 07:49:34 +0000

Current test use pseudo rand function with fixed seed, which means the
test data is the same pattern each time.

Add random seed parameter to randomize the test.

Link: https://lkml.kernel.org/r/20250310074938.26756-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h                     |    1 +
 lib/interval_tree_test.c                  |    3 ++-
 lib/rbtree_test.c                         |    3 ++-
 tools/include/linux/types.h               |    2 ++
 tools/testing/rbtree/interval_tree_test.c |    5 ++++-
 tools/testing/rbtree/rbtree_test.c        |    5 ++++-
 6 files changed, 15 insertions(+), 4 deletions(-)

--- a/include/linux/types.h~lib-rbtree-add-random-seed
+++ a/include/linux/types.h
@@ -92,6 +92,7 @@ typedef unsigned char		unchar;
 typedef unsigned short		ushort;
 typedef unsigned int		uint;
 typedef unsigned long		ulong;
+typedef unsigned long long	ullong;
 
 #ifndef __BIT_TYPES_DEFINED__
 #define __BIT_TYPES_DEFINED__
--- a/lib/interval_tree_test.c~lib-rbtree-add-random-seed
+++ a/lib/interval_tree_test.c
@@ -19,6 +19,7 @@ __param(int, search_loops, 1000, "Number
 __param(bool, search_all, false, "Searches will iterate all nodes in the tree");
 
 __param(uint, max_endpoint, ~0, "Largest value for the interval's endpoint");
+__param(ullong, seed, 3141592653589793238ULL, "Random seed");
 
 static struct rb_root_cached root = RB_ROOT_CACHED;
 static struct interval_tree_node *nodes = NULL;
@@ -137,7 +138,7 @@ static int interval_tree_test_init(void)
 		return -ENOMEM;
 	}
 
-	prandom_seed_state(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, seed);
 
 	basic_check();
 	search_check();
--- a/lib/rbtree_test.c~lib-rbtree-add-random-seed
+++ a/lib/rbtree_test.c
@@ -14,6 +14,7 @@
 __param(int, nnodes, 100, "Number of nodes in the rb-tree");
 __param(int, perf_loops, 1000, "Number of iterations modifying the rb-tree");
 __param(int, check_loops, 100, "Number of iterations modifying and verifying the rb-tree");
+__param(ullong, seed, 3141592653589793238ULL, "Random seed");
 
 struct test_node {
 	u32 key;
@@ -402,7 +403,7 @@ static int __init rbtree_test_init(void)
 	if (!nodes)
 		return -ENOMEM;
 
-	prandom_seed_state(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, seed);
 
 	basic_check();
 	augmented_check();
--- a/tools/include/linux/types.h~lib-rbtree-add-random-seed
+++ a/tools/include/linux/types.h
@@ -42,6 +42,8 @@ typedef __s16 s16;
 typedef __u8  u8;
 typedef __s8  s8;
 
+typedef unsigned long long	ullong;
+
 #ifdef __CHECKER__
 #define __bitwise	__attribute__((bitwise))
 #else
--- a/tools/testing/rbtree/interval_tree_test.c~lib-rbtree-add-random-seed
+++ a/tools/testing/rbtree/interval_tree_test.c
@@ -18,6 +18,7 @@ int usage(void)
 	fprintf(stderr, "  -s: Number of iterations searching the tree\n");
 	fprintf(stderr, "  -a: Searches will iterate all nodes in the tree\n");
 	fprintf(stderr, "  -m: Largest value for the interval's endpoint\n");
+	fprintf(stderr, "  -r: Random seed\n");
 	exit(-1);
 }
 
@@ -31,7 +32,7 @@ int main(int argc, char **argv)
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "n:p:q:s:am:")) != -1) {
+	while ((opt = getopt(argc, argv, "n:p:q:s:am:r:")) != -1) {
 		if (opt == 'n')
 			nnodes = strtoul(optarg, NULL, 0);
 		else if (opt == 'p')
@@ -44,6 +45,8 @@ int main(int argc, char **argv)
 			search_all = true;
 		else if (opt == 'm')
 			max_endpoint = strtoul(optarg, NULL, 0);
+		else if (opt == 'r')
+			seed = strtoul(optarg, NULL, 0);
 		else
 			usage();
 	}
--- a/tools/testing/rbtree/rbtree_test.c~lib-rbtree-add-random-seed
+++ a/tools/testing/rbtree/rbtree_test.c
@@ -16,6 +16,7 @@ int usage(void)
 	fprintf(stderr, "  -n: Number of nodes in the rb-tree\n");
 	fprintf(stderr, "  -p: Number of iterations modifying the rb-tree\n");
 	fprintf(stderr, "  -c: Number of iterations modifying and verifying the rb-tree\n");
+	fprintf(stderr, "  -r: Random seed\n");
 	exit(-1);
 }
 
@@ -29,13 +30,15 @@ int main(int argc, char **argv)
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "n:p:c:")) != -1) {
+	while ((opt = getopt(argc, argv, "n:p:c:r:")) != -1) {
 		if (opt == 'n')
 			nnodes = strtoul(optarg, NULL, 0);
 		else if (opt == 'p')
 			perf_loops = strtoul(optarg, NULL, 0);
 		else if (opt == 'c')
 			check_loops = strtoul(optarg, NULL, 0);
+		else if (opt == 'r')
+			seed = strtoul(optarg, NULL, 0);
 		else
 			usage();
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


