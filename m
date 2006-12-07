From: akpm@osdl.org
Subject: - fs-trivial-vsnprintf-conversion.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:41 -0800
Message-ID: <200612072303.kB7N3foT029979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163965AbWLGXIX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mark.fasheh@oracle.com, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/*: trivial vsnprintf() conversion
has been removed from the -mm tree.  Its filename was
     fs-trivial-vsnprintf-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/*: trivial vsnprintf() conversion
From: Alexey Dobriyan <adobriyan@gmail.com>

It would very lame to get buffer overflow via one of the following.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/adfs/super.c    |    2 +-
 fs/affs/amigaffs.c |    4 ++--
 fs/jfs/super.c     |    2 +-
 fs/ocfs2/super.c   |    4 ++--
 fs/udf/super.c     |    4 ++--
 fs/ufs/super.c     |    6 +++---
 6 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/adfs/super.c~fs-trivial-vsnprintf-conversion fs/adfs/super.c
--- a/fs/adfs/super.c~fs-trivial-vsnprintf-conversion
+++ a/fs/adfs/super.c
@@ -36,7 +36,7 @@ void __adfs_error(struct super_block *sb
 	va_list args;
 
 	va_start(args, fmt);
-	vsprintf(error_buf, fmt, args);
+	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 
 	printk(KERN_CRIT "ADFS-fs error (device %s)%s%s: %s\n",
diff -puN fs/affs/amigaffs.c~fs-trivial-vsnprintf-conversion fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-trivial-vsnprintf-conversion
+++ a/fs/affs/amigaffs.c
@@ -445,7 +445,7 @@ affs_error(struct super_block *sb, const
 	va_list	 args;
 
 	va_start(args,fmt);
-	vsprintf(ErrorBuffer,fmt,args);
+	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
 	printk(KERN_CRIT "AFFS error (device %s): %s(): %s\n", sb->s_id,
@@ -461,7 +461,7 @@ affs_warning(struct super_block *sb, con
 	va_list	 args;
 
 	va_start(args,fmt);
-	vsprintf(ErrorBuffer,fmt,args);
+	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
 	printk(KERN_WARNING "AFFS warning (device %s): %s(): %s\n", sb->s_id,
diff -puN fs/jfs/super.c~fs-trivial-vsnprintf-conversion fs/jfs/super.c
--- a/fs/jfs/super.c~fs-trivial-vsnprintf-conversion
+++ a/fs/jfs/super.c
@@ -93,7 +93,7 @@ void jfs_error(struct super_block *sb, c
 	va_list args;
 
 	va_start(args, function);
-	vsprintf(error_buf, function, args);
+	vsnprintf(error_buf, sizeof(error_buf), function, args);
 	va_end(args);
 
 	printk(KERN_ERR "ERROR: (device %s): %s\n", sb->s_id, error_buf);
diff -puN fs/ocfs2/super.c~fs-trivial-vsnprintf-conversion fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-trivial-vsnprintf-conversion
+++ a/fs/ocfs2/super.c
@@ -1674,7 +1674,7 @@ void __ocfs2_error(struct super_block *s
 	va_list args;
 
 	va_start(args, fmt);
-	vsprintf(error_buf, fmt, args);
+	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 
 	/* Not using mlog here because we want to show the actual
@@ -1695,7 +1695,7 @@ void __ocfs2_abort(struct super_block* s
 	va_list args;
 
 	va_start(args, fmt);
-	vsprintf(error_buf, fmt, args);
+	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 
 	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %s\n",
diff -puN fs/udf/super.c~fs-trivial-vsnprintf-conversion fs/udf/super.c
--- a/fs/udf/super.c~fs-trivial-vsnprintf-conversion
+++ a/fs/udf/super.c
@@ -1709,7 +1709,7 @@ void udf_error(struct super_block *sb, c
 		sb->s_dirt = 1;
 	}
 	va_start(args, fmt);
-	vsprintf(error_buf, fmt, args);
+	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 	printk (KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
@@ -1721,7 +1721,7 @@ void udf_warning(struct super_block *sb,
 	va_list args;
 
 	va_start (args, fmt);
-	vsprintf(error_buf, fmt, args);
+	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
diff -puN fs/ufs/super.c~fs-trivial-vsnprintf-conversion fs/ufs/super.c
--- a/fs/ufs/super.c~fs-trivial-vsnprintf-conversion
+++ a/fs/ufs/super.c
@@ -224,7 +224,7 @@ void ufs_error (struct super_block * sb,
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
-	vsprintf (error_buf, fmt, args);
+	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	switch (UFS_SB(sb)->s_mount_opt & UFS_MOUNT_ONERROR) {
 	case UFS_MOUNT_ONERROR_PANIC:
@@ -255,7 +255,7 @@ void ufs_panic (struct super_block * sb,
 		sb->s_dirt = 1;
 	}
 	va_start (args, fmt);
-	vsprintf (error_buf, fmt, args);
+	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	sb->s_flags |= MS_RDONLY;
 	printk (KERN_CRIT "UFS-fs panic (device %s): %s: %s\n",
@@ -268,7 +268,7 @@ void ufs_warning (struct super_block * s
 	va_list args;
 
 	va_start (args, fmt);
-	vsprintf (error_buf, fmt, args);
+	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
 	printk (KERN_WARNING "UFS-fs warning (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

