From: akpm@linux-foundation.org
Subject: + ocfs2-nowait-aio-support-v4.patch added to -mm tree
Date: Tue, 16 Jan 2018 14:17:20 -0800
Message-ID: <5a5e79f0.R3UyZOmQrP90DLCE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPWRV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 17:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-nowait-aio-support-v4
has been added to the -mm tree.  Its filename is
     ocfs2-nowait-aio-support-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-nowait-aio-support-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-nowait-aio-support-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-add-ocfs2_overwrite_io-function-v3.patch
ocfs2-nowait-aio-support.patch
ocfs2-nowait-aio-support-v4.patch
ocfs2-add-trimfs-dlm-lock-resource.patch
ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch

