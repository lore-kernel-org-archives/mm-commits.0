From: akpm@linux-foundation.org
Subject: [alternative-merged]
 ocfs2-remove-pointless-assignment-in-ocfs2_init.patch removed from -mm tree
Date: Tue, 11 Nov 2014 13:22:07 -0800
Message-ID: <54627dff.tr3NLXI6hcHkBdWt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaKKVWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 16:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove pointless assignment in ocfs2_init()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-pointless-assignment-in-ocfs2_init.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: remove pointless assignment in ocfs2_init()

Remove assignment which is never used.

Coverity id: 1227009.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-remove-pointless-assignment-in-ocfs2_init fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-remove-pointless-assignment-in-ocfs2_init
+++ a/fs/ocfs2/super.c
@@ -1621,10 +1621,8 @@ static int __init ocfs2_init(void)
 	}
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
-	if (!ocfs2_debugfs_root) {
-		status = -EFAULT;
+	if (!ocfs2_debugfs_root)
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
-	}
 
 	ocfs2_set_locking_protocol();
 
_

Patches currently in -mm which might be from jack@suse.cz are

fallocate-create-fan_modify-and-in_modify-events.patch
fanotify-ignore-marks-not-respected.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

