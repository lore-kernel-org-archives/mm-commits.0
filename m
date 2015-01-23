From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch removed from
 -mm tree
Date: Thu, 22 Jan 2015 16:30:17 -0800
Message-ID: <54c19619.w8F6Y6yjy9xmg6an%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbbAWAaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 19:30:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fallback to buffer I/O write if appending
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Weiwei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fallback to buffer I/O write if appending

Now we can do direct io and do not fallback to buffered IO any more in
case of append O_DIRECT write.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
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

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

