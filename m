From: akpm@linux-foundation.org
Subject: + rbtree-fix-typo-in-comment-of-__rb_insert.patch added to -mm
 tree
Date: Tue, 22 Jul 2014 13:40:07 -0700
Message-ID: <53cecc27.5bJiQMTZVD5ztUtc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:34941 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaGVUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:40:08 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so67408pab.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:40:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, walken@google.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree.c: fix typo in comment of __rb_insert()
has been added to the -mm tree.  Its filename is
     rbtree-fix-typo-in-comment-of-__rb_insert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-fix-typo-in-comment-of-__rb_insert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-fix-typo-in-comment-of-__rb_insert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: lib/rbtree.c: fix typo in comment of __rb_insert()

In case 1, it passes down the BLACK color from G to p and u, and maintains
the color of n.  By doing so, it maintains the black height of the
sub-tree.

While in the comment, it marks the color of n to BLACK.  This is a typo
and not consistents with the code.

This patch fixs this typo in comment.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/rbtree.c~rbtree-fix-typo-in-comment-of-__rb_insert lib/rbtree.c
--- a/lib/rbtree.c~rbtree-fix-typo-in-comment-of-__rb_insert
+++ a/lib/rbtree.c
@@ -101,7 +101,7 @@ __rb_insert(struct rb_node *node, struct
 				 *      / \          / \
 				 *     p   u  -->   P   U
 				 *    /            /
-				 *   n            N
+				 *   n            n
 				 *
 				 * However, since g's parent might be red, and
 				 * 4) does not allow this, we need to recurse
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

slub-reduce-duplicate-creation-on-the-first-object.patch
rbtree-fix-typo-in-comment-of-__rb_insert.patch

