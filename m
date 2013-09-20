From: akpm@linux-foundation.org
Subject: + ocfs2-break-useless-while-loop.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:55:12 -0700
Message-ID: <523cb630.hPkoto8FOPPu3XP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3ITUzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: + ocfs2-break-useless-while-loop.patch added to -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:55:12 -0700


The patch titled
     Subject: ocfs2: break useless while loop
has been added to the -mm tree.  Its filename is
     ocfs2-break-useless-while-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-break-useless-while-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-break-useless-while-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-filec-fix-wrong-comment.patch
ocfs2-break-useless-while-loop.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
linux-next.patch

