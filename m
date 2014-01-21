From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:28:01 -0800
Message-ID: <52df0281.oV3Pc6iJ9F2i5zlm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaAUX2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:28:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, dan.carpenter@oracle.com, rgoldwyn@suse.de

Subject: [folded-merged] ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix.patch removed from -mm tree
To: rgoldwyn@suse.de,dan.carpenter@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:28:01 -0800


The patch titled
     Subject: ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix.patch

This patch was dropped because it was folded into ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix

 New smatch warnings:
 fs/ocfs2/stack_user.c:938 get_protocol_version() warn: impossible condition '(pv.pv_minor < 0) => (0-255 < 0)'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix
+++ a/fs/ocfs2/stack_user.c
@@ -935,10 +935,6 @@ static int get_protocol_version(struct o
 			goto out;
 		lvb_to_version(lc->oc_lvb, &pv);
 
-		if (pv.pv_minor < 0) {
-			ret = -ERANGE;
-			goto out;
-		}
 		if ((pv.pv_major != running_proto.pv_major) ||
 				(pv.pv_minor > running_proto.pv_minor)) {
 			ret = -EINVAL;
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

ocfs2-remove-versioning-information.patch
ocfs2-add-clustername-to-cluster-connection.patch
ocfs2-add-dlm-recovery-callbacks.patch
ocfs2-shift-allocation-ocfs2_live_connection-to-user_connect.patch
ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
ocfs2-framework-for-version-lvb.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch

