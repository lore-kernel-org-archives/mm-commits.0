From: akpm@linux-foundation.org
Subject: [merged] lib-rbtree_testc-fix-uninitialized-variable-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:36 -0800
Message-ID: <20121218200636.9C24F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40822 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2LRUGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:37 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so125791qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dinggnu@gmail.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree_test.c: fix uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     lib-rbtree_testc-fix-uninitialized-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cong Ding <dinggnu@gmail.com>
Subject: lib/rbtree_test.c: fix uninitialized variable warning

lib/rbtree_test.c: In function `check':
lib/rbtree_test.c:121: warning: `blacks' may be used uninitialized in this function

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/rbtree_test.c~lib-rbtree_testc-fix-uninitialized-variable-warning lib/rbtree_test.c
--- a/lib/rbtree_test.c~lib-rbtree_testc-fix-uninitialized-variable-warning
+++ a/lib/rbtree_test.c
@@ -118,7 +118,7 @@ static void check(int nr_nodes)
 {
 	struct rb_node *rb;
 	int count = 0;
-	int blacks;
+	int blacks = 0;
 	u32 prev_key = 0;
 
 	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
_

Patches currently in -mm which might be from dinggnu@gmail.com are

origin.patch

