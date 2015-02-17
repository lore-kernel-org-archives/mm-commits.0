From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch removed from
 -mm tree
Date: Tue, 17 Feb 2015 12:06:26 -0800
Message-ID: <54e39f42.chtULYGgGV5F4ZXJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbbBQUG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fallback to buffer I/O write if appending
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: do not fallback to buffer I/O write if appending

Now we can do direct io and do not fallback to buffered IO any more in
case of append O_DIRECT write.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending
+++ a/fs/ocfs2/file.c
@@ -2116,6 +2116,9 @@ static int ocfs2_prepare_inode_for_write
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos = 0, end;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+		OCFS2_MOUNT_COHERENCY_BUFFERED);
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2204,7 +2207,7 @@ static int ocfs2_prepare_inode_for_write
 		 * one node could wind up truncating another
 		 * nodes writes.
 		 */
-		if (end > i_size_read(inode)) {
+		if (end > i_size_read(inode) && !full_coherency) {
 			*direct_io = 0;
 			break;
 		}
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

