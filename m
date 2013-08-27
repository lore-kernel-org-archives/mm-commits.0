From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch removed
 from -mm tree
Date: Tue, 27 Aug 2013 14:03:26 -0700
Message-ID: <521d141e.j5XBP0V7SH/Q+bYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3H0VD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yp.fangdong@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, dan.carpenter@oracle.com

Subject: [folded-merged] ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch removed from -mm tree
To: dan.carpenter@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,yp.fangdong@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:03:26 -0700


The patch titled
     Subject: ocfs2: fix up some NULL dereference bugs
has been removed from the -mm tree.  Its filename was
     ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch

This patch was dropped because it was folded into ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix up some NULL dereference bugs

The recent -mm patch 4bce37c3e3 "ocfs2: use list_for_each_entry()
instead of list_for_each()" introduced some NULL dereference bugs and
also a use after free bug in dlm_clean_master_list().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dong Fang <yp.fangdong@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c |    9 +++++----
 fs/ocfs2/dlm/dlmdomain.c  |   15 +++++++--------
 fs/ocfs2/dlm/dlmmaster.c  |    3 ++-
 3 files changed, 14 insertions(+), 13 deletions(-)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -422,6 +422,7 @@ int dlm_convert_lock_handler(struct o2ne
 	struct dlm_convert_lock *cnv = (struct dlm_convert_lock *)msg->buf;
 	struct dlm_lock_resource *res = NULL;
 	struct dlm_lock *lock = NULL;
+	struct dlm_lock *tmp_lock;
 	struct dlm_lockstatus *lksb;
 	enum dlm_status status = DLM_NORMAL;
 	u32 flags;
@@ -467,13 +468,13 @@ int dlm_convert_lock_handler(struct o2ne
 		dlm_error(status);
 		goto leave;
 	}
-	list_for_each_entry(lock, &res->granted, list) {
-		if (lock->ml.cookie == cnv->cookie &&
-		    lock->ml.node == cnv->node_idx) {
+	list_for_each_entry(tmp_lock, &res->granted, list) {
+		if (tmp_lock->ml.cookie == cnv->cookie &&
+		    tmp_lock->ml.node == cnv->node_idx) {
+			lock = tmp_lock;
 			dlm_lock_get(lock);
 			break;
 		}
-		lock = NULL;
 	}
 	spin_unlock(&res->spinlock);
 	if (!lock) {
diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -260,7 +260,7 @@ struct dlm_lock_resource * dlm_lookup_lo
 
 static struct dlm_ctxt * __dlm_lookup_domain_full(const char *domain, int len)
 {
-	struct dlm_ctxt *tmp = NULL;
+	struct dlm_ctxt *tmp;
 
 	assert_spin_locked(&dlm_domain_lock);
 
@@ -269,11 +269,10 @@ static struct dlm_ctxt * __dlm_lookup_do
 	list_for_each_entry(tmp, &dlm_domains, list) {
 		if (strlen(tmp->name) == len &&
 		    memcmp(tmp->name, domain, len)==0)
-			break;
-		tmp = NULL;
+			return tmp;
 	}
 
-	return tmp;
+	return NULL;
 }
 
 /* For null terminated domain strings ONLY */
@@ -362,22 +361,22 @@ static void __dlm_get(struct dlm_ctxt *d
  * you shouldn't trust your pointer. */
 struct dlm_ctxt *dlm_grab(struct dlm_ctxt *dlm)
 {
-	struct dlm_ctxt *target = NULL;
+	struct dlm_ctxt *target;
+	struct dlm_ctxt *ret = NULL;
 
 	spin_lock(&dlm_domain_lock);
 
 	list_for_each_entry(target, &dlm_domains, list) {
 		if (target == dlm) {
 			__dlm_get(target);
+			ret = target;
 			break;
 		}
-
-		target = NULL;
 	}
 
 	spin_unlock(&dlm_domain_lock);
 
-	return target;
+	return ret;
 }
 
 int dlm_domain_fully_joined(struct dlm_ctxt *dlm)
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3180,6 +3180,7 @@ void dlm_clean_master_list(struct dlm_ct
 	struct dlm_master_list_entry *mle;
 	struct dlm_lock_resource *res;
 	struct hlist_head *bucket;
+	struct hlist_node *tmp;
 	unsigned int i;
 
 	mlog(0, "dlm=%s, dead node=%u\n", dlm->name, dead_node);
@@ -3190,7 +3191,7 @@ top:
 	spin_lock(&dlm->master_lock);
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
-		hlist_for_each_entry(mle, bucket, master_hash_node) {
+		hlist_for_each_entry_safe(mle, tmp, bucket, master_hash_node) {
 			BUG_ON(mle->type != DLM_MLE_BLOCK &&
 			       mle->type != DLM_MLE_MASTER &&
 			       mle->type != DLM_MLE_MIGRATION);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
mbind-add-bug_onvma-in-new_vma_page.patch
affs-use-loff_t-in-affs_truncate.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

