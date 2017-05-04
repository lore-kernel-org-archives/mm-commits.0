From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:08:46 -0700
Message-ID: <20170504190846.3vU7aq6Sb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756183AbdEDTIs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: revert hb threshold to keep compatible
has been removed from the -mm tree.  Its filename was
     ocfs2-o2hb-revert-hb-threshold-to-keep-compatible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: revert hb threshold to keep compatible

Configfs is the interface for ocfs2-tools to set configure to kernel
and $configfs_dir/cluster/$clustername/heartbeat/dead_threshold is the
one used to configure heartbeat dead threshold.  Kernel has a default
value of it but user can set O2CB_HEARTBEAT_THRESHOLD in
/etc/sysconfig/o2cb to override it.

Commit 45b997737a80 ("ocfs2/cluster: use per-attribute show and store
methods") changed heartbeat dead threshold name while ocfs2-tools did
not, so ocfs2-tools won't set this configurable and the default value
is always used.  So revert it.

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


