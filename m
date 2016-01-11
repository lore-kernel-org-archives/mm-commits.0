From: akpm@linux-foundation.org
Subject: + rbtree-use-read_once-in-rb_empty_root.patch added to -mm tree
Date: Mon, 11 Jan 2016 13:27:25 -0800
Message-ID: <56941e3d.yEMIvS7Huw03+F9q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbcAKV10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 16:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, peterz@infradead.org, rusty@rustcorp.com.au, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: use READ_ONCE in RB_EMPTY_ROOT
has been added to the -mm tree.  Its filename is
     rbtree-use-read_once-in-rb_empty_root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-use-read_once-in-rb_empty_root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-use-read_once-in-rb_empty_root.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Peter Zijlstra <peterz@infradead.org>
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

rbtree-use-read_once-in-rb_empty_root.patch

