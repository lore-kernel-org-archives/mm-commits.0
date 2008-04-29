From: akpm@linux-foundation.org
Subject: + idr-introduce-ridr_find.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:14 -0700
Message-ID: <200804291901.m3TJ1EYl004464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbYD2TC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: introduce ridr_find()
has been added to the -mm tree.  Its filename is
     idr-introduce-ridr_find.patch

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
Subject: idr: introduce ridr_find()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_find() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ridr.h |   17 +++++++++++++++++
 lib/ridr.c           |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff -puN include/linux/ridr.h~idr-introduce-ridr_find include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_find
+++ a/include/linux/ridr.h
@@ -40,9 +40,26 @@ struct ridr {
 #define idr_to_ridr(p) container_of((p), struct ridr_layer, idr)
 #define ridr_to_idr(p) (&((p)->idr))
 
+/**
+ * Ridr synchronization (see radix-tree.h)
+ *
+ * ridr_find() is able to be called locklessly, using RCU. The caller must
+ * ensure calls to this function are made within rcu_read_lock() regions.
+ * Other readers (lock-free or otherwise) and modifications may be running
+ * concurrently.
+ *
+ * It is still required that the caller manage the synchronization and
+ * lifetimes of the items. So if RCU lock-free lookups are used, typically
+ * this would mean that the items have their own locks, or are amenable to
+ * lock-free access; and that the items are freed by RCU (or only freed after
+ * having been deleted from the ridr tree *and* a synchronize_rcu() grace
+ * period).
+ */
+
 /*
  * This is what we export.
  */
+void *ridr_find(struct ridr *, int);
 int ridr_pre_get(struct ridr *, gfp_t);
 int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
diff -puN lib/ridr.c~idr-introduce-ridr_find lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_find
+++ a/lib/ridr.c
@@ -259,6 +259,40 @@ int ridr_get_new(struct ridr *idp, void 
 }
 EXPORT_SYMBOL(ridr_get_new);
 
+/**
+ * ridr_find - return pointer for given id
+ * @idp: ridr handle
+ * @id: lookup key
+ *
+ * Return the pointer given the id it has been registered with.  A %NULL
+ * return indicates that @id is not valid or you passed %NULL in
+ * ridr_get_new().
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
+ */
+void *ridr_find(struct ridr *idp, int id)
+{
+	int n;
+	struct ridr_layer *p;
+
+	n = idp->layers * IDR_BITS;
+	p = rcu_dereference(idp->top);
+
+	/* Mask off upper bits we don't use for the search. */
+	id &= MAX_ID_MASK;
+
+	if (id >= (1 << n))
+		return NULL;
+
+	while (n > 0 && p) {
+		n -= IDR_BITS;
+		p = rcu_dereference(p->idr.ary[(id >> n) & IDR_MASK]);
+	}
+	return((void *)p);
+}
+EXPORT_SYMBOL(ridr_find);
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

