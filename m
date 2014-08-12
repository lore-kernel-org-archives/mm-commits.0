From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-use-pr_fmt.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:24 -0700
Message-ID: <53ea6d6c.BMO089iVpz8KCM0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:63710 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaHLTjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:25 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2665823pab.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: use pr_fmt
has been removed from the -mm tree.  Its filename was
     fs-ufs-use-pr_fmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs: use pr_fmt

Replace UFS-fs, UFS-fs: and UFS: by pr_fmt with module name "ufs: "

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   15 +++++++--------
 fs/ufs/ufs.h   |    6 ++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-use-pr_fmt fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-use-pr_fmt
+++ a/fs/ufs/super.c
@@ -65,7 +65,6 @@
  * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
-
 #include <linux/exportfs.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
@@ -310,13 +309,13 @@ void ufs_error (struct super_block * sb,
 	va_end (args);
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic ("UFS-fs panic (device %s): %s: %s\n", 
+		panic("panic (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("UFS-fs error (device %s): %s: %s\n",
+		pr_crit("error (device %s): %s: %s\n",
 			sb->s_id, function, error_buf);
 	}		
 }
@@ -340,7 +339,7 @@ void ufs_panic (struct super_block * sb,
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("UFS-fs panic (device %s): %s: %s\n",
+	pr_crit("panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -352,7 +351,7 @@ void ufs_warning (struct super_block * s
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	pr_warn("UFS-fs warning (device %s): %s: %s\n",
+	pr_warn("warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -464,12 +463,12 @@ static int ufs_parse_options (char * opt
 			ufs_set_opt (*mount_options, ONERROR_UMOUNT);
 			break;
 		case Opt_onerror_repair:
-			pr_err("UFS-fs: Unable to do repair on error, will lock lock instead\n");
+			pr_err("Unable to do repair on error, will lock lock instead\n");
 			ufs_clear_opt (*mount_options, ONERROR);
 			ufs_set_opt (*mount_options, ONERROR_REPAIR);
 			break;
 		default:
-			pr_err("UFS-fs: Invalid option: \"%s\" or missing value\n", p);
+			pr_err("Invalid option: \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -972,7 +971,7 @@ static int ufs_fill_super(struct super_b
 	
 again:	
 	if (!sb_set_blocksize(sb, block_size)) {
-		pr_err("UFS: failed to set blocksize\n");
+		pr_err("failed to set blocksize\n");
 		goto failed;
 	}
 
diff -puN fs/ufs/ufs.h~fs-ufs-use-pr_fmt fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-ufs-use-pr_fmt
+++ a/fs/ufs/ufs.h
@@ -1,6 +1,12 @@
 #ifndef _UFS_UFS_H
 #define _UFS_UFS_H 1
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define UFS_MAX_GROUP_LOADED 8
 #define UFS_CGNO_EMPTY ((unsigned)-1)
 
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

