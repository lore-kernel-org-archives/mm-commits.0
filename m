From: akpm@linux-foundation.org
Subject: +
 ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch added to -mm tree
Date: Thu, 22 Jan 2015 16:35:45 -0800
Message-ID: <54c19761.ajRjEofI+c3CIptc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbbAWAfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 19:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: wait for orphan recovery first once append O_DIRECT write crash
has been added to the -mm tree.  Its filename is
     ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: wait for orphan recovery first once append O_DIRECT write crash

If one node has crashed with orphan entry leftover, another node which do
append O_DIRECT write to the same file will override the
i_dio_orphaned_slot.  Then the old entry won't be cleaned forever.  If
this case happens, we let it wait for orphan recovery first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h   |    2 ++
 fs/ocfs2/journal.c |    2 ++
 fs/ocfs2/namei.c   |   37 +++++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c   |    2 ++
 4 files changed, 43 insertions(+)

diff -puN fs/ocfs2/inode.h~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash
+++ a/fs/ocfs2/inode.h
@@ -81,6 +81,8 @@ struct ocfs2_inode_info
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
+	wait_queue_head_t append_dio_wq;
+
 	struct dquot *i_dquot[MAXQUOTAS];
 };
 
diff -puN fs/ocfs2/journal.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash
+++ a/fs/ocfs2/journal.c
@@ -2205,6 +2205,8 @@ static int ocfs2_recover_orphans(struct
 			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
 			if (ret)
 				mlog_errno(ret);
+
+			wake_up(&OCFS2_I(inode)->append_dio_wq);
 		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
 
 next:
diff -puN fs/ocfs2/namei.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash
+++ a/fs/ocfs2/namei.c
@@ -2578,6 +2578,27 @@ leave:
 	return status;
 }
 
+static int ocfs2_dio_orphan_recovered(struct inode *inode)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return 0;
+	}
+
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	ret = !(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+	return ret;
+}
+
+#define OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL 10000
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
 	struct inode *inode)
 {
@@ -2587,13 +2608,29 @@ int ocfs2_add_inode_to_orphan(struct ocf
 	struct buffer_head *di_bh = NULL;
 	int status = 0;
 	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = NULL;
 
+restart:
 	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+	/*
+	 * Another append dio crashed?
+	 * If so, wait for recovery first.
+	 */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
+		wait_event_interruptible_timeout(OCFS2_I(inode)->append_dio_wq,
+				ocfs2_dio_orphan_recovered(inode),
+				msecs_to_jiffies(OCFS2_DIO_ORPHANED_FL_CHECK_INTERVAL));
+		goto restart;
+	}
+
 	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
 			OCFS2_I(inode)->ip_blkno,
 			orphan_name,
diff -puN fs/ocfs2/super.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash
+++ a/fs/ocfs2/super.c
@@ -1776,6 +1776,8 @@ static void ocfs2_inode_init_once(void *
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
+	init_waitqueue_head(&oi->append_dio_wq);
+
 	ocfs2_metadata_cache_init(INODE_CACHE(&oi->vfs_inode),
 				  &ocfs2_inode_caching_ops);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

