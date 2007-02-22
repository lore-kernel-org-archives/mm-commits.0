From: akpm@linux-foundation.org
Subject: + nommu-generalise-the-handling-of-mtd-specific-superblocks.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:38:53 -0800
Message-ID: <200702220038.l1M0crAW031489@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945922AbXBVAjn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:39:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     NOMMU: generalise the handling of MTD-specific superblocks
has been added to the -mm tree.  Its filename is
     nommu-generalise-the-handling-of-mtd-specific-superblocks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NOMMU: generalise the handling of MTD-specific superblocks
From: David Howells <dhowells@redhat.com>

Generalise the handling of MTD-specific superblocks so that JFFS2 and ROMFS
can both share it.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/Makefile      |    2 
 drivers/mtd/mtdsuper.c    |  231 ++++++++++++++++++++++++++++++++++++
 fs/jffs2/super.c          |  194 ++----------------------------
 include/linux/fs.h        |    1 
 include/linux/mtd/super.h |   30 ++++
 5 files changed, 282 insertions(+), 176 deletions(-)

diff -puN drivers/mtd/Makefile~nommu-generalise-the-handling-of-mtd-specific-superblocks drivers/mtd/Makefile
--- a/drivers/mtd/Makefile~nommu-generalise-the-handling-of-mtd-specific-superblocks
+++ a/drivers/mtd/Makefile
@@ -4,7 +4,7 @@
 # $Id: Makefile.common,v 1.7 2005/07/11 10:39:27 gleixner Exp $
 
 # Core functionality.
-mtd-y				:= mtdcore.o mtdbdi.o
+mtd-y				:= mtdcore.o mtdbdi.o mtdsuper.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 obj-$(CONFIG_MTD)		+= $(mtd-y)
 
diff -puN /dev/null drivers/mtd/mtdsuper.c
--- /dev/null
+++ a/drivers/mtd/mtdsuper.c
@@ -0,0 +1,231 @@
+/* MTD-based superblock management
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/mtd/super.h>
+#include <linux/namei.h>
+#include <linux/ctype.h>
+
+/*
+ * compare superblocks to see if they're equivalent
+ * - they are if the underlying MTD device is the same
+ */
+static int get_sb_mtd_compare(struct super_block *sb, void *_mtd)
+{
+	struct mtd_info *mtd = _mtd;
+
+	if (sb->s_mtd == mtd) {
+		DEBUG(2, "MTDSB: Match on device %d (\"%s\")\n",
+		      mtd->index, mtd->name);
+		return 1;
+	}
+
+	DEBUG(2, "MTDSB: No match, device %d (\"%s\"), device %d (\"%s\")\n",
+	      sb->s_mtd->index, sb->s_mtd->name, mtd->index, mtd->name);
+	return 0;
+}
+
+/*
+ * mark the superblock by the MTD device it is using
+ * - set the device number to be the correct MTD block device for pesuperstence
+ *   of NFS exports
+ */
+static int get_sb_mtd_set(struct super_block *sb, void *_mtd)
+{
+	struct mtd_info *mtd = _mtd;
+
+	sb->s_mtd = mtd;
+	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, mtd->index);
+	return 0;
+}
+
+/*
+ * get a superblock on an MTD-backed filesystem
+ */
+static int get_sb_mtd_aux(struct file_system_type *fs_type, int flags,
+			  const char *dev_name, void *data,
+			  struct mtd_info *mtd,
+			  int (*fill_super)(struct super_block *, void *, int),
+			  struct vfsmount *mnt)
+{
+	struct super_block *sb;
+	int ret;
+
+	sb = sget(fs_type, get_sb_mtd_compare, get_sb_mtd_set, mtd);
+	if (IS_ERR(sb))
+		goto out_error;
+
+	if (sb->s_root)
+		goto already_mounted;
+
+	/* fresh new superblock */
+	DEBUG(1, "MTDSB: New superblock for device %d (\"%s\")\n",
+	      mtd->index, mtd->name);
+
+	ret = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+	if (ret < 0) {
+		up_write(&sb->s_umount);
+		deactivate_super(sb);
+		return ret;
+	}
+
+	/* go */
+	sb->s_flags |= MS_ACTIVE;
+	return simple_set_mnt(mnt, sb);
+
+	/* new mountpoint for an already mounted superblock */
+already_mounted:
+	DEBUG(1, "MTDSB: Device %d (\"%s\") is already mounted\n",
+	      mtd->index, mtd->name);
+	ret = simple_set_mnt(mnt, sb);
+	goto out_put;
+
+out_error:
+	ret = PTR_ERR(sb);
+out_put:
+	put_mtd_device(mtd);
+	return ret;
+}
+
+/*
+ * get a superblock on an MTD-backed filesystem by MTD device number
+ */
+static int get_sb_mtd_nr(struct file_system_type *fs_type, int flags,
+			 const char *dev_name, void *data, int mtdnr,
+			 int (*fill_super)(struct super_block *, void *, int),
+			 struct vfsmount *mnt)
+{
+	struct mtd_info *mtd;
+
+	mtd = get_mtd_device(NULL, mtdnr);
+	if (!mtd) {
+		DEBUG(0, "MTDSB: Device #%u doesn't appear to exist\n", mtdnr);
+		return -EINVAL;
+	}
+
+	return get_sb_mtd_aux(fs_type, flags, dev_name, data, mtd, fill_super,
+			      mnt);
+}
+
+/*
+ * set up an MTD-based superblock
+ */
+int get_sb_mtd(struct file_system_type *fs_type, int flags,
+	       const char *dev_name, void *data,
+	       int (*fill_super)(struct super_block *, void *, int),
+	       struct vfsmount *mnt)
+{
+	struct nameidata nd;
+	int mtdnr, ret;
+
+	if (!dev_name)
+		return -EINVAL;
+
+	DEBUG(2, "MTDSB: dev_name \"%s\"\n", dev_name);
+
+	/* the preferred way of mounting in future; especially when
+	 * CONFIG_BLOCK=n - we specify the underlying MTD device by number or
+	 * by name, so that we don't require block device support to be present
+	 * in the kernel. */
+	if (dev_name[0] == 'm' && dev_name[1] == 't' && dev_name[2] == 'd') {
+		if (dev_name[3] == ':') {
+			struct mtd_info *mtd;
+
+			/* mount by MTD device name */
+			DEBUG(1, "MTDSB: mtd:%%s, name \"%s\"\n",
+			      dev_name + 4);
+
+			for (mtdnr = 0; mtdnr < MAX_MTD_DEVICES; mtdnr++) {
+				mtd = get_mtd_device(NULL, mtdnr);
+				if (mtd) {
+					if (!strcmp(mtd->name, dev_name + 4))
+						return get_sb_mtd_aux(
+							fs_type, flags,
+							dev_name, data, mtd,
+							fill_super, mnt);
+
+					put_mtd_device(mtd);
+				}
+			}
+
+			printk(KERN_NOTICE "MTD:"
+			       " MTD device with name \"%s\" not found.\n",
+			       dev_name + 4);
+
+		} else if (isdigit(dev_name[3])) {
+			/* mount by MTD device number name */
+			char *endptr;
+
+			mtdnr = simple_strtoul(dev_name + 3, &endptr, 0);
+			if (!*endptr) {
+				/* It was a valid number */
+				DEBUG(1, "MTDSB: mtd%%d, mtdnr %d\n",
+				      mtdnr);
+				return get_sb_mtd_nr(fs_type, flags,
+						     dev_name, data,
+						     mtdnr, fill_super, mnt);
+			}
+		}
+	}
+
+	/* try the old way - the hack where we allowed users to mount
+	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
+	 */
+	ret = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
+
+	DEBUG(1, "MTDSB: path_lookup() returned %d, inode %p\n",
+	      ret, nd.dentry ? nd.dentry->d_inode : NULL);
+
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+
+	if (!S_ISBLK(nd.dentry->d_inode->i_mode))
+		goto out;
+
+	if (nd.mnt->mnt_flags & MNT_NODEV) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	if (imajor(nd.dentry->d_inode) != MTD_BLOCK_MAJOR)
+		goto not_an_MTD_device;
+
+	mtdnr = iminor(nd.dentry->d_inode);
+	path_release(&nd);
+
+	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
+			     mnt);
+
+not_an_MTD_device:
+	if (!(flags & MS_SILENT))
+		printk(KERN_NOTICE
+		       "MTD: Attempt to mount non-MTD device \"%s\"\n",
+		       dev_name);
+out:
+	path_release(&nd);
+	return ret;
+
+}
+
+EXPORT_SYMBOL_GPL(get_sb_mtd);
+
+/*
+ * destroy an MTD-based superblock
+ */
+void kill_mtd_super(struct super_block *sb)
+{
+	generic_shutdown_super(sb);
+	put_mtd_device(sb->s_mtd);
+	sb->s_mtd = NULL;
+}
+
+EXPORT_SYMBOL_GPL(kill_mtd_super);
diff -puN fs/jffs2/super.c~nommu-generalise-the-handling-of-mtd-specific-superblocks fs/jffs2/super.c
--- a/fs/jffs2/super.c~nommu-generalise-the-handling-of-mtd-specific-superblocks
+++ a/fs/jffs2/super.c
@@ -21,7 +21,7 @@
 #include <linux/mount.h>
 #include <linux/jffs2.h>
 #include <linux/pagemap.h>
-#include <linux/mtd/mtd.h>
+#include <linux/mtd/super.h>
 #include <linux/ctype.h>
 #include <linux/namei.h>
 #include "compr.h"
@@ -80,69 +80,27 @@ static const struct super_operations jff
 	.sync_fs =	jffs2_sync_fs,
 };
 
-static int jffs2_sb_compare(struct super_block *sb, void *data)
+/*
+ * fill in the superblock
+ */
+static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct jffs2_sb_info *p = data;
-	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
-
-	/* The superblocks are considered to be equivalent if the underlying MTD
-	   device is the same one */
-	if (c->mtd == p->mtd) {
-		D1(printk(KERN_DEBUG "jffs2_sb_compare: match on device %d (\"%s\")\n", p->mtd->index, p->mtd->name));
-		return 1;
-	} else {
-		D1(printk(KERN_DEBUG "jffs2_sb_compare: No match, device %d (\"%s\"), device %d (\"%s\")\n",
-			  c->mtd->index, c->mtd->name, p->mtd->index, p->mtd->name));
-		return 0;
-	}
-}
-
-static int jffs2_sb_set(struct super_block *sb, void *data)
-{
-	struct jffs2_sb_info *p = data;
-
-	/* For persistence of NFS exports etc. we use the same s_dev
-	   each time we mount the device, don't just use an anonymous
-	   device */
-	sb->s_fs_info = p;
-	p->os_priv = sb;
-	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, p->mtd->index);
-
-	return 0;
-}
-
-static int jffs2_get_sb_mtd(struct file_system_type *fs_type,
-			    int flags, const char *dev_name,
-			    void *data, struct mtd_info *mtd,
-			    struct vfsmount *mnt)
-{
-	struct super_block *sb;
 	struct jffs2_sb_info *c;
-	int ret;
+
+	D1(printk(KERN_DEBUG "jffs2_get_sb_mtd():"
+		  " New superblock for device %d (\"%s\")\n",
+		  sb->s_mtd->index, sb->s_mtd->name));
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c)
 		return -ENOMEM;
-	c->mtd = mtd;
-
-	sb = sget(fs_type, jffs2_sb_compare, jffs2_sb_set, c);
-
-	if (IS_ERR(sb))
-		goto out_error;
-
-	if (sb->s_root) {
-		/* New mountpoint for JFFS2 which is already mounted */
-		D1(printk(KERN_DEBUG "jffs2_get_sb_mtd(): Device %d (\"%s\") is already mounted\n",
-			  mtd->index, mtd->name));
-		ret = simple_set_mnt(mnt, sb);
-		goto out_put;
-	}
 
-	D1(printk(KERN_DEBUG "jffs2_get_sb_mtd(): New superblock for device %d (\"%s\")\n",
-		  mtd->index, mtd->name));
+	c->mtd = sb->s_mtd;
+	c->os_priv = sb;
+	sb->s_fs_info = c;
 
-	/* Initialize JFFS2 superblock locks, the further initialization will be
-	 * done later */
+	/* Initialize JFFS2 superblock locks, the further initialization will
+	 * be done later */
 	init_MUTEX(&c->alloc_sem);
 	init_MUTEX(&c->erase_free_sem);
 	init_waitqueue_head(&c->erase_wait);
@@ -151,133 +109,20 @@ static int jffs2_get_sb_mtd(struct file_
 	spin_lock_init(&c->inocache_lock);
 
 	sb->s_op = &jffs2_super_operations;
-	sb->s_flags = flags | MS_NOATIME;
+	sb->s_flags = sb->s_flags | MS_NOATIME;
 	sb->s_xattr = jffs2_xattr_handlers;
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
-	ret = jffs2_do_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
-
-	if (ret) {
-		/* Failure case... */
-		up_write(&sb->s_umount);
-		deactivate_super(sb);
-		return ret;
-	}
-
-	sb->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, sb);
-
-out_error:
-	ret = PTR_ERR(sb);
- out_put:
-	kfree(c);
-	put_mtd_device(mtd);
-
-	return ret;
-}
-
-static int jffs2_get_sb_mtdnr(struct file_system_type *fs_type,
-			      int flags, const char *dev_name,
-			      void *data, int mtdnr,
-			      struct vfsmount *mnt)
-{
-	struct mtd_info *mtd;
-
-	mtd = get_mtd_device(NULL, mtdnr);
-	if (IS_ERR(mtd)) {
-		D1(printk(KERN_DEBUG "jffs2: MTD device #%u doesn't appear to exist\n", mtdnr));
-		return PTR_ERR(mtd);
-	}
-
-	return jffs2_get_sb_mtd(fs_type, flags, dev_name, data, mtd, mnt);
+	return jffs2_do_fill_super(sb, data, silent);
 }
 
 static int jffs2_get_sb(struct file_system_type *fs_type,
 			int flags, const char *dev_name,
 			void *data, struct vfsmount *mnt)
 {
-	int err;
-	struct nameidata nd;
-	int mtdnr;
-
-	if (!dev_name)
-		return -EINVAL;
-
-	D1(printk(KERN_DEBUG "jffs2_get_sb(): dev_name \"%s\"\n", dev_name));
-
-	/* The preferred way of mounting in future; especially when
-	   CONFIG_BLK_DEV is implemented - we specify the underlying
-	   MTD device by number or by name, so that we don't require
-	   block device support to be present in the kernel. */
-
-	/* FIXME: How to do the root fs this way? */
-
-	if (dev_name[0] == 'm' && dev_name[1] == 't' && dev_name[2] == 'd') {
-		/* Probably mounting without the blkdev crap */
-		if (dev_name[3] == ':') {
-			struct mtd_info *mtd;
-
-			/* Mount by MTD device name */
-			D1(printk(KERN_DEBUG "jffs2_get_sb(): mtd:%%s, name \"%s\"\n", dev_name+4));
-			for (mtdnr = 0; mtdnr < MAX_MTD_DEVICES; mtdnr++) {
-				mtd = get_mtd_device(NULL, mtdnr);
-				if (!IS_ERR(mtd)) {
-					if (!strcmp(mtd->name, dev_name+4))
-						return jffs2_get_sb_mtd(fs_type, flags, dev_name, data, mtd, mnt);
-					put_mtd_device(mtd);
-				}
-			}
-			printk(KERN_NOTICE "jffs2_get_sb(): MTD device with name \"%s\" not found.\n", dev_name+4);
-		} else if (isdigit(dev_name[3])) {
-			/* Mount by MTD device number name */
-			char *endptr;
-
-			mtdnr = simple_strtoul(dev_name+3, &endptr, 0);
-			if (!*endptr) {
-				/* It was a valid number */
-				D1(printk(KERN_DEBUG "jffs2_get_sb(): mtd%%d, mtdnr %d\n", mtdnr));
-				return jffs2_get_sb_mtdnr(fs_type, flags, dev_name, data, mtdnr, mnt);
-			}
-		}
-	}
-
-	/* Try the old way - the hack where we allowed users to mount
-	   /dev/mtdblock$(n) but didn't actually _use_ the blkdev */
-
-	err = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
-
-	D1(printk(KERN_DEBUG "jffs2_get_sb(): path_lookup() returned %d, inode %p\n",
-		  err, nd.dentry->d_inode));
-
-	if (err)
-		return err;
-
-	err = -EINVAL;
-
-	if (!S_ISBLK(nd.dentry->d_inode->i_mode))
-		goto out;
-
-	if (nd.mnt->mnt_flags & MNT_NODEV) {
-		err = -EACCES;
-		goto out;
-	}
-
-	if (imajor(nd.dentry->d_inode) != MTD_BLOCK_MAJOR) {
-		if (!(flags & MS_SILENT))
-			printk(KERN_NOTICE "Attempt to mount non-MTD device \"%s\" as JFFS2\n",
-			       dev_name);
-		goto out;
-	}
-
-	mtdnr = iminor(nd.dentry->d_inode);
-	path_release(&nd);
-
-	return jffs2_get_sb_mtdnr(fs_type, flags, dev_name, data, mtdnr, mnt);
-
-out:
-	path_release(&nd);
-	return err;
+	return get_sb_mtd(fs_type, flags, dev_name, data, jffs2_fill_super,
+			  mnt);
 }
 
 static void jffs2_put_super (struct super_block *sb)
@@ -312,8 +157,7 @@ static void jffs2_kill_sb(struct super_b
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 	if (!(sb->s_flags & MS_RDONLY))
 		jffs2_stop_garbage_collect_thread(c);
-	generic_shutdown_super(sb);
-	put_mtd_device(c->mtd);
+	kill_mtd_super(sb);
 	kfree(c);
 }
 
diff -puN include/linux/fs.h~nommu-generalise-the-handling-of-mtd-specific-superblocks include/linux/fs.h
--- a/include/linux/fs.h~nommu-generalise-the-handling-of-mtd-specific-superblocks
+++ a/include/linux/fs.h
@@ -932,6 +932,7 @@ struct super_block {
 	struct list_head	s_files;
 
 	struct block_device	*s_bdev;
+	struct mtd_info		*s_mtd;
 	struct list_head	s_instances;
 	struct quota_info	s_dquot;	/* Diskquota specific options */
 
diff -puN /dev/null include/linux/mtd/super.h
--- /dev/null
+++ a/include/linux/mtd/super.h
@@ -0,0 +1,30 @@
+/* MTD-based superblock handling
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef __MTD_SUPER_H__
+#define __MTD_SUPER_H__
+
+#ifdef __KERNEL__
+
+#include <linux/mtd/mtd.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+
+extern int get_sb_mtd(struct file_system_type *fs_type, int flags,
+		      const char *dev_name, void *data,
+		      int (*fill_super)(struct super_block *, void *, int),
+		      struct vfsmount *mnt);
+extern void kill_mtd_super(struct super_block *sb);
+
+
+#endif /* __KERNEL__ */
+
+#endif /* __MTD_SUPER_H__ */
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-no-zone_dma.patch
frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch
git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-parisc.patch
frv-missing-error-defs.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
