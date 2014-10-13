From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:35 -0700
Message-ID: <543c173f.GOxL/AqUvafq7UZ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaJMSRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: call o2quo_exit() if malloc failed in o2net_init()
has been removed from the -mm tree.  Its filename was
     ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: call o2quo_exit() if malloc failed in o2net_init()

In o2net_init, if malloc failed, it directly returns -ENOMEM.  Then
o2quo_exit won't be called in init_o2nm.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init
+++ a/fs/ocfs2/cluster/tcp.c
@@ -2146,17 +2146,13 @@ int o2net_init(void)
 	o2quo_init();
 
 	if (o2net_debugfs_init())
-		return -ENOMEM;
+		goto out;
 
 	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
 	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
 	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp) {
-		kfree(o2net_hand);
-		kfree(o2net_keep_req);
-		kfree(o2net_keep_resp);
-		return -ENOMEM;
-	}
+	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
+		goto out;
 
 	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
 	o2net_hand->connector_id = cpu_to_be64(1);
@@ -2181,6 +2177,14 @@ int o2net_init(void)
 	}
 
 	return 0;
+
+out:
+	kfree(o2net_hand);
+	kfree(o2net_keep_req);
+	kfree(o2net_keep_resp);
+
+	o2quo_exit();
+	return -ENOMEM;
 }
 
 void o2net_exit(void)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

