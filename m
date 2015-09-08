From: akpm@linux-foundation.org
Subject: [merged] ocfs2-optimize-error-handling-in-dlm_request_join.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:33 -0700
Message-ID: <55ef22b9.OiQSsFQnv+OrUNhe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: norton.zhu@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: optimize error handling in dlm_request_join
has been removed from the -mm tree.  Its filename was
     ocfs2-optimize-error-handling-in-dlm_request_join.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Norton.Zhu" <norton.zhu@huawei.com>
Subject: ocfs2: optimize error handling in dlm_request_join

Currently error handling in dlm_request_join is a little obscure, so
optimize it to promote readability.

If packet.code is invalid, reset it to JOIN_DISALLOW to keep it meaningful. 
It only influences the log printing.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   71 ++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-optimize-error-handling-in-dlm_request_join fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-optimize-error-handling-in-dlm_request_join
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1465,39 +1465,46 @@ static int dlm_request_join(struct dlm_c
 	if (status == -ENOPROTOOPT) {
 		status = 0;
 		*response = JOIN_OK_NO_MAP;
-	} else if (packet.code == JOIN_DISALLOW ||
-		   packet.code == JOIN_OK_NO_MAP) {
-		*response = packet.code;
-	} else if (packet.code == JOIN_PROTOCOL_MISMATCH) {
-		mlog(ML_NOTICE,
-		     "This node requested DLM locking protocol %u.%u and "
-		     "filesystem locking protocol %u.%u.  At least one of "
-		     "the protocol versions on node %d is not compatible, "
-		     "disconnecting\n",
-		     dlm->dlm_locking_proto.pv_major,
-		     dlm->dlm_locking_proto.pv_minor,
-		     dlm->fs_locking_proto.pv_major,
-		     dlm->fs_locking_proto.pv_minor,
-		     node);
-		status = -EPROTO;
-		*response = packet.code;
-	} else if (packet.code == JOIN_OK) {
-		*response = packet.code;
-		/* Use the same locking protocol as the remote node */
-		dlm->dlm_locking_proto.pv_minor = packet.dlm_minor;
-		dlm->fs_locking_proto.pv_minor = packet.fs_minor;
-		mlog(0,
-		     "Node %d responds JOIN_OK with DLM locking protocol "
-		     "%u.%u and fs locking protocol %u.%u\n",
-		     node,
-		     dlm->dlm_locking_proto.pv_major,
-		     dlm->dlm_locking_proto.pv_minor,
-		     dlm->fs_locking_proto.pv_major,
-		     dlm->fs_locking_proto.pv_minor);
 	} else {
-		status = -EINVAL;
-		mlog(ML_ERROR, "invalid response %d from node %u\n",
-		     packet.code, node);
+		*response = packet.code;
+		switch (packet.code) {
+		case JOIN_DISALLOW:
+		case JOIN_OK_NO_MAP:
+			break;
+		case JOIN_PROTOCOL_MISMATCH:
+			mlog(ML_NOTICE,
+			     "This node requested DLM locking protocol %u.%u and "
+			     "filesystem locking protocol %u.%u.  At least one of "
+			     "the protocol versions on node %d is not compatible, "
+			     "disconnecting\n",
+			     dlm->dlm_locking_proto.pv_major,
+			     dlm->dlm_locking_proto.pv_minor,
+			     dlm->fs_locking_proto.pv_major,
+			     dlm->fs_locking_proto.pv_minor,
+			     node);
+			status = -EPROTO;
+			break;
+		case JOIN_OK:
+			/* Use the same locking protocol as the remote node */
+			dlm->dlm_locking_proto.pv_minor = packet.dlm_minor;
+			dlm->fs_locking_proto.pv_minor = packet.fs_minor;
+			mlog(0,
+			     "Node %d responds JOIN_OK with DLM locking protocol "
+			     "%u.%u and fs locking protocol %u.%u\n",
+			     node,
+			     dlm->dlm_locking_proto.pv_major,
+			     dlm->dlm_locking_proto.pv_minor,
+			     dlm->fs_locking_proto.pv_major,
+			     dlm->fs_locking_proto.pv_minor);
+			break;
+		default:
+			status = -EINVAL;
+			mlog(ML_ERROR, "invalid response %d from node %u\n",
+			     packet.code, node);
+			/* Reset response to JOIN_DISALLOW */
+			*response = JOIN_DISALLOW;
+			break;
+		}
 	}
 
 	mlog(0, "status %d, node %d response is %d\n", status, node,
_

Patches currently in -mm which might be from norton.zhu@huawei.com are


