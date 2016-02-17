From: akpm@linux-foundation.org
Subject: + slub-drop-lock-at-the-end-of-free_debug_processing.patch added
 to -mm tree
Date: Wed, 17 Feb 2016 12:05:00 -0800
Message-ID: <56c4d26c.WIY4XHuHL/cObAce%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbcBQUFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 15:05:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: drop lock at the end of free_debug_processing
has been added to the -mm tree.  Its filename is
     slub-drop-lock-at-the-end-of-free_debug_processing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-drop-lock-at-the-end-of-free_debug_processing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-drop-lock-at-the-end-of-free_debug_processing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: slub: drop lock at the end of free_debug_processing

This series takes the suggestion of Christoph Lameter and only focuses on
optimizing the slow path where the debug processing runs.  The two main
optimizations in this series are letting the consistency checks be skipped
and relaxing the cmpxchg restrictions when we are not doing consistency
checks.  With hackbench -g 20 -l 1000 averaged over 100 runs:

Before slub_debug=P
mean 15.607
variance .086
stdev .294

After slub_debug=P
mean 10.836
variance .155
stdev .394

This still isn't as fast as what is in grsecurity unfortunately so there's
still work to be done.  Profiling ___slab_alloc shows that 25-50% of time
is spent in deactivate_slab.  I haven't looked too closely to see if this
is something that can be optimized.  My plan for now is to focus on
getting all of this merged (if appropriate) before digging in to another
task.


This patch (of 4):

Currently, free_debug_processing has a comment "Keep node_lock to preserve
integrity until the object is actually freed".  In actuallity, the lock is
dropped immediately in __slab_free.  Rather than wait until __slab_free
and potentially throw off the unlikely marking, just drop the lock in
__slab_free.  This also lets free_debug_processing take its own copy of
the spinlock flags rather than trying to share the ones from __slab_free. 
Since there is no use for the node afterwards, change the return type of
free_debug_processing to return an int like alloc_debug_processing.

Credit to Mathias Krause for the original work which inspired this series

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing mm/slub.c
--- a/mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing
+++ a/mm/slub.c
@@ -1044,16 +1044,17 @@ bad:
 }
 
 /* Supports checking bulk free of a constructed freelist */
-static noinline struct kmem_cache_node *free_debug_processing(
+static noinline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
-	unsigned long addr, unsigned long *flags)
+	unsigned long addr)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	void *object = head;
 	int cnt = 0;
+	unsigned long uninitialized_var(flags);
 
-	spin_lock_irqsave(&n->list_lock, *flags);
+	spin_lock_irqsave(&n->list_lock, flags);
 	slab_lock(page);
 
 	if (!check_slab(s, page))
@@ -1106,17 +1107,14 @@ out:
 			 bulk_cnt, cnt);
 
 	slab_unlock(page);
-	/*
-	 * Keep node_lock to preserve integrity
-	 * until the object is actually freed
-	 */
-	return n;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return 1;
 
 fail:
 	slab_unlock(page);
-	spin_unlock_irqrestore(&n->list_lock, *flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	slab_fix(s, "Object at 0x%p not freed", object);
-	return NULL;
+	return 0;
 }
 
 static int __init setup_slub_debug(char *str)
@@ -1207,7 +1205,7 @@ static inline void setup_object_debug(st
 static inline int alloc_debug_processing(struct kmem_cache *s,
 	struct page *page, void *object, unsigned long addr) { return 0; }
 
-static inline struct kmem_cache_node *free_debug_processing(
+static inline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
 	unsigned long addr, unsigned long *flags) { return NULL; }
@@ -2588,8 +2586,7 @@ static void __slab_free(struct kmem_cach
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) &&
-	    !(n = free_debug_processing(s, page, head, tail, cnt,
-					addr, &flags)))
+	    !free_debug_processing(s, page, head, tail, cnt, addr))
 		return;
 
 	do {
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

