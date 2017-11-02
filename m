From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-cluster-unlock-the-o2hb_live_lock-before-the-o2nm_depend_item.patch
 removed from -mm tree
Date: Thu, 02 Nov 2017 13:55:42 -0700
Message-ID: <59fb864e.6S05jyfaZZ1nb8BQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbdKBUzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: unlock the o2hb_live_lock before the o2nm_depend_item()
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-unlock-the-o2hb_live_lock-before-the-o2nm_depend_item.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2/cluster: unlock the o2hb_live_lock before the o2nm_depend_item()

In the following situation, the down_write() will be called under the
spin_lock(), which may lead a soft lockup:

o2hb_region_inc_user
 spin_lock(&o2hb_live_lock)
  o2hb_region_pin
   o2nm_depend_item
    configfs_depend_item
     inode_lock
      down_write
      -->here may sleep and reschedule

So we should unlock the o2hb_live_lock before the o2nm_depend_item(), and
get item reference in advance to prevent the region to be released.

Link: http://lkml.kernel.org/r/59FAB46C.9050703@huawei.com
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-unlock-the-o2hb_live_lock-before-the-o2nm_depend_item fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-unlock-the-o2hb_live_lock-before-the-o2nm_depend_item
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2399,8 +2399,15 @@ static int o2hb_region_pin(const char *r
 		if (reg->hr_item_pinned || reg->hr_item_dropped)
 			goto skip_pin;
 
+		config_item_get(&reg->hr_item);
+		spin_unlock(&o2hb_live_lock);
+
 		/* Ignore ENOENT only for local hb (userdlm domain) */
 		ret = o2nm_depend_item(&reg->hr_item);
+
+		config_item_put(&reg->hr_item);
+		spin_lock(&o2hb_live_lock);
+
 		if (!ret) {
 			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
 			reg->hr_item_pinned = 1;
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch
ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch
ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block-v3.patch
ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent.patch

