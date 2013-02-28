From: akpm@linux-foundation.org
Subject: [merged] ocfs2-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:36 -0800
Message-ID: <20130228201536.A44285A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33245 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3B1UPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:37 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so39515vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: ocfs2: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-convert-to-idr_alloc fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-convert-to-idr_alloc
+++ a/fs/ocfs2/cluster/tcp.c
@@ -304,28 +304,22 @@ static u8 o2net_num_from_nn(struct o2net
 
 static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
-	int ret = 0;
-
-	do {
-		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
-			ret = -EAGAIN;
-			break;
-		}
-		spin_lock(&nn->nn_lock);
-		ret = idr_get_new(&nn->nn_status_idr, nsw, &nsw->ns_id);
-		if (ret == 0)
-			list_add_tail(&nsw->ns_node_item,
-				      &nn->nn_status_list);
-		spin_unlock(&nn->nn_lock);
-	} while (ret == -EAGAIN);
+	int ret;
 
-	if (ret == 0)  {
-		init_waitqueue_head(&nsw->ns_wq);
-		nsw->ns_sys_status = O2NET_ERR_NONE;
-		nsw->ns_status = 0;
+	spin_lock(&nn->nn_lock);
+	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
+	if (ret >= 0) {
+		nsw->ns_id = ret;
+		list_add_tail(&nsw->ns_node_item, &nn->nn_status_list);
 	}
+	spin_unlock(&nn->nn_lock);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+	return 0;
 }
 
 static void o2net_complete_nsw_locked(struct o2net_node *nn,
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

