From: akpm@linux-foundation.org
Subject: + ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch added to -mm tree
Date: Mon, 01 Jul 2013 16:18:53 -0700
Message-ID: <51d20e5d.d0qnwaPgSLrlhG0C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAXSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 19:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, gurudas.pai@oracle.com, n_iwamatsu@jp.fujitsu.com

Subject: + ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch added to -mm tree
To: n_iwamatsu@jp.fujitsu.com,gurudas.pai@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 16:18:53 -0700


The patch titled
     Subject: ocfs2: submit disk heartbeat bio using WRITE_SYNC
has been added to the -mm tree.  Its filename is
     ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -492,7 +492,7 @@ static int o2hb_issue_node_write(struct
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE, bio);
+	submit_bio(WRITE_SYNC, bio);
 
 	status = 0;
 bail:
_

Patches currently in -mm which might be from n_iwamatsu@jp.fujitsu.com are

ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch
ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention.patch
ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch

