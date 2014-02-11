From: akpm@linux-foundation.org
Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch added to -mm
 tree
Date: Mon, 10 Feb 2014 16:16:10 -0800
Message-ID: <52f96bca.t9ji7dXtRLSjOk0F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaBKAQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch added to -mm tree
To: joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:10 -0800


The patch titled
     Subject: ncpfs: convert DPRINTK/DDPRINTK to ncp_dbg
has been added to the -mm tree.  Its filename is
     ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ncpfs: convert DPRINTK/DDPRINTK to ncp_dbg

Use a more current logging style and enable use of dynamic debugging.

Remove embedded function names, dynamic debug can add this instead.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c           |   46 ++++++++++++++++---------------------
 fs/ncpfs/file.c          |   16 ++++++------
 fs/ncpfs/inode.c         |   22 ++++++++---------
 fs/ncpfs/ioctl.c         |   17 ++++++-------
 fs/ncpfs/mmap.c          |    2 -
 fs/ncpfs/ncp_fs.h        |   18 +++++++-------
 fs/ncpfs/ncplib_kernel.c |   18 ++++++--------
 fs/ncpfs/sock.c          |   16 ++++++------
 fs/ncpfs/symlink.c       |    2 -
 9 files changed, 74 insertions(+), 83 deletions(-)

diff -puN fs/ncpfs/dir.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/dir.c
@@ -339,7 +339,7 @@ ncp_lookup_validate(struct dentry *dentr
 	if (val)
 		goto finished;
 
-	DDPRINTK("ncp_lookup_validate: %pd2 not valid, age=%ld, server lookup\n",
+	ncp_dbg(2, "%pd2 not valid, age=%ld, server lookup\n",
 		dentry, NCP_GET_AGE(dentry));
 
 	len = sizeof(__name);
@@ -358,7 +358,7 @@ ncp_lookup_validate(struct dentry *dentr
 			res = ncp_obtain_info(server, dir, __name, &(finfo.i));
 	}
 	finfo.volume = finfo.i.volNumber;
-	DDPRINTK("ncp_lookup_validate: looked for %pd/%s, res=%d\n",
+	ncp_dbg(2, "looked for %pd/%s, res=%d\n",
 		dentry->d_parent, __name, res);
 	/*
 	 * If we didn't find it, or if it has a different dirEntNum to
@@ -372,14 +372,14 @@ ncp_lookup_validate(struct dentry *dentr
 			ncp_new_dentry(dentry);
 			val=1;
 		} else
-			DDPRINTK("ncp_lookup_validate: found, but dirEntNum changed\n");
+			ncp_dbg(2, "found, but dirEntNum changed\n");
 
 		ncp_update_inode2(inode, &finfo);
 		mutex_unlock(&inode->i_mutex);
 	}
 
 finished:
-	DDPRINTK("ncp_lookup_validate: result=%d\n", val);
+	ncp_dbg(2, "result=%d\n", val);
 	dput(parent);
 	return val;
 }
@@ -453,8 +453,7 @@ static int ncp_readdir(struct file *file
 	ctl.page  = NULL;
 	ctl.cache = NULL;
 
-	DDPRINTK("ncp_readdir: reading %pD2, pos=%d\n", file,
-		(int) ctx->pos);
+	ncp_dbg(2, "reading %pD2, pos=%d\n", file, (int)ctx->pos);
 
 	result = -EIO;
 	/* Do not generate '.' and '..' when server is dead. */
@@ -697,8 +696,7 @@ ncp_read_volume_list(struct file *file,
 	struct ncp_entry_info entry;
 	int i;
 
-	DPRINTK("ncp_read_volume_list: pos=%ld\n",
-			(unsigned long) ctx->pos);
+	ncp_dbg(1, "pos=%ld\n", (unsigned long)ctx->pos);
 
 	for (i = 0; i < NCP_NUMBER_OF_VOLUMES; i++) {
 		int inval_dentry;
@@ -708,12 +706,11 @@ ncp_read_volume_list(struct file *file,
 		if (!strlen(info.volume_name))
 			continue;
 
-		DPRINTK("ncp_read_volume_list: found vol: %s\n",
-			info.volume_name);
+		ncp_dbg(1, "found vol: %s\n", info.volume_name);
 
 		if (ncp_lookup_volume(server, info.volume_name,
 					&entry.i)) {
-			DPRINTK("ncpfs: could not lookup vol %s\n",
+			ncp_dbg(1, "could not lookup vol %s\n",
 				info.volume_name);
 			continue;
 		}
@@ -738,14 +735,13 @@ ncp_do_readdir(struct file *file, struct
 	int more;
 	size_t bufsize;
 
-	DPRINTK("ncp_do_readdir: %pD2, fpos=%ld\n", file,
-		(unsigned long) ctx->pos);
+	ncp_dbg(1, "%pD2, fpos=%ld\n", file, (unsigned long)ctx->pos);
 	PPRINTK("ncp_do_readdir: init %pD, volnum=%d, dirent=%u\n",
 		file, NCP_FINFO(dir)->volNumber, NCP_FINFO(dir)->dirEntNum);
 
 	err = ncp_initialize_search(server, dir, &seq);
 	if (err) {
-		DPRINTK("ncp_do_readdir: init failed, err=%d\n", err);
+		ncp_dbg(1, "init failed, err=%d\n", err);
 		return;
 	}
 	/* We MUST NOT use server->buffer_size handshaked with server if we are
@@ -822,10 +818,10 @@ int ncp_conn_logged_in(struct super_bloc
 				NCP_FINFO(ino)->DosDirNum = DosDirNum;
 				result = 0;
 			} else {
-				DPRINTK("ncpfs: sb->s_root->d_inode == NULL!\n");
+				ncp_dbg(1, "sb->s_root->d_inode == NULL!\n");
 			}
 		} else {
-			DPRINTK("ncpfs: sb->s_root == NULL!\n");
+			ncp_dbg(1, "sb->s_root == NULL!\n");
 		}
 	} else
 		result = 0;
@@ -952,7 +948,7 @@ int ncp_create_new(struct inode *dir, st
 				error = -ENAMETOOLONG;
 			else if (result < 0)
 				error = result;
-			DPRINTK("ncp_create: %pd2 failed\n", dentry);
+			ncp_dbg(1, "%pd2 failed\n", dentry);
 			goto out;
 		}
 		opmode = O_WRONLY;
@@ -985,7 +981,7 @@ static int ncp_mkdir(struct inode *dir,
 	int error, len;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 
-	DPRINTK("ncp_mkdir: making %pd2\n", dentry);
+	ncp_dbg(1, "making %pd2\n", dentry);
 
 	ncp_age_dentry(server, dentry);
 	len = sizeof(__name);
@@ -1022,7 +1018,7 @@ static int ncp_rmdir(struct inode *dir,
 	int error, result, len;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 
-	DPRINTK("ncp_rmdir: removing %pd2\n", dentry);
+	ncp_dbg(1, "removing %pd2\n", dentry);
 
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
@@ -1067,7 +1063,7 @@ static int ncp_unlink(struct inode *dir,
 	int error;
 
 	server = NCP_SERVER(dir);
-	DPRINTK("ncp_unlink: unlinking %pd2\n", dentry);
+	ncp_dbg(1, "unlinking %pd2\n", dentry);
 	
 	/*
 	 * Check whether to close the file ...
@@ -1087,7 +1083,7 @@ static int ncp_unlink(struct inode *dir,
 #endif
 	switch (error) {
 		case 0x00:
-			DPRINTK("ncp: removed %pd2\n", dentry);
+			ncp_dbg(1, "removed %pd2\n", dentry);
 			break;
 		case 0x85:
 		case 0x8A:
@@ -1120,7 +1116,7 @@ static int ncp_rename(struct inode *old_
 	int old_len, new_len;
 	__u8 __old_name[NCP_MAXPATHLEN + 1], __new_name[NCP_MAXPATHLEN + 1];
 
-	DPRINTK("ncp_rename: %pd2 to %pd2\n", old_dentry, new_dentry);
+	ncp_dbg(1, "%pd2 to %pd2\n", old_dentry, new_dentry);
 
 	ncp_age_dentry(server, old_dentry);
 	ncp_age_dentry(server, new_dentry);
@@ -1150,8 +1146,8 @@ static int ncp_rename(struct inode *old_
 #endif
 	switch (error) {
 		case 0x00:
-               	        DPRINTK("ncp renamed %pd -> %pd.\n",
-                                old_dentry, new_dentry);
+			ncp_dbg(1, "renamed %pd -> %pd\n",
+				old_dentry, new_dentry);
 			break;
 		case 0x9E:
 			error = -ENAMETOOLONG;
@@ -1173,7 +1169,7 @@ static int ncp_mknod(struct inode * dir,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 	if (ncp_is_nfs_extras(NCP_SERVER(dir), NCP_FINFO(dir)->volNumber)) {
-		DPRINTK(KERN_DEBUG "ncp_mknod: mode = 0%ho\n", mode);
+		ncp_dbg(1, "mode = 0%ho\n", mode);
 		return ncp_create_new(dir, dentry, mode, rdev, 0);
 	}
 	return -EPERM; /* Strange, but true */
diff -puN fs/ncpfs/file.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/file.c
@@ -40,7 +40,7 @@ int ncp_make_open(struct inode *inode, i
 		goto out;
 	}
 
-	DPRINTK("ncp_make_open: opened=%d, volume # %u, dir entry # %u\n",
+	ncp_dbg(1, "opened=%d, volume # %u, dir entry # %u\n",
 		atomic_read(&NCP_FINFO(inode)->opened), 
 		NCP_FINFO(inode)->volNumber, 
 		NCP_FINFO(inode)->dirEntNum);
@@ -109,7 +109,7 @@ ncp_file_read(struct file *file, char __
 	void* freepage;
 	size_t freelen;
 
-	DPRINTK("ncp_file_read: enter %pd2\n", dentry);
+	ncp_dbg(1, "enter %pd2\n", dentry);
 
 	pos = *ppos;
 
@@ -126,7 +126,7 @@ ncp_file_read(struct file *file, char __
 
 	error = ncp_make_open(inode, O_RDONLY);
 	if (error) {
-		DPRINTK(KERN_ERR "ncp_file_read: open failed, error=%d\n", error);
+		ncp_dbg(1, "open failed, error=%d\n", error);
 		return error;
 	}
 
@@ -167,7 +167,7 @@ ncp_file_read(struct file *file, char __
 
 	file_accessed(file);
 
-	DPRINTK("ncp_file_read: exit %pd2\n", dentry);
+	ncp_dbg(1, "exit %pd2\n", dentry);
 outrel:
 	ncp_inode_close(inode);		
 	return already_read ? already_read : error;
@@ -184,7 +184,7 @@ ncp_file_write(struct file *file, const
 	int errno;
 	void* bouncebuffer;
 
-	DPRINTK("ncp_file_write: enter %pd2\n", dentry);
+	ncp_dbg(1, "enter %pd2\n", dentry);
 	if ((ssize_t) count < 0)
 		return -EINVAL;
 	pos = *ppos;
@@ -213,7 +213,7 @@ ncp_file_write(struct file *file, const
 		return 0;
 	errno = ncp_make_open(inode, O_WRONLY);
 	if (errno) {
-		DPRINTK(KERN_ERR "ncp_file_write: open failed, error=%d\n", errno);
+		ncp_dbg(1, "open failed, error=%d\n", errno);
 		return errno;
 	}
 	bufsize = NCP_SERVER(inode)->buffer_size;
@@ -263,7 +263,7 @@ ncp_file_write(struct file *file, const
 			i_size_write(inode, pos);
 		mutex_unlock(&inode->i_mutex);
 	}
-	DPRINTK("ncp_file_write: exit %pd2\n", dentry);
+	ncp_dbg(1, "exit %pd2\n", dentry);
 outrel:
 	ncp_inode_close(inode);		
 	return already_written ? already_written : errno;
@@ -271,7 +271,7 @@ outrel:
 
 static int ncp_release(struct inode *inode, struct file *file) {
 	if (ncp_make_closed(inode)) {
-		DPRINTK("ncp_release: failed to close\n");
+		ncp_dbg(1, "failed to close\n");
 	}
 	return 0;
 }
diff -puN fs/ncpfs/inode.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/inode.c
@@ -134,7 +134,7 @@ void ncp_update_inode(struct inode *inod
 	NCP_FINFO(inode)->access = nwinfo->access;
 	memcpy(NCP_FINFO(inode)->file_handle, nwinfo->file_handle,
 			sizeof(nwinfo->file_handle));
-	DPRINTK("ncp_update_inode: updated %s, volnum=%d, dirent=%u\n",
+	ncp_dbg(1, "updated %s, volnum=%d, dirent=%u\n",
 		nwinfo->i.entryName, NCP_FINFO(inode)->volNumber,
 		NCP_FINFO(inode)->dirEntNum);
 }
@@ -142,8 +142,7 @@ void ncp_update_inode(struct inode *inod
 static void ncp_update_dates(struct inode *inode, struct nw_info_struct *nwi)
 {
 	/* NFS namespace mode overrides others if it's set. */
-	DPRINTK(KERN_DEBUG "ncp_update_dates_and_mode: (%s) nfs.mode=0%o\n",
-		nwi->entryName, nwi->nfs.mode);
+	ncp_dbg(1, "(%s) nfs.mode=0%o\n", nwi->entryName, nwi->nfs.mode);
 	if (nwi->nfs.mode) {
 		/* XXX Security? */
 		inode->i_mode = nwi->nfs.mode;
@@ -231,7 +230,7 @@ static void ncp_set_attr(struct inode *i
 	
 	ncp_update_attrs(inode, nwinfo);
 
-	DDPRINTK("ncp_read_inode: inode->i_mode = %u\n", inode->i_mode);
+	ncp_dbg(2, "inode->i_mode = %u\n", inode->i_mode);
 
 	set_nlink(inode, 1);
 	inode->i_uid = server->m.uid;
@@ -302,7 +301,7 @@ ncp_evict_inode(struct inode *inode)
 	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode)) {
-		DDPRINTK("ncp_evict_inode: put directory %ld\n", inode->i_ino);
+		ncp_dbg(2, "put directory %ld\n", inode->i_ino);
 	}
 
 	if (ncp_make_closed(inode) != 0) {
@@ -683,7 +682,7 @@ static int ncp_fill_super(struct super_b
 	ncp_unlock_server(server);
 	if (error < 0)
 		goto out_rxbuf;
-	DPRINTK("ncp_fill_super: NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
+	ncp_dbg(1, "NCP_SBP(sb) = %x\n", (int) NCP_SBP(sb));
 
 	error = -EMSGSIZE;	/* -EREMOTESIDEINCOMPATIBLE */
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
@@ -711,7 +710,7 @@ static int ncp_fill_super(struct super_b
 	if (ncp_negotiate_buffersize(server, default_bufsize,
   				     &(server->buffer_size)) != 0)
 		goto out_disconnect;
-	DPRINTK("ncpfs: bufsize = %d\n", server->buffer_size);
+	ncp_dbg(1, "bufsize = %d\n", server->buffer_size);
 
 	memset(&finfo, 0, sizeof(finfo));
 	finfo.i.attributes	= aDIR;
@@ -740,7 +739,7 @@ static int ncp_fill_super(struct super_b
         root_inode = ncp_iget(sb, &finfo);
         if (!root_inode)
 		goto out_disconnect;
-	DPRINTK("ncp_fill_super: root vol=%d\n", NCP_FINFO(root_inode)->volNumber);
+	ncp_dbg(1, "root vol=%d\n", NCP_FINFO(root_inode)->volNumber);
 	sb->s_root = d_make_root(root_inode);
         if (!sb->s_root)
 		goto out_disconnect;
@@ -986,8 +985,7 @@ int ncp_notify_change(struct dentry *den
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		int written;
 
-		DPRINTK("ncpfs: trying to change size to %ld\n",
-			attr->ia_size);
+		ncp_dbg(1, "trying to change size to %ld\n", attr->ia_size);
 
 		if ((result = ncp_make_open(inode, O_WRONLY)) < 0) {
 			result = -EACCES;
@@ -1073,7 +1071,7 @@ MODULE_ALIAS_FS("ncpfs");
 static int __init init_ncp_fs(void)
 {
 	int err;
-	DPRINTK("ncpfs: init_ncp_fs called\n");
+	ncp_dbg(1, "called\n");
 
 	err = init_inodecache();
 	if (err)
@@ -1090,7 +1088,7 @@ out1:
 
 static void __exit exit_ncp_fs(void)
 {
-	DPRINTK("ncpfs: exit_ncp_fs called\n");
+	ncp_dbg(1, "called\n");
 	unregister_filesystem(&ncp_fs_type);
 	destroy_inodecache();
 }
diff -puN fs/ncpfs/ioctl.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/ioctl.c
@@ -41,7 +41,7 @@ ncp_get_fs_info(struct ncp_server * serv
 		return -EFAULT;
 
 	if (info.version != NCP_GET_FS_INFO_VERSION) {
-		DPRINTK("info.version invalid: %d\n", info.version);
+		ncp_dbg(1, "info.version invalid: %d\n", info.version);
 		return -EINVAL;
 	}
 	/* TODO: info.addr = server->m.serv_addr; */
@@ -66,7 +66,7 @@ ncp_get_fs_info_v2(struct ncp_server * s
 		return -EFAULT;
 
 	if (info2.version != NCP_GET_FS_INFO_VERSION_V2) {
-		DPRINTK("info.version invalid: %d\n", info2.version);
+		ncp_dbg(1, "info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
 	info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
@@ -132,7 +132,7 @@ ncp_get_compat_fs_info_v2(struct ncp_ser
 		return -EFAULT;
 
 	if (info2.version != NCP_GET_FS_INFO_VERSION_V2) {
-		DPRINTK("info.version invalid: %d\n", info2.version);
+		ncp_dbg(1, "info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
 	info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
@@ -308,8 +308,7 @@ static long __ncp_ioctl(struct inode *in
 		else
 			result = server->reply_size;
 		ncp_unlock_server(server);
-		DPRINTK("ncp_ioctl: copy %d bytes\n",
-			result);
+		ncp_dbg(1, "copy %d bytes\n", result);
 		if (result >= 0)
 			if (copy_to_user(request.data, bouncebuffer, result))
 				result = -EFAULT;
@@ -385,9 +384,9 @@ static long __ncp_ioctl(struct inode *in
 						sr.namespace = server->name_space[sr.volNumber];
 						result = 0;
 					} else
-						DPRINTK("ncpfs: s_root->d_inode==NULL\n");
+						ncp_dbg(1, "s_root->d_inode==NULL\n");
 				} else
-					DPRINTK("ncpfs: s_root==NULL\n");
+					ncp_dbg(1, "s_root==NULL\n");
 			} else {
 				sr.volNumber = -1;
 				sr.namespace = 0;
@@ -440,11 +439,11 @@ static long __ncp_ioctl(struct inode *in
 							NCP_FINFO(s_inode)->DosDirNum = dosde;
 							server->root_setuped = 1;
 						} else {
-							DPRINTK("ncpfs: s_root->d_inode==NULL\n");
+							ncp_dbg(1, "s_root->d_inode==NULL\n");
 							result = -EIO;
 						}
 					} else {
-						DPRINTK("ncpfs: s_root==NULL\n");
+						ncp_dbg(1, "s_root==NULL\n");
 						result = -EIO;
 					}
 				}
diff -puN fs/ncpfs/mmap.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/mmap.c
@@ -107,7 +107,7 @@ int ncp_mmap(struct file *file, struct v
 {
 	struct inode *inode = file_inode(file);
 	
-	DPRINTK("ncp_mmap: called\n");
+	ncp_dbg(1, "called\n");
 
 	if (!ncp_conn_valid(NCP_SERVER(inode)))
 		return -EIO;
diff -puN fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/ncp_fs.h
@@ -15,17 +15,17 @@
 #ifndef DEBUG_NCP
 #define DEBUG_NCP 0
 #endif
-#if DEBUG_NCP > 0
-#define DPRINTK(format, args...) PRINTK(format , ## args)
-#else
-#define DPRINTK(format, args...)
-#endif
-#if DEBUG_NCP > 1
-#define DDPRINTK(format, args...) PRINTK(format , ## args)
-#else
-#define DDPRINTK(format, args...)
+
+#if DEBUG_NCP > 0 && !defined(DEBUG)
+#define DEBUG
 #endif
 
+#define ncp_dbg(level, fmt, ...)				\
+do {								\
+	if (level >= DEBUG_NCP)					\
+		pr_debug(fmt, ##__VA_ARGS__);			\
+} while (0)
+
 #define NCP_MAX_RPC_TIMEOUT (6*HZ)
 
 
diff -puN fs/ncpfs/ncplib_kernel.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/ncplib_kernel.c
--- a/fs/ncpfs/ncplib_kernel.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/ncplib_kernel.c
@@ -16,7 +16,7 @@
 static inline void assert_server_locked(struct ncp_server *server)
 {
 	if (server->lock == 0) {
-		DPRINTK("ncpfs: server not locked!\n");
+		ncp_dbg(1, "server not locked!\n");
 	}
 }
 
@@ -75,7 +75,7 @@ static void ncp_add_pstring(struct ncp_s
 	int len = strlen(s);
 	assert_server_locked(server);
 	if (len > 255) {
-		DPRINTK("ncpfs: string too long: %s\n", s);
+		ncp_dbg(1, "string too long: %s\n", s);
 		len = 255;
 	}
 	ncp_add_byte(server, len);
@@ -225,7 +225,7 @@ int ncp_get_volume_info_with_number(stru
 	result = -EIO;
 	len = ncp_reply_byte(server, 29);
 	if (len > NCP_VOLNAME_LEN) {
-		DPRINTK("ncpfs: volume name too long: %d\n", len);
+		ncp_dbg(1, "volume name too long: %d\n", len);
 		goto out;
 	}
 	memcpy(&(target->volume_name), ncp_reply_data(server, 30), len);
@@ -259,7 +259,7 @@ int ncp_get_directory_info(struct ncp_se
 	result = -EIO;
 	len = ncp_reply_byte(server, 21);
 	if (len > NCP_VOLNAME_LEN) {
-		DPRINTK("ncpfs: volume name too long: %d\n", len);
+		ncp_dbg(1, "volume name too long: %d\n", len);
 		goto out;
 	}
 	memcpy(&(target->volume_name), ncp_reply_data(server, 22), len);
@@ -394,8 +394,7 @@ int ncp_obtain_nfs_info(struct ncp_serve
 
 		if ((result = ncp_request(server, 87)) == 0) {
 			ncp_extract_nfs_info(ncp_reply_data(server, 0), &target->nfs);
-			DPRINTK(KERN_DEBUG
-				"ncp_obtain_nfs_info: (%s) mode=0%o, rdev=0x%x\n",
+			ncp_dbg(1, "(%s) mode=0%o, rdev=0x%x\n",
 				target->entryName, target->nfs.mode,
 				target->nfs.rdev);
 		} else {
@@ -498,7 +497,7 @@ ncp_get_known_namespace(struct ncp_serve
 	namespace = ncp_reply_data(server, 2);
 
 	while (no_namespaces > 0) {
-		DPRINTK("get_namespaces: found %d on %d\n", *namespace, volume);
+		ncp_dbg(1, "found %d on %d\n", *namespace, volume);
 
 #ifdef CONFIG_NCPFS_NFS_NS
 		if ((*namespace == NW_NS_NFS) && !(server->m.flags&NCP_MOUNT_NO_NFS)) 
@@ -531,8 +530,7 @@ ncp_update_known_namespace(struct ncp_se
 	if (ret_ns)
 		*ret_ns = ns;
 
-	DPRINTK("lookup_vol: namespace[%d] = %d\n",
-		volume, server->name_space[volume]);
+	ncp_dbg(1, "namespace[%d] = %d\n", volume, server->name_space[volume]);
 
 	if (server->name_space[volume] == ns)
 		return 0;
@@ -596,7 +594,7 @@ ncp_get_volume_root(struct ncp_server *s
 {
 	int result;
 
-	DPRINTK("ncp_get_volume_root: looking up vol %s\n", volname);
+	ncp_dbg(1, "looking up vol %s\n", volname);
 
 	ncp_init_request(server);
 	ncp_add_byte(server, 22);	/* Subfunction: Generate dir handle */
diff -puN fs/ncpfs/sock.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/sock.c
--- a/fs/ncpfs/sock.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/sock.c
@@ -406,15 +406,15 @@ void ncpdgram_rcv_proc(struct work_struc
 				}
 				result = _recv(sock, buf, sizeof(buf), MSG_DONTWAIT);
 				if (result < 0) {
-					DPRINTK("recv failed with %d\n", result);
+					ncp_dbg(1, "recv failed with %d\n", result);
 					continue;
 				}
 				if (result < 10) {
-					DPRINTK("too short (%u) watchdog packet\n", result);
+					ncp_dbg(1, "too short (%u) watchdog packet\n", result);
 					continue;
 				}
 				if (buf[9] != '?') {
-					DPRINTK("bad signature (%02X) in watchdog packet\n", buf[9]);
+					ncp_dbg(1, "bad signature (%02X) in watchdog packet\n", buf[9]);
 					continue;
 				}
 				buf[9] = 'Y';
@@ -555,7 +555,7 @@ static int __ncptcp_rcv_proc(struct ncp_
 				if (result < 0) {
 					pr_err("tcp: error in recvmsg: %d\n", result);
 				} else {
-					DPRINTK(KERN_ERR "ncpfs: tcp: EOF\n");
+					ncp_dbg(1, "tcp: EOF\n");
 				}
 				return -EIO;
 			}
@@ -605,7 +605,7 @@ cont:;
 						server->rcv.len = datalen - 10;
 						break;
 					}					
-					DPRINTK("ncpfs: tcp: Unexpected NCP type %02X\n", type);
+					ncp_dbg(1, "tcp: Unexpected NCP type %02X\n", type);
 skipdata2:;
 					server->rcv.state = 2;
 skipdata:;
@@ -615,7 +615,7 @@ skipdata:;
 				}
 				req = server->rcv.creq;
 				if (!req) {
-					DPRINTK(KERN_ERR "ncpfs: Reply without appropriate request\n");
+					ncp_dbg(1, "Reply without appropriate request\n");
 					goto skipdata2;
 				}
 				if (datalen > req->datalen + 8) {
@@ -782,7 +782,7 @@ static int ncp_do_request(struct ncp_ser
 		spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	}
 
-	DDPRINTK("do_ncp_rpc_call returned %d\n", result);
+	ncp_dbg(2, "do_ncp_rpc_call returned %d\n", result);
 
 	return result;
 }
@@ -812,7 +812,7 @@ int ncp_request2(struct ncp_server *serv
 
 	result = ncp_do_request(server, server->current_size, reply, size);
 	if (result < 0) {
-		DPRINTK("ncp_request_error: %d\n", result);
+		ncp_dbg(1, "ncp_request_error: %d\n", result);
 		goto out;
 	}
 	server->completion = reply->completion_code;
diff -puN fs/ncpfs/symlink.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg fs/ncpfs/symlink.c
--- a/fs/ncpfs/symlink.c~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg
+++ a/fs/ncpfs/symlink.c
@@ -112,7 +112,7 @@ int ncp_symlink(struct inode *dir, struc
 	__le32 attr;
 	unsigned int hdr;
 
-	DPRINTK("ncp_symlink(dir=%p,dentry=%p,symname=%s)\n",dir,dentry,symname);
+	ncp_dbg(1, "dir=%p, dentry=%p, symname=%s\n", dir, dentry, symname);
 
 	if (ncp_is_nfs_extras(NCP_SERVER(dir), NCP_FINFO(dir)->volNumber))
 		kludge = 0;
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

