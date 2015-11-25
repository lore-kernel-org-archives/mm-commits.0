From: akpm@linux-foundation.org
Subject: + o2hb-increase-unsteady-iterations.patch added to -mm tree
Date: Tue, 24 Nov 2015 16:16:10 -0800
Message-ID: <5654fdca.WDzha07j9aO/2qBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbbKYAQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 19:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: increase unsteady iterations
has been added to the -mm tree.  Its filename is
     o2hb-increase-unsteady-iterations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/o2hb-increase-unsteady-iterations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/o2hb-increase-unsteady-iterations.patch

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
Subject: ocfs2: o2hb: increase unsteady iterations

When run multiple xattr test of ocfs2-test on a three-nodes cluster, mount
failed sometimes with the following message.

o2hb: Unable to stabilize heartbeart on region D18B775E758D4D80837E8CF3D086AD4A (xvdb)

Stabilize heartbeat depends on the timing order to mount ocfs2 from
cluster nodes and how fast the tcp connections are established.  So
increase unsteady interations to leave more time for it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~o2hb-increase-unsteady-iterations fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~o2hb-increase-unsteady-iterations
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1780,8 +1780,8 @@ static ssize_t o2hb_region_dev_store(str
 	}
 	++live_threshold;
 	atomic_set(&reg->hr_steady_iterations, live_threshold);
-	/* unsteady_iterations is double the steady_iterations */
-	atomic_set(&reg->hr_unsteady_iterations, (live_threshold << 1));
+	/* unsteady_iterations is triple the steady_iterations */
+	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

o2hb-increase-unsteady-iterations.patch

