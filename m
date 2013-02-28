From: akpm@linux-foundation.org
Subject: [merged] idr-remove-length-restriction-from-idr_layer-bitmap.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:11 -0800
Message-ID: <20130228201611.EF82D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:55544 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:13 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261461qah.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: remove length restriction from idr_layer->bitmap
has been removed from the -mm tree.  Its filename was
     idr-remove-length-restriction-from-idr_layer-bitmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: remove length restriction from idr_layer->bitmap

Currently, idr->bitmap is declared as an unsigned long which restricts
the number of bits an idr_layer can contain.  All bitops can handle
arbitrary positive integer bit number and there's no reason for this
restriction.

Declare idr_layer->bitmap using DECLARE_BITMAP() instead of a single
unsigned long.

* idr_layer->bitmap is now an array.  '&' dropped from params to
  bitops.

* Replaced "== IDR_FULL" tests with bitmap_full() and removed
  IDR_FULL.

* Replaced find_next_bit() on ~bitmap with find_next_zero_bit().

* Replaced "bitmap = 0" with bitmap_clear().

This patch doesn't (or at least shouldn't) introduce any behavior
changes.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   12 +-----------
 lib/idr.c           |   34 +++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff -puN include/linux/idr.h~idr-remove-length-restriction-from-idr_layer-bitmap include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-length-restriction-from-idr_layer-bitmap
+++ a/include/linux/idr.h
@@ -19,18 +19,8 @@
 
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
-# define IDR_FULL 0xfffffffful
-/* We can only use two of the bits in the top level because there is
-   only one possible bit in the top level (5 bits * 7 levels = 35
-   bits, but you only use 31 bits in the id). */
-# define TOP_LEVEL_FULL (IDR_FULL >> 30)
 #elif BITS_PER_LONG == 64
 # define IDR_BITS 6
-# define IDR_FULL 0xfffffffffffffffful
-/* We can only use two of the bits in the top level because there is
-   only one possible bit in the top level (6 bits * 6 levels = 36
-   bits, but you only use 31 bits in the id). */
-# define TOP_LEVEL_FULL (IDR_FULL >> 62)
 #else
 # error "BITS_PER_LONG is not 32 or 64"
 #endif
@@ -39,7 +29,7 @@
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
 struct idr_layer {
-	unsigned long		bitmap;	/* A zero bit means "space here" */
+	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			count;	/* When zero, we can release it */
 	int			layer;	/* distance from leaf */
diff -puN lib/idr.c~idr-remove-length-restriction-from-idr_layer-bitmap lib/idr.c
--- a/lib/idr.c~idr-remove-length-restriction-from-idr_layer-bitmap
+++ a/lib/idr.c
@@ -157,18 +157,18 @@ static void idr_mark_full(struct idr_lay
 	struct idr_layer *p = pa[0];
 	int l = 0;
 
-	__set_bit(id & IDR_MASK, &p->bitmap);
+	__set_bit(id & IDR_MASK, p->bitmap);
 	/*
 	 * If this layer is full mark the bit in the layer above to
 	 * show that this part of the radix tree is full.  This may
 	 * complete the layer above and require walking up the radix
 	 * tree.
 	 */
-	while (p->bitmap == IDR_FULL) {
+	while (bitmap_full(p->bitmap, IDR_SIZE)) {
 		if (!(p = pa[++l]))
 			break;
 		id = id >> IDR_BITS;
-		__set_bit((id & IDR_MASK), &p->bitmap);
+		__set_bit((id & IDR_MASK), p->bitmap);
 	}
 }
 
@@ -221,7 +221,6 @@ static int sub_alloc(struct idr *idp, in
 	int n, m, sh;
 	struct idr_layer *p, *new;
 	int l, id, oid;
-	unsigned long bm;
 
 	id = *starting_id;
  restart:
@@ -233,8 +232,7 @@ static int sub_alloc(struct idr *idp, in
 		 * We run around this while until we reach the leaf node...
 		 */
 		n = (id >> (IDR_BITS*l)) & IDR_MASK;
-		bm = ~p->bitmap;
-		m = find_next_bit(&bm, IDR_SIZE, n);
+		m = find_next_zero_bit(p->bitmap, IDR_SIZE, n);
 		if (m == IDR_SIZE) {
 			/* no space available go back to previous layer. */
 			l++;
@@ -326,7 +324,8 @@ build_up:
 			for (new = p; p && p != idp->top; new = p) {
 				p = p->ary[0];
 				new->ary[0] = NULL;
-				new->bitmap = new->count = 0;
+				new->count = 0;
+				bitmap_clear(new->bitmap, 0, IDR_SIZE);
 				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
@@ -335,8 +334,8 @@ build_up:
 		new->ary[0] = p;
 		new->count = 1;
 		new->layer = layers-1;
-		if (p->bitmap == IDR_FULL)
-			__set_bit(0, &new->bitmap);
+		if (bitmap_full(p->bitmap, IDR_SIZE))
+			__set_bit(0, new->bitmap);
 		p = new;
 	}
 	rcu_assign_pointer(idp->top, p);
@@ -517,14 +516,14 @@ static void sub_remove(struct idr *idp, 
 
 	while ((shift > 0) && p) {
 		n = (id >> shift) & IDR_MASK;
-		__clear_bit(n, &p->bitmap);
+		__clear_bit(n, p->bitmap);
 		*++paa = &p->ary[n];
 		p = p->ary[n];
 		shift -= IDR_BITS;
 	}
 	n = id & IDR_MASK;
-	if (likely(p != NULL && test_bit(n, &p->bitmap))){
-		__clear_bit(n, &p->bitmap);
+	if (likely(p != NULL && test_bit(n, p->bitmap))) {
+		__clear_bit(n, p->bitmap);
 		rcu_assign_pointer(p->ary[n], NULL);
 		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
@@ -567,7 +566,8 @@ void idr_remove(struct idr *idp, int id)
 		p = idp->top->ary[0];
 		rcu_assign_pointer(idp->top, p);
 		--idp->layers;
-		to_free->bitmap = to_free->count = 0;
+		to_free->count = 0;
+		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
 		free_layer(to_free);
 	}
 	while (idp->id_free_cnt >= MAX_IDR_FREE) {
@@ -827,7 +827,7 @@ void *idr_replace(struct idr *idp, void 
 	}
 
 	n = id & IDR_MASK;
-	if (unlikely(p == NULL || !test_bit(n, &p->bitmap)))
+	if (unlikely(p == NULL || !test_bit(n, p->bitmap)))
 		return ERR_PTR(-ENOENT);
 
 	old_p = p->ary[n];
@@ -1024,7 +1024,7 @@ void ida_remove(struct ida *ida, int id)
 	/* clear full bits while looking up the leaf idr_layer */
 	while ((shift > 0) && p) {
 		n = (idr_id >> shift) & IDR_MASK;
-		__clear_bit(n, &p->bitmap);
+		__clear_bit(n, p->bitmap);
 		p = p->ary[n];
 		shift -= IDR_BITS;
 	}
@@ -1033,7 +1033,7 @@ void ida_remove(struct ida *ida, int id)
 		goto err;
 
 	n = idr_id & IDR_MASK;
-	__clear_bit(n, &p->bitmap);
+	__clear_bit(n, p->bitmap);
 
 	bitmap = (void *)p->ary[n];
 	if (!test_bit(offset, bitmap->bitmap))
@@ -1042,7 +1042,7 @@ void ida_remove(struct ida *ida, int id)
 	/* update bitmap and remove it if empty */
 	__clear_bit(offset, bitmap->bitmap);
 	if (--bitmap->nr_busy == 0) {
-		__set_bit(n, &p->bitmap);	/* to please idr_remove() */
+		__set_bit(n, p->bitmap);	/* to please idr_remove() */
 		idr_remove(&ida->idr, idr_id);
 		free_bitmap(ida, bitmap);
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

