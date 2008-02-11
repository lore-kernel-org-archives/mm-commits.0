From: akpm@linux-foundation.org
Subject: - epoll-avoid-kmemcheck-warning.patch removed from -mm tree
Date: Mon, 11 Feb 2008 15:55:20 -0800
Message-ID: <200802112355.m1BNtKPX008215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYBKXz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 18:55:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epoll: avoid kmemcheck warning
has been removed from the -mm tree.  Its filename was
     epoll-avoid-kmemcheck-warning.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: avoid kmemcheck warning
From: Davide Libenzi <davidel@xmailserver.org>

Epoll calls rb_set_parent(n, n) to initialize the rb-tree node, but
rb_set_parent() accesses node's pointer in its code.  This creates a
warning in kmemcheck (reported by Vegard Nossum) about an uninitialized
memory access.  The warning is harmless since the following rb-tree node
insert is going to overwrite the node data.  In any case I think it's
better to not have that happening at all, and fix it by properly
initializing the data.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c         |    2 +-
 include/linux/rbtree.h |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-avoid-kmemcheck-warning fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-avoid-kmemcheck-warning
+++ a/fs/eventpoll.c
@@ -260,7 +260,7 @@ static inline int ep_cmp_ffd(struct epol
 /* Special initialization for the RB tree node to detect linkage */
 static inline void ep_rb_initnode(struct rb_node *n)
 {
-	rb_set_parent(n, n);
+	rb_init_node(n, n);
 }
 
 /* Removes a node from the RB tree and marks it for a fast is-linked check */
diff -puN include/linux/rbtree.h~epoll-avoid-kmemcheck-warning include/linux/rbtree.h
--- a/include/linux/rbtree.h~epoll-avoid-kmemcheck-warning
+++ a/include/linux/rbtree.h
@@ -112,6 +112,17 @@ struct rb_root
 	struct rb_node *rb_node;
 };
 
+/**
+ * rb_init_node - Initializes the node internal data
+ *
+ * @node: Pointer to the RB-Tree node
+ * @parent: Pointer to the parent node, or NULL
+ */
+static inline void rb_init_node(struct rb_node *node, struct rb_node *parent)
+{
+	node->rb_parent_color = (unsigned long) parent;
+	node->rb_left = node->rb_right = NULL;
+}
 
 #define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
 #define rb_color(r)   ((r)->rb_parent_color & 1)
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
epoll-avoid-kmemcheck-warning.patch
git-kvm.patch
