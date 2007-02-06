From: akpm@linux-foundation.org
Subject: - nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:32:47 -0800
Message-ID: <200702060033.l160Xomh004723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965239AbXBFAeL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:34:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@infradead.org, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     NFS: Represent 64-bit fileids as 64-bit inode numbers on 32-bit systems
has been removed from the -mm tree.  Its filename was
     nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch

This patch was dropped because it doesn't seem ready

------------------------------------------------------
Subject: NFS: Represent 64-bit fileids as 64-bit inode numbers on 32-bit systems
From: David Howells <dhowells@redhat.com>

Building on the previous patch that expanded the inode numbers in struct
kstat and filldir_t to an obligate 64-bits, make NFS represent 64-bit
fileids as 64-bit inode numbers rather than compressing them down to
32-bits.

hch says:
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
is quite risky as I mentioned so I'd drop it for the time beeing - we
shouldn't put it in as long as we don't have a mount option for it.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/dir.c           |    6 +++---
 fs/nfs/inode.c         |   21 ++++++++++-----------
 include/linux/nfs_fs.h |    9 ---------
 3 files changed, 13 insertions(+), 23 deletions(-)

diff -puN fs/nfs/dir.c~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems
+++ a/fs/nfs/dir.c
@@ -400,7 +400,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 	struct file	*file = desc->file;
 	struct nfs_entry *entry = desc->entry;
 	struct dentry	*dentry = NULL;
-	unsigned long	fileid;
+	u64		fileid;
 	int		loop_count = 0,
 			res;
 
@@ -411,7 +411,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 		unsigned d_type = DT_UNKNOWN;
 		/* Note: entry->prev_cookie contains the cookie for
 		 *	 retrieving the current dirent on the server */
-		fileid = nfs_fileid_to_ino_t(entry->ino);
+		fileid = entry->ino;
 
 		/* Get a dentry if we have one */
 		if (dentry != NULL)
@@ -421,7 +421,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 		/* Use readdirplus info */
 		if (dentry != NULL && dentry->d_inode != NULL) {
 			d_type = dt_type(dentry->d_inode);
-			fileid = dentry->d_inode->i_ino;
+			fileid = NFS_FILEID(dentry->d_inode);
 		}
 
 		res = filldir(dirent, entry->name, entry->len, 
diff -puN fs/nfs/inode.c~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems
+++ a/fs/nfs/inode.c
@@ -57,12 +57,6 @@ static void nfs_zap_acl_cache(struct ino
 
 static struct kmem_cache * nfs_inode_cachep;
 
-static inline unsigned long
-nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
-{
-	return nfs_fileid_to_ino_t(fattr->fileid);
-}
-
 int nfs_write_inode(struct inode *inode, int sync)
 {
 	int flags = sync ? FLUSH_SYNC : 0;
@@ -225,7 +219,9 @@ nfs_fhget(struct super_block *sb, struct
 		goto out_no_inode;
 	}
 
-	hash = nfs_fattr_to_ino_t(fattr);
+	hash = fattr->fileid;
+	if (sizeof(hash) < sizeof(u64))
+		hash ^= fattr->fileid >> (sizeof(u64) - sizeof(ino_t)) * 8;
 
 	inode = iget5_locked(sb, hash, nfs_find_actor, nfs_init_locked, &desc);
 	if (inode == NULL) {
@@ -236,9 +232,10 @@ nfs_fhget(struct super_block *sb, struct
 	if (inode->i_state & I_NEW) {
 		struct nfs_inode *nfsi = NFS_I(inode);
 
-		/* We set i_ino for the few things that still rely on it,
-		 * such as stat(2) */
-		inode->i_ino = hash;
+		/* We set i_ino for the few things that still rely on it, such
+		 * as printing messages; stat and filldir use the fileid
+		 * directly since i_ino may not be large enough */
+		inode->i_ino = fattr->fileid;
 
 		/* We can't support update_atime(), since the server will reset it */
 		inode->i_flags |= S_NOATIME|S_NOCMTIME;
@@ -441,8 +438,10 @@ int nfs_getattr(struct vfsmount *mnt, st
 		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
 	else
 		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (!err)
+	if (!err) {
 		generic_fillattr(inode, stat);
+		stat->ino = NFS_FILEID(inode);
+	}
 	return err;
 }
 
diff -puN include/linux/nfs_fs.h~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems
+++ a/include/linux/nfs_fs.h
@@ -521,15 +521,6 @@ nfs_size_to_loff_t(__u64 size)
 	return (loff_t) size;
 }
 
-static inline ino_t
-nfs_fileid_to_ino_t(u64 fileid)
-{
-	ino_t ino = (ino_t) fileid;
-	if (sizeof(ino_t) < sizeof(u64))
-		ino ^= fileid >> (sizeof(u64)-sizeof(ino_t)) * 8;
-	return ino;
-}
-
 /* NFS root */
 
 extern void * nfs_root_data(void);
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-alsa.patch
infiniband-work-around-gcc-bug-on-sparc64.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
git-cryptodev.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-frv.patch
reiser4-get_sb_dev-fix.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
mutex-subsystem-synchro-test-module.patch
