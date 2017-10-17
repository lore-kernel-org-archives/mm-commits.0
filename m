From: akpm@linux-foundation.org
Subject: + ocfs2-fix-qs_holds-may-could-not-be-zero.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 16:20:31 -0700
Message-ID: <59e6903f.oo5N4z72/MCKJ9h/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60698 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755951AbdJQXUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhang.yangB@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix qs_holds may could not be zero
has been added to the -mm tree.  Its filename is
     ocfs2-fix-qs_holds-may-could-not-be-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-qs_holds-may-could-not-be-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-qs_holds-may-could-not-be-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhangyang <zhang.yangB@h3c.com>
Subject: ocfs2: fix qs_holds may could not be zero

In our test, We fond that when the network down, qs->qs_holds could not b=
e reduce to zero, it will lead to the node can't do fence.

o2net_idle_timer -> o2quo_conn_err -> qs->qs_holds++, after
O2NET_QUORUM_DE= LAY_MS if qs_holds could be subtract to zero, it could do
make_decision.

But if there are many nodes, when one node network down which contains
o2net connections may not do o2net_idle_timer at the same time.

So when a o2net_node have done nn->nn_still_up, but the qs_holds is not
zero.  because the other o2net_node have not done nn->nn_still_up.  So the
first o2net_node will do o2net_idle_timer again, and the qs_holds could be
add again.  And the qs_holds is global variable, so it formed a loop, the
node could not do o2quo_make_decision, because of qs_holds never be zero.

I alter the function o2quo_conn_err, take o2quo_set_hold under control of
t= he bit map qs_conn_bm.

Link: http://lkml.kernel.org/r/7F50894FD17BEC45AAC26E5BADA6CE330C60F99A@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Yang Zhang <zhang.yangB@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-fix-qs_holds-may-could-not-be-zero fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-fix-qs_holds-may-could-not-be-zero
+++ a/fs/ocfs2/cluster/quorum.c
@@ -314,13 +314,16 @@ void o2quo_conn_err(u8 node)
 				node, qs->qs_connected);
 
 		clear_bit(node, qs->qs_conn_bm);
+		/*
+		 * Bring set hold within this judgement, in order to avoid
+		 * qs_hold could not be zero.
+		 */
+		if (test_bit(node, qs->qs_hb_bm))
+			o2quo_set_hold(qs, node);
 	}
 
 	mlog(0, "node %u, %d total\n", node, qs->qs_connected);
 
-	if (test_bit(node, qs->qs_hb_bm))
-		o2quo_set_hold(qs, node);
