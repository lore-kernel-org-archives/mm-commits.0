From: akpm@linux-foundation.org
Subject: [to-be-updated] framework-for-version-lvb.patch removed from -mm
 tree
Date: Thu, 21 Nov 2013 16:33:50 -0800
Message-ID: <528ea66e.CIEJjxrR75euXYj8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3KVAdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:33:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [to-be-updated] framework-for-version-lvb.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:33:50 -0800


The patch titled
     Subject: ocfs2: framework for version LVB
has been removed from the -mm tree.  Its filename was
     framework-for-version-lvb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: framework for version LVB

Use the native DLM locks for version control negotiation.  Most of the
framework is taken from gfs2/lock_dlm.c

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |  102 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff -puN fs/ocfs2/stack_user.c~framework-for-version-lvb fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~framework-for-version-lvb
+++ a/fs/ocfs2/stack_user.c
@@ -118,6 +118,9 @@ struct ocfs2_live_connection {
 	enum ocfs2_connection_type	oc_type;
 	atomic_t                        oc_this_node;
 	int                             oc_our_slot;
+	struct dlm_lksb                 oc_version_lksb;
+	char                            oc_lvb[DLM_LVB_LEN];
+	struct completion               oc_sync_wait;
 };
 
 struct ocfs2_control_private {
@@ -796,6 +799,105 @@ static int fs_protocol_compare(struct oc
 	return 0;
 }
 
+static int lvb_to_version(char *lvb, struct ocfs2_protocol_version *ver)
+{
+	struct ocfs2_protocol_version pv;
+	struct ocfs2_protocol_version *max =
+		&ocfs2_user_plugin.sp_max_proto;
+
+	memcpy(&pv, lvb, sizeof(struct ocfs2_protocol_version));
+	if ((pv.pv_major == LONG_MIN) || (pv.pv_major == LONG_MAX) ||
+	    (pv.pv_major > (u8)-1) || (pv.pv_major < 1))
+		return -ERANGE;
+	if ((pv.pv_minor == LONG_MIN) || (pv.pv_minor == LONG_MAX) ||
+	    (pv.pv_minor > (u8)-1) || (pv.pv_minor < 0))
+		return -ERANGE;
+	if ((pv.pv_major != max->pv_major) ||
+	    (pv.pv_minor > max->pv_minor))
+		return -EINVAL;
+	ver->pv_major = pv.pv_major;
+	ver->pv_minor = pv.pv_minor;
+	return 0;
+}
+
+static void version_to_lvb(struct ocfs2_protocol_version *ver, char *lvb)
+{
+	memcpy(lvb, ver, sizeof(struct ocfs2_protocol_version));
+}
+
+static void sync_wait_cb(void *arg)
+{
+	struct ocfs2_cluster_connection *conn = arg;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	complete(&lc->oc_sync_wait);
+}
+
+static int sync_unlock(struct ocfs2_cluster_connection *conn,
+		struct dlm_lksb *lksb, char *name)
+{
+	int error;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+
+	error = dlm_unlock(conn->cc_lockspace, lksb->sb_lkid, 0, lksb, conn);
+	if (error) {
+		printk(KERN_ERR "%s lkid %x error %d\n",
+				name, lksb->sb_lkid, error);
+		return error;
+	}
+
+	wait_for_completion(&lc->oc_sync_wait);
+
+	if (lksb->sb_status != -DLM_EUNLOCK) {
+		printk(KERN_ERR "%s lkid %x status %d\n",
+				name, lksb->sb_lkid, lksb->sb_status);
+		return -1;
+	}
+	return 0;
+}
+
+static int sync_lock(struct ocfs2_cluster_connection *conn,
+		int mode, uint32_t flags,
+		struct dlm_lksb *lksb, char *name)
+{
+	int error, status;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+
+	error = dlm_lock(conn->cc_lockspace, mode, lksb, flags,
+			name, strlen(name),
+			0, sync_wait_cb, conn, NULL);
+	if (error) {
+		printk(KERN_ERR "%s lkid %x flags %x mode %d error %d\n",
+				name, lksb->sb_lkid, flags, mode, error);
+		return error;
+	}
+
+	wait_for_completion(&lc->oc_sync_wait);
+
+	status = lksb->sb_status;
+
+	if (status && status != -EAGAIN) {
+		printk(KERN_ERR "%s lkid %x flags %x mode %d status %d\n",
+				name, lksb->sb_lkid, flags, mode, status);
+	}
+
+	return status;
+}
+
+
+static int version_lock(struct ocfs2_cluster_connection *conn, int mode,
+		int flags)
+{
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	return sync_lock(conn, mode, flags,
+			&lc->oc_version_lksb, "version_lock");
+}
+
+static int version_unlock(struct ocfs2_cluster_connection *conn)
+{
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	return sync_unlock(conn, &lc->oc_version_lksb, "version_lock");
+}
+
 static void user_recover_prep(void *arg)
 {
 }
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

