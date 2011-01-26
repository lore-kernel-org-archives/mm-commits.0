From: akpm@linux-foundation.org
Subject: + lib-rbtreec-export-the-augmented-rbtree-helper-functions.patch added to -mm tree
Date: Wed, 26 Jan 2011 14:17:46 -0800
Message-ID: <201101262217.p0QMHkhY007880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab1AZWRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 17:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@linbit.com


The patch titled
     lib/rbtree.c: export the augmented rbtree helper functions
has been added to the -mm tree.  Its filename is
     lib-rbtreec-export-the-augmented-rbtree-helper-functions.patch

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
Subject: lib/rbtree.c: export the augmented rbtree helper functions
From: Andreas Gruenbacher <agruen@linbit.com>

The augmented rbtree helper functions are not exported to modules right
now.  We have started using augmented rbtrees in the upcoming version of
drbd.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/rbtree.c~lib-rbtreec-export-the-augmented-rbtree-helper-functions lib/rbtree.c
--- a/lib/rbtree.c~lib-rbtreec-export-the-augmented-rbtree-helper-functions
+++ a/lib/rbtree.c
@@ -315,6 +315,7 @@ void rb_augment_insert(struct rb_node *n
 
 	rb_augment_path(node, func, data);
 }
+EXPORT_SYMBOL(rb_augment_insert);
 
 /*
  * before removing the node, find the deepest node on the rebalance path
@@ -340,6 +341,7 @@ struct rb_node *rb_augment_erase_begin(s
 
 	return deepest;
 }
+EXPORT_SYMBOL(rb_augment_erase_begin);
 
 /*
  * after removal, update the tree to account for the removed entry
@@ -350,6 +352,7 @@ void rb_augment_erase_end(struct rb_node
 	if (node)
 		rb_augment_path(node, func, data);
 }
+EXPORT_SYMBOL(rb_augment_erase_end);
 
 /*
  * This function returns the first node (in sort order) of the tree.
_

Patches currently in -mm which might be from agruen@linbit.com are

lib-rbtreec-export-the-augmented-rbtree-helper-functions.patch

