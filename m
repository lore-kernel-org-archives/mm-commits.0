From: akpm@linux-foundation.org
Subject: [merged] ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:29 -0700
Message-ID: <51db11b1.3EIPgT8P8N2F1DG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3GHTXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, gurudas.pai@oracle.com, n_iwamatsu@jp.fujitsu.com

Subject: [merged] ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch removed from -mm tree
To: n_iwamatsu@jp.fujitsu.com,gurudas.pai@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:29 -0700


The patch titled
     Subject: ocfs2: submit disk heartbeat bio using WRITE_SYNC
has been removed from the -mm tree.  Its filename was
     ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Subject: ocfs2: submit disk heartbeat bio using WRITE_SYNC

Under heavy I/O load, writing the disk heartbeat can be forced to wait for
minutes, and this causes the node to be fenced.

This patch tries to use WRITE_SYNC in submitting the heartbeat bio, so
that writing the heartbeat will have a priority over other requests.

Signed-off-by: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Acked-by: Tao Ma <tm@tao.ma>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Srinivas Eeeda <srinivas.eeda@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-submit-disk-heartbeat-bio-using-write_sync fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-submit-disk-heartbeat-bio-using-write_sync
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -500,7 +500,7 @@ static int o2hb_issue_node_write(struct
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE, bio);
+	submit_bio(WRITE_SYNC, bio);
 
 	status = 0;
 bail:
_

Patches currently in -mm which might be from n_iwamatsu@jp.fujitsu.com are

origin.patch

