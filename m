From: akpm@osdl.org
Subject: - struct-path-convert-net.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:20 -0800
Message-ID: <200612082004.kB8K4Ki4002172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426276AbWLHUEY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert net
has been removed from the -mm tree.  Its filename was
     struct-path-convert-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert net
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/socket.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN net/socket.c~struct-path-convert-net net/socket.c
--- a/net/socket.c~struct-path-convert-net
+++ a/net/socket.c
@@ -362,20 +362,20 @@ static int sock_attach_fd(struct socket 
 	this.name = name;
 	this.hash = 0;
 
-	file->f_dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
-	if (unlikely(!file->f_dentry))
+	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
+	if (unlikely(!file->f_path.dentry))
 		return -ENOMEM;
 
-	file->f_dentry->d_op = &sockfs_dentry_operations;
+	file->f_path.dentry->d_op = &sockfs_dentry_operations;
 	/*
 	 * We dont want to push this dentry into global dentry hash table.
 	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
 	 * This permits a working /proc/$pid/fd/XXX on sockets
 	 */
-	file->f_dentry->d_flags &= ~DCACHE_UNHASHED;
-	d_instantiate(file->f_dentry, SOCK_INODE(sock));
-	file->f_vfsmnt = mntget(sock_mnt);
-	file->f_mapping = file->f_dentry->d_inode->i_mapping;
+	file->f_path.dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(file->f_path.dentry, SOCK_INODE(sock));
+	file->f_path.mnt = mntget(sock_mnt);
+	file->f_mapping = file->f_path.dentry->d_inode->i_mapping;
 
 	sock->file = file;
 	file->f_op = SOCK_INODE(sock)->i_fop = &socket_file_ops;
@@ -413,7 +413,7 @@ static struct socket *sock_from_file(str
 	if (file->f_op == &socket_file_ops)
 		return file->private_data;	/* set in sock_map_fd */
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	if (!S_ISSOCK(inode->i_mode)) {
 		*err = -ENOTSOCK;
 		return NULL;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

