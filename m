From: akpm@linux-foundation.org
Subject: + rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:34 -0700
Message-ID: <20120713203034.EEB1A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:38438 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2GMUai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:30:38 -0400
Received: by weyr1 with SMTP id r1so204324wey.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:30:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: reference Documentation/rbtree.txt for usage instructions
has been added to the -mm tree.  Its filename is
     rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Woodhouse <dwmw2@infradead.org>
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
-
-static inline struct page * rb_insert_page_cache(struct inode * inode,
-						 unsigned long offset,
-						 struct rb_node * node)
-{
-	struct page * ret;
-	if ((ret = __rb_insert_page_cache(inode, offset, node)))
-		goto out;
-	rb_insert_color(node, &inode->i_rb_page_cache);
- out:
-	return ret;
-}
------------------------------------------------------------------------
+  See Documentation/rbtree.txt for documentation and samples.
 */
 
 #ifndef	_LINUX_RBTREE_H
_
Subject: Subject: rbtree: reference Documentation/rbtree.txt for usage instructions

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

