From: akpm@linux-foundation.org
Subject: - lib-idrc-fix-rcu-related-race-with-idr_find.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:56 -0800
Message-ID: <200812021838.mB2Icu2x007202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYLBSjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, Nadia.Derbey@bull.net, cboulte@gmail.com, peifferp@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lib/idr.c: fix rcu related race with idr_find
has been removed from the -mm tree.  Its filename was
     lib-idrc-fix-rcu-related-race-with-idr_find.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/idr.c: fix rcu related race with idr_find
From: Manfred Spraul <manfred@colorfullife.com>

2nd part of the fixes needed for
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

When the idr tree is either grown or shrunk, then the update to the number
of layers and the top pointer were not atomic.  This race caused crashes.

The attached patch fixes that by replicating the layers counter in each
layer, thus idr_find doesn't need idp->layers anymore.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Clement Calmels <cboulte@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    3 ++-
 lib/idr.c           |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/idr.h~lib-idrc-fix-rcu-related-race-with-idr_find include/linux/idr.h
--- a/include/linux/idr.h~lib-idrc-fix-rcu-related-race-with-idr_find
+++ a/include/linux/idr.h
@@ -52,13 +52,14 @@ struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct idr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	int			 layer;	 /* distance from leaf */
 	struct rcu_head		 rcu_head;
 };
 
 struct idr {
 	struct idr_layer *top;
 	struct idr_layer *id_free;
-	int		  layers;
+	int		  layers; /* only valid without concurrent changes */
 	int		  id_free_cnt;
 	spinlock_t	  lock;
 };
diff -puN lib/idr.c~lib-idrc-fix-rcu-related-race-with-idr_find lib/idr.c
--- a/lib/idr.c~lib-idrc-fix-rcu-related-race-with-idr_find
+++ a/lib/idr.c
@@ -185,6 +185,7 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
+			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -210,6 +211,7 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
+		p->layer = 0;
 		layers = 1;
 	}
 	/*
@@ -237,6 +239,7 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
+		new->layer = layers-1;
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
@@ -493,17 +496,21 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	n = idp->layers * IDR_BITS;
 	p = rcu_dereference(idp->top);
+	if (!p)
+		return NULL;
+	n = (p->layer+1) * IDR_BITS;
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
 
 	if (id >= (1 << n))
 		return NULL;
+	BUG_ON(n == 0);
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
+		BUG_ON(n != p->layer*IDR_BITS);
 		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
@@ -582,8 +589,11 @@ void *idr_replace(struct idr *idp, void 
 	int n;
 	struct idr_layer *p, *old_p;
 
-	n = idp->layers * IDR_BITS;
 	p = idp->top;
+	if (!p)
+		return ERR_PTR(-EINVAL);
+
+	n = (p->layer+1) * IDR_BITS;
 
 	id &= MAX_ID_MASK;
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

repeatable-slab-corruption-with-ltp-msgctl08.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

