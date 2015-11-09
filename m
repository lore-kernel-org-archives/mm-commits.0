From: akpm@linux-foundation.org
Subject: [merged]
 rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:48 -0800
Message-ID: <5640fe40.MX95PDGWCMY/O741%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbKIUMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@codyps.com, john@jjdev.com, peterz@infradead.org, rusty@rustcorp.com.au, tj@kernel.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: clarify documentation of rbtree_postorder_for_each_entry_safe()
has been removed from the -mm tree.  Its filename was
     rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <dev@codyps.com>
Subject: rbtree: clarify documentation of rbtree_postorder_for_each_entry_safe()

I noticed that commit a20135ffbc44 ("writeback: don't drain
bdi_writeback_congested on bdi destruction") added a usage of
rbtree_postorder_for_each_entry_safe() in mm/backing-dev.c which appears
to try to rb_erase() elements from an rbtree while iterating over it using
rbtree_postorder_for_each_entry_safe().

Doing this will cause random nodes to be missed by the iteration because
rb_erase() may rebalance the tree, changing the ordering that we're trying
to iterate over.

The previous documentation for rbtree_postorder_for_each_entry_safe()
wasn't clear that this wasn't allowed, it was taken from the docs for
list_for_each_entry_safe(), where erasing isn't a problem due to
list_del() not reordering.

Explicitly warn developers about this potential pit-fall.

Note that I haven't fixed the actual issue that (it appears) the commit
referenced above introduced (not familiar enough with that code).

In general (and in this case), the patterns to follow are:
 - switch to rb_first() + rb_erase(), don't use
   rbtree_postorder_for_each_entry_safe().
 - keep the postorder iteration and don't rb_erase() at all. Instead
   just clear the fields of rb_node & cgwb_congested_tree as required by
   other users of those structures.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Cody P Schafer <dev@codyps.com>
Cc: John de la Garza <john@jjdev.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe
+++ a/include/linux/rbtree.h
@@ -101,13 +101,21 @@ static inline void rb_link_node_rcu(stru
 	})
 
 /**
- * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
- * given type safe against removal of rb_node entry
+ * rbtree_postorder_for_each_entry_safe - iterate in post-order over rb_root of
+ * given type allowing the backing memory of @pos to be invalidated
  *
  * @pos:	the 'type *' to use as a loop cursor.
  * @n:		another 'type *' to use as temporary storage
  * @root:	'rb_root *' of the rbtree.
  * @field:	the name of the rb_node field within 'type'.
+ *
+ * rbtree_postorder_for_each_entry_safe() provides a similar guarantee as
+ * list_for_each_entry_safe() and allows the iteration to continue independent
+ * of changes to @pos by the body of the loop.
+ *
+ * Note, however, that it cannot handle other modifications that re-order the
+ * rbtree it is iterating over. This includes calling rb_erase() on @pos, as
+ * rb_erase() may rebalance the tree, causing us to miss some nodes.
  */
 #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
 	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
_

Patches currently in -mm which might be from dev@codyps.com are


