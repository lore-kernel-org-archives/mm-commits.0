From: akpm@linux-foundation.org
Subject: + idr-introduce-ridr_init.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:01:08 -0700
Message-ID: <200804291901.m3TJ18nH004455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324AbYD2THg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: introduce ridr_init()
has been added to the -mm tree.  Its filename is
     idr-introduce-ridr_init.patch

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
Subject: idr: introduce ridr_init()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_init() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ridr.h |    1 +
 lib/ridr.c           |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/ridr.h~idr-introduce-ridr_init include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_init
+++ a/include/linux/ridr.h
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+void ridr_init(struct ridr *);
 
 
 void __init ridr_init_cache(void);
diff -puN lib/ridr.c~idr-introduce-ridr_init lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_init
+++ a/lib/ridr.c
@@ -70,3 +70,17 @@ void __init ridr_init_cache(void)
 				ridr_cache_ctor);
 }
 
+/**
+ * ridr_init - initialize ridr handle
+ * @idp:	ridr handle
+ *
+ * This function is used to set up the handle (@idp) that you will pass
+ * to the rest of the functions.
+ */
+void ridr_init(struct ridr *idp)
+{
+	memset(idp, 0, sizeof(struct ridr));
+	spin_lock_init(&idp->lock);
+}
+EXPORT_SYMBOL(ridr_init);
+
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

