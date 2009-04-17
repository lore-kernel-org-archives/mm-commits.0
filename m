From: akpm@linux-foundation.org
Subject: + documentation-rbtreetxt-fix-errors-in-sample-code.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:43:34 -0700
Message-ID: <200904171843.n3HIhZHt001025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761360AbZDQSqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: figo.zhang@kolorific.com, a.p.zijlstra@chello.nl, wstrepp@gmx.de


The patch titled
     Documentation/rbtree.txt: fix errors in sample code
has been added to the -mm tree.  Its filename is
     documentation-rbtreetxt-fix-errors-in-sample-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-rbtreetxt-fix-errors-in-sample-code.patch

