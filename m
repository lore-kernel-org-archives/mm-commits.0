From: akpm@linux-foundation.org
Subject: [patch 021/119] ocfs2: add ocfs2_try_rw_lock() and
 ocfs2_try_inode_lock()
Date: Wed, 31 Jan 2018 16:15:17 -0800
Message-ID: <20180201001517.TZeQ_cKXK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()

Patch series "ocfs2: add nowait aio support", v4.

VFS layer has introduced the non-blocking aio flag IOCB_NOWAIT, which
tells the kernel to bail out if an AIO request will block for reasons such
as file allocations, or writeback triggering, or would block while
allocating requests while performing direct I/O.

Subsequently, pwritev2/preadv2 also can leverage this part of kernel code.
So far, ext4/xfs/btrfs have supported this feature.  Add the related code
for the ocfs2 file system.  


This patch (of 3):

Add ocfs2_try_rw_lock and ocfs2_try_inode_lock functions, which will be
used in non-blocking IO scenarios.

[ghe@suse.com: v2]
  Link: http://lkml.kernel.org/r/1511944612-9629-2-git-send-email-ghe@suse.com
Link: http://lkml.kernel.org/r/1511775987-841-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Acked-by: alex chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   21 +++++++++++++++++++++
 fs/ocfs2/dlmglue.h |    4 ++++
 2 files changed, 25 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -1764,6 +1764,27 @@ int ocfs2_rw_lock(struct inode *inode, i
 	return status;
 }
 
+int ocfs2_try_rw_lock(struct inode *inode, int write)
+{
+	int status, level;
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	mlog(0, "inode %llu try to take %s RW lock\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     write ? "EXMODE" : "PRMODE");
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	lockres = &OCFS2_I(inode)->ip_rw_lockres;
+
+	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
+
+	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
+	return status;
+}
+
 void ocfs2_rw_unlock(struct inode *inode, int write)
 {
 	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
diff -puN fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.h
@@ -139,6 +139,7 @@ void ocfs2_lock_res_free(struct ocfs2_lo
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_rw_lock(struct inode *inode, int write);
+int ocfs2_try_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
 int ocfs2_open_lock(struct inode *inode);
 int ocfs2_try_open_lock(struct inode *inode, int write);
@@ -163,6 +164,9 @@ int ocfs2_inode_lock_with_page(struct in
 /* 99% of the time we don't want to supply any additional flags --
  * those are for very specific cases only. */
 #define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0, OI_LS_NORMAL)
+#define ocfs2_try_inode_lock(i, b, e)\
+		ocfs2_inode_lock_full_nested(i, b, e, OCFS2_META_LOCK_NOQUEUE,\
+		OI_LS_NORMAL)
 void ocfs2_inode_unlock(struct inode *inode,
 		       int ex);
 int ocfs2_super_lock(struct ocfs2_super *osb,
_
