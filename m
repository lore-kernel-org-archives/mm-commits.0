From: akpm@linux-foundation.org
Subject: [merged] rbtree-fix-typo-in-comment-of-__rb_insert.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:40:34 -0700
Message-ID: <53ea6db2.9tDQZFH6p04QmxDZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:64332 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaHLTke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:34 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so1911841oif.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, walken@google.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree.c: fix typo in comment of __rb_insert()
has been removed from the -mm tree.  Its filename was
     rbtree-fix-typo-in-comment-of-__rb_insert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michel Lespinasse <walken@google.com>
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

origin.patch

