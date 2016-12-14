From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-replace-current_time-macro.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:23:22 -0800
Message-ID: <58519c2a.lA4WNNmykDFbNKq5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbcLNTXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace CURRENT_TIME macro
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-replace-current_time-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: ocfs2: replace CURRENT_TIME macro

CURRENT_TIME is not y2038 safe.

Use y2038 safe ktime_get_real_seconds() here for timestamps.  struct
heartbeat_block's hb_seq and deletetion time are already 64 bits wide and
accommodate times beyond y2038.

Also use y2038 safe ktime_get_real_ts64() for on disk inode timestamps. 
These are also wide enough to accommodate time64_t.

Link: http://lkml.kernel.org/r/1475365298-29236-1-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 fs/ocfs2/inode.c             |    2 +-
 fs/ocfs2/namei.c             |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~fs-ocfs2-replace-current_time-macro fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~fs-ocfs2-replace-current_time-macro
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -741,7 +741,7 @@ static inline void o2hb_prepare_block(st
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
 	memset(hb_block, 0, reg->hr_block_bytes);
 	/* TODO: time stuff */
-	cputime = CURRENT_TIME.tv_sec;
+	cputime = ktime_get_real_seconds();
 	if (!cputime)
 		cputime = 1;
 
diff -puN fs/ocfs2/inode.c~fs-ocfs2-replace-current_time-macro fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~fs-ocfs2-replace-current_time-macro
+++ a/fs/ocfs2/inode.c
@@ -703,7 +703,7 @@ static int ocfs2_remove_inode(struct ino
 		goto bail_commit;
 	}
 
-	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
+	di->i_dtime = cpu_to_le64(ktime_get_real_seconds());
 	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
 	ocfs2_journal_dirty(handle, di_bh);
 
diff -puN fs/ocfs2/namei.c~fs-ocfs2-replace-current_time-macro fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~fs-ocfs2-replace-current_time-macro
+++ a/fs/ocfs2/namei.c
@@ -516,6 +516,7 @@ static int __ocfs2_mknod_locked(struct i
 	struct ocfs2_extent_list *fel;
 	u16 feat;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct timespec64 ts;
 
 	*new_fe_bh = NULL;
 
@@ -564,10 +565,11 @@ static int __ocfs2_mknod_locked(struct i
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
+	ktime_get_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
-		cpu_to_le64(CURRENT_TIME.tv_sec);
+		cpu_to_le64(ts.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
-		cpu_to_le32(CURRENT_TIME.tv_nsec);
+		cpu_to_le32(ts.tv_nsec);
 	fe->i_dtime = 0;
 
 	/*
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are


