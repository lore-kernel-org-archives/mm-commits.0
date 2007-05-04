From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch added to -mm tree
Date: Thu, 03 May 2007 23:07:56 -0700
Message-ID: <200705040607.l4467uNC030305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbXEDGNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com


The patch titled
     unprivileged mounts: put declaration of put_filesystem() in fs.h
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unprivileged mounts: put declaration of put_filesystem() in fs.h
From: Miklos Szeredi <mszeredi@suse.cz>

Declarations go into headers.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |    4 ----
 include/linux/fs.h |    2 ++
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/super.c~unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh fs/super.c
--- a/fs/super.c~unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh
+++ a/fs/super.c
@@ -40,10 +40,6 @@
 #include <asm/uaccess.h>
 
 
-void get_filesystem(struct file_system_type *fs);
-void put_filesystem(struct file_system_type *fs);
-struct file_system_type *get_fs_type(const char *name);
-
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
diff -puN include/linux/fs.h~unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh
+++ a/include/linux/fs.h
@@ -1874,6 +1874,8 @@ extern int vfs_fstat(unsigned int, struc
 
 extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
 
+extern void get_filesystem(struct file_system_type *fs);
+extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *user_get_super(dev_t);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
check-privileges-before-setting-mount-propagation.patch
consolidate-generic_writepages-and-mpage_writepages.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
