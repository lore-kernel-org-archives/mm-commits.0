From: akpm@linux-foundation.org
Subject: [merged] documentation-rbtreetxt-fix-errors-in-sample-code.patch removed from -mm tree
Date: Wed, 06 May 2009 13:47:43 -0700
Message-ID: <200905062047.n46KlhBP011222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757118AbZEFUux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 16:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: figo.zhang@kolorific.com, a.p.zijlstra@chello.nl, wstrepp@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/rbtree.txt: fix errors in sample code
has been removed from the -mm tree.  Its filename was
     documentation-rbtreetxt-fix-errors-in-sample-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/rbtree.txt: fix errors in sample code
From: "figo.zhang" <figo.zhang@kolorific.com>

The first formal parameter of the rb_link_node() is a pointer, and the
"node" is define a data struct (pls see line 67 and line 73 in the doc),
so the actual parameter should use "&data->node".

Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
Cc: Wolfram Strepp <wstrepp@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rbtree.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/rbtree.txt~documentation-rbtreetxt-fix-errors-in-sample-code Documentation/rbtree.txt
--- a/Documentation/rbtree.txt~documentation-rbtreetxt-fix-errors-in-sample-code
+++ a/Documentation/rbtree.txt
@@ -131,8 +131,8 @@ Example:
   	}
 
   	/* Add new node and rebalance tree. */
-  	rb_link_node(data->node, parent, new);
-  	rb_insert_color(data->node, root);
+  	rb_link_node(&data->node, parent, new);
+  	rb_insert_color(&data->node, root);
 
 	return TRUE;
   }
@@ -146,10 +146,10 @@ To remove an existing node from a tree, 
 
 Example:
 
-  struct mytype *data = mysearch(mytree, "walrus");
+  struct mytype *data = mysearch(&mytree, "walrus");
 
   if (data) {
-  	rb_erase(data->node, mytree);
+  	rb_erase(&data->node, &mytree);
   	myfree(data);
   }
 
_

Patches currently in -mm which might be from figo.zhang@kolorific.com are

linux-next.patch

