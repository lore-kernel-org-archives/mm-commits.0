From: akpm@linux-foundation.org
Subject: + ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch added
 to -mm tree
Date: Tue, 28 Mar 2017 15:32:27 -0700
Message-ID: <58dae47b.fmpK6keB5Mjtjoe4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbdC1Wc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 18:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jiangqi903@gmail.com, jlbec@evilplan.org, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: revert hb threshold to keep compatible
has been added to the -mm tree.  Its filename is
     ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch

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
Subject: ocfs2: o2hb: revert hb threshold to keep compatible

Configfs is the interface for ocfs2-tools to configure the kernel. 
Changing heartbeat dead threshold name in configfs will cause a
compatiblity issue, so revert it.

Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and store methods")
Link: http://lkml.kernel.org/r/1490665245-15374-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-revert-hb-threshold-to-keep-compatible fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-revert-hb-threshold-to-keep-compatible
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2242,13 +2242,13 @@ unlock:
 	spin_unlock(&o2hb_live_lock);
 }
 
-static ssize_t o2hb_heartbeat_group_threshold_show(struct config_item *item,
+static ssize_t o2hb_heartbeat_group_dead_threshold_show(struct config_item *item,
 		char *page)
 {
 	return sprintf(page, "%u\n", o2hb_dead_threshold);
 }
 
-static ssize_t o2hb_heartbeat_group_threshold_store(struct config_item *item,
+static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	unsigned long tmp;
@@ -2297,11 +2297,11 @@ static ssize_t o2hb_heartbeat_group_mode
 
 }
 
-CONFIGFS_ATTR(o2hb_heartbeat_group_, threshold);
+CONFIGFS_ATTR(o2hb_heartbeat_group_, dead_threshold);
 CONFIGFS_ATTR(o2hb_heartbeat_group_, mode);
 
 static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
-	&o2hb_heartbeat_group_attr_threshold,
+	&o2hb_heartbeat_group_attr_dead_threshold,
 	&o2hb_heartbeat_group_attr_mode,
 	NULL,
 };
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch

