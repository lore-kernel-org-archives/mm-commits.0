From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:21 -0700
Message-ID: <533f084d.hx0V1UG3wSsxu+0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaDDTaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, guozhonghua@h3c.com

Subject: [merged] ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler.patch removed from -mm tree
To: guozhonghua@h3c.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:21 -0700


The patch titled
     Subject: ocfs2: fix deadlock risk when kmalloc failed in dlm_query_region_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhonghua Guo <guozhonghua@h3c.com>
Subject: ocfs2: fix deadlock risk when kmalloc failed in dlm_query_region_handler

In dlm_query_region_handler(), once kmalloc failed, it will unlock
dlm_domain_lock without lock first, then deadlock happens.

Signed-off-by: Zhonghua Guo <guozhonghua@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Tested-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-dead-lock-risk-when-kmalloc-failed-in-dlm_query_region_handler
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1123,7 +1123,6 @@ static int dlm_query_region_handler(stru
 	struct dlm_ctxt *dlm = NULL;
 	char *local = NULL;
 	int status = 0;
-	int locked = 0;
 
 	qr = (struct dlm_query_region *) msg->buf;
 
@@ -1132,10 +1131,8 @@ static int dlm_query_region_handler(stru
 
 	/* buffer used in dlm_mast_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
-	if (!local) {
-		status = -ENOMEM;
-		goto bail;
-	}
+	if (!local)
+		return -ENOMEM;
 
 	status = -EINVAL;
 
@@ -1144,16 +1141,15 @@ static int dlm_query_region_handler(stru
 	if (!dlm) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "before join domain\n", qr->qr_node, qr->qr_domain);
-		goto bail;
+		goto out_domain_lock;
 	}
 
 	spin_lock(&dlm->spinlock);
-	locked = 1;
 	if (dlm->joining_node != qr->qr_node) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "but joining node is %d\n", qr->qr_node, qr->qr_domain,
 		     dlm->joining_node);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	/* Support for global heartbeat was added in 1.1 */
@@ -1163,14 +1159,15 @@ static int dlm_query_region_handler(stru
 		     "but active dlm protocol is %d.%d\n", qr->qr_node,
 		     qr->qr_domain, dlm->dlm_locking_proto.pv_major,
 		     dlm->dlm_locking_proto.pv_minor);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	status = dlm_match_regions(dlm, qr, local, sizeof(qr->qr_regions));
 
-bail:
-	if (locked)
-		spin_unlock(&dlm->spinlock);
+out_dlm_lock:
+	spin_unlock(&dlm->spinlock);
+
+out_domain_lock:
 	spin_unlock(&dlm_domain_lock);
 
 	kfree(local);
_

Patches currently in -mm which might be from guozhonghua@h3c.com are

origin.patch

