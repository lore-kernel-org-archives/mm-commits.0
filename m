From: akpm@linux-foundation.org
Subject: [merged] rbtree-use-read_once-in-rb_empty_root.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:11 -0800
Message-ID: <56a1698b.8nB0MhPtT/2a6yNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, peterz@infradead.org, rusty@rustcorp.com.au, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: use READ_ONCE in RB_EMPTY_ROOT
has been removed from the -mm tree.  Its filename was
     rbtree-use-read_once-in-rb_empty_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: rbtree: use READ_ONCE in RB_EMPTY_ROOT

With d72da4a4d97 ("rbtree: Make lockless searches non-fatal") our rbtrees
provide weak guarantees that allows us to do lockless (and very
speculative) reads of the tree.  Such readers cannot see partial stores on
nodes, ie left/right as well as root.  As such, similar to the WRITE_ONCE
semantics when doing rotations, use READ_ONCE when checking the root node
in RB_EMPTY_ROOT.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rbtree.h~rbtree-use-read_once-in-rb_empty_root include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-use-read_once-in-rb_empty_root
+++ a/include/linux/rbtree.h
@@ -50,7 +50,7 @@ struct rb_root {
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
-#define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
+#define RB_EMPTY_ROOT(root)  (READ_ONCE((root)->rb_node) == NULL)
 
 /* 'empty' nodes are nodes that are known not to be inserted in an rbtree */
 #define RB_EMPTY_NODE(node)  \
_

Patches currently in -mm which might be from dave@stgolabs.net are


