From: akpm@linux-foundation.org
Subject: + idr-introduce-ridr_remove.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:16 -0700
Message-ID: <200804291901.m3TJ1GkN004470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764110AbYD2TKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: introduce ridr_remove()
has been added to the -mm tree.  Its filename is
     idr-introduce-ridr_remove.patch

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
Subject: idr: introduce ridr_remove()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_remove() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h  |    1 
 include/linux/ridr.h |    1 
 lib/idr.c            |    7 +--
 lib/ridr.c           |   83 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 3 deletions(-)

diff -puN include/linux/idr.h~idr-introduce-ridr_remove include/linux/idr.h
--- a/include/linux/idr.h~idr-introduce-ridr_remove
+++ a/include/linux/idr.h
@@ -91,6 +91,7 @@ static inline void _idr_set_new_slot(str
 
 void _idr_mark_full(struct idr_layer **, int);
 int _idr_sub_alloc(int *, int *, struct idr_layer **, struct idr_layer **);
+void _idr_remove_warning(const char *, int);
 
 /*
  * This is what we export.
diff -puN include/linux/ridr.h~idr-introduce-ridr_remove include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_remove
+++ a/include/linux/ridr.h
@@ -63,6 +63,7 @@ void *ridr_find(struct ridr *, int);
 int ridr_pre_get(struct ridr *, gfp_t);
 int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
+void ridr_remove(struct ridr *, int);
 void ridr_init(struct ridr *);
 
 
diff -puN lib/idr.c~idr-introduce-ridr_remove lib/idr.c
--- a/lib/idr.c~idr-introduce-ridr_remove
+++ a/lib/idr.c
@@ -356,9 +356,10 @@ int idr_get_new(struct idr *idp, void *p
 }
 EXPORT_SYMBOL(idr_get_new);
 
-static void idr_remove_warning(int id)
+void _idr_remove_warning(const char *caller, int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_INFO "%s called for id=%d which is not allocated.\n",
+		caller, id);
 	dump_stack();
 }
 
@@ -390,7 +391,7 @@ static void sub_remove(struct idr *idp, 
 		if (!*paa)
 			idp->layers = 0;
 	} else
-		idr_remove_warning(id);
+		_idr_remove_warning("idr_remove", id);
 }
 
 /**
diff -puN lib/ridr.c~idr-introduce-ridr_remove lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_remove
+++ a/lib/ridr.c
@@ -28,6 +28,19 @@ static struct ridr_layer *get_from_free_
 	return(q);
 }
 
+static void ridr_layer_rcu_free(struct rcu_head *head)
+{
+	struct ridr_layer *layer;
+
+	layer = container_of(head, struct ridr_layer, rcu_head);
+	kmem_cache_free(ridr_layer_cache, layer);
+}
+
+static inline void free_layer(struct ridr_layer *p)
+{
+	call_rcu(&p->rcu_head, ridr_layer_rcu_free);
+}
+
 /* only called when idp->lock is held */
 /* moves an ridr_layer to the free list */
 static void __move_to_free_list(struct ridr *idp, struct ridr_layer *p)
@@ -259,6 +272,76 @@ int ridr_get_new(struct ridr *idp, void 
 }
 EXPORT_SYMBOL(ridr_get_new);
 
+static void sub_remove(struct ridr *idp, int shift, int id)
+{
+	struct ridr_layer *p = idp->top;
+	struct ridr_layer **pa[MAX_LEVEL];
+	struct ridr_layer ***paa = &pa[0];
+	struct ridr_layer *to_free;
+	int n;
+
+	*paa = NULL;
+	*++paa = &idp->top;
+
+	while ((shift > 0) && p) {
+		n = (id >> shift) & IDR_MASK;
+		__clear_bit(n, &p->idr.bitmap);
+		*++paa = (struct ridr_layer **) &(p->idr.ary[n]);
+		p = p->idr.ary[n];
+		shift -= IDR_BITS;
+	}
+	n = id & IDR_MASK;
+	if (likely(p != NULL && test_bit(n, &p->idr.bitmap))) {
+		__clear_bit(n, &p->idr.bitmap);
+		rcu_assign_pointer(p->idr.ary[n], NULL);
+		to_free = NULL;
+		while (*paa && !--((**paa)->idr.count)) {
+			if (to_free)
+				free_layer(to_free);
+			to_free = **paa;
+			**paa-- = NULL;
+		}
+		if (!*paa)
+			idp->layers = 0;
+		if (to_free)
+			free_layer(to_free);
+	} else
+		_idr_remove_warning("ridr_remove", id);
+}
+/**
+ * ridr_remove - remove the given id and free it's slot
+ * @idp: ridr handle
+ * @id: unique key
+ */
+void ridr_remove(struct ridr *idp, int id)
+{
+	struct ridr_layer *p;
+	struct ridr_layer *to_free;
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
+	if (idp->top && idp->top->idr.count == 1 && (idp->layers > 1) &&
+	    idp->top->idr.ary[0]) {
+		/*
+		 * Single child at leftmost slot: we can shrink the tree.
+		 * This level is not needed anymore since when layers are
+		 * inserted, they are inserted at the top of the existing
+		 * tree.
+		 */
+		to_free = idp->top;
+		p = idp->top->idr.ary[0];
+		rcu_assign_pointer(idp->top, p);
+		--idp->layers;
+		to_free->idr.bitmap = to_free->idr.count = 0;
+		to_free->idr.ary[0] = NULL;
+		free_layer(to_free);
+	}
+	return;
+}
+EXPORT_SYMBOL(ridr_remove);
+
 /**
  * ridr_find - return pointer for given id
  * @idp: ridr handle
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

