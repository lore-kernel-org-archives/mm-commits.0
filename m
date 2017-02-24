From: akpm@linux-foundation.org
Subject: [patch 111/124] rbtree: use designated initializers
Date: Fri, 24 Feb 2017 15:01:04 -0800
Message-ID: <58b0bb30.q/3JMvoR5ADkA/Bv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdBXXBF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, dhowells@redhat.com, fykcee1@gmail.com, peterz@infradead.org

From: Kees Cook <keescook@chromium.org>
Subject: rbtree: use designated initializers

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Link: http://lkml.kernel.org/r/20161217010253.GA140470@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jie Chen <fykcee1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree_augmented.h |    4 +++-
 lib/rbtree.c                     |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/rbtree_augmented.h~rbtree-use-designated-initializers include/linux/rbtree_augmented.h
--- a/include/linux/rbtree_augmented.h~rbtree-use-designated-initializers
+++ a/include/linux/rbtree_augmented.h
@@ -90,7 +90,9 @@ rbname ## _rotate(struct rb_node *rb_old
 	old->rbaugmented = rbcompute(old);				\
 }									\
 rbstatic const struct rb_augment_callbacks rbname = {			\
-	rbname ## _propagate, rbname ## _copy, rbname ## _rotate	\
+	.propagate = rbname ## _propagate,				\
+	.copy = rbname ## _copy,					\
+	.rotate = rbname ## _rotate					\
 };
 
 
diff -puN lib/rbtree.c~rbtree-use-designated-initializers lib/rbtree.c
--- a/lib/rbtree.c~rbtree-use-designated-initializers
+++ a/lib/rbtree.c
@@ -427,7 +427,9 @@ static inline void dummy_copy(struct rb_
 static inline void dummy_rotate(struct rb_node *old, struct rb_node *new) {}
 
 static const struct rb_augment_callbacks dummy_callbacks = {
-	dummy_propagate, dummy_copy, dummy_rotate
+	.propagate = dummy_propagate,
+	.copy = dummy_copy,
+	.rotate = dummy_rotate
 };
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
_
