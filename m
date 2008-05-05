From: akpm@linux-foundation.org
Subject: - idr-introduce-ridr_pre_get.patch removed from -mm tree
Date: Mon, 05 May 2008 09:28:41 -0700
Message-ID: <200805051628.m45GSfd1025486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbYEEQaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 12:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: introduce ridr_pre_get()
has been removed from the -mm tree.  Its filename was
     idr-introduce-ridr_pre_get.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: introduce ridr_pre_get()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_pre_get() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ridr.h |    1 
 lib/ridr.c           |   46 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff -puN include/linux/ridr.h~idr-introduce-ridr_pre_get include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_pre_get
+++ a/include/linux/ridr.h
@@ -43,6 +43,7 @@ struct ridr {
 /*
  * This is what we export.
  */
+int ridr_pre_get(struct ridr *, gfp_t);
 
 
 void __init ridr_init_cache(void);
diff -puN lib/ridr.c~idr-introduce-ridr_pre_get lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_pre_get
+++ a/lib/ridr.c
@@ -11,6 +11,52 @@
 static struct kmem_cache *ridr_layer_cache;
 
 
+/* only called when idp->lock is held */
+/* moves an ridr_layer to the free list */
+static void __move_to_free_list(struct ridr *idp, struct ridr_layer *p)
+{
+	p->idr.ary[0] = idp->id_free;
+	idp->id_free = p;
+	idp->id_free_cnt++;
+}
+
+static void move_to_free_list(struct ridr *idp, struct ridr_layer *p)
+{
+	unsigned long flags;
+
+	/*
+	 * Depends on the return element being zeroed.
+	 */
+	spin_lock_irqsave(&idp->lock, flags);
+	__move_to_free_list(idp, p);
+	spin_unlock_irqrestore(&idp->lock, flags);
+}
+
+/**
+ * ridr_pre_get - reserver resources for ridr allocation
+ * @idp:	ridr handle
+ * @gfp_mask:	memory allocation flags
+ *
+ * This function should be called prior to locking and calling the
+ * ridr_get_new* functions. It preallocates enough memory to satisfy
+ * the worst possible allocation.
+ *
+ * If the system is REALLY out of memory this function returns 0,
+ * otherwise 1.
+ */
+int ridr_pre_get(struct ridr *idp, gfp_t gfp_mask)
+{
+	while (idp->id_free_cnt < IDR_FREE_MAX) {
+		struct ridr_layer *new;
+		new = kmem_cache_alloc(ridr_layer_cache, gfp_mask);
+		if (new == NULL)
+			return (0);
+		move_to_free_list(idp, new);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(ridr_pre_get);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

