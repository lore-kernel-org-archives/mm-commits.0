From: akpm@linux-foundation.org
Subject: - idr-introduce-ridr_get_new.patch removed from -mm tree
Date: Mon, 05 May 2008 09:28:47 -0700
Message-ID: <200805051628.m45GSleR025495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbYEEQaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 12:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: introduce ridr_get_new()
has been removed from the -mm tree.  Its filename was
     idr-introduce-ridr_get_new.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: introduce ridr_get_new()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_get_new() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ridr.h |    1 +
 lib/ridr.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/ridr.h~idr-introduce-ridr_get_new include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_get_new
+++ a/include/linux/ridr.h
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+int ridr_get_new(struct ridr *, void *, int *);
 int ridr_get_new_above(struct ridr *, void *, int, int *);
 void ridr_init(struct ridr *);
 
diff -puN lib/ridr.c~idr-introduce-ridr_get_new lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_get_new
+++ a/lib/ridr.c
@@ -232,6 +232,33 @@ int ridr_get_new_above(struct ridr *idp,
 }
 EXPORT_SYMBOL(ridr_get_new_above);
 
+/**
+ * ridr_get_new - allocate new ridr entry
+ * @idp: ridr handle
+ * @ptr: pointer you want associated with the ide
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
+int ridr_get_new(struct ridr *idp, void *ptr, int *id)
+{
+	int rv;
+
+	rv = ridr_get_new_above_int(idp, ptr, 0);
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
+	*id = rv;
+	return 0;
+}
+EXPORT_SYMBOL(ridr_get_new);
+
 static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
 			void *ridr_layer)
 {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

