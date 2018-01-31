From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-nowait-aio-support-v4.patch removed from
 -mm tree
Date: Wed, 31 Jan 2018 15:48:02 -0800
Message-ID: <5a7255b2.7tK9obXiJN7PcDYh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753472AbeAaXsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:48:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-nowait-aio-support-v4
has been removed from the -mm tree.  Its filename was
     ocfs2-nowait-aio-support-v4.patch

This patch was dropped because it was folded into ocfs2-nowait-aio-support.patch

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-nowait-aio-support-v4

Compare with v3, modify the check condition for nowait in
ocfs2_file_write_iter() function.  second, add direct-io and nowait
combination check in ocfs2_file_read_iter() function.  Compare with v2, do
some modification in ocfs2_overwrite_io() function for
OCFS2_INLINE_DATA_FL case.

Link: http://lkml.kernel.org/r/1516007283-29932-4-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-nowait-aio-support-v4 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-nowait-aio-support-v4
+++ a/fs/ocfs2/file.c
@@ -2269,7 +2269,7 @@ static ssize_t ocfs2_file_write_iter(str
 	if (count == 0)
 		return 0;
 
-	if (direct_io && nowait) {
+	if (nowait) {
 		if (!inode_trylock(inode))
 			return -EAGAIN;
 	} else
@@ -2282,7 +2282,7 @@ static ssize_t ocfs2_file_write_iter(str
 	 */
 	rw_level = (!direct_io || full_coherency || append_write);
 
-	if (direct_io && nowait)
+	if (nowait)
 		ret = ocfs2_try_rw_lock(inode, rw_level);
 	else
 		ret = ocfs2_rw_lock(inode, rw_level);
@@ -2402,6 +2402,7 @@ static ssize_t ocfs2_file_read_iter(stru
 	int ret = 0, rw_level = -1, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = file_inode(filp);
+	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
 	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
@@ -2417,11 +2418,14 @@ static ssize_t ocfs2_file_read_iter(stru
 		goto bail;
 	}
 
+	if (!direct_io && nowait)
+		return -EOPNOTSUPP;
+
 	/*
 	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
 	 */
-	if (iocb->ki_flags & IOCB_DIRECT) {
+	if (direct_io) {
 		if (nowait)
 			ret = ocfs2_try_rw_lock(inode, 0);
 		else
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-try-a-blocking-lock-before-return-aop_truncated_page.patch
ocfs2-add-trimfs-dlm-lock-resource.patch
ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch

