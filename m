From: akpm@linux-foundation.org
Subject: [merged] lib-rbtreec-export-the-augmented-rbtree-helper-functions.patch removed from -mm tree
Date: Fri, 28 Jan 2011 12:01:04 -0800
Message-ID: <201101282001.p0SK14br024883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab1A1UBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Jan 2011 15:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@linbit.com, mm-commits@vger.kernel.org


The patch titled
     lib/rbtree.c: export the augmented rbtree helper functions
has been removed from the -mm tree.  Its filename was
     lib-rbtreec-export-the-augmented-rbtree-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

