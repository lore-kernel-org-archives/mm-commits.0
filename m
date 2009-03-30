From: akpm@linux-foundation.org
Subject: [merged] nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:50 -0700
Message-ID: <200903301906.n2UJ6onf019173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759437AbZC3TLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bernd.schmidt@analog.com, dwmw2@infradead.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: make it possible for RomFS to use MTD devices directly
has been removed from the -mm tree.  Its filename was
     nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: make it possible for RomFS to use MTD devices directly
From: David Howells <dhowells@redhat.com>

Change RomFS so that it can use MTD devices directly - without the
intercession of the block layer - as well as using block devices.

This permits RomFS:

 (1) to use the MTD direct mapping facility available under NOMMU conditions if
     the underlying device is directly accessible by the CPU (including XIP);

 (2) and thus to be used when the block layer is disabled.

RomFS can be configured with support just for MTD devices, just for Block
devices or for both.  If RomFS is configured for both, then it will treat
mtdblock device files as MTD backing stores, not block layer backing
stores.

I tested this using a CONFIG_MMU=n CONFIG_BLOCK=n kernel running on my FRV
board with a RomFS image installed on the mtdram test device.  I see my
test program being run XIP:

	# cat /proc/maps
	...
	c0c000b0-c0c01f8c r-xs 00000000 1f:00 144        /mnt/doshm
	...

GDB on the kernel can be used to show that these addresses are within the
set-aside RAM space.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Bernd Schmidt <bernd.schmidt@analog.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/Kconfig      |   24 +
 fs/romfs/Makefile     |    9 
 fs/romfs/inode.c      |  665 ----------------------------------------
 fs/romfs/internal.h   |   47 ++
 fs/romfs/mmap-nommu.c |   75 ++++
 fs/romfs/storage.c    |  261 +++++++++++++++
 fs/romfs/super.c      |  648 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 1062 insertions(+), 667 deletions(-)

diff -puN fs/romfs/Kconfig~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly fs/romfs/Kconfig
--- a/fs/romfs/Kconfig~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly
+++ a/fs/romfs/Kconfig
@@ -14,3 +14,27 @@ config ROMFS_FS
 
 	  If you don't know whether you need it, then you don't need it:
 	  answer N.
+
+config ROMFS_ON_BLOCK
+	bool "Block device-backed ROM file system support" if (ROMFS_ON_MTD && EMBEDDED)
+	depends on ROMFS_FS && BLOCK
+	help
+	  This permits ROMFS to use block devices buffered through the page
+	  cache as the medium from which to retrieve data.  It does not allow
+	  direct mapping of the medium.
+
+	  If unsure, answer Y.
+
+config ROMFS_ON_MTD
+	bool "MTD-backed ROM file system support"
+	depends on ROMFS_FS
+	depends on MTD=y || (ROMFS_FS=m && MTD)
+	help
+	  This permits ROMFS to use MTD based devices directly, without the
+	  intercession of the block layer (which may have been disabled).  It
+	  also allows direct mapping of MTD devices through romfs files under
+	  NOMMU conditions if the underlying device is directly addressable by
+	  the CPU.
+
+	  If unsure, answer Y.
+
diff -puN fs/romfs/Makefile~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly fs/romfs/Makefile
--- a/fs/romfs/Makefile~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly
+++ a/fs/romfs/Makefile
@@ -1,7 +1,12 @@
 #
-# Makefile for the linux romfs filesystem routines.
+# Makefile for the linux RomFS filesystem routines.
 #
 
 obj-$(CONFIG_ROMFS_FS) += romfs.o
 
-romfs-objs := inode.o
+romfs-y := storage.o super.o
+
+ifneq ($(CONFIG_MMU),y)
+romfs-$(CONFIG_ROMFS_ON_MTD) += mmap-nommu.o
+endif
+
diff -puN fs/romfs/inode.c~nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly /dev/null
--- a/fs/romfs/inode.c
+++ /dev/null
@@ -1,665 +0,0 @@
-/*
- * ROMFS file system, Linux implementation
- *
- * Copyright (C) 1997-1999  Janos Farkas <chexum@shadow.banki.hu>
- *
- * Using parts of the minix filesystem
- * Copyright (C) 1991, 1992  Linus Torvalds
- *
- * and parts of the affs filesystem additionally
- * Copyright (C) 1993  Ray Burr
- * Copyright (C) 1996  Hans-Joachim Widmaier
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * Changes
- *					Changed for 2.1.19 modules
- *	Jan 1997			Initial release
- *	Jun 1997			2.1.43+ changes
- *					Proper page locking in readpage
- *					Changed to work with 2.1.45+ fs
- *	Jul 1997			Fixed follow_link
- *			2.1.47
- *					lookup shouldn't return -ENOENT
- *					from Horst von Brand:
- *					  fail on wrong checksum
- *					  double unlock_super was possible
- *					  correct namelen for statfs
- *					spotted by Bill Hawes:
- *					  readlink shouldn't iput()
- *	Jun 1998	2.1.106		from Avery Pennarun: glibc scandir()
- *					  exposed a problem in readdir
- *			2.1.107		code-freeze spellchecker run
- *	Aug 1998			2.1.118+ VFS changes
- *	Sep 1998	2.1.122		another VFS change (follow_link)
- *	Apr 1999	2.2.7		no more EBADF checking in
- *					  lookup/readdir, use ERR_PTR
- *	Jun 1999	2.3.6		d_alloc_root use changed
- *			2.3.9		clean up usage of ENOENT/negative
- *					  dentries in lookup
- *					clean up page flags setting
- *					  (error, uptodate, locking) in
- *					  in readpage
- *					use init_special_inode for
- *					  fifos/sockets (and streamline) in
- *					  read_inode, fix _ops table order
- *	Aug 1999	2.3.16		__initfunc() => __init change
- *	Oct 1999	2.3.24		page->owner hack obsoleted
- *	Nov 1999	2.3.27		2.3.25+ page->offset => index change
- */
-
-/* todo:
- *	- see Documentation/filesystems/romfs.txt
- *	- use allocated, not stack memory for file names?
- *	- considering write access...
- *	- network (tftp) files?
- *	- merge back some _op tables
- */
-
-/*
- * Sorry about some optimizations and for some goto's.  I just wanted
- * to squeeze some more bytes out of this code.. :)
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/romfs_fs.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/pagemap.h>
-#include <linux/smp_lock.h>
-#include <linux/buffer_head.h>
-#include <linux/vfs.h>
-
-#include <asm/uaccess.h>
-
-struct romfs_inode_info {
-	unsigned long i_metasize;	/* size of non-data area */
-	unsigned long i_dataoffset;	/* from the start of fs */
-	struct inode vfs_inode;
-};
-
-static struct inode *romfs_iget(struct super_block *, unsigned long);
-
-/* instead of private superblock data */
-static inline unsigned long romfs_maxsize(struct super_block *sb)
-{
-	return (unsigned long)sb->s_fs_info;
-}
-
-static inline struct romfs_inode_info *ROMFS_I(struct inode *inode)
-{
-	return container_of(inode, struct romfs_inode_info, vfs_inode);
-}
-
-static __u32
-romfs_checksum(void *data, int size)
-{
-	__u32 sum;
-	__be32 *ptr;
-
-	sum = 0; ptr = data;
-	size>>=2;
-	while (size>0) {
-		sum += be32_to_cpu(*ptr++);
-		size--;
-	}
-	return sum;
-}
-
-static const struct super_operations romfs_ops;
-
-static int romfs_fill_super(struct super_block *s, void *data, int silent)
-{
-	struct buffer_head *bh;
-	struct romfs_super_block *rsb;
-	struct inode *root;
-	int sz, ret = -EINVAL;
-
-	/* I would parse the options here, but there are none.. :) */
-
-	sb_set_blocksize(s, ROMBSIZE);
-	s->s_maxbytes = 0xFFFFFFFF;
-
-	bh = sb_bread(s, 0);
-	if (!bh) {
-		/* XXX merge with other printk? */
-                printk ("romfs: unable to read superblock\n");
-		goto outnobh;
-	}
-
-	rsb = (struct romfs_super_block *)bh->b_data;
-	sz = be32_to_cpu(rsb->size);
-	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1
-	   || sz < ROMFH_SIZE) {
-		if (!silent)
-			printk ("VFS: Can't find a romfs filesystem on dev "
-				"%s.\n", s->s_id);
-		goto out;
-	}
-	if (romfs_checksum(rsb, min_t(int, sz, 512))) {
-		printk ("romfs: bad initial checksum on dev "
-			"%s.\n", s->s_id);
-		goto out;
-	}
-
-	s->s_magic = ROMFS_MAGIC;
-	s->s_fs_info = (void *)(long)sz;
-
-	s->s_flags |= MS_RDONLY;
-
-	/* Find the start of the fs */
-	sz = (ROMFH_SIZE +
-	      strnlen(rsb->name, ROMFS_MAXFN) + 1 + ROMFH_PAD)
-	     & ROMFH_MASK;
-
-	s->s_op	= &romfs_ops;
-	root = romfs_iget(s, sz);
-	if (IS_ERR(root)) {
-		ret = PTR_ERR(root);
-		goto out;
-	}
-
-	ret = -ENOMEM;
-	s->s_root = d_alloc_root(root);
-	if (!s->s_root)
-		goto outiput;
-
-	brelse(bh);
-	return 0;
-
-outiput:
-	iput(root);
-out:
-	brelse(bh);
-outnobh:
-	return ret;
-}
-
-/* That's simple too. */
-
-static int
-romfs_statfs(struct dentry *dentry, struct kstatfs *buf)
-{
-	buf->f_type = ROMFS_MAGIC;
-	buf->f_bsize = ROMBSIZE;
-	buf->f_bfree = buf->f_bavail = buf->f_ffree;
-	buf->f_blocks = (romfs_maxsize(dentry->d_sb)+ROMBSIZE-1)>>ROMBSBITS;
-	buf->f_namelen = ROMFS_MAXFN;
-	return 0;
-}
-
-/* some helper routines */
-
-static int
-romfs_strnlen(struct inode *i, unsigned long offset, unsigned long count)
-{
-	struct buffer_head *bh;
-	unsigned long avail, maxsize, res;
-
-	maxsize = romfs_maxsize(i->i_sb);
-	if (offset >= maxsize)
-		return -1;
-
-	/* strnlen is almost always valid */
-	if (count > maxsize || offset+count > maxsize)
-		count = maxsize-offset;
-
-	bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-	if (!bh)
-		return -1;		/* error */
-
-	avail = ROMBSIZE - (offset & ROMBMASK);
-	maxsize = min_t(unsigned long, count, avail);
-	res = strnlen(((char *)bh->b_data)+(offset&ROMBMASK), maxsize);
-	brelse(bh);
-
-	if (res < maxsize)
-		return res;		/* found all of it */
-
-	while (res < count) {
-		offset += maxsize;
-
-		bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-		if (!bh)
-			return -1;
-		maxsize = min_t(unsigned long, count - res, ROMBSIZE);
-		avail = strnlen(bh->b_data, maxsize);
-		res += avail;
-		brelse(bh);
-		if (avail < maxsize)
-			return res;
-	}
-	return res;
-}
-
-static int
-romfs_copyfrom(struct inode *i, void *dest, unsigned long offset, unsigned long count)
-{
-	struct buffer_head *bh;
-	unsigned long avail, maxsize, res;
-
-	maxsize = romfs_maxsize(i->i_sb);
-	if (offset >= maxsize || count > maxsize || offset+count>maxsize)
-		return -1;
-
-	bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-	if (!bh)
-		return -1;		/* error */
-
-	avail = ROMBSIZE - (offset & ROMBMASK);
-	maxsize = min_t(unsigned long, count, avail);
-	memcpy(dest, ((char *)bh->b_data) + (offset & ROMBMASK), maxsize);
-	brelse(bh);
-
-	res = maxsize;			/* all of it */
-
-	while (res < count) {
-		offset += maxsize;
-		dest += maxsize;
-
-		bh = sb_bread(i->i_sb, offset>>ROMBSBITS);
-		if (!bh)
-			return -1;
-		maxsize = min_t(unsigned long, count - res, ROMBSIZE);
-		memcpy(dest, bh->b_data, maxsize);
-		brelse(bh);
-		res += maxsize;
-	}
-	return res;
-}
-
-static unsigned char romfs_dtype_table[] = {
-	DT_UNKNOWN, DT_DIR, DT_REG, DT_LNK, DT_BLK, DT_CHR, DT_SOCK, DT_FIFO
-};
-
-static int
-romfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
-{
-	struct inode *i = filp->f_path.dentry->d_inode;
-	struct romfs_inode ri;
-	unsigned long offset, maxoff;
-	int j, ino, nextfh;
-	int stored = 0;
-	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
-
-	lock_kernel();
-
-	maxoff = romfs_maxsize(i->i_sb);
-
-	offset = filp->f_pos;
-	if (!offset) {
-		offset = i->i_ino & ROMFH_MASK;
-		if (romfs_copyfrom(i, &ri, offset, ROMFH_SIZE) <= 0)
-			goto out;
-		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
-	}
-
-	/* Not really failsafe, but we are read-only... */
-	for(;;) {
-		if (!offset || offset >= maxoff) {
-			offset = maxoff;
-			filp->f_pos = offset;
-			goto out;
-		}
-		filp->f_pos = offset;
-
-		/* Fetch inode info */
-		if (romfs_copyfrom(i, &ri, offset, ROMFH_SIZE) <= 0)
-			goto out;
-
-		j = romfs_strnlen(i, offset+ROMFH_SIZE, sizeof(fsname)-1);
-		if (j < 0)
-			goto out;
-
-		fsname[j]=0;
-		romfs_copyfrom(i, fsname, offset+ROMFH_SIZE, j);
-
-		ino = offset;
-		nextfh = be32_to_cpu(ri.next);
-		if ((nextfh & ROMFH_TYPE) == ROMFH_HRD)
-			ino = be32_to_cpu(ri.spec);
-		if (filldir(dirent, fsname, j, offset, ino,
-			    romfs_dtype_table[nextfh & ROMFH_TYPE]) < 0) {
-			goto out;
-		}
-		stored++;
-		offset = nextfh & ROMFH_MASK;
-	}
-out:
-	unlock_kernel();
-	return stored;
-}
-
-static struct dentry *
-romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
-{
-	unsigned long offset, maxoff;
-	long res;
-	int fslen;
-	struct inode *inode = NULL;
-	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
-	struct romfs_inode ri;
-	const char *name;		/* got from dentry */
-	int len;
-
-	res = -EACCES;			/* placeholder for "no data here" */
-	offset = dir->i_ino & ROMFH_MASK;
-	lock_kernel();
-	if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-		goto error;
-
-	maxoff = romfs_maxsize(dir->i_sb);
-	offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
-
-	/* OK, now find the file whose name is in "dentry" in the
-	 * directory specified by "dir".  */
-
-	name = dentry->d_name.name;
-	len = dentry->d_name.len;
-
-	for(;;) {
-		if (!offset || offset >= maxoff)
-			goto success; /* negative success */
-		if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-			goto error;
-
-		/* try to match the first 16 bytes of name */
-		fslen = romfs_strnlen(dir, offset+ROMFH_SIZE, ROMFH_SIZE);
-		if (len < ROMFH_SIZE) {
-			if (len == fslen) {
-				/* both are shorter, and same size */
-				romfs_copyfrom(dir, fsname, offset+ROMFH_SIZE, len+1);
-				if (strncmp (name, fsname, len) == 0)
-					break;
-			}
-		} else if (fslen >= ROMFH_SIZE) {
-			/* both are longer; XXX optimize max size */
-			fslen = romfs_strnlen(dir, offset+ROMFH_SIZE, sizeof(fsname)-1);
-			if (len == fslen) {
-				romfs_copyfrom(dir, fsname, offset+ROMFH_SIZE, len+1);
-				if (strncmp(name, fsname, len) == 0)
-					break;
-			}
-		}
-		/* next entry */
-		offset = be32_to_cpu(ri.next) & ROMFH_MASK;
-	}
-
-	/* Hard link handling */
-	if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
-		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
-
-	inode = romfs_iget(dir->i_sb, offset);
-	if (IS_ERR(inode)) {
-		res = PTR_ERR(inode);
-		goto error;
-	}
-
-success:
-	d_add(dentry, inode);
-	res = 0;
-error:
-	unlock_kernel();
-	return ERR_PTR(res);
-}
-
-/*
- * Ok, we do readpage, to be able to execute programs.  Unfortunately,
- * we can't use bmap, since we may have looser alignments.
- */
-
-static int
-romfs_readpage(struct file *file, struct page * page)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t offset, size;
-	unsigned long filled;
-	void *buf;
-	int result = -EIO;
-
-	page_cache_get(page);
-	lock_kernel();
-	buf = kmap(page);
-	if (!buf)
-		goto err_out;
-
-	/* 32 bit warning -- but not for us :) */
-	offset = page_offset(page);
-	size = i_size_read(inode);
-	filled = 0;
-	result = 0;
-	if (offset < size) {
-		unsigned long readlen;
-
-		size -= offset;
-		readlen = size > PAGE_SIZE ? PAGE_SIZE : size;
-
-		filled = romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen);
-
-		if (filled != readlen) {
-			SetPageError(page);
-			filled = 0;
-			result = -EIO;
-		}
-	}
-
-	if (filled < PAGE_SIZE)
-		memset(buf + filled, 0, PAGE_SIZE-filled);
-
-	if (!result)
-		SetPageUptodate(page);
-	flush_dcache_page(page);
-
-	unlock_page(page);
-
-	kunmap(page);
-err_out:
-	page_cache_release(page);
-	unlock_kernel();
-
-	return result;
-}
-
-/* Mapping from our types to the kernel */
-
-static const struct address_space_operations romfs_aops = {
-	.readpage = romfs_readpage
-};
-
-static const struct file_operations romfs_dir_operations = {
-	.read		= generic_read_dir,
-	.readdir	= romfs_readdir,
-};
-
-static const struct inode_operations romfs_dir_inode_operations = {
-	.lookup		= romfs_lookup,
-};
-
-static mode_t romfs_modemap[] =
-{
-	0, S_IFDIR+0644, S_IFREG+0644, S_IFLNK+0777,
-	S_IFBLK+0600, S_IFCHR+0600, S_IFSOCK+0644, S_IFIFO+0644
-};
-
-static struct inode *
-romfs_iget(struct super_block *sb, unsigned long ino)
-{
-	int nextfh, ret;
-	struct romfs_inode ri;
-	struct inode *i;
-
-	ino &= ROMFH_MASK;
-	i = iget_locked(sb, ino);
-	if (!i)
-		return ERR_PTR(-ENOMEM);
-	if (!(i->i_state & I_NEW))
-		return i;
-
-	i->i_mode = 0;
-
-	/* Loop for finding the real hard link */
-	for(;;) {
-		if (romfs_copyfrom(i, &ri, ino, ROMFH_SIZE) <= 0) {
-			printk(KERN_ERR "romfs: read error for inode 0x%lx\n",
-				ino);
-			iget_failed(i);
-			return ERR_PTR(-EIO);
-		}
-		/* XXX: do romfs_checksum here too (with name) */
-
-		nextfh = be32_to_cpu(ri.next);
-		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
-			break;
-
-		ino = be32_to_cpu(ri.spec) & ROMFH_MASK;
-	}
-
-	i->i_nlink = 1;		/* Hard to decide.. */
-	i->i_size = be32_to_cpu(ri.size);
-	i->i_mtime.tv_sec = i->i_atime.tv_sec = i->i_ctime.tv_sec = 0;
-	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
-
-        /* Precalculate the data offset */
-	ret = romfs_strnlen(i, ino + ROMFH_SIZE, ROMFS_MAXFN);
-	if (ret >= 0)
-		ino = (ROMFH_SIZE + ret + 1 + ROMFH_PAD) & ROMFH_MASK;
-	else
-		ino = 0;
-
-        ROMFS_I(i)->i_metasize = ino;
-        ROMFS_I(i)->i_dataoffset = ino+(i->i_ino&ROMFH_MASK);
-
-        /* Compute permissions */
-        ino = romfs_modemap[nextfh & ROMFH_TYPE];
-	/* only "normal" files have ops */
-	switch (nextfh & ROMFH_TYPE) {
-		case 1:
-			i->i_size = ROMFS_I(i)->i_metasize;
-			i->i_op = &romfs_dir_inode_operations;
-			i->i_fop = &romfs_dir_operations;
-			if (nextfh & ROMFH_EXEC)
-				ino |= S_IXUGO;
-			i->i_mode = ino;
-			break;
-		case 2:
-			i->i_fop = &generic_ro_fops;
-			i->i_data.a_ops = &romfs_aops;
-			if (nextfh & ROMFH_EXEC)
-				ino |= S_IXUGO;
-			i->i_mode = ino;
-			break;
-		case 3:
-			i->i_op = &page_symlink_inode_operations;
-			i->i_data.a_ops = &romfs_aops;
-			i->i_mode = ino | S_IRWXUGO;
-			break;
-		default:
-			/* depending on MBZ for sock/fifos */
-			nextfh = be32_to_cpu(ri.spec);
-			init_special_inode(i, ino,
-					MKDEV(nextfh>>16,nextfh&0xffff));
-	}
-	unlock_new_inode(i);
-	return i;
-}
-
-static struct kmem_cache * romfs_inode_cachep;
-
-static struct inode *romfs_alloc_inode(struct super_block *sb)
-{
-	struct romfs_inode_info *ei;
-	ei = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
-	if (!ei)
-		return NULL;
-	return &ei->vfs_inode;
-}
-
-static void romfs_destroy_inode(struct inode *inode)
-{
-	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
-}
-
-static void init_once(void *foo)
-{
-	struct romfs_inode_info *ei = foo;
-
-	inode_init_once(&ei->vfs_inode);
-}
-
-static int init_inodecache(void)
-{
-	romfs_inode_cachep = kmem_cache_create("romfs_inode_cache",
-					     sizeof(struct romfs_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
-					     init_once);
-	if (romfs_inode_cachep == NULL)
-		return -ENOMEM;
-	return 0;
-}
-
-static void destroy_inodecache(void)
-{
-	kmem_cache_destroy(romfs_inode_cachep);
-}
-
-static int romfs_remount(struct super_block *sb, int *flags, char *data)
-{
-	*flags |= MS_RDONLY;
-	return 0;
-}
-
-static const struct super_operations romfs_ops = {
-	.alloc_inode	= romfs_alloc_inode,
-	.destroy_inode	= romfs_destroy_inode,
-	.statfs		= romfs_statfs,
-	.remount_fs	= romfs_remount,
-};
-
-static int romfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_bdev(fs_type, flags, dev_name, data, romfs_fill_super,
-			   mnt);
-}
-
-static struct file_system_type romfs_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "romfs",
-	.get_sb		= romfs_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
-};
-
-static int __init init_romfs_fs(void)
-{
-	int err = init_inodecache();
-	if (err)
-		goto out1;
-        err = register_filesystem(&romfs_fs_type);
-	if (err)
-		goto out;
-	return 0;
-out:
-	destroy_inodecache();
-out1:
-	return err;
-}
-
-static void __exit exit_romfs_fs(void)
-{
-	unregister_filesystem(&romfs_fs_type);
-	destroy_inodecache();
-}
-
-/* Yes, works even as a module... :) */
-
-module_init(init_romfs_fs)
-module_exit(exit_romfs_fs)
-MODULE_LICENSE("GPL");
diff -puN /dev/null fs/romfs/internal.h
--- /dev/null
+++ a/fs/romfs/internal.h
@@ -0,0 +1,47 @@
+/* RomFS internal definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/romfs_fs.h>
+
+struct romfs_inode_info {
+	struct inode	vfs_inode;
+	unsigned long	i_metasize;	/* size of non-data area */
+	unsigned long	i_dataoffset;	/* from the start of fs */
+};
+
+static inline size_t romfs_maxsize(struct super_block *sb)
+{
+	return (size_t) (unsigned long) sb->s_fs_info;
+}
+
+static inline struct romfs_inode_info *ROMFS_I(struct inode *inode)
+{
+	return container_of(inode, struct romfs_inode_info, vfs_inode);
+}
+
+/*
+ * mmap-nommu.c
+ */
+#if !defined(CONFIG_MMU) && defined(CONFIG_ROMFS_ON_MTD)
+extern const struct file_operations romfs_ro_fops;
+#else
+#define romfs_ro_fops	generic_ro_fops
+#endif
+
+/*
+ * storage.c
+ */
+extern int romfs_dev_read(struct super_block *sb, unsigned long pos,
+			  void *buf, size_t buflen);
+extern ssize_t romfs_dev_strnlen(struct super_block *sb,
+				 unsigned long pos, size_t maxlen);
+extern int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
+			     const char *str, size_t size);
diff -puN /dev/null fs/romfs/mmap-nommu.c
--- /dev/null
+++ a/fs/romfs/mmap-nommu.c
@@ -0,0 +1,75 @@
+/* NOMMU mmap support for RomFS on MTD devices
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/mm.h>
+#include <linux/mtd/super.h>
+#include "internal.h"
+
+/*
+ * try to determine where a shared mapping can be made
+ * - only supported for NOMMU at the moment (MMU can't doesn't copy private
+ *   mappings)
+ * - attempts to map through to the underlying MTD device
+ */
+static unsigned long romfs_get_unmapped_area(struct file *file,
+					     unsigned long addr,
+					     unsigned long len,
+					     unsigned long pgoff,
+					     unsigned long flags)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct mtd_info *mtd = inode->i_sb->s_mtd;
+	unsigned long isize, offset;
+
+	if (!mtd)
+		goto cant_map_directly;
+
+	isize = i_size_read(inode);
+	offset = pgoff << PAGE_SHIFT;
+	if (offset > isize || len > isize || offset > isize - len)
+		return (unsigned long) -EINVAL;
+
+	/* we need to call down to the MTD layer to do the actual mapping */
+	if (mtd->get_unmapped_area) {
+		if (addr != 0)
+			return (unsigned long) -EINVAL;
+
+		if (len > mtd->size || pgoff >= (mtd->size >> PAGE_SHIFT))
+			return (unsigned long) -EINVAL;
+
+		offset += ROMFS_I(inode)->i_dataoffset;
+		if (offset > mtd->size - len)
+			return (unsigned long) -EINVAL;
+
+		return mtd->get_unmapped_area(mtd, len, offset, flags);
+	}
+
+cant_map_directly:
+	return (unsigned long) -ENOSYS;
+}
+
+/*
+ * permit a R/O mapping to be made directly through onto an MTD device if
+ * possible
+ */
+static int romfs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -ENOSYS;
+}
+
+const struct file_operations romfs_ro_fops = {
+	.llseek			= generic_file_llseek,
+	.read			= do_sync_read,
+	.aio_read		= generic_file_aio_read,
+	.splice_read		= generic_file_splice_read,
+	.mmap			= romfs_mmap,
+	.get_unmapped_area	= romfs_get_unmapped_area,
+};
diff -puN /dev/null fs/romfs/storage.c
--- /dev/null
+++ a/fs/romfs/storage.c
@@ -0,0 +1,261 @@
+/* RomFS storage access routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/fs.h>
+#include <linux/mtd/super.h>
+#include <linux/buffer_head.h>
+#include "internal.h"
+
+#if !defined(CONFIG_ROMFS_ON_MTD) && !defined(CONFIG_ROMFS_ON_BLOCK)
+#error no ROMFS backing store interface configured
+#endif
+
+#ifdef CONFIG_ROMFS_ON_MTD
+#define ROMFS_MTD_READ(sb, ...) ((sb)->s_mtd->read((sb)->s_mtd, ##__VA_ARGS__))
+
+/*
+ * read data from an romfs image on an MTD device
+ */
+static int romfs_mtd_read(struct super_block *sb, unsigned long pos,
+			  void *buf, size_t buflen)
+{
+	size_t rlen;
+	int ret;
+
+	ret = ROMFS_MTD_READ(sb, pos, buflen, &rlen, buf);
+	return (ret < 0 || rlen != buflen) ? -EIO : 0;
+}
+
+/*
+ * determine the length of a string in a romfs image on an MTD device
+ */
+static ssize_t romfs_mtd_strnlen(struct super_block *sb,
+				 unsigned long pos, size_t maxlen)
+{
+	ssize_t n = 0;
+	size_t segment;
+	u_char buf[16], *p;
+	size_t len;
+	int ret;
+
+	/* scan the string up to 16 bytes at a time */
+	while (maxlen > 0) {
+		segment = min_t(size_t, maxlen, 16);
+		ret = ROMFS_MTD_READ(sb, pos, segment, &len, buf);
+		if (ret < 0)
+			return ret;
+		p = memchr(buf, 0, len);
+		if (p)
+			return n + (p - buf);
+		maxlen -= len;
+		pos += len;
+		n += len;
+	}
+
+	return n;
+}
+
+/*
+ * compare a string to one in a romfs image on MTD
+ * - return 1 if matched, 0 if differ, -ve if error
+ */
+static int romfs_mtd_strncmp(struct super_block *sb, unsigned long pos,
+			     const char *str, size_t size)
+{
+	u_char buf[16];
+	size_t len, segment;
+	int ret;
+
+	/* scan the string up to 16 bytes at a time */
+	while (size > 0) {
+		segment = min_t(size_t, size, 16);
+		ret = ROMFS_MTD_READ(sb, pos, segment, &len, buf);
+		if (ret < 0)
+			return ret;
+		if (memcmp(buf, str, len) != 0)
+			return 0;
+		size -= len;
+		pos += len;
+		str += len;
+	}
+
+	return 1;
+}
+#endif /* CONFIG_ROMFS_ON_MTD */
+
+#ifdef CONFIG_ROMFS_ON_BLOCK
+/*
+ * read data from an romfs image on a block device
+ */
+static int romfs_blk_read(struct super_block *sb, unsigned long pos,
+			  void *buf, size_t buflen)
+{
+	struct buffer_head *bh;
+	unsigned long offset;
+	size_t segment;
+
+	/* copy the string up to blocksize bytes at a time */
+	while (buflen > 0) {
+		offset = pos & (ROMBSIZE - 1);
+		segment = min_t(size_t, buflen, ROMBSIZE - offset);
+		bh = sb_bread(sb, pos >> ROMBSBITS);
+		if (!bh)
+			return -EIO;
+		memcpy(buf, bh->b_data + offset, segment);
+		brelse(bh);
+		buflen -= segment;
+		pos += segment;
+	}
+
+	return 0;
+}
+
+/*
+ * determine the length of a string in romfs on a block device
+ */
+static ssize_t romfs_blk_strnlen(struct super_block *sb,
+				 unsigned long pos, size_t limit)
+{
+	struct buffer_head *bh;
+	unsigned long offset;
+	ssize_t n = 0;
+	size_t segment;
+	u_char *buf, *p;
+
+	/* scan the string up to blocksize bytes at a time */
+	while (limit > 0) {
+		offset = pos & (ROMBSIZE - 1);
+		segment = min_t(size_t, limit, ROMBSIZE - offset);
+		bh = sb_bread(sb, pos >> ROMBSBITS);
+		if (!bh)
+			return -EIO;
+		buf = bh->b_data + offset;
+		p = memchr(buf, 0, segment);
+		brelse(bh);
+		if (p)
+			return n + (p - buf);
+		limit -= segment;
+		pos += segment;
+		n += segment;
+	}
+
+	return n;
+}
+
+/*
+ * compare a string to one in a romfs image on a block device
+ * - return 1 if matched, 0 if differ, -ve if error
+ */
+static int romfs_blk_strncmp(struct super_block *sb, unsigned long pos,
+			     const char *str, size_t size)
+{
+	struct buffer_head *bh;
+	unsigned long offset;
+	size_t segment;
+	bool x;
+
+	/* scan the string up to 16 bytes at a time */
+	while (size > 0) {
+		offset = pos & (ROMBSIZE - 1);
+		segment = min_t(size_t, size, ROMBSIZE - offset);
+		bh = sb_bread(sb, pos >> ROMBSBITS);
+		if (!bh)
+			return -EIO;
+		x = (memcmp(bh->b_data + offset, str, segment) != 0);
+		brelse(bh);
+		if (x)
+			return 0;
+		size -= segment;
+		pos += segment;
+		str += segment;
+	}
+
+	return 1;
+}
+#endif /* CONFIG_ROMFS_ON_BLOCK */
+
+/*
+ * read data from the romfs image
+ */
+int romfs_dev_read(struct super_block *sb, unsigned long pos,
+		   void *buf, size_t buflen)
+{
+	size_t limit;
+
+	limit = romfs_maxsize(sb);
+	if (pos >= limit)
+		return -EIO;
+	if (buflen > limit - pos)
+		buflen = limit - pos;
+
+#ifdef CONFIG_ROMFS_ON_MTD
+	if (sb->s_mtd)
+		return romfs_mtd_read(sb, pos, buf, buflen);
+#endif
+#ifdef CONFIG_ROMFS_ON_BLOCK
+	if (sb->s_bdev)
+		return romfs_blk_read(sb, pos, buf, buflen);
+#endif
+	return -EIO;
+}
+
+/*
+ * determine the length of a string in romfs
+ */
+ssize_t romfs_dev_strnlen(struct super_block *sb,
+			  unsigned long pos, size_t maxlen)
+{
+	size_t limit;
+
+	limit = romfs_maxsize(sb);
+	if (pos >= limit)
+		return -EIO;
+	if (maxlen > limit - pos)
+		maxlen = limit - pos;
+
+#ifdef CONFIG_ROMFS_ON_MTD
+	if (sb->s_mtd)
+		return romfs_mtd_strnlen(sb, pos, limit);
+#endif
+#ifdef CONFIG_ROMFS_ON_BLOCK
+	if (sb->s_bdev)
+		return romfs_blk_strnlen(sb, pos, limit);
+#endif
+	return -EIO;
+}
+
+/*
+ * compare a string to one in romfs
+ * - return 1 if matched, 0 if differ, -ve if error
+ */
+int romfs_dev_strncmp(struct super_block *sb, unsigned long pos,
+		      const char *str, size_t size)
+{
+	size_t limit;
+
+	limit = romfs_maxsize(sb);
+	if (pos >= limit)
+		return -EIO;
+	if (size > ROMFS_MAXFN)
+		return -ENAMETOOLONG;
+	if (size > limit - pos)
+		return -EIO;
+
+#ifdef CONFIG_ROMFS_ON_MTD
+	if (sb->s_mtd)
+		return romfs_mtd_strncmp(sb, pos, str, size);
+#endif
+#ifdef CONFIG_ROMFS_ON_BLOCK
+	if (sb->s_bdev)
+		return romfs_blk_strncmp(sb, pos, str, size);
+#endif
+	return -EIO;
+}
diff -puN /dev/null fs/romfs/super.c
--- /dev/null
+++ a/fs/romfs/super.c
@@ -0,0 +1,648 @@
+/* Block- or MTD-based romfs
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Derived from: ROMFS file system, Linux implementation
+ *
+ * Copyright (C) 1997-1999  Janos Farkas <chexum@shadow.banki.hu>
+ *
+ * Using parts of the minix filesystem
+ * Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * and parts of the affs filesystem additionally
+ * Copyright (C) 1993  Ray Burr
+ * Copyright (C) 1996  Hans-Joachim Widmaier
+ *
+ * Changes
+ *					Changed for 2.1.19 modules
+ *	Jan 1997			Initial release
+ *	Jun 1997			2.1.43+ changes
+ *					Proper page locking in readpage
+ *					Changed to work with 2.1.45+ fs
+ *	Jul 1997			Fixed follow_link
+ *			2.1.47
+ *					lookup shouldn't return -ENOENT
+ *					from Horst von Brand:
+ *					  fail on wrong checksum
+ *					  double unlock_super was possible
+ *					  correct namelen for statfs
+ *					spotted by Bill Hawes:
+ *					  readlink shouldn't iput()
+ *	Jun 1998	2.1.106		from Avery Pennarun: glibc scandir()
+ *					  exposed a problem in readdir
+ *			2.1.107		code-freeze spellchecker run
+ *	Aug 1998			2.1.118+ VFS changes
+ *	Sep 1998	2.1.122		another VFS change (follow_link)
+ *	Apr 1999	2.2.7		no more EBADF checking in
+ *					  lookup/readdir, use ERR_PTR
+ *	Jun 1999	2.3.6		d_alloc_root use changed
+ *			2.3.9		clean up usage of ENOENT/negative
+ *					  dentries in lookup
+ *					clean up page flags setting
+ *					  (error, uptodate, locking) in
+ *					  in readpage
+ *					use init_special_inode for
+ *					  fifos/sockets (and streamline) in
+ *					  read_inode, fix _ops table order
+ *	Aug 1999	2.3.16		__initfunc() => __init change
+ *	Oct 1999	2.3.24		page->owner hack obsoleted
+ *	Nov 1999	2.3.27		2.3.25+ page->offset => index change
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/time.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/parser.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/statfs.h>
+#include <linux/mtd/super.h>
+#include <linux/ctype.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/uaccess.h>
+#include "internal.h"
+
+static struct kmem_cache *romfs_inode_cachep;
+
+static const umode_t romfs_modemap[8] = {
+	0,			/* hard link */
+	S_IFDIR  | 0644,	/* directory */
+	S_IFREG  | 0644,	/* regular file */
+	S_IFLNK  | 0777,	/* symlink */
+	S_IFBLK  | 0600,	/* blockdev */
+	S_IFCHR  | 0600,	/* chardev */
+	S_IFSOCK | 0644,	/* socket */
+	S_IFIFO  | 0644		/* FIFO */
+};
+
+static const unsigned char romfs_dtype_table[] = {
+	DT_UNKNOWN, DT_DIR, DT_REG, DT_LNK, DT_BLK, DT_CHR, DT_SOCK, DT_FIFO
+};
+
+static struct inode *romfs_iget(struct super_block *sb, unsigned long pos);
+
+/*
+ * read a page worth of data from the image
+ */
+static int romfs_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t offset, size;
+	unsigned long fillsize, pos;
+	void *buf;
+	int ret;
+
+	buf = kmap(page);
+	if (!buf)
+		return -ENOMEM;
+
+	/* 32 bit warning -- but not for us :) */
+	offset = page_offset(page);
+	size = i_size_read(inode);
+	fillsize = 0;
+	ret = 0;
+	if (offset < size) {
+		size -= offset;
+		fillsize = size > PAGE_SIZE ? PAGE_SIZE : size;
+
+		pos = ROMFS_I(inode)->i_dataoffset + offset;
+
+		ret = romfs_dev_read(inode->i_sb, pos, buf, fillsize);
+		if (ret < 0) {
+			SetPageError(page);
+			fillsize = 0;
+			ret = -EIO;
+		}
+	}
+
+	if (fillsize < PAGE_SIZE)
+		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
+	if (ret == 0)
+		SetPageUptodate(page);
+
+	flush_dcache_page(page);
+	kunmap(page);
+	unlock_page(page);
+	return ret;
+}
+
+static const struct address_space_operations romfs_aops = {
+	.readpage	= romfs_readpage
+};
+
+/*
+ * read the entries from a directory
+ */
+static int romfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *i = filp->f_dentry->d_inode;
+	struct romfs_inode ri;
+	unsigned long offset, maxoff;
+	int j, ino, nextfh;
+	int stored = 0;
+	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
+	int ret;
+
+	maxoff = romfs_maxsize(i->i_sb);
+
+	offset = filp->f_pos;
+	if (!offset) {
+		offset = i->i_ino & ROMFH_MASK;
+		ret = romfs_dev_read(i->i_sb, offset, &ri, ROMFH_SIZE);
+		if (ret < 0)
+			goto out;
+		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
+	}
+
+	/* Not really failsafe, but we are read-only... */
+	for (;;) {
+		if (!offset || offset >= maxoff) {
+			offset = maxoff;
+			filp->f_pos = offset;
+			goto out;
+		}
+		filp->f_pos = offset;
+
+		/* Fetch inode info */
+		ret = romfs_dev_read(i->i_sb, offset, &ri, ROMFH_SIZE);
+		if (ret < 0)
+			goto out;
+
+		j = romfs_dev_strnlen(i->i_sb, offset + ROMFH_SIZE,
+				      sizeof(fsname) - 1);
+		if (j < 0)
+			goto out;
+
+		ret = romfs_dev_read(i->i_sb, offset + ROMFH_SIZE, fsname, j);
+		if (ret < 0)
+			goto out;
+		fsname[j] = '\0';
+
+		ino = offset;
+		nextfh = be32_to_cpu(ri.next);
+		if ((nextfh & ROMFH_TYPE) == ROMFH_HRD)
+			ino = be32_to_cpu(ri.spec);
+		if (filldir(dirent, fsname, j, offset, ino,
+			    romfs_dtype_table[nextfh & ROMFH_TYPE]) < 0)
+			goto out;
+
+		stored++;
+		offset = nextfh & ROMFH_MASK;
+	}
+
+out:
+	return stored;
+}
+
+/*
+ * look up an entry in a directory
+ */
+static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	unsigned long offset, maxoff;
+	struct inode *inode;
+	struct romfs_inode ri;
+	const char *name;		/* got from dentry */
+	int len, ret;
+
+	offset = dir->i_ino & ROMFH_MASK;
+	ret = romfs_dev_read(dir->i_sb, offset, &ri, ROMFH_SIZE);
+	if (ret < 0)
+		goto error;
+
+	/* search all the file entries in the list starting from the one
+	 * pointed to by the directory's special data */
+	maxoff = romfs_maxsize(dir->i_sb);
+	offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
+
+	name = dentry->d_name.name;
+	len = dentry->d_name.len;
+
+	for (;;) {
+		if (!offset || offset >= maxoff)
+			goto out0;
+
+		ret = romfs_dev_read(dir->i_sb, offset, &ri, sizeof(ri));
+		if (ret < 0)
+			goto error;
+
+		/* try to match the first 16 bytes of name */
+		ret = romfs_dev_strncmp(dir->i_sb, offset + ROMFH_SIZE, name,
+					len);
+		if (ret < 0)
+			goto error;
+		if (ret == 1)
+			break;
+
+		/* next entry */
+		offset = be32_to_cpu(ri.next) & ROMFH_MASK;
+	}
+
+	/* Hard link handling */
+	if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
+		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
+
+	inode = romfs_iget(dir->i_sb, offset);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto error;
+	}
+	goto outi;
+
+	/*
+	 * it's a bit funky, _lookup needs to return an error code
+	 * (negative) or a NULL, both as a dentry.  ENOENT should not
+	 * be returned, instead we need to create a negative dentry by
+	 * d_add(dentry, NULL); and return 0 as no error.
+	 * (Although as I see, it only matters on writable file
+	 * systems).
+	 */
+out0:
+	inode = NULL;
+outi:
+	d_add(dentry, inode);
+	ret = 0;
+error:
+	return ERR_PTR(ret);
+}
+
+static const struct file_operations romfs_dir_operations = {
+	.read		= generic_read_dir,
+	.readdir	= romfs_readdir,
+};
+
+static struct inode_operations romfs_dir_inode_operations = {
+	.lookup		= romfs_lookup,
+};
+
+/*
+ * get a romfs inode based on its position in the image (which doubles as the
+ * inode number)
+ */
+static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
+{
+	struct romfs_inode_info *inode;
+	struct romfs_inode ri;
+	struct inode *i;
+	unsigned long nlen;
+	unsigned nextfh, ret;
+	umode_t mode;
+
+	/* we might have to traverse a chain of "hard link" file entries to get
+	 * to the actual file */
+	for (;;) {
+		ret = romfs_dev_read(sb, pos, &ri, sizeof(ri));
+		if (ret < 0)
+			goto error;
+
+		/* XXX: do romfs_checksum here too (with name) */
+
+		nextfh = be32_to_cpu(ri.next);
+		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
+			break;
+
+		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
+	}
+
+	/* determine the length of the filename */
+	nlen = romfs_dev_strnlen(sb, pos + ROMFH_SIZE, ROMFS_MAXFN);
+	if (IS_ERR_VALUE(nlen))
+		goto eio;
+
+	/* get an inode for this image position */
+	i = iget_locked(sb, pos);
+	if (!i)
+		return ERR_PTR(-ENOMEM);
+
+	if (!(i->i_state & I_NEW))
+		return i;
+
+	/* precalculate the data offset */
+	inode = ROMFS_I(i);
+	inode->i_metasize = (ROMFH_SIZE + nlen + 1 + ROMFH_PAD) & ROMFH_MASK;
+	inode->i_dataoffset = pos + inode->i_metasize;
+
+	i->i_nlink = 1;		/* Hard to decide.. */
+	i->i_size = be32_to_cpu(ri.size);
+	i->i_mtime.tv_sec = i->i_atime.tv_sec = i->i_ctime.tv_sec = 0;
+	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
+
+	/* set up mode and ops */
+	mode = romfs_modemap[nextfh & ROMFH_TYPE];
+
+	switch (nextfh & ROMFH_TYPE) {
+	case ROMFH_DIR:
+		i->i_size = ROMFS_I(i)->i_metasize;
+		i->i_op = &romfs_dir_inode_operations;
+		i->i_fop = &romfs_dir_operations;
+		if (nextfh & ROMFH_EXEC)
+			mode |= S_IXUGO;
+		break;
+	case ROMFH_REG:
+		i->i_fop = &romfs_ro_fops;
+		i->i_data.a_ops = &romfs_aops;
+		if (i->i_sb->s_mtd)
+			i->i_data.backing_dev_info =
+				i->i_sb->s_mtd->backing_dev_info;
+		if (nextfh & ROMFH_EXEC)
+			mode |= S_IXUGO;
+		break;
+	case ROMFH_SYM:
+		i->i_op = &page_symlink_inode_operations;
+		i->i_data.a_ops = &romfs_aops;
+		mode |= S_IRWXUGO;
+		break;
+	default:
+		/* depending on MBZ for sock/fifos */
+		nextfh = be32_to_cpu(ri.spec);
+		init_special_inode(i, mode, MKDEV(nextfh >> 16,
+						  nextfh & 0xffff));
+		break;
+	}
+
+	i->i_mode = mode;
+
+	unlock_new_inode(i);
+	return i;
+
+eio:
+	ret = -EIO;
+error:
+	printk(KERN_ERR "ROMFS: read error for inode 0x%lx\n", pos);
+	return ERR_PTR(ret);
+}
+
+/*
+ * allocate a new inode
+ */
+static struct inode *romfs_alloc_inode(struct super_block *sb)
+{
+	struct romfs_inode_info *inode;
+	inode = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
+	return inode ? &inode->vfs_inode : NULL;
+}
+
+/*
+ * return a spent inode to the slab cache
+ */
+static void romfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
+}
+
+/*
+ * get filesystem statistics
+ */
+static int romfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	buf->f_type = ROMFS_MAGIC;
+	buf->f_namelen = ROMFS_MAXFN;
+	buf->f_bsize = ROMBSIZE;
+	buf->f_bfree = buf->f_bavail = buf->f_ffree;
+	buf->f_blocks =
+		(romfs_maxsize(dentry->d_sb) + ROMBSIZE - 1) >> ROMBSBITS;
+	return 0;
+}
+
+/*
+ * remounting must involve read-only
+ */
+static int romfs_remount(struct super_block *sb, int *flags, char *data)
+{
+	*flags |= MS_RDONLY;
+	return 0;
+}
+
+static const struct super_operations romfs_super_ops = {
+	.alloc_inode	= romfs_alloc_inode,
+	.destroy_inode	= romfs_destroy_inode,
+	.statfs		= romfs_statfs,
+	.remount_fs	= romfs_remount,
+};
+
+/*
+ * checksum check on part of a romfs filesystem
+ */
+static __u32 romfs_checksum(const void *data, int size)
+{
+	const __be32 *ptr = data;
+	__u32 sum;
+
+	sum = 0;
+	size >>= 2;
+	while (size > 0) {
+		sum += be32_to_cpu(*ptr++);
+		size--;
+	}
+	return sum;
+}
+
+/*
+ * fill in the superblock
+ */
+static int romfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct romfs_super_block *rsb;
+	struct inode *root;
+	unsigned long pos, img_size;
+	const char *storage;
+	size_t len;
+	int ret;
+
+#ifdef CONFIG_BLOCK
+	if (!sb->s_mtd) {
+		sb_set_blocksize(sb, ROMBSIZE);
+	} else {
+		sb->s_blocksize = ROMBSIZE;
+		sb->s_blocksize_bits = blksize_bits(ROMBSIZE);
+	}
+#endif
+
+	sb->s_maxbytes = 0xFFFFFFFF;
+	sb->s_magic = ROMFS_MAGIC;
+	sb->s_flags |= MS_RDONLY | MS_NOATIME;
+	sb->s_op = &romfs_super_ops;
+
+	/* read the image superblock and check it */
+	rsb = kmalloc(512, GFP_KERNEL);
+	if (!rsb)
+		return -ENOMEM;
+
+	sb->s_fs_info = (void *) 512;
+	ret = romfs_dev_read(sb, 0, rsb, 512);
+	if (ret < 0)
+		goto error_rsb;
+
+	img_size = be32_to_cpu(rsb->size);
+
+	if (sb->s_mtd && img_size > sb->s_mtd->size)
+		goto error_rsb_inval;
+
+	sb->s_fs_info = (void *) img_size;
+
+	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1 ||
+	    img_size < ROMFH_SIZE) {
+		if (!silent)
+			printk(KERN_WARNING "VFS:"
+			       " Can't find a romfs filesystem on dev %s.\n",
+			       sb->s_id);
+		goto error_rsb_inval;
+	}
+
+	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
+		printk(KERN_ERR "ROMFS: bad initial checksum on dev %s.\n",
+		       sb->s_id);
+		goto error_rsb_inval;
+	}
+
+	storage = sb->s_mtd ? "MTD" : "the block layer";
+
+	len = strnlen(rsb->name, ROMFS_MAXFN);
+	if (!silent)
+		printk(KERN_NOTICE "ROMFS: Mounting image '%*.*s' through %s\n",
+		       (unsigned) len, (unsigned) len, rsb->name, storage);
+
+	kfree(rsb);
+	rsb = NULL;
+
+	/* find the root directory */
+	pos = (ROMFH_SIZE + len + 1 + ROMFH_PAD) & ROMFH_MASK;
+
+	root = romfs_iget(sb, pos);
+	if (!root)
+		goto error;
+
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root)
+		goto error_i;
+
+	return 0;
+
+error_i:
+	iput(root);
+error:
+	return -EINVAL;
+error_rsb_inval:
+	ret = -EINVAL;
+error_rsb:
+	return ret;
+}
+
+/*
+ * get a superblock for mounting
+ */
+static int romfs_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *mnt)
+{
+	int ret = -EINVAL;
+
+#ifdef CONFIG_ROMFS_ON_MTD
+	ret = get_sb_mtd(fs_type, flags, dev_name, data, romfs_fill_super,
+			 mnt);
+#endif
+#ifdef CONFIG_ROMFS_ON_BLOCK
+	if (ret == -EINVAL)
+		ret = get_sb_bdev(fs_type, flags, dev_name, data,
+				  romfs_fill_super, mnt);
+#endif
+	return ret;
+}
+
+/*
+ * destroy a romfs superblock in the appropriate manner
+ */
+static void romfs_kill_sb(struct super_block *sb)
+{
+#ifdef CONFIG_ROMFS_ON_MTD
+	if (sb->s_mtd) {
+		kill_mtd_super(sb);
+		return;
+	}
+#endif
+#ifdef CONFIG_ROMFS_ON_BLOCK
+	if (sb->s_bdev) {
+		kill_block_super(sb);
+		return;
+	}
+#endif
+}
+
+static struct file_system_type romfs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "romfs",
+	.get_sb		= romfs_get_sb,
+	.kill_sb	= romfs_kill_sb,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+/*
+ * inode storage initialiser
+ */
+static void romfs_i_init_once(void *_inode)
+{
+	struct romfs_inode_info *inode = _inode;
+
+	inode_init_once(&inode->vfs_inode);
+}
+
+/*
+ * romfs module initialisation
+ */
+static int __init init_romfs_fs(void)
+{
+	int ret;
+
+	printk(KERN_INFO "ROMFS MTD (C) 2007 Red Hat, Inc.\n");
+
+	romfs_inode_cachep =
+		kmem_cache_create("romfs_i",
+				  sizeof(struct romfs_inode_info), 0,
+				  SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				  romfs_i_init_once);
+
+	if (!romfs_inode_cachep) {
+		printk(KERN_ERR
+		       "ROMFS error: Failed to initialise inode cache\n");
+		return -ENOMEM;
+	}
+	ret = register_filesystem(&romfs_fs_type);
+	if (ret) {
+		printk(KERN_ERR "ROMFS error: Failed to register filesystem\n");
+		goto error_register;
+	}
+	return 0;
+
+error_register:
+	kmem_cache_destroy(romfs_inode_cachep);
+	return ret;
+}
+
+/*
+ * romfs module removal
+ */
+static void __exit exit_romfs_fs(void)
+{
+	unregister_filesystem(&romfs_fs_type);
+	kmem_cache_destroy(romfs_inode_cachep);
+}
+
+module_init(init_romfs_fs);
+module_exit(exit_romfs_fs);
+
+MODULE_DESCRIPTION("Direct-MTD Capable RomFS");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL"); /* Actually dual-licensed, but it doesn't matter for */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

