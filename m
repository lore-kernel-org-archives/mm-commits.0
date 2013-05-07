From: akpm@linux-foundation.org
Subject: [merged] ipc-introduce-obtaining-a-lockless-ipc-object.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:12 -0700
Message-ID: <20130507175212.9A7325A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60657 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3EGRwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:14 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so86585vbe.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr.bueso@hp.com, benisty.e@gmail.com, chegu_vinod@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, sedat.dilek@gmail.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: introduce obtaining a lockless ipc object
has been removed from the -mm tree.  Its filename was
     ipc-introduce-obtaining-a-lockless-ipc-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: introduce obtaining a lockless ipc object

Through ipc_lock() and therefore ipc_lock_check() we currently return the
locked ipc object.  This is not necessary for all situations and can,
therefore, cause unnecessary ipc lock contention.

Introduce analogous ipc_obtain_object() and ipc_obtain_object_check()
functions that only lookup and return the ipc object.

Both these functions must be called within the RCU read critical section.

[akpm@linux-foundation.org: propagate the ipc_obtain_object() errno from ipc_lock()]
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Chegu Vinod <chegu_vinod@hp.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   71 ++++++++++++++++++++++++++++++++++++++++-----------
 ipc/util.h |    2 +
 2 files changed, 59 insertions(+), 14 deletions(-)

diff -puN ipc/util.c~ipc-introduce-obtaining-a-lockless-ipc-object ipc/util.c
--- a/ipc/util.c~ipc-introduce-obtaining-a-lockless-ipc-object
+++ a/ipc/util.c
@@ -669,38 +669,81 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 }
 
 /**
+ * ipc_obtain_object
+ * @ids: ipc identifier set
+ * @id: ipc id to look for
+ *
+ * Look for an id in the ipc ids idr and return associated ipc object.
+ *
+ * Call inside the RCU critical section.
+ * The ipc object is *not* locked on exit.
+ */
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+	int lid = ipcid_to_idx(id);
+
+	out = idr_find(&ids->ipcs_idr, lid);
+	if (!out)
+		return ERR_PTR(-EINVAL);
+
+	return out;
+}
+
+/**
  * ipc_lock - Lock an ipc structure without rw_mutex held
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
  * Look for an id in the ipc ids idr and lock the associated ipc object.
  *
- * The ipc object is locked on exit.
+ * The ipc object is locked on successful exit.
  */
-
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
-	if (out == NULL) {
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
+	out = ipc_obtain_object(ids, id);
+	if (IS_ERR(out))
+		goto err1;
 
 	spin_lock(&out->lock);
-	
+
 	/* ipc_rmid() may have already freed the ID while ipc_lock
 	 * was spinning: here verify that the structure is still valid
 	 */
-	if (out->deleted) {
-		spin_unlock(&out->lock);
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
+	if (!out->deleted)
+		return out;
+
+	spin_unlock(&out->lock);
+	out = ERR_PTR(-EINVAL);
+err1:
+	rcu_read_unlock();
+	return out;
+}
+
+/**
+ * ipc_obtain_object_check
+ * @ids: ipc identifier set
+ * @id: ipc id to look for
+ *
+ * Similar to ipc_obtain_object() but also checks
+ * the ipc object reference counter.
+ *
+ * Call inside the RCU critical section.
+ * The ipc object is *not* locked on exit.
+ */
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
 
+	if (IS_ERR(out))
+		goto out;
+
+	if (ipc_checkid(out, id))
+		return ERR_PTR(-EIDRM);
+out:
 	return out;
 }
 
diff -puN ipc/util.h~ipc-introduce-obtaining-a-lockless-ipc-object ipc/util.h
--- a/ipc/util.h~ipc-introduce-obtaining-a-lockless-ipc-object
+++ a/ipc/util.h
@@ -123,6 +123,7 @@ void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
+struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -168,6 +169,7 @@ static inline void ipc_unlock(struct ker
 }
 
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

