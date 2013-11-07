From: akpm@linux-foundation.org
Subject: +
 fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:16:55 -0800
Message-ID: <527c1157.WbizD/tNZv1khVsM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3KGWQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, jack@suse.cz, dwmw2@infradead.org, cody@linux.vnet.ibm.com

Subject: + fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch added to -mm tree
To: cody@linux.vnet.ibm.com,dwmw2@infradead.org,jack@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:55 -0800


The patch titled
     Subject: fs/jffs2: use rbtree postorder iteration helper instead of opencoding
has been added to the -mm tree.  Its filename is
     fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch

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
Subject: fs/jffs2: use rbtree postorder iteration helper instead of opencoding

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodelist.c  |   28 ++--------------------------
 fs/jffs2/readinode.c |   26 +++-----------------------
 2 files changed, 5 insertions(+), 49 deletions(-)

diff -puN fs/jffs2/nodelist.c~fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/jffs2/nodelist.c
--- a/fs/jffs2/nodelist.c~fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/jffs2/nodelist.c
@@ -564,25 +564,10 @@ struct jffs2_node_frag *jffs2_lookup_nod
    they're killed. */
 void jffs2_kill_fragtree(struct rb_root *root, struct jffs2_sb_info *c)
 {
-	struct jffs2_node_frag *frag;
-	struct jffs2_node_frag *parent;
-
-	if (!root->rb_node)
-		return;
+	struct jffs2_node_frag *frag, *next;
 
 	dbg_fragtree("killing\n");
-
-	frag = (rb_entry(root->rb_node, struct jffs2_node_frag, rb));
-	while(frag) {
-		if (frag->rb.rb_left) {
-			frag = frag_left(frag);
-			continue;
-		}
-		if (frag->rb.rb_right) {
-			frag = frag_right(frag);
-			continue;
-		}
-
+	rbtree_postorder_for_each_entry_safe(frag, next, root, rb) {
 		if (frag->node && !(--frag->node->frags)) {
 			/* Not a hole, and it's the final remaining frag
 			   of this node. Free the node */
@@ -591,17 +576,8 @@ void jffs2_kill_fragtree(struct rb_root
 
 			jffs2_free_full_dnode(frag->node);
 		}
-		parent = frag_parent(frag);
-		if (parent) {
-			if (frag_left(parent) == frag)
-				parent->rb.rb_left = NULL;
-			else
-				parent->rb.rb_right = NULL;
-		}
 
 		jffs2_free_node_frag(frag);
-		frag = parent;
-
 		cond_resched();
 	}
 }
diff -puN fs/jffs2/readinode.c~fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding
+++ a/fs/jffs2/readinode.c
@@ -543,33 +543,13 @@ static int jffs2_build_inode_fragtree(st
 
 static void jffs2_free_tmp_dnode_info_list(struct rb_root *list)
 {
-	struct rb_node *this;
-	struct jffs2_tmp_dnode_info *tn;
+	struct jffs2_tmp_dnode_info *tn, *next;
 
-	this = list->rb_node;
-
-	/* Now at bottom of tree */
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			tn = rb_entry(this, struct jffs2_tmp_dnode_info, rb);
+	rbtree_postorder_for_each_entry_safe(tn, next, list, rb) {
 			jffs2_free_full_dnode(tn->fn);
 			jffs2_free_tmp_dnode_info(tn);
-
-			this = rb_parent(this);
-			if (!this)
-				break;
-
-			if (this->rb_left == &tn->rb)
-				this->rb_left = NULL;
-			else if (this->rb_right == &tn->rb)
-				this->rb_right = NULL;
-			else BUG();
-		}
 	}
+
 	*list = RB_ROOT;
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

