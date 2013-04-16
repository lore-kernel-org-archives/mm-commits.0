From: akpm@linux-foundation.org
Subject: + rbtree_test-add-__init-__exit-annotations.patch added to -mm tree
Date: Tue, 16 Apr 2013 16:25:49 -0700
Message-ID: <20130416232549.ECB695A41F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35998 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965621Ab3DPXZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 19:25:51 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so115932qad.0
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 16:25:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, walken@google.com


The patch titled
     Subject: rbtree_test: add __init/__exit annotations
has been added to the -mm tree.  Its filename is
     rbtree_test-add-__init-__exit-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch
rbtree_test-add-extra-rbtree-integrity-check.patch
rbtree_test-add-__init-__exit-annotations.patch

