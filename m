From: akpm@linux-foundation.org
Subject: + sysvipc-make-get_maxid-o1-again.patch added to -mm tree
Date: Tue, 03 Oct 2017 14:59:54 -0700
Message-ID: <59d4085a.k/F9GVKLiR0U+OON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCV7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: make get_maxid O(1) again
has been added to the -mm tree.  Its filename is
     sysvipc-make-get_maxid-o1-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysvipc-make-get_maxid-o1-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysvipc-make-get_maxid-o1-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: sysvipc: make get_maxid O(1) again

For a custom microbenchmark on a 3.30GHz Xeon SandyBridge, which calls
IPC_STAT over and over, it was calculated that, on avg the cost of
ipc_get_maxid() for increasing amounts of keys was:

10 keys: ~900 cycles
100 keys: ~15000 cycles
1000 keys: ~150000 cycles
10000 keys: ~2100000 cycles

This is unsurprising as maxid is currently O(n).

By having the max_id available in O(1) we save all those cycles for each
semctl(_STAT) command, the idr_find can be expensive -- which some real
(customer) workloads actually poll on.  Note that this used to be the
case, until 7ca7e564e04 ("ipc: store ipcs into IDRs").  The cost is the
extra idr_find when doing RMIDs, but we simply go backwards, and should
not take too many iterations to find the new value.

Link: http://lkml.kernel.org/r/20170831172049.14576-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 
 ipc/util.c                    |   43 +++++++++-----------------------
 ipc/util.h                    |   21 +++++++++++++--
 3 files changed, 32 insertions(+), 33 deletions(-)

diff -puN include/linux/ipc_namespace.h~sysvipc-make-get_maxid-o1-again include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~sysvipc-make-get_maxid-o1-again
+++ a/include/linux/ipc_namespace.h
@@ -18,6 +18,7 @@ struct ipc_ids {
 	bool tables_initialized;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
+	int max_id;
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	int next_id;
 #endif
diff -puN ipc/util.c~sysvipc-make-get_maxid-o1-again ipc/util.c
--- a/ipc/util.c~sysvipc-make-get_maxid-o1-again
+++ a/ipc/util.c
@@ -121,6 +121,7 @@ int ipc_init_ids(struct ipc_ids *ids)
 		return err;
 	idr_init(&ids->ipcs_idr);
 	ids->tables_initialized = true;
+	ids->max_id = -1;
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	ids->next_id = -1;
 #endif
@@ -187,36 +188,6 @@ static struct kern_ipc_perm *ipc_findkey
 	return NULL;
 }
 
-/**
- * ipc_get_maxid - get the last assigned id
- * @ids: ipc identifier set
- *
- * Called with ipc_ids.rwsem held.
- */
-int ipc_get_maxid(struct ipc_ids *ids)
-{
-	struct kern_ipc_perm *ipc;
-	int max_id = -1;
-	int total, id;
-
-	if (ids->in_use == 0)
-		return -1;
-
-	if (ids->in_use == IPCMNI)
-		return IPCMNI - 1;
-
-	/* Look for the last assigned id */
-	total = 0;
-	for (id = 0; id < IPCMNI && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
-		if (ipc != NULL) {
-			max_id = id;
-			total++;
-		}
-	}
-	return max_id;
-}
-
 #ifdef CONFIG_CHECKPOINT_RESTORE
 /*
  * Specify desired id for next allocated IPC object.
@@ -312,6 +283,9 @@ int ipc_addid(struct ipc_ids *ids, struc
 	}
 
 	ids->in_use++;
+	if (id > ids->max_id)
+		ids->max_id = id;
+
 	new->id = ipc_buildid(id, ids, new);
 
 	return id;
@@ -458,6 +432,15 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;
+
+	if (unlikely(lid == ids->max_id)) {
+		do {
+			lid--;
+			if(lid == -1)
+				break;
+		} while (!idr_find(&ids->ipcs_idr, lid));
+		ids->max_id = lid;
+	}
 }
 
 /**
diff -puN ipc/util.h~sysvipc-make-get_maxid-o1-again ipc/util.h
--- a/ipc/util.h~sysvipc-make-get_maxid-o1-again
+++ a/ipc/util.h
@@ -12,6 +12,7 @@
 
 #include <linux/unistd.h>
 #include <linux/err.h>
+#include <linux/ipc_namespace.h>
 
 #define SEQ_MULTIPLIER	(IPCMNI)
 
@@ -98,9 +99,6 @@ void __init ipc_init_proc_interface(cons
 /* must be called with ids->rwsem acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 
-/* must be called with ids->rwsem acquired for reading */
-int ipc_get_maxid(struct ipc_ids *);
-
 /* must be called with both locks acquired. */
 void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
@@ -110,6 +108,23 @@ void ipc_set_key_private(struct ipc_ids
 /* must be called with ipcp locked */
 int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flg);
 
+/**
+ * ipc_get_maxid - get the last assigned id
+ * @ids: ipc identifier set
+ *
+ * Called with ipc_ids.rwsem held for reading.
+ */
+static inline int ipc_get_maxid(struct ipc_ids *ids)
+{
+	if (ids->in_use == 0)
+		return -1;
+
+	if (ids->in_use == IPCMNI)
+		return IPCMNI - 1;
+
+	return ids->max_id;
+}
+
 /*
  * For allocation that need to be freed by RCU.
  * Objects are reference counted, they start with reference count 1.
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmcompaction-serialize-waitqueue_active-checks-for-real.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch
sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch
sysvipc-properly-name-ipc_addid-limit-parameter.patch
sysvipc-make-get_maxid-o1-again.patch

