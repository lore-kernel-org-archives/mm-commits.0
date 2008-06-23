From: akpm@linux-foundation.org
Subject: - ext4-improve-some-code-in-rb-tree-part-of-dirc.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:04:08 -0700
Message-ID: <200806232104.m5NL48Xl016249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757979AbYFWVEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext4: improve some code in rb tree part of dir.c
has been removed from the -mm tree.  Its filename was
     ext4-improve-some-code-in-rb-tree-part-of-dirc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: improve some code in rb tree part of dir.c
From: Shen Feng <shen@cn.fujitsu.com>

*remove unnecessary code in free_rb_tree_fname
*rename free_rb_tree_fname to ext4_htree_create_dir_info
 since it and ext4_htree_free_dir_info are a pair
*replace kmalloc with kzalloc in ext4_htree_free_dir_info

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/dir.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/ext4/dir.c~ext4-improve-some-code-in-rb-tree-part-of-dirc fs/ext4/dir.c
--- a/fs/ext4/dir.c~ext4-improve-some-code-in-rb-tree-part-of-dirc
+++ a/fs/ext4/dir.c
@@ -272,7 +272,7 @@ static void free_rb_tree_fname(struct rb
 
 	while (n) {
 		/* Do the node's children first */
-		if ((n)->rb_left) {
+		if (n->rb_left) {
 			n = n->rb_left;
 			continue;
 		}
@@ -301,24 +301,18 @@ static void free_rb_tree_fname(struct rb
 			parent->rb_right = NULL;
 		n = parent;
 	}
-	root->rb_node = NULL;
 }
 
 
-static struct dir_private_info *create_dir_info(loff_t pos)
+static struct dir_private_info *ext4_htree_create_dir_info(loff_t pos)
 {
 	struct dir_private_info *p;
 
-	p = kmalloc(sizeof(struct dir_private_info), GFP_KERNEL);
+	p = kzalloc(sizeof(struct dir_private_info), GFP_KERNEL);
 	if (!p)
 		return NULL;
-	p->root.rb_node = NULL;
-	p->curr_node = NULL;
-	p->extra_fname = NULL;
-	p->last_pos = 0;
 	p->curr_hash = pos2maj_hash(pos);
 	p->curr_minor_hash = pos2min_hash(pos);
-	p->next_hash = 0;
 	return p;
 }
 
@@ -433,7 +427,7 @@ static int ext4_dx_readdir(struct file *
 	int	ret;
 
 	if (!info) {
-		info = create_dir_info(filp->f_pos);
+		info = ext4_htree_create_dir_info(filp->f_pos);
 		if (!info)
 			return -ENOMEM;
 		filp->private_data = info;
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

linux-next.patch
ext2-remove-double-definitions-of-xattr-macros.patch
ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
ext3-remove-double-definitions-of-xattr-macros.patch
reiserfs-remove-double-definitions-of-xattr-macros.patch
ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch
ext4-fix-error-processing-in-mb_free_blocks.patch

