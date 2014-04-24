From: akpm@linux-foundation.org
Subject: + fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch added
 to -mm tree
Date: Thu, 24 Apr 2014 10:47:45 -0700
Message-ID: <53594e41.zdWPn4B3L0Wromq3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaDXRrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 13:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 10:47:45 -0700


The patch titled
     Subject: fs/befs/linuxvfs.c: remove positive test on sector_t
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: remove positive test on sector_t

sector_t is unsigned.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-positive-test-on-sector_t fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-positive-test-on-sector_t
+++ a/fs/befs/linuxvfs.c
@@ -133,14 +133,6 @@ befs_get_block(struct inode *inode, sect
 
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   (unsigned long)inode->i_ino, (long)block);
-
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   (long)block, (unsigned long)inode->i_ino);
-		return -EIO;
-	}
-
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
 			   "block %ld in inode %lu", (long)block,
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

