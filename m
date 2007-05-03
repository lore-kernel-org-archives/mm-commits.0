From: akpm@linux-foundation.org
Subject: - idr-separate-out-idr_mark_full.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:56 -0700
Message-ID: <200705031930.l43JUuBK018222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767825AbXECTdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: teheo@suse.de, greg@kroah.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: separate out idr_mark_full()
has been removed from the -mm tree.  Its filename was
     idr-separate-out-idr_mark_full.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: idr: separate out idr_mark_full()
From: Tejun Heo <teheo@suse.de>

Separate out idr_mark_full() from sub_alloc() and make marking the
allocated slot full the responsibility of idr_get_new_above_int().

Allocation part of idr_get_new_above_int() is renamed to
idr_get_empty_slot().  New idr_get_new_above_int() allocates a slot using
the function, install the user pointer and marks it full using
idr_mark_full().

This change doesn't introduce any behavior change.  This will be
used by ida.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   71 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 25 deletions(-)

diff -puN lib/idr.c~idr-separate-out-idr_mark_full lib/idr.c
--- a/lib/idr.c~idr-separate-out-idr_mark_full
+++ a/lib/idr.c
@@ -70,6 +70,26 @@ static void free_layer(struct idr *idp, 
 	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
+static void idr_mark_full(struct idr_layer **pa, int id)
+{
+	struct idr_layer *p = pa[0];
+	int l = 0;
+
+	__set_bit(id & IDR_MASK, &p->bitmap);
+	/*
+	 * If this layer is full mark the bit in the layer above to
+	 * show that this part of the radix tree is full.  This may
+	 * complete the layer above and require walking up the radix
+	 * tree.
+	 */
+	while (p->bitmap == IDR_FULL) {
+		if (!(p = pa[++l]))
+			break;
+		id = id >> IDR_BITS;
+		__set_bit((id & IDR_MASK), &p->bitmap);
+	}
+}
+
 /**
  * idr_pre_get - reserver resources for idr allocation
  * @idp:	idr handle
@@ -95,11 +115,10 @@ int idr_pre_get(struct idr *idp, gfp_t g
 }
 EXPORT_SYMBOL(idr_pre_get);
 
-static int sub_alloc(struct idr *idp, void *ptr, int *starting_id)
+static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 {
 	int n, m, sh;
 	struct idr_layer *p, *new;
-	struct idr_layer *pa[MAX_LEVEL];
 	int l, id, oid;
 	long bm;
 
@@ -156,30 +175,13 @@ static int sub_alloc(struct idr *idp, vo
 		pa[l--] = p;
 		p = p->ary[m];
 	}
-	/*
-	 * We have reached the leaf node, plant the
-	 * users pointer and return the raw id.
-	 */
-	p->ary[m] = (struct idr_layer *)ptr;
-	__set_bit(m, &p->bitmap);
-	p->count++;
-	/*
-	 * If this layer is full mark the bit in the layer above
-	 * to show that this part of the radix tree is full.
-	 * This may complete the layer above and require walking
-	 * up the radix tree.
-	 */
-	n = id;
-	while (p->bitmap == IDR_FULL) {
-		if (!(p = pa[++l]))
-			break;
-		n = n >> IDR_BITS;
-		__set_bit((n & IDR_MASK), &p->bitmap);
-	}
-	return(id);
+
+	pa[l] = p;
+	return id;
 }
 
-static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
+static int idr_get_empty_slot(struct idr *idp, int starting_id,
+			      struct idr_layer **pa)
 {
 	struct idr_layer *p, *new;
 	int layers, v, id;
@@ -225,12 +227,31 @@ build_up:
 	}
 	idp->top = p;
 	idp->layers = layers;
-	v = sub_alloc(idp, ptr, &id);
+	v = sub_alloc(idp, &id, pa);
 	if (v == -2)
 		goto build_up;
 	return(v);
 }
 
+static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
+{
+	struct idr_layer *pa[MAX_LEVEL];
+	int id;
+
+	id = idr_get_empty_slot(idp, starting_id, pa);
+	if (id >= 0) {
+		/*
+		 * Successfully found an empty slot.  Install the user
+		 * pointer and mark the slot full.
+		 */
+		pa[0]->ary[id & IDR_MASK] = (struct idr_layer *)ptr;
+		pa[0]->count++;
+		idr_mark_full(pa, id);
+	}
+
+	return id;
+}
+
 /**
  * idr_get_new_above - allocate new idr entry above or equal to a start id
  * @idp: idr handle
_

Patches currently in -mm which might be from teheo@suse.de are
