From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
 added to -mm tree
Date: Tue, 28 Oct 2014 13:59:23 -0700
Message-ID: <545003ab.+wO5EVnpy53NYHy1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaJ1U7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not fallback to buffer I/O write if appending
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

