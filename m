From: akpm@linux-foundation.org
Subject: + fs-affs-remove-redundant-sys_tz-declarations.patch added to -mm tree
Date: Wed, 01 Oct 2014 15:29:45 -0700
Message-ID: <542c8059.wgbuxovOwIPnn8uO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaJAW3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: remove redundant sys_tz declarations
has been added to the -mm tree.  Its filename is
     fs-affs-remove-redundant-sys_tz-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-remove-redundant-sys_tz-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-remove-redundant-sys_tz-declarations.patch

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
Subject: fs/affs: remove redundant sys_tz declarations

sys_tz is already declared in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 --
 fs/affs/inode.c    |    1 -
 fs/affs/super.c    |    2 --
 3 files changed, 5 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-extern struct timezone sys_tz;
-
 static char ErrorBuffer[256];
 
 /*
diff -puN fs/affs/inode.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/inode.c
@@ -14,7 +14,6 @@
 #include "affs.h"
 
 extern const struct inode_operations affs_symlink_inode_operations;
-extern struct timezone sys_tz;
 
 struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
diff -puN fs/affs/super.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/super.c
@@ -20,8 +20,6 @@
 #include <linux/writeback.h>
 #include "affs.h"
 
-extern struct timezone sys_tz;
-
 static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int affs_remount (struct super_block *sb, int *flags, char *data);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ufs-ballocc-remove-unused-variable.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fat-remove-redundant-sys_tz-declaration.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
fs-affs-filec-fix-shadow-warnings.patch
fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
linux-next.patch
fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch
fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch
fs-affs-remove-redundant-sys_tz-declarations.patch

