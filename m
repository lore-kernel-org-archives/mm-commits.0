From: akpm@linux-foundation.org
Subject: + sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch added
 to -mm tree
Date: Tue, 03 Oct 2017 14:59:47 -0700
Message-ID: <59d40853.661hnG2t9HsnUk6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCV7s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: unteach ids->next_id for !CHECKPOINT_RESTORE
has been added to the -mm tree.  Its filename is
     sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch

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
Subject: sysvipc: unteach ids->next_id for !CHECKPOINT_RESTORE

Patch series "sysvipc: ipc-key management improvements".

Here are a few improvements I spotted while eyeballing Guillaume's
rhashtable implementation for ipc keys.  The first and fourth patches are
the interesting ones, the middle two are trivial.


This patch (of 4):

The next_id object-allocation functionality was introduced in
03f595668017f ("ipc: add sysctl to specify desired next object id"). 
Given that these new entries are _only_ exported under the
CONFIG_CHECKPOINT_RESTORE option, there is no point for the common case to
even know about ->next_id.  As such rewrite ipc_buildid() such that it can
do away with the field as well as unnecessary branches when adding a new
identifier.  The end result also better differentiates both cases, so the
code ends up being cleaner; albeit the small duplications regarding the
default case.

Link: http://lkml.kernel.org/r/20170831172049.14576-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 +
 ipc/util.c                    |   60 ++++++++++++++++++++++++--------
 ipc/util.h                    |    5 --
 3 files changed, 47 insertions(+), 20 deletions(-)

diff -puN include/linux/ipc_namespace.h~sysvipc-unteach-ids-next_id-for-checkpoint_restore include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~sysvipc-unteach-ids-next_id-for-checkpoint_restore
+++ a/include/linux/ipc_namespace.h
@@ -18,7 +18,9 @@ struct ipc_ids {
 	bool tables_initialized;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	int next_id;
+#endif
 	struct rhashtable key_ht;
 };
 
diff -puN ipc/util.c~sysvipc-unteach-ids-next_id-for-checkpoint_restore ipc/util.c
--- a/ipc/util.c~sysvipc-unteach-ids-next_id-for-checkpoint_restore
+++ a/ipc/util.c
@@ -115,13 +115,15 @@ int ipc_init_ids(struct ipc_ids *ids)
 	int err;
 	ids->in_use = 0;
 	ids->seq = 0;
-	ids->next_id = -1;
 	init_rwsem(&ids->rwsem);
 	err = rhashtable_init(&ids->key_ht, &ipc_kht_params);
 	if (err)
 		return err;
 	idr_init(&ids->ipcs_idr);
 	ids->tables_initialized = true;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	ids->next_id = -1;
+#endif
 	return 0;
 }
 
@@ -215,6 +217,46 @@ int ipc_get_maxid(struct ipc_ids *ids)
 	return max_id;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+/*
+ * Specify desired id for next allocated IPC object.
+ */
+#define ipc_idr_alloc(ids, new)						\
+	idr_alloc(&(ids)->ipcs_idr, (new),				\
+		  (ids)->next_id < 0 ? 0: ipcid_to_idx((ids)->next_id), \
+		  0, GFP_NOWAIT);
+
+static inline int ipc_buildid(int id, struct ipc_ids *ids,
+			      struct kern_ipc_perm *new)
+{
+	if (ids->next_id < 0) { /* default, behave as !CHECKPOINT_RESTORE */
+		new->seq = ids->seq++;
+		if (ids->seq > IPCID_SEQ_MAX)
+			ids->seq = 0;
+	} else {
+		new->seq = ipcid_to_seqx(ids->next_id);
+		ids->next_id = -1;
+	}
+
+	return SEQ_MULTIPLIER * new->seq + id;
+}
+
+#else
+#define ipc_idr_alloc(ids, new)					\
+	idr_alloc(&(ids)->ipcs_idr, (new), 0, 0, GFP_NOWAIT);
+
+static inline int ipc_buildid(int id, struct ipc_ids *ids,
+			      struct kern_ipc_perm *new)
+{
+	new->seq = ids->seq++;
+	if (ids->seq > IPCID_SEQ_MAX)
+		ids->seq = 0;
+
+	return SEQ_MULTIPLIER * new->seq + id;
+}
+
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 /**
  * ipc_addid - add an ipc identifier
  * @ids: ipc identifier set
@@ -233,7 +275,6 @@ int ipc_addid(struct ipc_ids *ids, struc
 	kuid_t euid;
 	kgid_t egid;
 	int id, err;
-	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
 		size = IPCMNI;
@@ -253,9 +294,7 @@ int ipc_addid(struct ipc_ids *ids, struc
 	new->cuid = new->uid = euid;
 	new->gid = new->cgid = egid;
 
-	id = idr_alloc(&ids->ipcs_idr, new,
-		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
-		       GFP_NOWAIT);
+	id = ipc_idr_alloc(ids, new);
 	idr_preload_end();
 
 	if (id >= 0 && new->key != IPC_PRIVATE) {
@@ -273,17 +312,8 @@ int ipc_addid(struct ipc_ids *ids, struc
 	}
 
 	ids->in_use++;
+	new->id = ipc_buildid(id, ids, new);
 
-	if (next_id < 0) {
-		new->seq = ids->seq++;
-		if (ids->seq > IPCID_SEQ_MAX)
-			ids->seq = 0;
-	} else {
-		new->seq = ipcid_to_seqx(next_id);
-		ids->next_id = -1;
-	}
-
-	new->id = ipc_buildid(id, new->seq);
 	return id;
 }
 
diff -puN ipc/util.h~sysvipc-unteach-ids-next_id-for-checkpoint_restore ipc/util.h
--- a/ipc/util.h~sysvipc-unteach-ids-next_id-for-checkpoint_restore
+++ a/ipc/util.h
@@ -145,11 +145,6 @@ extern struct msg_msg *load_msg(const vo
 extern struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst);
 extern int store_msg(void __user *dest, struct msg_msg *msg, size_t len);
 
-static inline int ipc_buildid(int id, int seq)
-{
-	return SEQ_MULTIPLIER * seq + id;
-}
