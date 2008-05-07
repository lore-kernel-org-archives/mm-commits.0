From: akpm@linux-foundation.org
Subject: + idr-make-idr_remove-rcu-safe.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:34 -0700
Message-ID: <200805072040.m47KeYmT015477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbYEGUvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: make idr_remove rcu-safe
has been added to the -mm tree.  Its filename is
     idr-make-idr_remove-rcu-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: make idr_remove rcu-safe
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the free_layer() routine: it is the one that actually frees memory
after a grace period has elapsed.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   57 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff -puN lib/idr.c~idr-make-idr_remove-rcu-safe lib/idr.c
--- a/lib/idr.c~idr-make-idr_remove-rcu-safe
+++ a/lib/idr.c
@@ -52,6 +52,19 @@ static struct idr_layer *get_from_free_l
 	return(p);
 }
 
+static void idr_layer_rcu_free(struct rcu_head *head)
+{
+	struct idr_layer *layer;
+
+	layer = container_of(head, struct idr_layer, rcu_head);
+	kmem_cache_free(idr_layer_cache, layer);
+}
+
+static inline void free_layer(struct idr_layer *p)
+{
+	call_rcu(&p->rcu_head, idr_layer_rcu_free);
+}
+
 /* only called when idp->lock is held */
 static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
@@ -334,6 +347,7 @@ static void sub_remove(struct idr *idp, 
 	struct idr_layer *p = idp->top;
 	struct idr_layer **pa[MAX_LEVEL];
 	struct idr_layer ***paa = &pa[0];
+	struct idr_layer *to_free;
 	int n;
 
 	*paa = NULL;
@@ -349,13 +363,18 @@ static void sub_remove(struct idr *idp, 
 	n = id & IDR_MASK;
 	if (likely(p != NULL && test_bit(n, &p->bitmap))){
 		__clear_bit(n, &p->bitmap);
-		p->ary[n] = NULL;
+		rcu_assign_pointer(p->ary[n], NULL);
+		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
-			move_to_free_list(idp, **paa);
+			if (to_free)
+				free_layer(to_free);
+			to_free = **paa;
 			**paa-- = NULL;
 		}
 		if (!*paa)
 			idp->layers = 0;
+		if (to_free)
+			free_layer(to_free);
 	} else
 		idr_remove_warning(id);
 }
@@ -368,22 +387,34 @@ static void sub_remove(struct idr *idp, 
 void idr_remove(struct idr *idp, int id)
 {
 	struct idr_layer *p;
+	struct idr_layer *to_free;
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
-	    idp->top->ary[0]) {  // We can drop a layer
-
+	    idp->top->ary[0]) {
+		/*
+		 * Single child at leftmost slot: we can shrink the tree.
+		 * This level is not needed anymore since when layers are
+		 * inserted, they are inserted at the top of the existing
+		 * tree.
+		 */
+		to_free = idp->top;
 		p = idp->top->ary[0];
-		idp->top->bitmap = idp->top->count = 0;
-		move_to_free_list(idp, idp->top);
-		idp->top = p;
+		rcu_assign_pointer(idp->top, p);
 		--idp->layers;
+		to_free->bitmap = to_free->count = 0;
+		free_layer(to_free);
 	}
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
 		p = get_from_free_list(idp);
+		/*
+		 * Note: we don't call the rcu callback here, since the only
+		 * layers that fall into the freelist are those that have been
+		 * preallocated.
+		 */
 		kmem_cache_free(idr_layer_cache, p);
 	}
 	return;
@@ -424,15 +455,13 @@ void idr_remove_all(struct idr *idp)
 
 		id += 1 << n;
 		while (n < fls(id)) {
-			if (p) {
-				memset(p, 0, sizeof *p);
-				move_to_free_list(idp, p);
-			}
+			if (p)
+				free_layer(p);
 			n += IDR_BITS;
 			p = *--paa;
 		}
 	}
-	idp->top = NULL;
+	rcu_assign_pointer(idp->top, NULL);
 	idp->layers = 0;
 }
 EXPORT_SYMBOL(idr_remove_all);
@@ -549,7 +578,7 @@ EXPORT_SYMBOL(idr_for_each);
  * A -ENOENT return indicates that @id was not found.
  * A -EINVAL return indicates that @id was not within valid constraints.
  *
- * The caller must serialize vs idr_find(), idr_get_new(), and idr_remove().
+ * The caller must serialize with writers.
  */
 void *idr_replace(struct idr *idp, void *ptr, int id)
 {
@@ -575,7 +604,7 @@ void *idr_replace(struct idr *idp, void 
 		return ERR_PTR(-ENOENT);
 
 	old_p = p->ary[n];
-	p->ary[n] = ptr;
+	rcu_assign_pointer(p->ary[n], ptr);
 
 	return old_p;
 }
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

