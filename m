From: akpm@linux-foundation.org
Subject: [merged] ocfs2-add-dlm-recovery-callbacks.patch removed from -mm
 tree
Date: Wed, 22 Jan 2014 12:11:39 -0800
Message-ID: <52e025fb.eLRGFhHbc7Zad+SL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaAVULj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [merged] ocfs2-add-dlm-recovery-callbacks.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:39 -0800


The patch titled
     Subject: ocfs2: add DLM recovery callbacks
has been removed from the -mm tree.  Its filename was
     ocfs2-add-dlm-recovery-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: add DLM recovery callbacks

These are the callbacks called by the fs/dlm code in case the membership
changes.  If there is a failure while/during calling any of these, the DLM
creates a new membership and relays to the rest of the nodes.

recover_prep() is called when DLM understands a node is down. 
recover_slot() is called once all nodes have acknowledged recover_prep and
recovery can begin.  recover_done() is called once the recovery is
complete.  It returns the new membership.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN fs/ocfs2/stack_user.c~ocfs2-add-dlm-recovery-callbacks fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-add-dlm-recovery-callbacks
+++ a/fs/ocfs2/stack_user.c
@@ -110,6 +110,8 @@
 struct ocfs2_live_connection {
 	struct list_head		oc_list;
 	struct ocfs2_cluster_connection	*oc_conn;
+	atomic_t                        oc_this_node;
+	int                             oc_our_slot;
 };
 
 struct ocfs2_control_private {
@@ -799,6 +801,42 @@ static int fs_protocol_compare(struct oc
 	return 0;
 }
 
+static void user_recover_prep(void *arg)
+{
+}
+
+static void user_recover_slot(void *arg, struct dlm_slot *slot)
+{
+	struct ocfs2_cluster_connection *conn = arg;
+	printk(KERN_INFO "ocfs2: Node %d/%d down. Initiating recovery.\n",
+			slot->nodeid, slot->slot);
+	conn->cc_recovery_handler(slot->nodeid, conn->cc_recovery_data);
+
+}
+
+static void user_recover_done(void *arg, struct dlm_slot *slots,
+		int num_slots, int our_slot,
+		uint32_t generation)
+{
+	struct ocfs2_cluster_connection *conn = arg;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+	int i;
+
+	for (i = 0; i < num_slots; i++)
+		if (slots[i].slot == our_slot) {
+			atomic_set(&lc->oc_this_node, slots[i].nodeid);
+			break;
+		}
+
+	lc->oc_our_slot = our_slot;
+}
+
+const struct dlm_lockspace_ops ocfs2_ls_ops = {
+	.recover_prep = user_recover_prep,
+	.recover_slot = user_recover_slot,
+	.recover_done = user_recover_done,
+};
+
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch
ocfs2-code-cleanup-remove-unused-functions.patch

