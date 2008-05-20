From: akpm@linux-foundation.org
Subject: + ext3-improve-some-code-in-rb-tree-part-of-dirc.patch added to -mm tree
Date: Tue, 20 May 2008 02:15:13 -0700
Message-ID: <200805200915.m4K9FDs0015090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759702AbYETJPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com


The patch titled
     ext3: improve some code in rb tree part of dir.c
has been added to the -mm tree.  Its filename is
     ext3-improve-some-code-in-rb-tree-part-of-dirc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: improve some code in rb tree part of dir.c
From: Shen Feng <shen@cn.fujitsu.com>

*remove unnecessary code in free_rb_tree_fname
*rename free_rb_tree_fname to ext3_htree_create_dir_info
 since it and ext3_htree_free_dir_info are a pair
*replace kmalloc with kzalloc in ext3_htree_free_dir_info

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN fs/ext3/dir.c~ext3-improve-some-code-in-rb-tree-part-of-dirc fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-improve-some-code-in-rb-tree-part-of-dirc
+++ a/fs/ext3/dir.c
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
+static struct dir_private_info *ext3_htree_create_dir_info(loff_t pos)
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
 
@@ -433,7 +427,7 @@ static int ext3_dx_readdir(struct file *
 	int	ret;
 
 	if (!info) {
-		info = create_dir_info(filp->f_pos);
+		info = ext3_htree_create_dir_info(filp->f_pos);
 		if (!info)
 			return -ENOMEM;
 		filp->private_data = info;
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch
ext4-improve-some-code-in-rb-tree-part-of-dirc.patch

