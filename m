From: akpm@linux-foundation.org
Subject: + rbtree-add-comment-to-rb_insert_augmented.patch added to -mm
 tree
Date: Thu, 18 Sep 2014 13:03:27 -0700
Message-ID: <541b3a8f.9JgcjqetQcuM9QSx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaIRUD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 16:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: add comment to rb_insert_augmented()
has been added to the -mm tree.  Its filename is
     rbtree-add-comment-to-rb_insert_augmented.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-add-comment-to-rb_insert_augmented.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-add-comment-to-rb_insert_augmented.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rbtree-add-comment-to-rb_insert_augmented.patch
linux-next.patch

