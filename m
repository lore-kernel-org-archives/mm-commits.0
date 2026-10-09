Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B541B8F2
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525571; cv=none; b=uccu9TlsoDCfn+L4+C/gxlnLkAF7V1oXkAFu2HLOZJPx0AyA55gP+N1lIxIIl23izhjgFFDa7aoDFoI/RSCu9JAw82md0zKnUHnorI1H/5+XALVULqvP/IkMC0LiBHGEX2U6AXcEZAVaCaWdMa4aiUjXRuTBWW0+gd32JdoeweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525571; c=relaxed/simple;
	bh=KG0Hslxntyo9Rox4OloHaWEB9o6uwWBkiccz4sdMUfo=;
	h=Date:To:From:Subject:Message-Id; b=QSznbt+6aZOLEPxyS+eL/XRn4+0RivfGWTn/Mu9qVC9NfPqeLuXjQXRG/Vb6dFk8FZITIl67nm1N3jBzzH+q+hCA45Z1Edz8gqLYb2k2lp4ayGaCKHK/ubB81HxF4pMuMvqfNukeeE+yWF5tZUhBcZGRCwq812qkiJGQFrmpD9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OUFnaK7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OUFnaK7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434721F000FF;
	Fri,  9 Oct 2026 05:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525568;
	bh=K4PlJ2d4FH1KkwingaiIBeYLNKLJS0itmS8YOsT3150=;
	h=Date:To:From:Subject;
	b=OUFnaK7xAZ3WhV1+2ULx85Z+6tIC6FfLl5c49Nqh1r1dZOdvRwxKE99dfUJ3qtFIY
	 N0jh1u8bGaXOFaW0THwDSjyFzJoVcV7fQ7a3eKdrOoJCRlBOjh6kzac6ErvBdYQmRq
	 uPhn4WUrMku2b+05x+/qW46Q6oC1zYCWdvZOdKVc=
Date: Thu, 08 Oct 2026 22:59:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sparse@chrisli.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-assert-static-storage-for-define_mtree.patch removed from -mm tree
Message-Id: <20261009055928.434721F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: assert static storage for DEFINE_MTREE()
has been removed from the -mm tree.  Its filename was
     maple_tree-assert-static-storage-for-define_mtree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: maple_tree: assert static storage for DEFINE_MTREE()
Date: Fri, 11 Sep 2026 18:14:43 -0400

DEFINE_MTREE() uses MTREE_INIT(), which initializes the tree's embedded
lock with a static spinlock initializer.  If the tree is an automatic
local object, lockdep rejects its address as a non-static class key and
disables locking validation on the first lock acquisition.

Apply ASSERT_STATIC_STORAGE() to DEFINE_MTREE() to catch automatic local
definitions at compile time.  For example:

  void example(void)
  {
          DEFINE_MTREE(mt);
          mtree_destroy(&mt);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(name)
  note: in expansion of macro 'DEFINE_MTREE'
    DEFINE_MTREE(mt);

File-scope definitions and static local trees remain valid.  Automatic
local trees must instead use mt_init() or mt_init_flags().  Direct uses of
MTREE_INIT() and MTREE_INIT_EXT() are unchanged.

Replace the local DEFINE_MTREE() in the interval-tree span test with a
plain declaration; the test already initializes the tree with
mt_init_flags() before use.  Convert the three local Maple Trees in the
userspace radix-tree tests to mt_init().

Validated file-scope and static local definitions with a kernel object
build, and confirmed that an automatic local definition fails to compile. 
The Maple Tree test and region allocation benchmark objects also build
with lockdep enabled.

Link: https://lore.kernel.org/20260911221444.1523311-4-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 include/linux/maple_tree.h       |    4 +++-
 lib/interval_tree_test.c         |    2 +-
 tools/testing/radix-tree/maple.c |   12 +++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-assert-static-storage-for-define_mtree
+++ a/include/linux/maple_tree.h
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 
@@ -297,7 +298,8 @@ struct maple_tree {
 #endif
 
 #define DEFINE_MTREE(name)						\
-	struct maple_tree name = MTREE_INIT(name, 0)
+	struct maple_tree name = MTREE_INIT(name, 0);		\
+	ASSERT_STATIC_STORAGE(name)
 
 #define mtree_lock(mt)		spin_lock((&(mt)->ma_lock))
 #define mtree_lock_nested(mas, subclass) \
--- a/lib/interval_tree_test.c~maple_tree-assert-static-storage-for-define_mtree
+++ a/lib/interval_tree_test.c
@@ -244,7 +244,7 @@ static int span_iteration_check(void)
 	unsigned long start, last;
 	struct interval_tree_span_iter span, mas_span;
 
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
 
 	MA_STATE(mas, &tree, 0, 0);
 
--- a/tools/testing/radix-tree/maple.c~maple_tree-assert-static-storage-for-define_mtree
+++ a/tools/testing/radix-tree/maple.c
@@ -36022,10 +36022,12 @@ static noinline void __init check_erase_
 
 static noinline void __init check_mtree_dup(struct maple_tree *mt)
 {
-	DEFINE_MTREE(new);
+	struct maple_tree new;
 	int i, j, ret, count = 0;
 	unsigned int rand_seed = 17, rand;
 
+	mt_init(&new);
+
 	/* store a value at [0, 0] */
 	mt_init_flags(mt, 0);
 	mtree_store_range(mt, 0, 0, xa_mk_value(0), GFP_KERNEL);
@@ -36319,7 +36321,9 @@ static inline int check_vma_modification
 void farmer_tests(void)
 {
 	struct maple_node *node;
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
+
+	mt_init(&tree);
 
 	mt_dump(&tree, mt_dump_dec);
 
@@ -36432,9 +36436,11 @@ static unsigned long get_last_index(stru
 static void test_spanning_store_regression(void)
 {
 	unsigned long from = 0, to = 0;
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
 	MA_STATE(mas, &tree, 0, 0);
 
+	mt_init(&tree);
+
 	/*
 	 * Build a 3-level tree. We require a parent node below the root node
 	 * and 2 leaf nodes under it, so we can span the entirety of the right
_

Patches currently in -mm which might be from ynorov@nvidia.com are


