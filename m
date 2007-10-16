From: akpm@linux-foundation.org
Subject: - fix-the-max-path-calculation-in-radix-treec.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:42 -0700
Message-ID: <200710162031.l9GKVgV8014524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764982AbXJPVqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     fix the max path calculation in radix-tree.c
has been removed from the -mm tree.  Its filename was
     fix-the-max-path-calculation-in-radix-treec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix the max path calculation in radix-tree.c
From: Jeff Moyer <jmoyer@redhat.com>

A while back, Nick Piggin introduced a patch to reduce the node memory
usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):

-#define RADIX_TREE_MAP_SHIFT	6
+#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)

Unfortunately, he didn't take into account the fact that the
calculation of the maximum path was based on an assumption of having
to round up:

#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)

So, if CONFIG_BASE_SMALL is set, you will end up with a
RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
upshot of this is just a bit of wasted memory (one long in the
height_to_maxindex array, an extra pre-allocated radix tree node per
cpu, and extra stack usage in a couple of functions), but it seems
worth getting right.

It's also worth noting that I never build with CONFIG_BASE_SMALL.
What I did to test this was duplicate the code in a small user-space
program and check the results of the calculations for max path and the
contents of the height_to_maxindex array.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec lib/radix-tree.c
--- a/lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec
+++ a/lib/radix-tree.c
@@ -60,9 +60,14 @@ struct radix_tree_path {
 };
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
+#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
+					  RADIX_TREE_MAP_SHIFT))
 
-static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
+/*
+ * The height_to_maxindex array needs to be one deeper than the maximum
+ * path as height 0 holds only 1 entry.
+ */
+static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH + 1] __read_mostly;
 
 /*
  * Radix tree node cache.
@@ -492,7 +497,11 @@ EXPORT_SYMBOL(radix_tree_tag_set);
 void *radix_tree_tag_clear(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
+	/*
+	 * The radix tree path needs to be one longer than the maximum path
+	 * since the "list" is null terminated.
+	 */
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
 	struct radix_tree_node *slot = NULL;
 	unsigned int height, shift;
 
@@ -934,7 +943,11 @@ static inline void radix_tree_shrink(str
  */
 void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 {
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
+	/*
+	 * The radix tree path needs to be one longer than the maximum path
+	 * since the "list" is null terminated.
+	 */
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
 	struct radix_tree_node *slot = NULL;
 	struct radix_tree_node *to_free;
 	unsigned int height, shift;
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
aio-account-i-o-wait-time-properly.patch
