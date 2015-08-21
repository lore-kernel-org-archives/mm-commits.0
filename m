From: akpm@linux-foundation.org
Subject: + ocfs2-optimize-error-handling-in-dlm_request_join.patch added
 to -mm tree
Date: Fri, 21 Aug 2015 14:00:46 -0700
Message-ID: <55d7917e.6vNGqCp572ubvWgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbHUVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 17:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: norton.zhu@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: optimize error handling in dlm_request_join
has been added to the -mm tree.  Its filename is
     ocfs2-optimize-error-handling-in-dlm_request_join.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-optimize-error-handling-in-dlm_request_join.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-optimize-error-handling-in-dlm_request_join.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Norton.Zhu" <norton.zhu@huawei.com>
Subject: ocfs2: optimize error handling in dlm_request_join

Currently error handling in dlm_request_join is a little obscure, so
optimize it to promote readability.

If packet.code is invalid, reset it to JOIN_DISALLOW to keep it meaningful. 
It only influences the log printing.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
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

ocfs2-optimize-error-handling-in-dlm_request_join.patch

