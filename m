From: akpm@linux-foundation.org
Subject: + idr-introduce-ridr_get_new.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:12 -0700
Message-ID: <200804291901.m3TJ1Cq6004461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758283AbYD2TPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: introduce ridr_get_new()
has been added to the -mm tree.  Its filename is
     idr-introduce-ridr_get_new.patch

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

