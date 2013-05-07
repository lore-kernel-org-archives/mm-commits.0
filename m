From: akpm@linux-foundation.org
Subject: [merged] rbtree_test-add-extra-rbtree-integrity-check.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:57 -0700
Message-ID: <20130507174957.7470331C3C9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48243 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EGRt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:58 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so85798vbe.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr.bueso@hp.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree_test: add extra rbtree integrity check
has been removed from the -mm tree.  Its filename was
     rbtree_test-add-extra-rbtree-integrity-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: rbtree_test: add extra rbtree integrity check

Account for the rbtree having  2**bh(v)-1 internal nodes.

While this can be seen as a consequence of other checks, Michel states
that it nicely sums up what the other properties are for.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/rbtree_test.c~rbtree_test-add-extra-rbtree-integrity-check lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree_test-add-extra-rbtree-integrity-check
+++ a/lib/rbtree_test.c
@@ -117,8 +117,7 @@ static int black_path_count(struct rb_no
 static void check(int nr_nodes)
 {
 	struct rb_node *rb;
-	int count = 0;
-	int blacks = 0;
+	int count = 0, blacks = 0;
 	u32 prev_key = 0;
 
 	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
@@ -134,7 +133,9 @@ static void check(int nr_nodes)
 		prev_key = node->key;
 		count++;
 	}
+
 	WARN_ON_ONCE(count != nr_nodes);
+	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 }
 
 static void check_augmented(int nr_nodes)
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

