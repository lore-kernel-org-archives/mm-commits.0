From: akpm@linux-foundation.org
Subject: + lib-rbtree_testc-fix-uninitialized-variable-warning.patch added to -mm tree
Date: Tue, 11 Dec 2012 13:50:50 -0800
Message-ID: <20121211215051.02DA0200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:41618 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2LKVux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 16:50:53 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so280008eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 13:50:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dinggnu@gmail.com, walken@google.com


The patch titled
     Subject: lib/rbtree_test.c: fix uninitialized variable warning
has been added to the -mm tree.  Its filename is
     lib-rbtree_testc-fix-uninitialized-variable-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
lib-rbtree_testc-fix-uninitialized-variable-warning.patch

