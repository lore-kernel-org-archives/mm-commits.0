From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-convert-ufsd-printk-to-pr_debug.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:39:30 -0700
Message-ID: <53ea6d72.LROAEA0I6VPRPU0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:58722 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaHLTjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:31 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2673246pde.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: convert UFSD printk to pr_debug
has been removed from the -mm tree.  Its filename was
     fs-ufs-convert-ufsd-printk-to-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs: convert UFSD printk to pr_debug

Convert no level printk to pr_debug in UFSD.  DEBUG is defined with
CONFIG_UFS_DEBUG so pr_debug are emitted here.

Also fixing call to UFSD (add;)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 fs/ufs/ufs.h   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-convert-ufsd-printk-to-pr_debug fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-convert-ufsd-printk-to-pr_debug
+++ a/fs/ufs/super.c
@@ -868,7 +868,7 @@ static int ufs_fill_super(struct super_b
 		break;
 
 	case UFS_MOUNT_UFSTYPE_SUNOS:
-		UFSD(("ufstype=sunos\n"))
+		UFSD("ufstype=sunos\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
 		uspi->s_fshift = 10;
diff -puN fs/ufs/ufs.h~fs-ufs-convert-ufsd-printk-to-pr_debug fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-ufs-convert-ufsd-printk-to-pr_debug
+++ a/fs/ufs/ufs.h
@@ -77,9 +77,9 @@ struct ufs_inode_info {
  */
 #ifdef CONFIG_UFS_DEBUG
 #	define UFSD(f, a...)	{					\
-		printk ("UFSD (%s, %d): %s:",				\
+		pr_debug("UFSD (%s, %d): %s:",				\
 			__FILE__, __LINE__, __func__);		\
-		printk (f, ## a);					\
+		pr_debug(f, ## a);					\
 	}
 #else
 #	define UFSD(f, a...)	/**/
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

