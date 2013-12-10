From: akpm@linux-foundation.org
Subject: + ocfs2-add-dlm-recovery-callbacks.patch added to -mm tree
Date: Tue, 10 Dec 2013 14:43:16 -0800
Message-ID: <52a79904.QjbzahxbhzoTZQht%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LJWnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + ocfs2-add-dlm-recovery-callbacks.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:43:16 -0800


The patch titled
     Subject: ocfs2: add DLM recovery callbacks
has been added to the -mm tree.  Its filename is
     ocfs2-add-dlm-recovery-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-dlm-recovery-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-dlm-recovery-callbacks.patch

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

ocfs2-remove-versioning-information.patch
ocfs2-add-clustername-to-cluster-connection.patch
ocfs2-add-dlm-recovery-callbacks.patch
ocfs2-shift-allocation-ocfs2_live_connection-to-user_connect.patch
ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
ocfs2-framework-for-version-lvb.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

