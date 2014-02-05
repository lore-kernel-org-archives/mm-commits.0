From: akpm@linux-foundation.org
Subject: +
 mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch added to
 -mm tree
Date: Wed, 05 Feb 2014 13:33:44 -0800
Message-ID: <52f2ae38./GFUnQVh9tZgsSyr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbaBEVdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 16:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, cl@linux.com, dave.hansen@linux.intel.com

Subject: + mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch added to -mm tree
To: dave.hansen@linux.intel.com,cl@linux.com,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 13:33:44 -0800


The patch titled
     Subject: mm: slab/slub: use page->list consistently instead of page->lru
has been added to the -mm tree.  Its filename is
     mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: slab/slub: use page->list consistently instead of page->lru

'struct page' has two list_head fields: 'lru' and 'list'.  Conveniently,
they are unioned together.  This means that code can use them
interchangably, which gets horribly confusing like with this nugget from
slab.c:

>	list_del(&page->lru);
>	if (page->active == cachep->num)
>		list_add(&page->list, &n->slabs_full);

This patch makes the slab and slub code use page->lru universally instead
of mixing ->list and ->lru.

So, the new rule is: page->lru is what the you use if you want to keep
your page on a list.  Don't like the fact that it's not called ->list? 
Too bad.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 ++-
 mm/slab.c                |    4 ++--
 mm/slob.c                |   10 +++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~mm-slab-slub-use-page-list-consistently-instead-of-page-lru include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-slab-slub-use-page-list-consistently-instead-of-page-lru
+++ a/include/linux/mm_types.h
@@ -124,6 +124,8 @@ struct page {
 	union {
 		struct list_head lru;	/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
+					 * Can be used as a generic list
+					 * by the page owner.
 					 */
 		struct {		/* slub per cpu partial pages */
 			struct page *next;	/* Next partial slab */
@@ -136,7 +138,6 @@ struct page {
 #endif
 		};
 
-		struct list_head list;	/* slobs list of pages */
 		struct slab *slab_page; /* slab fields */
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
diff -puN mm/slab.c~mm-slab-slub-use-page-list-consistently-instead-of-page-lru mm/slab.c
--- a/mm/slab.c~mm-slab-slub-use-page-list-consistently-instead-of-page-lru
+++ a/mm/slab.c
@@ -2886,9 +2886,9 @@ retry:
 		/* move slabp to correct slabp list: */
 		list_del(&page->lru);
 		if (page->active == cachep->num)
-			list_add(&page->list, &n->slabs_full);
+			list_add(&page->lru, &n->slabs_full);
 		else
-			list_add(&page->list, &n->slabs_partial);
+			list_add(&page->lru, &n->slabs_partial);
 	}
 
 must_grow:
diff -puN mm/slob.c~mm-slab-slub-use-page-list-consistently-instead-of-page-lru mm/slob.c
--- a/mm/slob.c~mm-slab-slub-use-page-list-consistently-instead-of-page-lru
+++ a/mm/slob.c
@@ -111,13 +111,13 @@ static inline int slob_page_free(struct
 
 static void set_slob_page_free(struct page *sp, struct list_head *list)
 {
-	list_add(&sp->list, list);
+	list_add(&sp->lru, list);
 	__SetPageSlobFree(sp);
 }
 
 static inline void clear_slob_page_free(struct page *sp)
 {
-	list_del(&sp->list);
+	list_del(&sp->lru);
 	__ClearPageSlobFree(sp);
 }
 
@@ -282,7 +282,7 @@ static void *slob_alloc(size_t size, gfp
 
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, slob_list, list) {
+	list_for_each_entry(sp, slob_list, lru) {
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
@@ -296,7 +296,7 @@ static void *slob_alloc(size_t size, gfp
 			continue;
 
 		/* Attempt to alloc */
-		prev = sp->list.prev;
+		prev = sp->lru.prev;
 		b = slob_page_alloc(sp, size, align);
 		if (!b)
 			continue;
@@ -322,7 +322,7 @@ static void *slob_alloc(size_t size, gfp
 		spin_lock_irqsave(&slob_lock, flags);
 		sp->units = SLOB_UNITS(PAGE_SIZE);
 		sp->freelist = b;
-		INIT_LIST_HEAD(&sp->list);
+		INIT_LIST_HEAD(&sp->lru);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
 		set_slob_page_free(sp, slob_list);
 		b = slob_page_alloc(sp, size, align);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch

