From: akpm@linux-foundation.org
Subject: [merged] rbtree-add-comment-to-rb_insert_augmented.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:21:28 -0700
Message-ID: <543d69a8.xN50yEJqHiLwb6mY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: add comment to rb_insert_augmented()
has been removed from the -mm tree.  Its filename was
     rbtree-add-comment-to-rb_insert_augmented.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: rbtree: add comment to rb_insert_augmented()

The comment is copied from Documentation/rbtree.txt, but this comment
is so important that it should also be in the code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree_augmented.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/rbtree_augmented.h~rbtree-add-comment-to-rb_insert_augmented include/linux/rbtree_augmented.h
--- a/include/linux/rbtree_augmented.h~rbtree-add-comment-to-rb_insert_augmented
+++ a/include/linux/rbtree_augmented.h
@@ -43,6 +43,16 @@ struct rb_augment_callbacks {
 
 extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+/*
+ * Fixup the rbtree and update the augmented information when rebalancing.
+ *
+ * On insertion, the user must update the augmented information on the path
+ * leading to the inserted node, then call rb_link_node() as usual and
+ * rb_augment_inserted() instead of the usual rb_insert_color() call.
+ * If rb_augment_inserted() rebalances the rbtree, it will callback into
+ * a user provided function to update the augmented information on the
+ * affected subtrees.
+ */
 static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

