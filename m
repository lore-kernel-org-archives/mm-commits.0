From: akpm@linux-foundation.org
Subject: [merged] fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:02 -0700
Message-ID: <53960b76.ZvcutGjxGCDAPxNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFITbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:02 -0700


The patch titled
     Subject: fs/befs/linuxvfs.c: replace strncpy by strlcpy
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: replace strncpy by strlcpy

strncpy + end of string assignment replaced by strlcpy

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-replace-strncpy-by-strlcpy fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-replace-strncpy-by-strlcpy
+++ a/fs/befs/linuxvfs.c
@@ -396,9 +396,8 @@ static struct inode *befs_iget(struct su
 	if (S_ISLNK(inode->i_mode) && !(befs_ino->i_flags & BEFS_LONG_SYMLINK)){
 		inode->i_size = 0;
 		inode->i_blocks = befs_sb->block_size / VFS_BLOCK_SIZE;
-		strncpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
-			BEFS_SYMLINK_LEN - 1);
-		befs_ino->i_data.symlink[BEFS_SYMLINK_LEN - 1] = '\0';
+		strlcpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
+			BEFS_SYMLINK_LEN);
 	} else {
 		int num_blks;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

