From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:22 -0800
Message-ID: <5489e89a.WW3yOpmyCUznYBlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbaLKSzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix error handling when creating debugfs root in ocfs2_init()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: fix error handling when creating debugfs root in ocfs2_init()

Error handling if creation of root of debugfs in ocfs2_init() fails is
broken.  Although error code is set we fail to exit ocfs2_init() with
error and thus initialization ends with success.  Later when mounting a
filesystem, ocfs2 debugfs entries end up being created in the root of
debugfs filesystem which is confusing.

Fix the error handling to bail out.

Coverity id: 1227009.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init
+++ a/fs/ocfs2/super.c
@@ -1622,8 +1622,9 @@ static int __init ocfs2_init(void)
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
 	if (!ocfs2_debugfs_root) {
-		status = -EFAULT;
+		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
+		goto out4;
 	}
 
 	ocfs2_set_locking_protocol();
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

