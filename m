From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-add-deref_done-message.patch added to -mm tree
Date: Tue, 26 Jan 2016 13:21:06 -0800
Message-ID: <56a7e342.EmgQgzuvFhMxL5F5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcAZVVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: add DEREF_DONE message
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-add-deref_done-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-add-deref_done-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-add-deref_done-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: add DEREF_DONE message

This patch is to add DEREF_DONE message and corresponding handler.  Node
can purge the lock resource after receiving this message.  As a new
message is added, so increase the minor number of dlm protocol version.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |   12 +++
 fs/ocfs2/dlm/dlmdomain.c |   11 +++
 fs/ocfs2/dlm/dlmmaster.c |  116 +++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-add-deref_done-message fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-add-deref_done-message
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -451,6 +451,7 @@ enum {
 	DLM_QUERY_REGION		= 519,
 	DLM_QUERY_NODEINFO		= 520,
 	DLM_BEGIN_EXIT_DOMAIN_MSG	= 521,
+	DLM_DEREF_LOCKRES_DONE		= 522,
 };
 
 struct dlm_reco_node_data
@@ -782,6 +783,15 @@ struct dlm_deref_lockres
 	u8 name[O2NM_MAX_NAME_LEN];
 };
 
+struct dlm_deref_lockres_done {
+	u32 pad1;
+	u16 pad2;
+	u8 node_idx;
+	u8 namelen;
+
+	u8 name[O2NM_MAX_NAME_LEN];
+};
+
 static inline enum dlm_status
 __dlm_lockres_state_to_status(struct dlm_lock_resource *res)
 {
@@ -968,6 +978,8 @@ int dlm_assert_master_handler(struct o2n
 void dlm_assert_master_post_handler(int status, void *data, void *ret_data);
 int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 			      void **ret_data);
+int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
+			      void **ret_data);
 int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 				void **ret_data);
 int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-add-deref_done-message fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-add-deref_done-message
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -132,10 +132,13 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domai
  *	- Message DLM_QUERY_NODEINFO added to allow online node removes
  * New in version 1.2:
  * 	- Message DLM_BEGIN_EXIT_DOMAIN_MSG added to mark start of exit domain
+ * New in version 1.3:
+ *	- Message DLM_DEREF_LOCKRES_DONE added to inform non-master that the
+ *	  refmap is cleared
  */
 static const struct dlm_protocol_version dlm_protocol = {
 	.pv_major = 1,
-	.pv_minor = 2,
+	.pv_minor = 3,
 };
 
 #define DLM_DOMAIN_BACKOFF_MS 200
@@ -1853,7 +1856,13 @@ static int dlm_register_domain_handlers(
 					sizeof(struct dlm_exit_domain),
 					dlm_begin_exit_domain_handler,
 					dlm, NULL, &dlm->dlm_domain_handlers);
+	if (status)
+		goto bail;
 
+	status = o2net_register_handler(DLM_DEREF_LOCKRES_DONE, dlm->key,
+					sizeof(struct dlm_deref_lockres_done),
+					dlm_deref_lockres_done_handler,
+					dlm, NULL, &dlm->dlm_domain_handlers);
 bail:
 	if (status)
 		dlm_unregister_domain_handlers(dlm);
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-add-deref_done-message fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-add-deref_done-message
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2375,6 +2375,122 @@ done:
 	return ret;
 }
 
+int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
+			      void **ret_data)
+{
+	struct dlm_ctxt *dlm = data;
+	struct dlm_deref_lockres_done *deref
+			= (struct dlm_deref_lockres_done *)msg->buf;
+	struct dlm_lock_resource *res = NULL;
+	char *name;
+	unsigned int namelen;
+	int ret = -EINVAL;
+	u8 node;
+	unsigned int hash;
+
+	if (!dlm_grab(dlm))
+		return 0;
+
+	name = deref->name;
+	namelen = deref->namelen;
+	node = deref->node_idx;
+
+	if (namelen > DLM_LOCKID_NAME_MAX) {
+		mlog(ML_ERROR, "Invalid name length!");
+		goto done;
+	}
+	if (deref->node_idx >= O2NM_MAX_NODES) {
+		mlog(ML_ERROR, "Invalid node number: %u\n", node);
+		goto done;
+	}
+
+	hash = dlm_lockid_hash(name, namelen);
+
+	spin_lock(&dlm->spinlock);
+	res = __dlm_lookup_lockres_full(dlm, name, namelen, hash);
+	if (!res) {
+		spin_unlock(&dlm->spinlock);
+		mlog(ML_ERROR, "%s:%.*s: bad lockres name\n",
+		     dlm->name, namelen, name);
+		goto done;
+	}
+
+	spin_lock(&res->spinlock);
+	BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));
+	if (!list_empty(&res->purge)) {
+		mlog(0, "%s: Removing res %.*s from purgelist\n",
+			dlm->name, res->lockname.len, res->lockname.name);
+		list_del_init(&res->purge);
+		dlm_lockres_put(res);
+		dlm->purge_count--;
+	}
+
+	if (!__dlm_lockres_unused(res)) {
+		mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
+			dlm->name, res->lockname.len, res->lockname.name);
+		__dlm_print_one_lock_resource(res);
+		BUG();
+	}
+
+	__dlm_unhash_lockres(dlm, res);
+
+	spin_lock(&dlm->track_lock);
+	if (!list_empty(&res->tracking))
+		list_del_init(&res->tracking);
+	else {
+		mlog(ML_ERROR, "%s: Resource %.*s not on the Tracking list\n",
+		     dlm->name, res->lockname.len, res->lockname.name);
+		__dlm_print_one_lock_resource(res);
+	}
+	spin_unlock(&dlm->track_lock);
+
+	/* lockres is not in the hash now. drop the flag and wake up
+	 * any processes waiting in dlm_get_lock_resource.
+	 */
+	res->state &= ~DLM_LOCK_RES_DROPPING_REF;
+	spin_unlock(&res->spinlock);
+	wake_up(&res->wq);
+
+	dlm_lockres_put(res);
+
+	spin_unlock(&dlm->spinlock);
+
+done:
+	dlm_put(dlm);
+	return ret;
+}
+
+static void dlm_drop_lockres_ref_done(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res, u8 node)
+{
+	struct dlm_deref_lockres_done deref;
+	int ret = 0, r;
+	const char *lockname;
+	unsigned int namelen;
+
+	lockname = res->lockname.name;
+	namelen = res->lockname.len;
+	BUG_ON(namelen > O2NM_MAX_NAME_LEN);
+
+	memset(&deref, 0, sizeof(deref));
+	deref.node_idx = dlm->node_num;
+	deref.namelen = namelen;
+	memcpy(deref.name, lockname, namelen);
+
+	ret = o2net_send_message(DLM_DEREF_LOCKRES_DONE, dlm->key,
+				 &deref, sizeof(deref), node, &r);
+	if (ret < 0) {
+		mlog(ML_ERROR, "%s: res %.*s, error %d send DEREF DONE "
+				" to node %u\n", dlm->name, namelen,
+				lockname, ret, node);
+	} else if (r < 0) {
+		/* ignore the error */
+		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
+		     dlm->name, namelen, lockname, node, r);
+		dlm_print_one_lock_resource(res);
+	}
+}
+
 static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_ctxt *dlm;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-add-deref_done-message.patch
ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

