From: akpm@linux-foundation.org
Subject: +
 fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:16:54 -0800
Message-ID: <527c1156.Psj3xFemClJPSNbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3KGWQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tytso@mit.edu, jack@suse.cz, cody@linux.vnet.ibm.com

Subject: + fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch added to -mm tree
To: cody@linux.vnet.ibm.com,jack@suse.cz,tytso@mit.edu,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:54 -0800


The patch titled
     Subject: fs/ext4: use rbtree postorder iteration helper instead of opencoding
has been added to the -mm tree.  Its filename is
     fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: fs/ext4: use rbtree postorder iteration helper instead of opencoding

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/block_validity.c |   33 ++++-----------------------------
 fs/ext4/dir.c            |   33 ++++-----------------------------
 2 files changed, 8 insertions(+), 58 deletions(-)

diff -puN fs/ext4/block_validity.c~fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ext4/block_validity.c
--- a/fs/ext4/block_validity.c~fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ext4/block_validity.c
@@ -180,37 +180,12 @@ int ext4_setup_system_zone(struct super_
 /* Called when the filesystem is unmounted */
 void ext4_release_system_zone(struct super_block *sb)
 {
-	struct rb_node	*n = EXT4_SB(sb)->system_blks.rb_node;
-	struct rb_node	*parent;
-	struct ext4_system_zone	*entry;
+	struct ext4_system_zone	*entry, *n;
 
-	while (n) {
-		/* Do the node's children first */
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		/*
-		 * The node has no children; free it, and then zero
-		 * out parent's link to it.  Finally go to the
-		 * beginning of the loop and try to free the parent
-		 * node.
-		 */
-		parent = rb_parent(n);
-		entry = rb_entry(n, struct ext4_system_zone, node);
+	rbtree_postorder_for_each_entry_safe(entry, n,
+			&EXT4_SB(sb)->system_blks, node)
 		kmem_cache_free(ext4_system_zone_cachep, entry);
-		if (!parent)
-			EXT4_SB(sb)->system_blks = RB_ROOT;
-		else if (parent->rb_left == n)
-			parent->rb_left = NULL;
-		else if (parent->rb_right == n)
-			parent->rb_right = NULL;
-		n = parent;
-	}
+
 	EXT4_SB(sb)->system_blks = RB_ROOT;
 }
 
diff -puN fs/ext4/dir.c~fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ext4/dir.c
--- a/fs/ext4/dir.c~fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ext4/dir.c
@@ -353,41 +353,16 @@ struct fname {
  */
 static void free_rb_tree_fname(struct rb_root *root)
 {
-	struct rb_node	*n = root->rb_node;
-	struct rb_node	*parent;
-	struct fname	*fname;
+	struct fname *fname, *next;
 
-	while (n) {
-		/* Do the node's children first */
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		/*
-		 * The node has no children; free it, and then zero
-		 * out parent's link to it.  Finally go to the
-		 * beginning of the loop and try to free the parent
-		 * node.
-		 */
-		parent = rb_parent(n);
-		fname = rb_entry(n, struct fname, rb_hash);
+	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
 		while (fname) {
 			struct fname *old = fname;
 			fname = fname->next;
 			kfree(old);
 		}
-		if (!parent)
-			*root = RB_ROOT;
-		else if (parent->rb_left == n)
-			parent->rb_left = NULL;
-		else if (parent->rb_right == n)
-			parent->rb_right = NULL;
-		n = parent;
-	}
+
+	*root = RB_ROOT;
 }
 
 
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch
linux-next.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

