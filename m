From: akpm@linux-foundation.org
Subject: [merged] rbtree_test-add-__init-__exit-annotations.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:00 -0700
Message-ID: <20130507175000.77A9B5A43FE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:63619 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3EGRuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:01 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so85930qcz.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr.bueso@hp.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree_test: add __init/__exit annotations
has been removed from the -mm tree.  Its filename was
     rbtree_test-add-__init-__exit-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: rbtree_test: add __init/__exit annotations

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/rbtree_test.c~rbtree_test-add-__init-__exit-annotations lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree_test-add-__init-__exit-annotations
+++ a/lib/rbtree_test.c
@@ -149,7 +149,7 @@ static void check_augmented(int nr_nodes
 	}
 }
 
-static int rbtree_test_init(void)
+static int __init rbtree_test_init(void)
 {
 	int i, j;
 	cycles_t time1, time2, time;
@@ -222,7 +222,7 @@ static int rbtree_test_init(void)
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
-static void rbtree_test_exit(void)
+static void __exit rbtree_test_exit(void)
 {
 	printk(KERN_ALERT "test exit\n");
 }
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

