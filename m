From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:31 -0700
Message-ID: <51db11b3.Lj6470VoiRMxhdPW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3GHTXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, n_iwamatsu@jp.fujitsu.com, mfasheh@suse.com, jlbec@evilplan.org, gurudas.pai@oracle.com, jeff.liu@oracle.com

Subject: [merged] ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention.patch removed from -mm tree
To: jeff.liu@oracle.com,gurudas.pai@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,n_iwamatsu@jp.fujitsu.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:31 -0700


The patch titled
     Subject: ocfs2: consolidate o2hb_global_hearbeat_mode_set() naming convention
has been removed from the -mm tree.  Its filename was
     ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: consolidate o2hb_global_hearbeat_mode_set() naming convention

s/o2hb_global_hearbeat_mode_set/o2hb_global_heartbeat_mode_set/ to make
the signature of those routines in a consistent manner with others for
heartbeating.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Cc: Srinivas Eeeda <srinivas.eeda@oracle.com>
Cc: Tao Ma <tm@tao.ma>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -176,7 +176,7 @@ static void o2hb_dead_threshold_set(unsi
 	}
 }
 
-static int o2hb_global_hearbeat_mode_set(unsigned int hb_mode)
+static int o2hb_global_heartbeat_mode_set(unsigned int hb_mode)
 {
 	int ret = -1;
 
@@ -2271,7 +2271,7 @@ ssize_t o2hb_heartbeat_group_mode_store(
 		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
 			continue;
 
-		ret = o2hb_global_hearbeat_mode_set(i);
+		ret = o2hb_global_heartbeat_mode_set(i);
 		if (!ret)
 			printk(KERN_NOTICE "o2hb: Heartbeat mode set to %s\n",
 			       o2hb_heartbeat_mode_desc[i]);
@@ -2304,7 +2304,7 @@ static struct configfs_attribute *o2hb_h
 	NULL,
 };
 
-static struct configfs_item_operations o2hb_hearbeat_group_item_ops = {
+static struct configfs_item_operations o2hb_heartbeat_group_item_ops = {
 	.show_attribute		= o2hb_heartbeat_group_show,
 	.store_attribute	= o2hb_heartbeat_group_store,
 };
@@ -2316,7 +2316,7 @@ static struct configfs_group_operations
 
 static struct config_item_type o2hb_heartbeat_group_type = {
 	.ct_group_ops	= &o2hb_heartbeat_group_group_ops,
-	.ct_item_ops	= &o2hb_hearbeat_group_item_ops,
+	.ct_item_ops	= &o2hb_heartbeat_group_item_ops,
 	.ct_attrs	= o2hb_heartbeat_group_attrs,
 	.ct_owner	= THIS_MODULE,
 };
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

