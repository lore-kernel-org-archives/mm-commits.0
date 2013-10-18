From: akpm@linux-foundation.org
Subject: + shift-allocation-ocfs2_live_connection-to-user_connect.patch
 added to -mm tree
Date: Fri, 18 Oct 2013 13:03:07 -0700
Message-ID: <526193fb.gsr52PG6VMtvC7F7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3JRUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Oct 2013 16:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + shift-allocation-ocfs2_live_connection-to-user_connect.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Fri, 18 Oct 2013 13:03:07 -0700


The patch titled
     Subject: ocfs2: shift allocation ocfs2_live_connection to user_connect()
has been added to the -mm tree.  Its filename is
     shift-allocation-ocfs2_live_connection-to-user_connect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shift-allocation-ocfs2_live_connection-to-user_connect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shift-allocation-ocfs2_live_connection-to-user_connect.patch

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
Subject: ocfs2: shift allocation ocfs2_live_connection to user_connect()

We perform this because the DLM recovery callbacks will require the
ocfs2_live_connection structure to record the node information when
dlm_new_lockspace() is updated.

[AKPM] rc initialization is not required because it assigned in case of
errors.  It will be cleared by compiler anyways.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff -puN fs/ocfs2/stack_user.c~shift-allocation-ocfs2_live_connection-to-user_connect fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~shift-allocation-ocfs2_live_connection-to-user_connect
+++ a/fs/ocfs2/stack_user.c
@@ -201,14 +201,9 @@ static struct ocfs2_live_connection *ocf
  * fill_super(), we can't get dupes here.
  */
 static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
-				     struct ocfs2_live_connection **c_ret)
+				     struct ocfs2_live_connection *c)
 {
 	int rc = 0;
-	struct ocfs2_live_connection *c;
-
-	c = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
-	if (!c)
-		return -ENOMEM;
 
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
@@ -222,12 +217,6 @@ static int ocfs2_live_connection_new(str
 	}
 
 	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc)
-		*c_ret = c;
-	else
-		kfree(c);
-
 	return rc;
 }
 
@@ -840,12 +829,18 @@ const struct dlm_lockspace_ops ocfs2_ls_
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *uninitialized_var(control);
-	int rc = 0;
+	struct ocfs2_live_connection *lc;
+	int rc;
 
 	BUG_ON(conn == NULL);
 
-	rc = ocfs2_live_connection_new(conn, &control);
+	lc = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
+	if (!lc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = ocfs2_live_connection_new(conn, lc);
 	if (rc)
 		goto out;
 
@@ -861,20 +856,24 @@ static int user_cluster_connect(struct o
 		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
 		       running_proto.pv_major, running_proto.pv_minor);
 		rc = -EPROTO;
-		ocfs2_live_connection_drop(control);
+		ocfs2_live_connection_drop(lc);
+		lc = NULL;
 		goto out;
 	}
 
 	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
 			       NULL, NULL, NULL, &fsdlm);
 	if (rc) {
-		ocfs2_live_connection_drop(control);
+		ocfs2_live_connection_drop(lc);
+		lc = NULL;
 		goto out;
 	}
 
-	conn->cc_private = control;
+	conn->cc_private = lc;
 	conn->cc_lockspace = fsdlm;
 out:
+	if (rc && lc)
+		kfree(lc);
 	return rc;
 }
 
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

fs-ocfs2-remove-unnecessary-variable-bits_wanted-from-ocfs2_calc_extend_credits.patch
add-clustername-to-cluster-connection.patch
add-dlm-recovery-callbacks.patch
shift-allocation-ocfs2_live_connection-to-user_connect.patch
pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
framework-for-version-lvb.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

