From: akpm@linux-foundation.org
Subject: [merged] rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:54 -0700
Message-ID: <20121009180855.6F51D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:38942 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2JISI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:59 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309190lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: reference Documentation/rbtree.txt for usage instructions
has been removed from the -mm tree.  Its filename was
     rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: reference Documentation/rbtree.txt for usage instructions

I recently started looking at the rbtree code (with an eye towards
improving the augmented rbtree support, but I haven't gotten there yet). 
I noticed a lot of possible speed improvements, which I am now proposing
in this patch set.

Patches 1-4 are preparatory: remove internal functions from rbtree.h so
that users won't be tempted to use them instead of the documented APIs,
clean up some incorrect usages I've noticed (in particular, with the
recently added fs/proc/proc_sysctl.c rbtree usage), reference the
documentation so that people have one less excuse to miss it, etc.

Patch 5 is a small module I wrote to check the rbtree performance.  It
creates 100 nodes with random keys and repeatedly inserts and erases them
from an rbtree.  Additionally, it has code to check for rbtree invariants
after each insert or erase operation.

Patches 6-12 is where the rbtree optimizations are done, and they touch
only that one file, lib/rbtree.c .  I am getting good results out of these
- in my small benchmark doing rbtree insertion (including search) and
erase, I'm seeing a 30% runtime reduction on Sandybridge E5, which is more
than I initially thought would be possible.  (the results aren't as
impressive on my two other test hosts though, AMD barcelona and Intel
Westmere, where I am seeing 14% runtime reduction only).  The code size -
both source (ommiting comments) and compiled - is also shorter after these
changes.  However, I do admit that the updated code is more arduous to
read - one big reason for that is the removal of the tree rotation
helpers, which added some overhead but also made it easier to reason about
things locally.  Overall, I believe this is an acceptable compromise,
given that this code doesn't get modified very often, and that I have good
tests for it.

Upon Peter's suggestion, I added comments showing the rtree configuration
before every rotation.  I think they help; however it's still best to have
a copy of the cormen/leiserson/rivest book when digging into this code.



This patch: reference Documentation/rbtree.txt for usage instructions

include/linux/rbtree.h included some basic usage instructions, while
Documentation/rbtree.txt had some more complete and easier to follow
instructions.  Replacing the former with a reference to the latter.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   67 ---------------------------------------
 1 file changed, 1 insertion(+), 66 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-reference-documentation-rbtreetxt-for-usage-instructions include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-reference-documentation-rbtreetxt-for-usage-instructions
+++ a/include/linux/rbtree.h
@@ -23,72 +23,7 @@
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
-  Some example of insert and search follows here. The search is a plain
-  normal search over an ordered tree. The insert instead must be implemented
-  in two steps: First, the code must insert the element in order as a red leaf
-  in the tree, and then the support library function rb_insert_color() must
-  be called. Such function will do the not trivial work to rebalance the
-  rbtree, if necessary.
-
------------------------------------------------------------------------
-static inline struct page * rb_search_page_cache(struct inode * inode,
-						 unsigned long offset)
-{
-	struct rb_node * n = inode->i_rb_page_cache.rb_node;
-	struct page * page;
-
-	while (n)
-	{
-		page = rb_entry(n, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			n = n->rb_left;
-		else if (offset > page->offset)
-			n = n->rb_right;
-		else
-			return page;
-	}
-	return NULL;
-}
-
-static inline struct page * __rb_insert_page_cache(struct inode * inode,
-						   unsigned long offset,
-						   struct rb_node * node)
-{
-	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
-	struct rb_node * parent = NULL;
-	struct page * page;
-
-	while (*p)
-	{
-		parent = *p;
-		page = rb_entry(parent, struct page, rb_page_cache);
-
-		if (offset < page->offset)
-			p = &(*p)->rb_left;
-		else if (offset > page->offset)
-			p = &(*p)->rb_right;
-		else
-			return page;
-	}
-
-	rb_link_node(node, parent, p);
-
-	return NULL;
-}
