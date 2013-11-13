From: akpm@linux-foundation.org
Subject: [merged] ocfs2-break-useless-while-loop.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:37:26 -0800
Message-ID: <5283e306.nOEFyqlVAbInLeDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: [merged] ocfs2-break-useless-while-loop.patch removed from -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:26 -0800


The patch titled
     Subject: ocfs2: break useless while loop
has been removed from the -mm tree.  Its filename was
     ocfs2-break-useless-while-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: break useless while loop

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-break-useless-while-loop fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-break-useless-while-loop
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1885,8 +1885,10 @@ ok:
 			 * up nodes that this node contacted */
 			while ((nn = find_next_bit (mle->response_map, O2NM_MAX_NODES,
 						    nn+1)) < O2NM_MAX_NODES) {
-				if (nn != dlm->node_num && nn != assert->node_idx)
+				if (nn != dlm->node_num && nn != assert->node_idx) {
 					master_request = 1;
+					break;
+				}
 			}
 		}
 		mle->master = assert->node_idx;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
configfs-fix-race-between-dentry-put-and-lookup.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

