Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA02627E1
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719042; cv=none; b=fBqowba4jB0swl/SglpDGwLEDKpqMtwnSDVx0SufDV/Aohdj7qFJvb0rnyEXp7eZzohcQGxYmnqDFhTF49ydu4tgkrn824hjEHHPQ7puGWIpnrvT+rTBBwZRkjAelYJA9brlrOjehcSfJYJ5v/MrS5DnagFgr8GbpBJZfkKJNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719042; c=relaxed/simple;
	bh=sbhH1eDAMcjFYMUdEHGQy94cEyWRH6asz+mQEVNlbW8=;
	h=Date:To:From:Subject:Message-Id; b=n67bhiujP5bf8w67ZRKS3oiXn8REgF5piGNba/ler9qi7+n0TZJzeWm9QTzCN0+e0vD1n7Xb040wJErXsuA1nT+B+SOOfMBk+oDT3eqE2KdPFmbjmFd7kYVjSsJtAkY4GMG6BW6Ge1MZt5t7idwVZuSeZULP0b/LaX3HkHfFMX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=riSP64YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="riSP64YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527DDC4CEEA;
	Tue, 11 Mar 2025 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741719042;
	bh=sbhH1eDAMcjFYMUdEHGQy94cEyWRH6asz+mQEVNlbW8=;
	h=Date:To:From:Subject:From;
	b=riSP64YA1BSintAaPKW5z7zqq1xa5/oshCmGOqvA1pwRAR+wFbyLU3ot/FlwgvftQ
	 17OdVvXWX4bVk3NGqqz60w7QGvdWAZfDocwaophtiy5bzyXG27D29M91PfEGakgBuO
	 Mho5LBVOqp6HvnrSwCD2lfvwatHl9fv4RE87lBXk=
Date: Tue, 11 Mar 2025 11:50:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtree-add-random-seed.patch added to mm-nonmm-unstable branch
Message-Id: <20250311185042.527DDC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rbtree: add random seed
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rbtree-add-random-seed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rbtree-add-random-seed.patch

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

