From: akpm@linux-foundation.org
Subject: [merged] slub-reduce-duplicate-creation-on-the-first-object.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:23 -0700
Message-ID: <53e3db8b.5fcHKMr6WWn+ZxMU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:44089 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:24 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1175411pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: avoid duplicate creation on the first object
has been removed from the -mm tree.  Its filename was
     slub-reduce-duplicate-creation-on-the-first-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: slub: avoid duplicate creation on the first object

When a kmem_cache is created with ctor, each object in the kmem_cache will
be initialized before ready to use.  While in slub implementation, the
first object will be initialized twice.

This patch reduces the duplication of initialization of the first object.

Fix commit 7656c72b ("SLUB: add macros for scanning objects in a slab").

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/slub.c~slub-reduce-duplicate-creation-on-the-first-object mm/slub.c
--- a/mm/slub.c~slub-reduce-duplicate-creation-on-the-first-object
+++ a/mm/slub.c
@@ -283,6 +283,10 @@ static inline void set_freepointer(struc
 	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
 			__p += (__s)->size)
 
+#define for_each_object_idx(__p, __idx, __s, __addr, __objects) \
+	for (__p = (__addr), __idx = 1; __idx <= __objects;\
+			__p += (__s)->size, __idx++)
+
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
 {
@@ -1379,9 +1383,9 @@ static struct page *new_slab(struct kmem
 {
 	struct page *page;
 	void *start;
-	void *last;
 	void *p;
 	int order;
+	int idx;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1402,14 +1406,13 @@ static struct page *new_slab(struct kmem
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
-	last = start;
-	for_each_object(p, s, start, page->objects) {
-		setup_object(s, page, last);
-		set_freepointer(s, last, p);
-		last = p;
+	for_each_object_idx(p, idx, s, start, page->objects) {
+		setup_object(s, page, p);
+		if (likely(idx < page->objects))
+			set_freepointer(s, p, p + s->size);
+		else
+			set_freepointer(s, p, NULL);
 	}
-	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
 	page->inuse = page->objects;
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

origin.patch
rbtree-fix-typo-in-comment-of-__rb_insert.patch

