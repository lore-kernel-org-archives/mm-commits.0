From: akpm@linux-foundation.org
Subject: + idr-rename-some-of-the-idr-apis-internal-routines.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:24 -0700
Message-ID: <200805072040.m47KeOqe015459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYEGUvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: rename some of the idr APIs internal routines
has been added to the -mm tree.  Its filename is
     idr-rename-some-of-the-idr-apis-internal-routines.patch

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
Subject: idr: rename some of the idr APIs internal routines
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that renames:

   . alloc_layer to get_from_free_list since it idr_pre_get that actually
     allocates memory.
   . free_layer to move_to_free_list since memory is not actually freed there.

This makes things more clear for the next patches.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN lib/idr.c~idr-rename-some-of-the-idr-apis-internal-routines lib/idr.c
--- a/lib/idr.c~idr-rename-some-of-the-idr-apis-internal-routines
+++ a/lib/idr.c
@@ -35,7 +35,7 @@
 
 static struct kmem_cache *idr_layer_cache;
 
-static struct idr_layer *alloc_layer(struct idr *idp)
+static struct idr_layer *get_from_free_list(struct idr *idp)
 {
 	struct idr_layer *p;
 	unsigned long flags;
@@ -51,14 +51,14 @@ static struct idr_layer *alloc_layer(str
 }
 
 /* only called when idp->lock is held */
-static void __free_layer(struct idr *idp, struct idr_layer *p)
+static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
 	p->ary[0] = idp->id_free;
 	idp->id_free = p;
 	idp->id_free_cnt++;
 }
 
-static void free_layer(struct idr *idp, struct idr_layer *p)
+static void move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
 	unsigned long flags;
 
@@ -66,7 +66,7 @@ static void free_layer(struct idr *idp, 
 	 * Depends on the return element being zeroed.
 	 */
 	spin_lock_irqsave(&idp->lock, flags);
-	__free_layer(idp, p);
+	__move_to_free_list(idp, p);
 	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
@@ -109,7 +109,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
 			return (0);
-		free_layer(idp, new);
+		move_to_free_list(idp, new);
 	}
 	return 1;
 }
@@ -167,7 +167,8 @@ static int sub_alloc(struct idr *idp, in
 		 * Create the layer below if it is missing.
 		 */
 		if (!p->ary[m]) {
-			if (!(new = alloc_layer(idp)))
+			new = get_from_free_list(idp);
+			if (!new)
 				return -1;
 			p->ary[m] = new;
 			p->count++;
@@ -192,7 +193,7 @@ build_up:
 	p = idp->top;
 	layers = idp->layers;
 	if (unlikely(!p)) {
-		if (!(p = alloc_layer(idp)))
+		if (!(p = get_from_free_list(idp)))
 			return -1;
 		layers = 1;
 	}
@@ -204,7 +205,7 @@ build_up:
 		layers++;
 		if (!p->count)
 			continue;
-		if (!(new = alloc_layer(idp))) {
+		if (!(new = get_from_free_list(idp))) {
 			/*
 			 * The allocation failed.  If we built part of
 			 * the structure tear it down.
@@ -214,7 +215,7 @@ build_up:
 				p = p->ary[0];
 				new->ary[0] = NULL;
 				new->bitmap = new->count = 0;
-				__free_layer(idp, new);
+				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
@@ -351,7 +352,7 @@ static void sub_remove(struct idr *idp, 
 		__clear_bit(n, &p->bitmap);
 		p->ary[n] = NULL;
 		while(*paa && ! --((**paa)->count)){
-			free_layer(idp, **paa);
+			move_to_free_list(idp, **paa);
 			**paa-- = NULL;
 		}
 		if (!*paa)
@@ -378,12 +379,12 @@ void idr_remove(struct idr *idp, int id)
 
 		p = idp->top->ary[0];
 		idp->top->bitmap = idp->top->count = 0;
-		free_layer(idp, idp->top);
+		move_to_free_list(idp, idp->top);
 		idp->top = p;
 		--idp->layers;
 	}
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
-		p = alloc_layer(idp);
+		p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
 	}
 	return;
@@ -426,7 +427,7 @@ void idr_remove_all(struct idr *idp)
 		while (n < fls(id)) {
 			if (p) {
 				memset(p, 0, sizeof *p);
-				free_layer(idp, p);
+				move_to_free_list(idp, p);
 			}
 			n += IDR_BITS;
 			p = *--paa;
@@ -444,7 +445,7 @@ EXPORT_SYMBOL(idr_remove_all);
 void idr_destroy(struct idr *idp)
 {
 	while (idp->id_free_cnt) {
-		struct idr_layer *p = alloc_layer(idp);
+		struct idr_layer *p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
 	}
 }
@@ -749,7 +750,7 @@ int ida_get_new_above(struct ida *ida, i
 	 * allocation.
 	 */
 	if (ida->idr.id_free_cnt || ida->free_bitmap) {
-		struct idr_layer *p = alloc_layer(&ida->idr);
+		struct idr_layer *p = get_from_free_list(&ida->idr);
 		if (p)
 			kmem_cache_free(idr_layer_cache, p);
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

