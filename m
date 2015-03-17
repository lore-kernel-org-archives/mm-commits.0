From: akpm@linux-foundation.org
Subject: +
 ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch added
 to -mm tree
Date: Tue, 17 Mar 2015 16:30:50 -0700
Message-ID: <5508b92a.lSiXesmESDq82NpU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbbCQXav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 19:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use ENOENT instead of EEXIST when get system file fails
has been added to the -mm tree.  Its filename is
     ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch

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

ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
ocfs2-use-enoent-instead-of-eexist-when-get-system-file-fails.patch
ocfs2-rollback-the-cleared-bits-if-error-occurs-after-ocfs2_block_group_clear_bits.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

