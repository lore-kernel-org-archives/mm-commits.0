From: akpm@linux-foundation.org
Subject: +
 fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:16:53 -0800
Message-ID: <527c1155.ngilKWzUOYWO7FZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3KGWQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, dedekind1@gmail.com, adrian.hunter@intel.com, cody@linux.vnet.ibm.com

Subject: + fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch added to -mm tree
To: cody@linux.vnet.ibm.com,adrian.hunter@intel.com,dedekind1@gmail.com,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:53 -0800


The patch titled
     Subject: fs/ubifs: use rbtree postorder iteration helper instead of opencoding
has been added to the -mm tree.  Its filename is
     fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

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
Subject: fs/ubifs: use rbtree postorder iteration helper instead of opencoding

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/debug.c    |   22 +++-------------------
 fs/ubifs/log.c      |   21 ++-------------------
 fs/ubifs/orphan.c   |   21 ++-------------------
 fs/ubifs/recovery.c |   21 +++------------------
 fs/ubifs/super.c    |   22 +++-------------------
 fs/ubifs/tnc.c      |   22 +++-------------------
 6 files changed, 16 insertions(+), 113 deletions(-)

diff -puN fs/ubifs/debug.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/debug.c
--- a/fs/ubifs/debug.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/debug.c
@@ -2118,26 +2118,10 @@ out_free:
  */
 static void free_inodes(struct fsck_data *fsckd)
 {
-	struct rb_node *this = fsckd->inodes.rb_node;
-	struct fsck_inode *fscki;
+	struct fsck_inode *fscki, *n;
 
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			fscki = rb_entry(this, struct fsck_inode, rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &fscki->rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-			kfree(fscki);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(fscki, n, &fsckd->inodes, rb)
+		kfree(fscki);
 }
 
 /**
diff -puN fs/ubifs/log.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/log.c
--- a/fs/ubifs/log.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/log.c
@@ -574,27 +574,10 @@ static int done_already(struct rb_root *
  */
 static void destroy_done_tree(struct rb_root *done_tree)
 {
-	struct rb_node *this = done_tree->rb_node;
-	struct done_ref *dr;
+	struct done_ref *dr, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		dr = rb_entry(this, struct done_ref, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &dr->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(dr, n, done_tree, rb)
 		kfree(dr);
-	}
 }
 
 /**
diff -puN fs/ubifs/orphan.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/orphan.c
--- a/fs/ubifs/orphan.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/orphan.c
@@ -815,27 +815,10 @@ static int dbg_find_check_orphan(struct
 
 static void dbg_free_check_tree(struct rb_root *root)
 {
-	struct rb_node *this = root->rb_node;
-	struct check_orphan *o;
+	struct check_orphan *o, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		o = rb_entry(this, struct check_orphan, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &o->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(o, n, root, rb)
 		kfree(o);
-	}
 }
 
 static int dbg_orphan_check(struct ubifs_info *c, struct ubifs_zbranch *zbr,
diff -puN fs/ubifs/recovery.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/recovery.c
--- a/fs/ubifs/recovery.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/recovery.c
@@ -1335,29 +1335,14 @@ static void remove_ino(struct ubifs_info
  */
 void ubifs_destroy_size_tree(struct ubifs_info *c)
 {
-	struct rb_node *this = c->size_tree.rb_node;
-	struct size_entry *e;
+	struct size_entry *e, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		e = rb_entry(this, struct size_entry, rb);
+	rbtree_postorder_for_each_entry_safe(e, n, &c->size_tree, rb) {
 		if (e->inode)
 			iput(e->inode);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &e->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
 		kfree(e);
 	}
+
 	c->size_tree = RB_ROOT;
 }
 
diff -puN fs/ubifs/super.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/super.c
--- a/fs/ubifs/super.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/super.c
@@ -873,26 +873,10 @@ static void free_orphans(struct ubifs_in
  */
 static void free_buds(struct ubifs_info *c)
 {
-	struct rb_node *this = c->buds.rb_node;
-	struct ubifs_bud *bud;
+	struct ubifs_bud *bud, *n;
 
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			bud = rb_entry(this, struct ubifs_bud, rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &bud->rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-			kfree(bud);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(bud, n, &c->buds, rb)
+		kfree(bud);
 }
 
 /**
diff -puN fs/ubifs/tnc.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/ubifs/tnc.c
--- a/fs/ubifs/tnc.c~fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/ubifs/tnc.c
@@ -178,27 +178,11 @@ static int ins_clr_old_idx_znode(struct
  */
 void destroy_old_idx(struct ubifs_info *c)
 {
-	struct rb_node *this = c->old_idx.rb_node;
-	struct ubifs_old_idx *old_idx;
+	struct ubifs_old_idx *old_idx, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		old_idx = rb_entry(this, struct ubifs_old_idx, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &old_idx->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(old_idx, n, &c->old_idx, rb)
 		kfree(old_idx);
-	}
+
 	c->old_idx = RB_ROOT;
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

