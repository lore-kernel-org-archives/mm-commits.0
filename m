From: akpm@linux-foundation.org
Subject: + fix-the-max-path-calculation-in-radix-treec-update.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:34:38 -0700
Message-ID: <200708311934.l7VJYcEL023180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbXHaTfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, npiggin@suse.de


The patch titled
     fix-the-max-path-calculation-in-radix-treec update
has been added to the -mm tree.  Its filename is
     fix-the-max-path-calculation-in-radix-treec-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-the-max-path-calculation-in-radix-treec update
From: Jeff Moyer <jmoyer@redhat.com>

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff -puN lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec-update lib/radix-tree.c
--- a/lib/radix-tree.c~fix-the-max-path-calculation-in-radix-treec-update
+++ a/lib/radix-tree.c
@@ -61,9 +61,13 @@ struct radix_tree_path {
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
 #define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
-					  RADIX_TREE_MAP_SHIFT) + 1)
+					  RADIX_TREE_MAP_SHIFT))
 
-static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
+/*
+ * The height_to_maxindex array needs to be one deeper than the maximum
+ * path as height 0 holds only 1 entry.
+ */
+static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH + 1] __read_mostly;
 
 /*
  * Radix tree node cache.
@@ -493,7 +497,11 @@ EXPORT_SYMBOL(radix_tree_tag_set);
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
 
@@ -935,7 +943,11 @@ static inline void radix_tree_shrink(str
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

fix-the-max-path-calculation-in-radix-treec.patch
fix-the-max-path-calculation-in-radix-treec-update.patch
aio-account-i-o-wait-time-properly.patch
