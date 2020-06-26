From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 05/32] ocfs2: avoid inode removal while nfsd is
 accessing it
Date: Thu, 25 Jun 2020 20:29:30 -0700
Message-ID: <20200626032930.4vH1ff2cG%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZD3b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:29:31 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, stable@vger.kernel.org, torvalds@linux-foundation.org

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: avoid inode removal while nfsd is accessing it

Patch series "ocfs2: fix nfsd over ocfs2 issues", v2.

This is a series of patches to fix issues on nfsd over ocfs2.  patch 1 is
to avoid inode removed while nfsd access it patch 2 & 3 is to fix a panic
issue.


This patch (of 4):

When nfsd is getting file dentry using handle or parent dentry of some
dentry, one cluster lock is used to avoid inode removed from other node,
but it still could be removed from local node, so use a rw lock to avoid
this.

Link: http://lkml.kernel.org/r/20200616183829.87211-1-junxiao.bi@oracle.com
Link: http://lkml.kernel.org/r/20200616183829.87211-2-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   17 ++++++++++++++++-
 fs/ocfs2/ocfs2.h   |    1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-avoid-inode-removed-while-nfsd-access-it
+++ a/fs/ocfs2/dlmglue.c
@@ -689,6 +689,12 @@ static void ocfs2_nfs_sync_lock_res_init
 				   &ocfs2_nfs_sync_lops, osb);
 }
 
+static void ocfs2_nfs_sync_lock_init(struct ocfs2_super *osb)
+{
+	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	init_rwsem(&osb->nfs_sync_rwlock);
+}
+
 void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb)
 {
 	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
@@ -2855,6 +2861,11 @@ int ocfs2_nfs_sync_lock(struct ocfs2_sup
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	if (ex)
+		down_write(&osb->nfs_sync_rwlock);
+	else
+		down_read(&osb->nfs_sync_rwlock);
+
 	if (ocfs2_mount_local(osb))
 		return 0;
 
@@ -2873,6 +2884,10 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_
 	if (!ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, lockres,
 				     ex ? LKM_EXMODE : LKM_PRMODE);
+	if (ex)
+		up_write(&osb->nfs_sync_rwlock);
+	else
+		up_read(&osb->nfs_sync_rwlock);
 }
 
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
@@ -3340,7 +3355,7 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
-	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	ocfs2_nfs_sync_lock_init(osb);
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-inode-removed-while-nfsd-access-it
+++ a/fs/ocfs2/ocfs2.h
@@ -395,6 +395,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
+	struct rw_semaphore nfs_sync_rwlock;
 	struct ocfs2_lock_res osb_trim_fs_lockres;
 	struct mutex obs_trim_fs_mutex;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
_
