From: akpm@linux-foundation.org
Subject: + ocfs2-cluster-close-a-race-that-fence-cant-be-triggered.patch
 added to -mm tree
Date: Fri, 08 Dec 2017 14:56:50 -0800
Message-ID: <5a2b18b2.GBTjOaKU0JCxXS/e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbdLHW4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 17:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhang.yangB@h3c.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: close a race that fence can't be triggered
has been added to the -mm tree.  Its filename is
     ocfs2-cluster-close-a-race-that-fence-cant-be-triggered.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cluster-close-a-race-that-fence-cant-be-triggered.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cluster-close-a-race-that-fence-cant-be-triggered.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Zhang <zhang.yangB@h3c.com>
Subject: ocfs2/cluster: close a race that fence can't be triggered

When some nodes of cluster face with TCP connection fault, ocfs2 will pick
up a quorum to continue to work and other nodes will be fenced by
resetting host.

In order to decide which node should be fenced, ocfs2 leverages
o2quo_state::qs_holds.  If that variable is reduced to zero, then a try to
decide if fence local node is performed.  However, under a specific
scenario that local node is not disconnected from others at the same time,
above method has a problem to reduce ::qs_holds to zero.

Because, o2net 90s idle timer corresponding to different nodes is
triggered one after another.

node 2				node 3
90s idle timer elapses
clear ::qs_conn_bm
set hold
				40s is passed
				90 idle timer elapses
				clear ::qs_conn_bm
				set hold
still up timer elapses
clear hold (NOT to zero )
90s idle timer elapses AGAIN
				still up timer elapses.
				clear hold
				still up timer elapses

To solve this issue, a node which has already be evicted from ::qs_conn_bm
can't set hold again and again invoked from idle timer.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F3F93B@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Yang Zhang <zhang.yangB@h3c.com>
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-cluster-close-a-race-that-fence-cant-be-triggered fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-cluster-close-a-race-that-fence-cant-be-triggered
+++ a/fs/ocfs2/cluster/quorum.c
@@ -314,12 +314,13 @@ void o2quo_conn_err(u8 node)
 				node, qs->qs_connected);
 
 		clear_bit(node, qs->qs_conn_bm);
+
+		if (test_bit(node, qs->qs_hb_bm))
+			o2quo_set_hold(qs, node);
 	}
 
 	mlog(0, "node %u, %d total\n", node, qs->qs_connected);
 
-	if (test_bit(node, qs->qs_hb_bm))
-		o2quo_set_hold(qs, node);
 
 	spin_unlock(&qs->qs_lock);
 }
_

Patches currently in -mm which might be from zhang.yangB@h3c.com are

ocfs2-cluster-close-a-race-that-fence-cant-be-triggered.patch
ocfs2-fix-qs_holds-may-could-not-be-zero.patch

