From: akpm@linux-foundation.org
Subject: + add-in-sunos-41x-compatible-mode-for-ufs.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:33:09 -0700
Message-ID: <200707290633.l6T6X9rW011826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759070AbXG2Gdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark@mtfhpc.demon.co.uk, dushistov@mail.ru


The patch titled
     Add in SunOS 4.1.x compatible mode for UFS
has been added to the -mm tree.  Its filename is
     add-in-sunos-41x-compatible-mode-for-ufs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add in SunOS 4.1.x compatible mode for UFS
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>

Add in support for SunOS 4.1.x flavor of BSD 4.2 UFS filing system Macros have
been put in to alow suport for the old static table Cylinder Groups but this
implementation does not use them yet.

This also fixes Solaris UFS filing system access by disabling fast symbolic
links as Sun's version of UFS does not support on-disk fast symbolic links.

Tested by:
  Ppartitioning a new disk using SunOS 4.1.1, creating a UFS filing system on
  one of the partitions and writing some files to the filing system.
  Using Linux-2.6.22 (patched) to read the files and then write a shed load of
  files to the UFS partition.
  Using SunOS 4.1.1 to verify the filing system is OK and to check the files.
The test host is a sun4c SS1 Clone.

Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c         |   37 ++++++++++++++++++++++----
 fs/ufs/util.h          |   48 +++++++++++++++++++++++++---------
 include/linux/ufs_fs.h |   55 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 119 insertions(+), 21 deletions(-)

diff -puN fs/ufs/super.c~add-in-sunos-41x-compatible-mode-for-ufs fs/ufs/super.c
--- a/fs/ufs/super.c~add-in-sunos-41x-compatible-mode-for-ufs
+++ a/fs/ufs/super.c
@@ -286,7 +286,7 @@ void ufs_warning (struct super_block * s
 }
 
 enum {
-	Opt_type_old, Opt_type_sunx86, Opt_type_sun, Opt_type_44bsd,
+	Opt_type_old, Opt_type_sunx86, Opt_type_sun, Opt_type_sunos, Opt_type_44bsd,
 	Opt_type_ufs2, Opt_type_hp, Opt_type_nextstepcd, Opt_type_nextstep,
 	Opt_type_openstep, Opt_onerror_panic, Opt_onerror_lock,
 	Opt_onerror_umount, Opt_onerror_repair, Opt_err
@@ -296,6 +296,7 @@ static match_table_t tokens = {
 	{Opt_type_old, "ufstype=old"},
 	{Opt_type_sunx86, "ufstype=sunx86"},
 	{Opt_type_sun, "ufstype=sun"},
+	{Opt_type_sunos, "ufstype=sunos"},
 	{Opt_type_44bsd, "ufstype=44bsd"},
 	{Opt_type_ufs2, "ufstype=ufs2"},
 	{Opt_type_ufs2, "ufstype=5xbsd"},
@@ -339,6 +340,10 @@ static int ufs_parse_options (char * opt
 			ufs_clear_opt (*mount_options, UFSTYPE);
 			ufs_set_opt (*mount_options, UFSTYPE_SUN);
 			break;
+		case Opt_type_sunos:
+			ufs_clear_opt (*mount_options, UFSTYPE);
+			ufs_set_opt (*mount_options, UFSTYPE_SUNOS);
+			break;
 		case Opt_type_44bsd:
 			ufs_clear_opt (*mount_options, UFSTYPE);
 			ufs_set_opt (*mount_options, UFSTYPE_44BSD);
@@ -655,7 +660,7 @@ static int ufs_fill_super(struct super_b
 	}
 
 	sbi->s_uspi = uspi =
-		kmalloc (sizeof(struct ufs_sb_private_info), GFP_KERNEL);
+		kzalloc (sizeof(struct ufs_sb_private_info), GFP_KERNEL);
 	if (!uspi)
 		goto failed;
 	uspi->s_dirblksize = UFS_SECTOR_SIZE;
@@ -692,10 +697,21 @@ static int ufs_fill_super(struct super_b
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
-		uspi->s_maxsymlinklen = 56;
+		uspi->s_maxsymlinklen = 0; /* Not supported on disk */
 		flags |= UFS_DE_OLD | UFS_UID_EFT | UFS_ST_SUN | UFS_CG_SUN;
 		break;
 
+	case UFS_MOUNT_UFSTYPE_SUNOS:
+		UFSD(("ufstype=sunos\n"))
+		uspi->s_fsize = block_size = 1024;
+		uspi->s_fmask = ~(1024 - 1);
+		uspi->s_fshift = 10;
+		uspi->s_sbsize = super_block_size = 2048;
+		uspi->s_sbbase = 0;
+		uspi->s_maxsymlinklen = 0; /* Not supported on disk */
+		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_SUNOS | UFS_CG_SUN;
+		break;
+
 	case UFS_MOUNT_UFSTYPE_SUNx86:
 		UFSD("ufstype=sunx86\n");
 		uspi->s_fsize = block_size = 1024;
@@ -703,7 +719,7 @@ static int ufs_fill_super(struct super_b
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
-		uspi->s_maxsymlinklen = 56;
+		uspi->s_maxsymlinklen = 0; /* Not supported on disk */
 		flags |= UFS_DE_OLD | UFS_UID_EFT | UFS_ST_SUNx86 | UFS_CG_SUN;
 		break;
 
@@ -894,6 +910,14 @@ magic_found:
 		goto again;
 	}
 
+	/* Sort out mod used on SunOS 4.1.3 for fs_state */
+	uspi->s_postblformat = fs32_to_cpu(sb, usb3->fs_postblformat);
+	if (((flags & UFS_ST_MASK) == UFS_ST_SUNOS) &&
+	    (uspi->s_postblformat != UFS_42POSTBLFMT)) {
+		flags &= ~UFS_ST_MASK;
+		flags |=  UFS_ST_SUN;
+	}
+
 
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
@@ -904,6 +928,7 @@ magic_found:
 	if (((flags & UFS_ST_MASK) == UFS_ST_44BSD) ||
 	  ((flags & UFS_ST_MASK) == UFS_ST_OLD) ||
 	  (((flags & UFS_ST_MASK) == UFS_ST_SUN || 
+	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
 	  (flags & UFS_ST_MASK) == UFS_ST_SUNx86) && 
 	  (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time))))) {
 		switch(usb1->fs_clean) {
@@ -995,7 +1020,6 @@ magic_found:
 	uspi->s_contigsumsize = fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_contigsumsize);
 	uspi->s_qbmask = ufs_get_fs_qbmask(sb, usb3);
 	uspi->s_qfmask = ufs_get_fs_qfmask(sb, usb3);
-	uspi->s_postblformat = fs32_to_cpu(sb, usb3->fs_postblformat);
 	uspi->s_nrpos = fs32_to_cpu(sb, usb3->fs_nrpos);
 	uspi->s_postbloff = fs32_to_cpu(sb, usb3->fs_postbloff);
 	uspi->s_rotbloff = fs32_to_cpu(sb, usb3->fs_rotbloff);
@@ -1079,6 +1103,7 @@ static void ufs_write_super(struct super
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_time = cpu_to_fs32(sb, get_seconds());
 		if ((flags & UFS_ST_MASK) == UFS_ST_SUN 
+		  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
 		  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86)
 			ufs_set_fs_state(sb, usb1, usb3,
 					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
@@ -1148,6 +1173,7 @@ static int ufs_remount (struct super_blo
 		ufs_put_super_internal(sb);
 		usb1->fs_time = cpu_to_fs32(sb, get_seconds());
 		if ((flags & UFS_ST_MASK) == UFS_ST_SUN
+		  || (flags & UFS_ST_MASK) == UFS_ST_SUNOS
 		  || (flags & UFS_ST_MASK) == UFS_ST_SUNx86) 
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
@@ -1164,6 +1190,7 @@ static int ufs_remount (struct super_blo
 		return -EINVAL;
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
+		    ufstype != UFS_MOUNT_UFSTYPE_SUNOS &&
 		    ufstype != UFS_MOUNT_UFSTYPE_44BSD &&
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
diff -puN fs/ufs/util.h~add-in-sunos-41x-compatible-mode-for-ufs fs/ufs/util.h
--- a/fs/ufs/util.h~add-in-sunos-41x-compatible-mode-for-ufs
+++ a/fs/ufs/util.h
@@ -38,6 +38,10 @@ ufs_get_fs_state(struct super_block *sb,
 		 struct ufs_super_block_third *usb3)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
+	case UFS_ST_SUNOS:
+		if (fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT)
+			return fs32_to_cpu(sb, usb1->fs_u0.fs_sun.fs_state);
+		/* Fall Through to UFS_ST_SUN */
 	case UFS_ST_SUN:
 		return fs32_to_cpu(sb, usb3->fs_un2.fs_sun.fs_state);
 	case UFS_ST_SUNx86:
@@ -53,6 +57,12 @@ ufs_set_fs_state(struct super_block *sb,
 		 struct ufs_super_block_third *usb3, s32 value)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
+	case UFS_ST_SUNOS:
+		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT)) {
+			usb1->fs_u0.fs_sun.fs_state = cpu_to_fs32(sb, value);
+			break;
+		}
+		/* Fall Through to UFS_ST_SUN */
 	case UFS_ST_SUN:
 		usb3->fs_un2.fs_sun.fs_state = cpu_to_fs32(sb, value);
 		break;
@@ -81,6 +91,7 @@ ufs_get_fs_qbmask(struct super_block *sb
 	__fs64 tmp;
 
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
+	case UFS_ST_SUNOS:
 	case UFS_ST_SUN:
 		((__fs32 *)&tmp)[0] = usb3->fs_un2.fs_sun.fs_qbmask[0];
 		((__fs32 *)&tmp)[1] = usb3->fs_un2.fs_sun.fs_qbmask[1];
@@ -104,6 +115,7 @@ ufs_get_fs_qfmask(struct super_block *sb
 	__fs64 tmp;
 
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
+	case UFS_ST_SUNOS:
 	case UFS_ST_SUN:
 		((__fs32 *)&tmp)[0] = usb3->fs_un2.fs_sun.fs_qfmask[0];
 		((__fs32 *)&tmp)[1] = usb3->fs_un2.fs_sun.fs_qfmask[1];
@@ -179,10 +191,12 @@ static inline u32
 ufs_get_inode_uid(struct super_block *sb, struct ufs_inode *inode)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_UID_MASK) {
-	case UFS_UID_EFT:
-		return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_uid);
 	case UFS_UID_44BSD:
 		return fs32_to_cpu(sb, inode->ui_u3.ui_44.ui_uid);
+	case UFS_UID_EFT:
+		if (inode->ui_u1.oldids.ui_suid == 0xFFFF)
+			return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_uid);
+		/* Fall through */
 	default:
 		return fs16_to_cpu(sb, inode->ui_u1.oldids.ui_suid);
 	}
@@ -192,24 +206,30 @@ static inline void
 ufs_set_inode_uid(struct super_block *sb, struct ufs_inode *inode, u32 value)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_UID_MASK) {
-	case UFS_UID_EFT:
-		inode->ui_u3.ui_sun.ui_uid = cpu_to_fs32(sb, value);
-		break;
 	case UFS_UID_44BSD:
 		inode->ui_u3.ui_44.ui_uid = cpu_to_fs32(sb, value);
+		inode->ui_u1.oldids.ui_suid = cpu_to_fs16(sb, value);
+		break;
+	case UFS_UID_EFT:
+		inode->ui_u3.ui_sun.ui_uid = cpu_to_fs32(sb, value);
+		if (value > 0xFFFF) value = 0xFFFF;
+		/* Fall through */
+	default:
+		inode->ui_u1.oldids.ui_suid = cpu_to_fs16(sb, value);
 		break;
 	}
-	inode->ui_u1.oldids.ui_suid = cpu_to_fs16(sb, value); 
 }
 
 static inline u32
 ufs_get_inode_gid(struct super_block *sb, struct ufs_inode *inode)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_UID_MASK) {
-	case UFS_UID_EFT:
-		return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_gid);
 	case UFS_UID_44BSD:
 		return fs32_to_cpu(sb, inode->ui_u3.ui_44.ui_gid);
+	case UFS_UID_EFT:
+		if (inode->ui_u1.oldids.ui_suid == 0xFFFF)
+			return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_gid);
+		/* Fall through */
 	default:
 		return fs16_to_cpu(sb, inode->ui_u1.oldids.ui_sgid);
 	}
@@ -219,14 +239,18 @@ static inline void
 ufs_set_inode_gid(struct super_block *sb, struct ufs_inode *inode, u32 value)
 {
 	switch (UFS_SB(sb)->s_flags & UFS_UID_MASK) {
-	case UFS_UID_EFT:
-		inode->ui_u3.ui_sun.ui_gid = cpu_to_fs32(sb, value);
-		break;
 	case UFS_UID_44BSD:
 		inode->ui_u3.ui_44.ui_gid = cpu_to_fs32(sb, value);
+		inode->ui_u1.oldids.ui_sgid =  cpu_to_fs16(sb, value);
+		break;
+	case UFS_UID_EFT:
+		inode->ui_u3.ui_sun.ui_gid = cpu_to_fs32(sb, value);
+		if (value > 0xFFFF) value = 0xFFFF;
+		/* Fall through */
+	default:
+		inode->ui_u1.oldids.ui_sgid =  cpu_to_fs16(sb, value);
 		break;
 	}
-	inode->ui_u1.oldids.ui_sgid =  cpu_to_fs16(sb, value);
 }
 
 extern dev_t ufs_get_inode_dev(struct super_block *, struct ufs_inode_info *);
diff -puN include/linux/ufs_fs.h~add-in-sunos-41x-compatible-mode-for-ufs include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~add-in-sunos-41x-compatible-mode-for-ufs
+++ a/include/linux/ufs_fs.h
@@ -170,8 +170,9 @@ typedef __u16 __bitwise __fs16;
 #define UFS_ST_MASK		0x00000700	/* mask for the following */
 #define UFS_ST_OLD		0x00000000
 #define UFS_ST_44BSD		0x00000100
-#define UFS_ST_SUN		0x00000200
-#define UFS_ST_SUNx86		0x00000400
+#define UFS_ST_SUN		0x00000200 /* Solaris */
+#define UFS_ST_SUNOS		0x00000300
+#define UFS_ST_SUNx86		0x00000400 /* Solaris x86 */
 /*cylinder group encoding */
 #define UFS_CG_MASK		0x00003000	/* mask for the following */
 #define UFS_CG_OLD		0x00000000
@@ -204,6 +205,7 @@ typedef __u16 __bitwise __fs16;
 #define UFS_MOUNT_UFSTYPE_SUNx86	0x00000400
 #define UFS_MOUNT_UFSTYPE_HP	        0x00000800
 #define UFS_MOUNT_UFSTYPE_UFS2		0x00001000
+#define UFS_MOUNT_UFSTYPE_SUNOS		0x00002000
 
 #define ufs_clear_opt(o,opt)	o &= ~UFS_MOUNT_##opt
 #define ufs_set_opt(o,opt)	o |= UFS_MOUNT_##opt
@@ -374,7 +376,14 @@ struct ufs_csum_core {
  * struct ufs_super_block_(first,second,third) instead.
  */
 struct ufs_super_block {
-	__fs32	fs_link;	/* UNUSED */
+	union {
+		struct {
+			__fs32	fs_link;	/* UNUSED */
+		} fs_42;
+		struct {
+			__fs32	fs_state;	/* file system state flag */
+		} fs_sun;
+	} fs_u0;
 	__fs32	fs_rlink;	/* UNUSED */
 	__fs32	fs_sblkno;	/* addr of super-block in filesys */
 	__fs32	fs_cblkno;	/* offset of cyl-block in filesys */
@@ -545,6 +554,15 @@ struct ufs_super_block {
 #define	CG_MAGIC	0x090255
 #define ufs_cg_chkmagic(sb, ucg) \
 	(fs32_to_cpu((sb), (ucg)->cg_magic) == CG_MAGIC)
+/*
+ * Macros for access to old cylinder group array structures
+ */
+#define ufs_ocg_blktot(sb, ucg)      fs32_to_cpu((sb), ((struct ufs_old_cylinder_group *)(ucg))->cg_btot)
+#define ufs_ocg_blks(sb, ucg, cylno) fs32_to_cpu((sb), ((struct ufs_old_cylinder_group *)(ucg))->cg_b[cylno])
+#define ufs_ocg_inosused(sb, ucg)    fs32_to_cpu((sb), ((struct ufs_old_cylinder_group *)(ucg))->cg_iused)
+#define ufs_ocg_blksfree(sb, ucg)    fs32_to_cpu((sb), ((struct ufs_old_cylinder_group *)(ucg))->cg_free)
+#define ufs_ocg_chkmagic(sb, ucg) \
+	(fs32_to_cpu((sb), ((struct ufs_old_cylinder_group *)(ucg))->cg_magic) == CG_MAGIC)
 
 /*
  * size of this structure is 172 B
@@ -590,6 +608,28 @@ struct	ufs_cylinder_group {
 /* actually longer */
 };
 
+/* Historic Cylinder group info */
+struct ufs_old_cylinder_group {
+	__fs32	cg_link;		/* linked list of cyl groups */
+	__fs32	cg_rlink;		/* for incore cyl groups     */
+	__fs32	cg_time;		/* time last written */
+	__fs32	cg_cgx;			/* we are the cgx'th cylinder group */
+	__fs16	cg_ncyl;		/* number of cyl's this cg */
+	__fs16	cg_niblk;		/* number of inode blocks this cg */
+	__fs32	cg_ndblk;		/* number of data blocks this cg */
+	struct	ufs_csum cg_cs;		/* cylinder summary information */
+	__fs32	cg_rotor;		/* position of last used block */
+	__fs32	cg_frotor;		/* position of last used frag */
+	__fs32	cg_irotor;		/* position of last used inode */
+	__fs32	cg_frsum[8];		/* counts of available frags */
+	__fs32	cg_btot[32];		/* block totals per cylinder */
+	__fs16	cg_b[32][8];		/* positions of free blocks */
+	__u8	cg_iused[256];		/* used inode map */
+	__fs32	cg_magic;		/* magic number */
+	__u8	cg_free[1];		/* free block map */
+/* actually longer */
+};
+
 /*
  * structure of an on-disk inode
  */
@@ -796,7 +836,14 @@ struct ufs_sb_private_info {
  *	ufs_super_block_third	356
  */
 struct ufs_super_block_first {
-	__fs32	fs_link;
+	union {
+		struct {
+			__fs32	fs_link;	/* UNUSED */
+		} fs_42;
+		struct {
+			__fs32	fs_state;	/* file system state flag */
+		} fs_sun;
+	} fs_u0;
 	__fs32	fs_rlink;
 	__fs32	fs_sblkno;
 	__fs32	fs_cblkno;
_

Patches currently in -mm which might be from mark@mtfhpc.demon.co.uk are

git-sparc64.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
