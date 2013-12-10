From: akpm@linux-foundation.org
Subject: + ocfs2-add-clustername-to-cluster-connection.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 14:43:14 -0800
Message-ID: <52a79902.RM4jmPvTgJZPSvFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LJWnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + ocfs2-add-clustername-to-cluster-connection.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:43:14 -0800


The patch titled
     Subject: ocfs2: add clustername to cluster connection
has been added to the -mm tree.  Its filename is
     ocfs2-add-clustername-to-cluster-connection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-clustername-to-cluster-connection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-clustername-to-cluster-connection.patch

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
 + No controld device handling and controld protocol
 + Shifting responsibilities of node management to DLM layer

For backward compatibility, we are keeping the controld handling code. Once
enough time has passed we can remove a significant portion of the code. This
was tested by using the kernel with changes on older unmodified tools. The
kernel used ocfs2_controld as expected, and displayed the appropriate
warning message.

This feature requires modification in the userspace ocfs2-tools.  The
changes can be found at: https://github.com/goldwynr/ocfs2-tools branch:
nocontrold Currently, not many checks are present in the userspace code,
but that would change soon.


This patch (of 6):

Add clustername to cluster connection.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c   |    2 ++
 fs/ocfs2/ocfs2.h     |    1 +
 fs/ocfs2/stackglue.c |   11 ++++++++---
 fs/ocfs2/stackglue.h |    9 ++++++++-
 fs/ocfs2/super.c     |    8 +++++---
 5 files changed, 24 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-clustername-to-cluster-connection fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-clustername-to-cluster-connection
+++ a/fs/ocfs2/dlmglue.c
@@ -2996,6 +2996,8 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 
 	/* for now, uuid == domain */
 	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
+				       osb->osb_cluster_name,
+				       strlen(osb->osb_cluster_name),
 				       osb->uuid_str,
 				       strlen(osb->uuid_str),
 				       &lproto, ocfs2_do_node_down, osb,
diff -puN fs/ocfs2/ocfs2.h~ocfs2-add-clustername-to-cluster-connection fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-add-clustername-to-cluster-connection
+++ a/fs/ocfs2/ocfs2.h
@@ -387,6 +387,7 @@ struct ocfs2_super
 	u8 osb_stackflags;
 
 	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
+	char osb_cluster_name[OCFS2_CLUSTER_NAME_LEN + 1];
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
diff -puN fs/ocfs2/stackglue.c~ocfs2-add-clustername-to-cluster-connection fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-add-clustername-to-cluster-connection
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
+	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
 	new_conn->cc_namelen = grouplen;
+	strlcpy(new_conn->cc_cluster_name, cluster_name, CLUSTER_NAME_MAX + 1);
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
 
diff -puN fs/ocfs2/stackglue.h~ocfs2-add-clustername-to-cluster-connection fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~ocfs2-add-clustername-to-cluster-connection
+++ a/fs/ocfs2/stackglue.h
@@ -45,6 +45,9 @@ struct file_lock;
  */
 #define GROUP_NAME_MAX		64
 
+/* This shadows  OCFS2_CLUSTER_NAME_LEN */
+#define CLUSTER_NAME_MAX	16
+
 
 /*
  * ocfs2_protocol_version changes when ocfs2 does something different in
@@ -97,8 +100,10 @@ struct ocfs2_locking_protocol {
  * locking compatibility.
  */
 struct ocfs2_cluster_connection {
-	char cc_name[GROUP_NAME_MAX];
+	char cc_name[GROUP_NAME_MAX + 1];
 	int cc_namelen;
+	char cc_cluster_name[CLUSTER_NAME_MAX + 1];
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
diff -puN fs/ocfs2/super.c~ocfs2-add-clustername-to-cluster-connection fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-add-clustername-to-cluster-connection
+++ a/fs/ocfs2/super.c
@@ -2223,10 +2223,9 @@ static int ocfs2_initialize_super(struct
 	if (ocfs2_clusterinfo_valid(osb)) {
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		memcpy(osb->osb_cluster_stack,
+		strlcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN);
-		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
+		       OCFS2_STACK_LABEL_LEN + 1);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2235,6 +2234,9 @@ static int ocfs2_initialize_super(struct
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

ocfs2-remove-versioning-information.patch
ocfs2-add-clustername-to-cluster-connection.patch
ocfs2-add-dlm-recovery-callbacks.patch
ocfs2-shift-allocation-ocfs2_live_connection-to-user_connect.patch
ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
ocfs2-framework-for-version-lvb.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

