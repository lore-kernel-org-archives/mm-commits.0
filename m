From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:47 -0800
Message-ID: <52e02603.8fSII0yALSFdZTKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaAVULs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, dan.carpenter@oracle.com, rgoldwyn@suse.de

Subject: [merged] ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch removed from -mm tree
To: rgoldwyn@suse.de,dan.carpenter@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:47 -0800


The patch titled
     Subject: ocfs2: use the new DLM operation callbacks while requesting new lockspace
has been removed from the -mm tree.  Its filename was
     ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: use the new DLM operation callbacks while requesting new lockspace

Attempt to use the new DLM operations.  If it is not supported, use the
traditional ocfs2_controld.

To exchange ocfs2 versioning, we use the LVB of the version dlm lock.  It
first attempts to take the lock in EX mode (non-blocking).  If successful
(which means it is the first mount), it writes the version number and
downconverts to PR lock.  If it is unsuccessful, it reads the version from
the lock.

If this becomes the standard (with o2cb as well), it could simplify
userspace tools to check if the filesystem is mounted on other nodes.

Dan: Since ocfs2_protocol_version are two u8 values, the additional
checks with LONG* don't make sense.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |  126 ++++++++++++++++++++++++++++++++--------
 1 file changed, 102 insertions(+), 24 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace
+++ a/fs/ocfs2/stack_user.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "stackglue.h"
@@ -122,6 +123,7 @@ struct ocfs2_live_connection {
 	struct dlm_lksb                 oc_version_lksb;
 	char                            oc_lvb[DLM_LVB_LEN];
 	struct completion               oc_sync_wait;
+	wait_queue_head_t		oc_wait;
 };
 
 struct ocfs2_control_private {
@@ -218,7 +220,7 @@ static int ocfs2_live_connection_attach(
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
 
-	if (atomic_read(&ocfs2_control_opened))
+	if ((c->oc_type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
 		list_add(&c->oc_list, &ocfs2_live_connection_list);
 	else {
 		printk(KERN_ERR
@@ -897,6 +899,55 @@ static int version_unlock(struct ocfs2_c
 	return sync_unlock(conn, &lc->oc_version_lksb, VERSION_LOCK);
 }
 
+/* get_protocol_version()
+ *
+ * To exchange ocfs2 versioning, we use the LVB of the version dlm lock.
+ * The algorithm is:
+ * 1. Attempt to take the lock in EX mode (non-blocking).
+ * 2. If successful (which means it is the first mount), write the
+ *    version number and downconvert to PR lock.
+ * 3. If unsuccessful (returns -EAGAIN), read the version from the LVB after
+ *    taking the PR lock.
+ */
+
+static int get_protocol_version(struct ocfs2_cluster_connection *conn)
+{
+	int ret;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	struct ocfs2_protocol_version pv;
+
+	running_proto.pv_major =
+		ocfs2_user_plugin.sp_max_proto.pv_major;
+	running_proto.pv_minor =
+		ocfs2_user_plugin.sp_max_proto.pv_minor;
+
+	lc->oc_version_lksb.sb_lvbptr = lc->oc_lvb;
+	ret = version_lock(conn, DLM_LOCK_EX,
+			DLM_LKF_VALBLK|DLM_LKF_NOQUEUE);
+	if (!ret) {
+		conn->cc_version.pv_major = running_proto.pv_major;
+		conn->cc_version.pv_minor = running_proto.pv_minor;
+		version_to_lvb(&running_proto, lc->oc_lvb);
+		version_lock(conn, DLM_LOCK_PR, DLM_LKF_CONVERT|DLM_LKF_VALBLK);
+	} else if (ret == -EAGAIN) {
+		ret = version_lock(conn, DLM_LOCK_PR, DLM_LKF_VALBLK);
+		if (ret)
+			goto out;
+		lvb_to_version(lc->oc_lvb, &pv);
+
+		if ((pv.pv_major != running_proto.pv_major) ||
+				(pv.pv_minor > running_proto.pv_minor)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		conn->cc_version.pv_major = pv.pv_major;
+		conn->cc_version.pv_minor = pv.pv_minor;
+	}
+out:
+	return ret;
+}
+
 static void user_recover_prep(void *arg)
 {
 }
@@ -925,6 +976,7 @@ static void user_recover_done(void *arg,
 		}
 
 	lc->oc_our_slot = our_slot;
+	wake_up(&lc->oc_wait);
 }
 
 const struct dlm_lockspace_ops ocfs2_ls_ops = {
@@ -933,11 +985,21 @@ const struct dlm_lockspace_ops ocfs2_ls_
 	.recover_done = user_recover_done,
 };
 
+static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+{
+	version_unlock(conn);
+	dlm_release_lockspace(conn->cc_lockspace, 2);
+	conn->cc_lockspace = NULL;
+	ocfs2_live_connection_drop(conn->cc_private);
+	conn->cc_private = NULL;
+	return 0;
+}
+
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
 	struct ocfs2_live_connection *lc;
-	int rc;
+	int rc, ops_rv;
 
 	BUG_ON(conn == NULL);
 
@@ -947,11 +1009,44 @@ static int user_cluster_connect(struct o
 		goto out;
 	}
 
-	lc->oc_type = WITH_CONTROLD;
+	init_waitqueue_head(&lc->oc_wait);
+	init_completion(&lc->oc_sync_wait);
+	atomic_set(&lc->oc_this_node, 0);
+	conn->cc_private = lc;
+	lc->oc_type = NO_CONTROLD;
+
+	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
+			       DLM_LSFL_FS, DLM_LVB_LEN,
+			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
+	if (rc)
+		goto out;
+
+	if (ops_rv == -EOPNOTSUPP) {
+		lc->oc_type = WITH_CONTROLD;
+		printk(KERN_NOTICE "ocfs2: You seem to be using an older "
+				"version of dlm_controld and/or ocfs2-tools."
+				" Please consider upgrading.\n");
+	} else if (ops_rv) {
+		rc = ops_rv;
+		goto out;
+	}
+	conn->cc_lockspace = fsdlm;
+
 	rc = ocfs2_live_connection_attach(conn, lc);
 	if (rc)
 		goto out;
 
+	if (lc->oc_type == NO_CONTROLD) {
+		rc = get_protocol_version(conn);
+		if (rc) {
+			printk(KERN_ERR "ocfs2: Could not determine"
+					" locking version\n");
+			user_cluster_disconnect(conn);
+			goto out;
+		}
+		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
+	}
+
 	/*
 	 * running_proto must have been set before we allowed any mounts
 	 * to proceed.
@@ -959,40 +1054,20 @@ static int user_cluster_connect(struct o
 	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
 		printk(KERN_ERR
 		       "Unable to mount with fs locking protocol version "
-		       "%u.%u because the userspace control daemon has "
-		       "negotiated %u.%u\n",
+		       "%u.%u because negotiated protocol is %u.%u\n",
 		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
 		       running_proto.pv_major, running_proto.pv_minor);
 		rc = -EPROTO;
 		ocfs2_live_connection_drop(lc);
 		lc = NULL;
-		goto out;
 	}
 
-	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
-			       NULL, NULL, NULL, &fsdlm);
-	if (rc) {
-		ocfs2_live_connection_drop(lc);
-		lc = NULL;
-		goto out;
-	}
-
-	conn->cc_private = lc;
-	conn->cc_lockspace = fsdlm;
 out:
 	if (rc && lc)
 		kfree(lc);
 	return rc;
 }
 
-static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
-{
-	dlm_release_lockspace(conn->cc_lockspace, 2);
-	conn->cc_lockspace = NULL;
-	ocfs2_live_connection_drop(conn->cc_private);
-	conn->cc_private = NULL;
-	return 0;
-}
 
 static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
 				  unsigned int *this_node)
@@ -1002,8 +1077,11 @@ static int user_cluster_this_node(struct
 
 	if (lc->oc_type == WITH_CONTROLD)
 		rc = ocfs2_control_get_this_node();
+	else if (lc->oc_type == NO_CONTROLD)
+		rc = atomic_read(&lc->oc_this_node);
 	else
 		rc = -EINVAL;
+
 	if (rc < 0)
 		return rc;
 
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
ocfs2-code-cleanup-remove-unused-functions.patch

