From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:20 -0700
Message-ID: <552eb724.goGH5l5JhAoyjzGD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use ENOENT instead of EEXIST when get system file fails
has been removed from the -mm tree.  Its filename was
     ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: use ENOENT instead of EEXIST when get system file fails

When ocfs2_get_system_file_inode fails, it is obscure to set the return
value to -EEXIST. So change it to -ENOENT.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    4 ++--
 fs/ocfs2/namei.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails
+++ a/fs/ocfs2/inode.c
@@ -624,7 +624,7 @@ static int ocfs2_remove_inode(struct ino
 		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
 					    le16_to_cpu(di->i_suballoc_slot));
 	if (!inode_alloc_inode) {
-		status = -EEXIST;
+		status = -ENOENT;
 		mlog_errno(status);
 		goto bail;
 	}
@@ -742,7 +742,7 @@ static int ocfs2_wipe_inode(struct inode
 							       ORPHAN_DIR_SYSTEM_INODE,
 							       orphaned_slot);
 		if (!orphan_dir_inode) {
-			status = -EEXIST;
+			status = -ENOENT;
 			mlog_errno(status);
 			goto bail;
 		}
diff -puN fs/ocfs2/namei.c~ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails
+++ a/fs/ocfs2/namei.c
@@ -2808,7 +2808,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 						       ORPHAN_DIR_SYSTEM_INODE,
 						       osb->slot_num);
 	if (!orphan_dir_inode) {
-		status = -EEXIST;
+		status = -ENOENT;
 		mlog_errno(status);
 		goto leave;
 	}
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

