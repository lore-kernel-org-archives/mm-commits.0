From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
 added to -mm tree
Date: Tue, 11 Nov 2014 13:23:04 -0800
Message-ID: <54627e38.R9+TexAIk6S9tjGb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaKKVXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 16:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix error handling when creating debugfs root in ocfs2_init()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

