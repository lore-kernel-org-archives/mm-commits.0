From: akpm@linux-foundation.org
Subject: [to-be-updated] add-clustername-to-cluster-connection.patch
 removed from -mm tree
Date: Thu, 21 Nov 2013 16:33:42 -0800
Message-ID: <528ea666.lG2a90Y+2mg5NnZk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3KVAdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [to-be-updated] add-clustername-to-cluster-connection.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:33:42 -0800


The patch titled
     Subject: ocfs2: add clustername to cluster connection
has been removed from the -mm tree.  Its filename was
     add-clustername-to-cluster-connection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: add clustername to cluster connection

This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
handling up to the times with respect to DLM (>=4.0.1) and corosync
(2.3.x).  AFAIK, cman also is being phased out for a unified corosync
cluster stack.

fs/dlm performs all the functions with respect to fencing and node
management and provides the API's to do so for ocfs2.  For all future
references, DLM stands for fs/dlm code.

The advantages are:
 + No need to run an additional userspace daemon (ocfs2_controld)
 + No contrrold devince handling and controld protocol
 + Shifting responsibilities of node management to DLM layer

For backward compatibility, we are keeping the controld handling code. 
Once enough time has passed we can remove a significant portion of the
code.

This feature requires modification in the userspace ocfs2-tools.  The
changes can be found at: https://github.com/goldwynr/ocfs2-tools branch:
nocontrold Currently, not many checks are present in the userspace code,
but that would change soon.

These changes were developed on linux-stable 3.11.y.  However, the changes
are applicable to the current upstream as well.  If you wish to give the
entire kernel a spin, the link is:

https://github.com/goldwynr/linux-stable branch: nocontrold


This patch (of 6): 

Add clustername to cluster connection.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c   |    2 ++
 fs/ocfs2/ocfs2.h     |    1 +
 fs/ocfs2/stackglue.c |   11 ++++++++---
 fs/ocfs2/stackglue.h |    7 +++++++
 fs/ocfs2/super.c     |    7 +++++--
 5 files changed, 23 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~add-clustername-to-cluster-connection fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~add-clustername-to-cluster-connection
+++ a/fs/ocfs2/dlmglue.c
@@ -2996,6 +2996,8 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 
 	/* for now, uuid == domain */
 	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
+				       osb->osb_cluster_name,
+				       strlen(osb->osb_cluster_name),
 				       osb->uuid_str,
 				       strlen(osb->uuid_str),
 				       &lproto, ocfs2_do_node_down, osb,
diff -puN fs/ocfs2/ocfs2.h~add-clustername-to-cluster-connection fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~add-clustername-to-cluster-connection
+++ a/fs/ocfs2/ocfs2.h
@@ -387,6 +387,7 @@ struct ocfs2_super
 	u8 osb_stackflags;
 
 	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
+	char osb_cluster_name[OCFS2_CLUSTER_NAME_LEN + 1];
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
diff -puN fs/ocfs2/stackglue.c~add-clustername-to-cluster-connection fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~add-clustername-to-cluster-connection
+++ a/fs/ocfs2/stackglue.c
@@ -309,6 +309,8 @@ int ocfs2_plock(struct ocfs2_cluster_con
 EXPORT_SYMBOL_GPL(ocfs2_plock);
 
 int ocfs2_cluster_connect(const char *stack_name,
+			  const char *cluster_name,
+			  int cluster_name_len,
 			  const char *group,
 			  int grouplen,
 			  struct ocfs2_locking_protocol *lproto,
@@ -342,8 +344,10 @@ int ocfs2_cluster_connect(const char *st
 		goto out;
 	}
 
-	memcpy(new_conn->cc_name, group, grouplen);
+	strlcpy(new_conn->cc_name, group, grouplen + 1);
 	new_conn->cc_namelen = grouplen;
+	strlcpy(new_conn->cc_cluster_name, cluster_name, cluster_name_len + 1);
+	new_conn->cc_cluster_name_len = cluster_name_len;
 	new_conn->cc_recovery_handler = recovery_handler;
 	new_conn->cc_recovery_data = recovery_data;
 
@@ -386,8 +390,9 @@ int ocfs2_cluster_connect_agnostic(const
 
 	if (cluster_stack_name[0])
 		stack_name = cluster_stack_name;
-	return ocfs2_cluster_connect(stack_name, group, grouplen, lproto,
-				     recovery_handler, recovery_data, conn);
+	return ocfs2_cluster_connect(stack_name, NULL, 0, group, grouplen,
+				     lproto, recovery_handler, recovery_data,
+				     conn);
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_connect_agnostic);
 
diff -puN fs/ocfs2/stackglue.h~add-clustername-to-cluster-connection fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~add-clustername-to-cluster-connection
+++ a/fs/ocfs2/stackglue.h
@@ -45,6 +45,9 @@ struct file_lock;
  */
 #define GROUP_NAME_MAX		64
 
+/* This shadows  OCFS2_CLUSTER_NAME_LEN */
+#define CLUSTER_NAME_MAX	16
+
 
 /*
  * ocfs2_protocol_version changes when ocfs2 does something different in
@@ -99,6 +102,8 @@ struct ocfs2_locking_protocol {
 struct ocfs2_cluster_connection {
 	char cc_name[GROUP_NAME_MAX];
 	int cc_namelen;
+	char cc_cluster_name[CLUSTER_NAME_MAX];
+	int cc_cluster_name_len;
 	struct ocfs2_protocol_version cc_version;
 	struct ocfs2_locking_protocol *cc_proto;
 	void (*cc_recovery_handler)(int node_num, void *recovery_data);
@@ -239,6 +244,8 @@ struct ocfs2_stack_plugin {
 
 /* Used by the filesystem */
 int ocfs2_cluster_connect(const char *stack_name,
+			  const char *cluster_name,
+			  int cluster_name_len,
 			  const char *group,
 			  int grouplen,
 			  struct ocfs2_locking_protocol *lproto,
diff -puN fs/ocfs2/super.c~add-clustername-to-cluster-connection fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~add-clustername-to-cluster-connection
+++ a/fs/ocfs2/super.c
@@ -2225,9 +2225,9 @@ static int ocfs2_initialize_super(struct
 	if (ocfs2_clusterinfo_valid(osb)) {
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		memcpy(osb->osb_cluster_stack,
+		strlcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN);
+		       OCFS2_STACK_LABEL_LEN + 1);
 		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
@@ -2237,6 +2237,9 @@ static int ocfs2_initialize_super(struct
 			status = -EINVAL;
 			goto bail;
 		}
+		strlcpy(osb->osb_cluster_name,
+			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
+			OCFS2_CLUSTER_NAME_LEN + 1);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
add-dlm-recovery-callbacks.patch
shift-allocation-ocfs2_live_connection-to-user_connect.patch
pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
framework-for-version-lvb.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

