From: akpm@linux-foundation.org
Subject: + slqb-cleanup-for-concatenating-kmlist.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:10:33 -0800
Message-ID: <200903032110.n23LAXkH003920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbZCCVKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     slqb: cleanup for concatenating kmlist
has been added to the -mm tree.  Its filename is
     slqb-cleanup-for-concatenating-kmlist.patch

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
Subject: slqb: cleanup for concatenating kmlist
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Move duplicate code into a inline functions.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slqb.c |   62 ++++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff -puN mm/slqb.c~slqb-cleanup-for-concatenating-kmlist mm/slqb.c
--- a/mm/slqb.c~slqb-cleanup-for-concatenating-kmlist
+++ a/mm/slqb.c
@@ -303,6 +303,23 @@ static inline void set_freepointer(struc
 	*(void **)(object + s->offset) = fp;
 }
 
+static inline void __kmlist_concat(struct kmem_cache *s, struct kmlist *dest,
+		void **head, void **tail, int nr)
+{
+	if (!dest->head)
+		dest->head = head;
+	else
+		set_freepointer(s, dest->tail, head);
+	dest->tail = tail;
+	dest->nr += nr;
+}
+
+static inline void kmlist_concat(struct kmem_cache *s, struct kmlist *dest,
+		struct kmlist *src)
+{
+	__kmlist_concat(s, dest, src->head, src->tail, src->nr);
+}
+
 /* Loop over all objects in a slab */
 #define for_each_object(__p, __s, __addr) \
 	for (__p = (__addr); __p < (__addr) + (__s)->objects * (__s)->size;\
@@ -1148,8 +1165,7 @@ static void flush_free_list_all(struct k
 static void claim_remote_free_list(struct kmem_cache *s,
 					struct kmem_cache_list *l)
 {
-	void **head, **tail;
-	int nr;
+	struct kmlist tmp_list;
 
 	if (!l->remote_free.list.nr)
 		return;
@@ -1157,29 +1173,20 @@ static void claim_remote_free_list(struc
 	spin_lock(&l->remote_free.lock);
 
 	l->remote_free_check = 0;
-	head = l->remote_free.list.head;
+	tmp_list = l->remote_free.list;
+
 	l->remote_free.list.head = NULL;
-	tail = l->remote_free.list.tail;
 	l->remote_free.list.tail = NULL;
-	nr = l->remote_free.list.nr;
 	l->remote_free.list.nr = 0;
 
 	spin_unlock(&l->remote_free.lock);
 
-	VM_BUG_ON(!nr);
-
-	if (!l->freelist.nr) {
-		/* Get head hot for likely subsequent allocation or flush */
-		prefetchw(head);
-		l->freelist.head = head;
-	} else
-		set_freepointer(s, l->freelist.tail, head);
-	l->freelist.tail = tail;
+	VM_BUG_ON(!tmp_list.nr);
 
-	l->freelist.nr += nr;
+	kmlist_concat(s, &l->freelist, &tmp_list);
 
 	slqb_stat_inc(l, CLAIM_REMOTE_LIST);
-	slqb_stat_add(l, CLAIM_REMOTE_LIST_OBJECTS, nr);
+	slqb_stat_add(l, CLAIM_REMOTE_LIST_OBJECTS, tmp_list.nr);
 }
 #endif
 
@@ -1545,22 +1552,16 @@ static void flush_remote_free_cache(stru
 
 	spin_lock(&dst->remote_free.lock);
 
-	if (!dst->remote_free.list.head)
-		dst->remote_free.list.head = src->head;
-	else
-		set_freepointer(s, dst->remote_free.list.tail, src->head);
-	dst->remote_free.list.tail = src->tail;
-
-	src->head = NULL;
-	src->tail = NULL;
-	src->nr = 0;
-
 	if (dst->remote_free.list.nr < slab_freebatch(s))
 		set = 1;
 	else
 		set = 0;
 
-	dst->remote_free.list.nr += nr;
+	kmlist_concat(s, &dst->remote_free.list, src);
+
+	src->head = NULL;
+	src->tail = NULL;
+	src->nr = 0;
 
 	if (unlikely(dst->remote_free.list.nr >= slab_freebatch(s) && set))
 		dst->remote_free_check = 1;
@@ -1589,13 +1590,8 @@ static noinline void slab_free_to_remote
 	}
 
 	r = &c->rlist;
-	if (!r->head)
-		r->head = object;
-	else
-		set_freepointer(s, r->tail, object);
 	set_freepointer(s, object, NULL);
-	r->tail = object;
-	r->nr++;
+	__kmlist_concat(s, r, object, object, 1);
 
 	if (unlikely(r->nr > slab_freebatch(s)))
 		flush_remote_free_cache(s, c);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
workqueue-avoid-recursion-in-run_workqueue.patch
cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch

