From: akpm@linux-foundation.org
Subject: + ocfs2-cleanup-unused-func-declaration-and-assignment.patch
 added to -mm tree
Date: Fri, 13 Oct 2017 14:27:49 -0700
Message-ID: <59e12fd5.Xi5FbsNX7ZoJ3mKm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdJMV1w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup unused func declaration and assignment
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-unused-func-declaration-and-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-unused-func-declaration-and-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-unused-func-declaration-and-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: cleanup unused func declaration and assignment

Link: http://lkml.kernel.org/r/59E064BB.8000005@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c             |    2 --
 fs/ocfs2/cluster/heartbeat.h |    2 --
 2 files changed, 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-cleanup-unused-func-declaration-and-assignment fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-cleanup-unused-func-declaration-and-assignment
+++ a/fs/ocfs2/alloc.c
@@ -3585,8 +3585,6 @@ static int ocfs2_merge_rec_left(struct o
 		 * The easy case - we can just plop the record right in.
 		 */
 		*left_rec = *split_rec;
-
-		has_empty_extent = 0;
 	} else
 		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);
 
diff -puN fs/ocfs2/cluster/heartbeat.h~ocfs2-cleanup-unused-func-declaration-and-assignment fs/ocfs2/cluster/heartbeat.h
--- a/fs/ocfs2/cluster/heartbeat.h~ocfs2-cleanup-unused-func-declaration-and-assignment
+++ a/fs/ocfs2/cluster/heartbeat.h
@@ -79,10 +79,8 @@ void o2hb_fill_node_map(unsigned long *m
 			unsigned bytes);
 void o2hb_exit(void);
 int o2hb_init(void);
-int o2hb_check_node_heartbeating(u8 node_num);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
-int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
 int o2hb_get_all_regions(char *region_uuids, u8 numregions);
 int o2hb_global_heartbeat_active(void);
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-no-need-flush-workqueue-before-destroying-it.patch
ocfs2-cleanup-unused-func-declaration-and-assignment.patch

