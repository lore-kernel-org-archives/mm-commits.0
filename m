From: akpm@linux-foundation.org
Subject: +
 use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
 added to -mm tree
Date: Fri, 18 Oct 2013 13:03:10 -0700
Message-ID: <526193fe.lAiyBJn81zCfeP/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3JRUDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Oct 2013 16:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Fri, 18 Oct 2013 13:03:10 -0700


The patch titled
     Subject: ocfs2: use the new DLM operation callbacks while requesting new lockspace
has been added to the -mm tree.  Its filename is
     use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   97 ++++++++++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 24 deletions(-)

diff -puN fs/ocfs2/stack_user.c~use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace
+++ a/fs/ocfs2/stack_user.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "stackglue.h"
@@ -121,6 +122,7 @@ struct ocfs2_live_connection {
 	struct dlm_lksb                 oc_version_lksb;
 	char                            oc_lvb[DLM_LVB_LEN];
 	struct completion               oc_sync_wait;
+	wait_queue_head_t		oc_wait;
 };
 
 struct ocfs2_control_private {
@@ -217,7 +219,7 @@ static int ocfs2_live_connection_new(str
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
 
-	if (atomic_read(&ocfs2_control_opened))
+	if ((c->oc_type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
 		list_add(&c->oc_list, &ocfs2_live_connection_list);
 	else {
 		printk(KERN_ERR
@@ -926,6 +928,7 @@ static void user_recover_done(void *arg,
 		}
 
 	lc->oc_our_slot = our_slot;
+	wake_up(&lc->oc_wait);
 }
 
 const struct dlm_lockspace_ops ocfs2_ls_ops = {
@@ -934,11 +937,21 @@ const struct dlm_lockspace_ops ocfs2_ls_
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
 
@@ -948,12 +961,65 @@ static int user_cluster_connect(struct o
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
 
 	rc = ocfs2_live_connection_new(conn, lc);
 	if (rc)
 		goto out;
 
+	if (lc->oc_type == NO_CONTROLD) {
+		int ret;
+		lc->oc_version_lksb.sb_lvbptr = lc->oc_lvb;
+		ret = version_lock(conn, DLM_LOCK_EX,
+				DLM_LKF_VALBLK|DLM_LKF_NOQUEUE);
+		running_proto.pv_major =
+			ocfs2_user_plugin.sp_max_proto.pv_major;
+		running_proto.pv_minor =
+			ocfs2_user_plugin.sp_max_proto.pv_minor;
+		if (!ret) {
+			conn->cc_version.pv_major = running_proto.pv_major;
+			conn->cc_version.pv_minor = running_proto.pv_minor;
+			version_to_lvb(&running_proto, lc->oc_lvb);
+			version_lock(conn, DLM_LOCK_PR, DLM_LKF_CONVERT|DLM_LKF_VALBLK);
+		} else if (ret == -EAGAIN) {
+			version_lock(conn, DLM_LOCK_PR, DLM_LKF_VALBLK);
+			ret = lvb_to_version(lc->oc_lvb, &conn->cc_version);
+			if (ret) {
+				rc = ret;
+				user_cluster_disconnect(conn);
+				goto out;
+			}
+		} else {
+			printk(KERN_ERR "ocfs2: Could not determine"
+					" locking version\n");
+			rc = ret;
+			user_cluster_disconnect(conn);
+			goto out;
+		}
+		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
+	}
+
 	/*
 	 * running_proto must have been set before we allowed any mounts
 	 * to proceed.
@@ -961,40 +1027,20 @@ static int user_cluster_connect(struct o
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
-	}
-
-	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
-			       NULL, NULL, NULL, &fsdlm);
-	if (rc) {
-		ocfs2_live_connection_drop(lc);
-		lc = NULL;
-		goto out;
 	}
 
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
@@ -1004,8 +1050,11 @@ static int user_cluster_this_node(struct
 
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

fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch
add-clustername-to-cluster-connection.patch
add-dlm-recovery-callbacks.patch
shift-allocation-ocfs2_live_connection-to-user_connect.patch
pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
framework-for-version-lvb.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

