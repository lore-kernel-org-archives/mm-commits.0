From: akpm@linux-foundation.org
Subject: + idr-introduce-ridr_get_new_above.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:10 -0700
Message-ID: <200804291901.m3TJ1AuT004458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbYD2THg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: introduce ridr_get_new_above()
has been added to the -mm tree.  Its filename is
     idr-introduce-ridr_get_new_above.patch

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
Subject: idr: introduce ridr_get_new_above()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_get_new_above() routine, and some common code between the
idr an ridr API's.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h  |   21 ++++
 include/linux/ridr.h |    1 
 lib/idr.c            |  151 +++++++++++++++++++++--------------
 lib/ridr.c           |  175 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 287 insertions(+), 61 deletions(-)

diff -puN include/linux/idr.h~idr-introduce-ridr_get_new_above include/linux/idr.h
--- a/include/linux/idr.h~idr-introduce-ridr_get_new_above
+++ a/include/linux/idr.h
@@ -71,6 +71,27 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
+/* Actions to be taken after a call to _idr_sub_alloc */
+#define IDR_DONE         -1
+#define IDR_NEED_TO_GROW -2
+#define IDR_NOMORE_SPACE -3
+#define IDR_GO_TOP       -4
+#define IDR_GO_UP        -5
+
+#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
+
+static inline void _idr_set_new_slot(struct idr_layer *new,
+						struct idr_layer *p)
+{
+	new->ary[0] = p;
+	new->count = 1;
+	if (p->bitmap == IDR_FULL)
+		__set_bit(0, &new->bitmap);
+}
+
+void _idr_mark_full(struct idr_layer **, int);
+int _idr_sub_alloc(int *, int *, struct idr_layer **, struct idr_layer **);
+
 /*
  * This is what we export.
  */
diff -puN include/linux/ridr.h~idr-introduce-ridr_get_new_above include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_get_new_above
+++ a/include/linux/ridr.h
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+int ridr_get_new_above(struct ridr *, void *, int, int *);
 void ridr_init(struct ridr *);
 
 
diff -puN lib/idr.c~idr-introduce-ridr_get_new_above lib/idr.c
--- a/lib/idr.c~idr-introduce-ridr_get_new_above
+++ a/lib/idr.c
@@ -70,7 +70,7 @@ static void free_layer(struct idr *idp, 
 	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
-static void idr_mark_full(struct idr_layer **pa, int id)
+void _idr_mark_full(struct idr_layer **pa, int id)
 {
 	struct idr_layer *p = pa[0];
 	int l = 0;
@@ -115,12 +115,71 @@ int idr_pre_get(struct idr *idp, gfp_t g
 }
 EXPORT_SYMBOL(idr_pre_get);
 
-static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
+int _idr_sub_alloc(int *cur_id, int *layer, struct idr_layer **cur_ptr,
+	struct idr_layer **pa)
 {
 	int n, m, sh;
-	struct idr_layer *p, *new;
-	int l, id, oid;
+	int l = *layer;
+	int id = *cur_id;
 	unsigned long bm;
+	struct idr_layer *p = *cur_ptr;
+	int rc;
+
+	n = (id >> (IDR_BITS * l)) & IDR_MASK;
+	bm = ~p->bitmap;
+	m = find_next_bit(&bm, IDR_SIZE, n);
+	if (m == IDR_SIZE) {
+		int oid;
+
+		/* no space available go back to previous layer. */
+		l++;
+		oid = id;
+		id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
+
+		/* if already at the top layer, we need to grow */
+		p = pa[l];
+		if (!p) {
+			*cur_id = id;
+			return IDR_NEED_TO_GROW;
+		}
+
+		/* If we need to go up one layer, continue the
+		 * loop; otherwise, restart from the top.
+		 */
+		*cur_id = id;
+		*layer = l;
+		*cur_ptr = p;
+		sh = IDR_BITS * (l + 1);
+		if (oid >> sh == id >> sh)
+			rc = IDR_GO_UP;
+		else
+			rc = IDR_GO_TOP;
+		goto end_sub_alloc;
+	}
+	if (m != n) {
+		sh = IDR_BITS * l;
+		id = ((id >> sh) ^ n ^ m) << sh;
+	}
+	if ((id >= MAX_ID_BIT) || (id < 0))
+		return IDR_NOMORE_SPACE;
+
+	if (l == 0)
+		rc = IDR_DONE;
+	else
+		rc = m;
+end_sub_alloc:
+	*cur_id = id;
+	*layer = l;
+	*cur_ptr = p;
+
+	return rc;
+}
+
+static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
+{
+	int m;
+	struct idr_layer *p, *new;
+	int l, id;
 
 	id = *starting_id;
  restart:
@@ -131,38 +190,23 @@ static int sub_alloc(struct idr *idp, in
 		/*
 		 * We run around this while until we reach the leaf node...
 		 */
-		n = (id >> (IDR_BITS*l)) & IDR_MASK;
-		bm = ~p->bitmap;
-		m = find_next_bit(&bm, IDR_SIZE, n);
-		if (m == IDR_SIZE) {
-			/* no space available go back to previous layer. */
-			l++;
-			oid = id;
-			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
-
-			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
-				*starting_id = id;
-				return -2;
-			}
-
-			/* If we need to go up one layer, continue the
-			 * loop; otherwise, restart from the top.
-			 */
-			sh = IDR_BITS * (l + 1);
-			if (oid >> sh == id >> sh)
-				continue;
-			else
-				goto restart;
-		}
-		if (m != n) {
-			sh = IDR_BITS*l;
-			id = ((id >> sh) ^ n ^ m) << sh;
-		}
-		if ((id >= MAX_ID_BIT) || (id < 0))
-			return -3;
-		if (l == 0)
+		int action = _idr_sub_alloc(&id, &l, &p, pa);
+		switch (action) {
+		case IDR_NEED_TO_GROW:
+			*starting_id = id;
+		case IDR_NOMORE_SPACE:
+			return action;
+		case IDR_DONE:
+			goto end_loop;
+		case IDR_GO_UP:
+			continue;
+		case IDR_GO_TOP:
+			goto restart;
+		default:
+			m = action;
 			break;
+		}
+		BUG_ON(m < 0);
 		/*
 		 * Create the layer below if it is missing.
 		 */
@@ -175,7 +219,7 @@ static int sub_alloc(struct idr *idp, in
 		pa[l--] = p;
 		p = p->ary[m];
 	}
-
+end_loop:
 	pa[l] = p;
 	return id;
 }
@@ -219,16 +263,13 @@ build_up:
 			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
 		}
-		new->ary[0] = p;
-		new->count = 1;
-		if (p->bitmap == IDR_FULL)
-			__set_bit(0, &new->bitmap);
+		_idr_set_new_slot(new, p);
 		p = new;
 	}
 	idp->top = p;
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == -2)
+	if (v == IDR_NEED_TO_GROW)
 		goto build_up;
 	return(v);
 }
@@ -246,7 +287,7 @@ static int idr_get_new_above_int(struct 
 		 */
 		pa[0]->ary[id & IDR_MASK] = (struct idr_layer *)ptr;
 		pa[0]->count++;
-		idr_mark_full(pa, id);
+		_idr_mark_full(pa, id);
 	}
 
 	return id;
@@ -277,12 +318,8 @@ int idr_get_new_above(struct idr *idp, v
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -312,12 +349,8 @@ int idr_get_new(struct idr *idp, void *p
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -694,12 +727,8 @@ int ida_get_new_above(struct ida *ida, i
  restart:
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
-	if (t < 0) {
-		if (t == -1)
-			return -EAGAIN;
-		else /* will be -3 */
-			return -ENOSPC;
-	}
+	if (t < 0)
+		return _idr_rc_to_errno(t);
 
 	if (t * IDA_BITMAP_BITS >= MAX_ID_BIT)
 		return -ENOSPC;
@@ -739,7 +768,7 @@ int ida_get_new_above(struct ida *ida, i
 
 	__set_bit(t, bitmap->bitmap);
 	if (++bitmap->nr_busy == IDA_BITMAP_BITS)
-		idr_mark_full(pa, idr_id);
+		_idr_mark_full(pa, idr_id);
 
 	*p_id = id;
 
diff -puN lib/ridr.c~idr-introduce-ridr_get_new_above lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_get_new_above
+++ a/lib/ridr.c
@@ -11,6 +11,23 @@
 static struct kmem_cache *ridr_layer_cache;
 
 
+static struct ridr_layer *get_from_free_list(struct ridr *idp)
+{
+	struct ridr_layer *q;
+	struct idr_layer *p;
+	unsigned long flags;
+
+	spin_lock_irqsave(&idp->lock, flags);
+	if ((q = idp->id_free)) {
+		p = ridr_to_idr(q);
+		idp->id_free = p->ary[0];
+		idp->id_free_cnt--;
+		p->ary[0] = NULL;
+	}
+	spin_unlock_irqrestore(&idp->lock, flags);
+	return(q);
+}
+
 /* only called when idp->lock is held */
 /* moves an ridr_layer to the free list */
 static void __move_to_free_list(struct ridr *idp, struct ridr_layer *p)
@@ -57,6 +74,164 @@ int ridr_pre_get(struct ridr *idp, gfp_t
 }
 EXPORT_SYMBOL(ridr_pre_get);
 
+static int sub_alloc(struct ridr *idp, int *starting_id,
+			struct ridr_layer **rpa, struct idr_layer **pa)
+{
+	int m;
+	struct ridr_layer *q, *new;
+	struct idr_layer *p;
+	int l, id;
+
+	id = *starting_id;
+ restart:
+	q = idp->top;
+	p = ridr_to_idr(q);
+	l = idp->layers;
+	pa[l] = NULL;
+	rpa[l--] = NULL;
+	while (1) {
+		/*
+		 * We run around this while until we reach the leaf node...
+		 */
+		int action = _idr_sub_alloc(&id, &l, &p, pa);
+		switch (action) {
+		case IDR_NEED_TO_GROW:
+			*starting_id = id;
+		case IDR_NOMORE_SPACE:
+			return action;
+		case IDR_DONE:
+			goto end_loop;
+		case IDR_GO_UP:
+			continue;
+		case IDR_GO_TOP:
+			goto restart;
+		default:
+			m = action;
+			break;
+		}
+		BUG_ON(m < 0);
+		/*
+		 * Create the layer below if it is missing.
+		 */
+		if (!p->ary[m]) {
+			new = get_from_free_list(idp);
+			if (!new)
+				return -1;
+			rcu_assign_pointer(p->ary[m], new);
+			p->count++;
+		}
+		pa[l] = p;
+		rpa[l--] = idr_to_ridr(p);
+		p = p->ary[m];
+	}
+
+end_loop:
+	pa[l] = p;
+	rpa[l] = idr_to_ridr(p);
+	return id;
+}
+
+static int ridr_get_empty_slot(struct ridr *idp, int starting_id,
+			      struct ridr_layer **rpa, struct idr_layer **pa)
+{
+	struct ridr_layer *p, *rnew;
+	int layers, v, id;
+	unsigned long flags;
+
+	id = starting_id;
+build_up:
+	p = idp->top;
+	layers = idp->layers;
+	if (unlikely(!p)) {
+		p = get_from_free_list(idp);
+		if (!p)
+			return -1;
+		layers = 1;
+	}
+	/*
+	 * Add a new layer to the top of the tree if the requested
+	 * id is larger than the currently allocated space.
+	 */
+	while (layers < MAX_LEVEL - 1 && id >= (1 << (layers * IDR_BITS))) {
+		layers++;
+		if (!p->idr.count)
+			continue;
+		rnew = get_from_free_list(idp);
+		if (!rnew) {
+			/*
+			 * The allocation failed.  If we built part of
+			 * the structure tear it down.
+			 */
+			spin_lock_irqsave(&idp->lock, flags);
+			for (rnew = p; p && p != idp->top; rnew = p) {
+				p = p->idr.ary[0];
+				rnew->idr.ary[0] = NULL;
+				rnew->idr.bitmap = rnew->idr.count = 0;
+				__move_to_free_list(idp, rnew);
+			}
+			spin_unlock_irqrestore(&idp->lock, flags);
+			return -1;
+		}
+		_idr_set_new_slot(ridr_to_idr(rnew), ridr_to_idr(p));
+		p = rnew;
+	}
+	rcu_assign_pointer(idp->top, p);
+	idp->layers = layers;
+	v = sub_alloc(idp, &id, rpa, pa);
+	if (v == IDR_NEED_TO_GROW)
+		goto build_up;
+	return(v);
+}
+
+static int ridr_get_new_above_int(struct ridr *idp, void *ptr, int starting_id)
+{
+	struct ridr_layer *rpa[MAX_LEVEL];
+	struct idr_layer *pa[MAX_LEVEL];
+	int id;
+
+	id = ridr_get_empty_slot(idp, starting_id, rpa, pa);
+	if (id >= 0) {
+		/*
+		 * Successfully found an empty slot.  Install the user
+		 * pointer and mark the slot full.
+		 */
+		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
+				(struct ridr_layer *)ptr);
+		pa[0]->count++;
+		_idr_mark_full(pa, id);
+	}
+
+	return id;
+}
+
+/**
+ * ridr_get_new_above - allocate new ridr entry above or equal to a start id
+ * @idp: ridr handle
+ * @ptr: pointer you want associated with the ide
+ * @start_id: id to start search at
+ * @id: pointer to the allocated handle
+ *
+ * This is the allocate id function.  It should be called with any
+ * required locks.
+ *
+ * If memory is required, it will return -EAGAIN, you should unlock
+ * and go back to the ridr_pre_get() call.  If the ridr is full, it will
+ * return -ENOSPC.
+ *
+ * @id returns a value in the range 0 ... 0x7fffffff
+ */
+int ridr_get_new_above(struct ridr *idp, void *ptr, int starting_id, int *id)
+{
+	int rv;
+
+	rv = ridr_get_new_above_int(idp, ptr, starting_id);
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
+	*id = rv;
+	return 0;
+}
+EXPORT_SYMBOL(ridr_get_new_above);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
ipc-add-definitions-of-ushort_max-and-others.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

