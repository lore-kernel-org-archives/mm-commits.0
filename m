From: akpm@linux-foundation.org
Subject: + ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
 added to -mm tree
Date: Tue, 10 Dec 2013 14:43:18 -0800
Message-ID: <52a79906.k3UtKPRbh96SLLHx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3LJWnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:43:18 -0800


The patch titled
     Subject: ocfs2: pass ocfs2_cluster_connection to ocfs2_this_node
has been added to the -mm tree.  Its filename is
     ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch

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
Subject: ocfs2: pass ocfs2_cluster_connection to ocfs2_this_node

This is done to differentiate between using and not using controld and use
the connection information accordingly.

We need to be backward compatible.  So, we use a new enum
ocfs2_connection_type to identify when controld is used and when it is
not.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c    |    2 +-
 fs/ocfs2/stack_o2cb.c |    3 ++-
 fs/ocfs2/stack_user.c |   16 ++++++++++++++--
 fs/ocfs2/stackglue.c  |    5 +++--
 fs/ocfs2/stackglue.h  |    6 ++++--
 5 files changed, 24 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node
+++ a/fs/ocfs2/dlmglue.c
@@ -3007,7 +3007,7 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 		goto bail;
 	}
 
-	status = ocfs2_cluster_this_node(&osb->node_num);
+	status = ocfs2_cluster_this_node(conn, &osb->node_num);
 	if (status < 0) {
 		mlog_errno(status);
 		mlog(ML_ERROR,
diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node fs/ocfs2/stack_o2cb.c
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node
+++ a/fs/ocfs2/stack_o2cb.c
@@ -398,7 +398,8 @@ static int o2cb_cluster_disconnect(struc
 	return 0;
 }
 
-static int o2cb_cluster_this_node(unsigned int *node)
+static int o2cb_cluster_this_node(struct ocfs2_cluster_connection *conn,
+				  unsigned int *node)
 {
 	int node_num;
 
diff -puN fs/ocfs2/stack_user.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node
+++ a/fs/ocfs2/stack_user.c
@@ -103,6 +103,11 @@
 #define OCFS2_CONTROL_MESSAGE_VERNUM_LEN	2
 #define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
 
+enum ocfs2_connection_type {
+	WITH_CONTROLD,
+	NO_CONTROLD
+};
+
 /*
  * ocfs2_live_connection is refcounted because the filesystem and
  * miscdevice sides can detach in different order.  Let's just be safe.
@@ -110,6 +115,7 @@
 struct ocfs2_live_connection {
 	struct list_head		oc_list;
 	struct ocfs2_cluster_connection	*oc_conn;
+	enum ocfs2_connection_type	oc_type;
 	atomic_t                        oc_this_node;
 	int                             oc_our_slot;
 };
@@ -840,6 +846,7 @@ static int user_cluster_connect(struct o
 		goto out;
 	}
 
+	lc->oc_type = WITH_CONTROLD;
 	rc = ocfs2_live_connection_attach(conn, lc);
 	if (rc)
 		goto out;
@@ -886,11 +893,16 @@ static int user_cluster_disconnect(struc
 	return 0;
 }
 
-static int user_cluster_this_node(unsigned int *this_node)
+static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
+				  unsigned int *this_node)
 {
 	int rc;
+	struct ocfs2_live_connection *lc = conn->cc_private;
 
-	rc = ocfs2_control_get_this_node();
+	if (lc->oc_type == WITH_CONTROLD)
+		rc = ocfs2_control_get_this_node();
+	else
+		rc = -EINVAL;
 	if (rc < 0)
 		return rc;
 
diff -puN fs/ocfs2/stackglue.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node
+++ a/fs/ocfs2/stackglue.c
@@ -465,9 +465,10 @@ void ocfs2_cluster_hangup(const char *gr
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_hangup);
 
-int ocfs2_cluster_this_node(unsigned int *node)
+int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *conn,
+			    unsigned int *node)
 {
-	return active_stack->sp_ops->this_node(node);
+	return active_stack->sp_ops->this_node(conn, node);
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_this_node);
 
diff -puN fs/ocfs2/stackglue.h~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node
+++ a/fs/ocfs2/stackglue.h
@@ -157,7 +157,8 @@ struct ocfs2_stack_operations {
 	 * ->this_node() returns the cluster's unique identifier for the
 	 * local node.
 	 */
-	int (*this_node)(unsigned int *node);
+	int (*this_node)(struct ocfs2_cluster_connection *conn,
+			 unsigned int *node);
 
 	/*
 	 * Call the underlying dlm lock function.  The ->dlm_lock()
@@ -267,7 +268,8 @@ int ocfs2_cluster_connect_agnostic(const
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 			     int hangup_pending);
 void ocfs2_cluster_hangup(const char *group, int grouplen);
-int ocfs2_cluster_this_node(unsigned int *node);
+int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *conn,
+			    unsigned int *node);
 
 struct ocfs2_lock_res;
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

ocfs2-remove-versioning-information.patch
ocfs2-add-clustername-to-cluster-connection.patch
ocfs2-add-dlm-recovery-callbacks.patch
ocfs2-shift-allocation-ocfs2_live_connection-to-user_connect.patch
ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
ocfs2-framework-for-version-lvb.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

