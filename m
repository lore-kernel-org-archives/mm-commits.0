From: akpm@linux-foundation.org
Subject: + rbtree_test-add-extra-rbtree-integrity-check.patch added to -mm tree
Date: Tue, 16 Apr 2013 16:25:47 -0700
Message-ID: <20130416232547.CC04E5A41F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:44027 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965610Ab3DPXZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 19:25:49 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so107353vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 16:25:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, walken@google.com


The patch titled
     Subject: rbtree_test: add extra rbtree integrity check
has been added to the -mm tree.  Its filename is
     rbtree_test-add-extra-rbtree-integrity-check.patch

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

