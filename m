From: akpm@linux-foundation.org
Subject: [merged]
 fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:39:28 -0700
Message-ID: <53ea6d70.Z0Z7ZJDrd1E6/q9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:64184 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaHLTj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:29 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2669809pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: use va_format instead of buffer/vsnprintf
has been removed from the -mm tree.  Its filename was
     fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: use va_format instead of buffer/vsnprintf

Remove error_buffer and use %pV

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf
+++ a/fs/ufs/super.c
@@ -286,13 +286,12 @@ static void ufs_print_cylinder_stuff(str
 
 static const struct super_operations ufs_super_ops;
 
-static char error_buf[1024];
-
 void ufs_error (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 
 	uspi = UFS_SB(sb)->s_uspi;
@@ -304,20 +303,21 @@ void ufs_error (struct super_block * sb,
 		ufs_mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
-		panic("panic (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
+		panic("panic (device %s): %s: %pV\n",
+		      sb->s_id, function, &vaf);
 
 	case UFS_MOUNT_ONERROR_LOCK:
 	case UFS_MOUNT_ONERROR_UMOUNT:
 	case UFS_MOUNT_ONERROR_REPAIR:
-		pr_crit("error (device %s): %s: %s\n",
-			sb->s_id, function, error_buf);
-	}		
+		pr_crit("error (device %s): %s: %pV\n",
+			sb->s_id, function, &vaf);
+	}
+	va_end(args);
 }
 
 void ufs_panic (struct super_block * sb, const char * function,
@@ -325,6 +325,7 @@ void ufs_panic (struct super_block * sb,
 {
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
+	struct va_format vaf;
 	va_list args;
 	
 	uspi = UFS_SB(sb)->s_uspi;
@@ -335,24 +336,27 @@ void ufs_panic (struct super_block * sb,
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
 		ufs_mark_sb_dirty(sb);
 	}
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	sb->s_flags |= MS_RDONLY;
-	pr_crit("panic (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	pr_crit("panic (device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 void ufs_warning (struct super_block * sb, const char * function,
 	const char * fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
-	va_start (args, fmt);
-	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
-	va_end (args);
-	pr_warn("warning (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s: %pV\n",
+		sb->s_id, function, &vaf);
+	va_end(args);
 }
 
 enum {
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

