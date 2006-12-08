From: akpm@osdl.org
Subject: - struct-path-convert-lockd.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:00 -0800
Message-ID: <200612082004.kB8K40Dd002134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426268AbWLHUEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert lockd
has been removed from the -mm tree.  Its filename was
     struct-path-convert-lockd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert lockd
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/lockd/clntlock.c         |    2 +-
 fs/lockd/clntproc.c         |    2 +-
 fs/lockd/svclock.c          |   16 ++++++++--------
 fs/lockd/svcsubs.c          |    2 +-
 include/linux/lockd/lockd.h |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/lockd/clntlock.c~struct-path-convert-lockd fs/lockd/clntlock.c
--- a/fs/lockd/clntlock.c~struct-path-convert-lockd
+++ a/fs/lockd/clntlock.c
@@ -126,7 +126,7 @@ __be32 nlmclnt_grant(const struct sockad
 			continue;
 		if (!nlm_cmp_addr(&block->b_host->h_addr, addr))
 			continue;
-		if (nfs_compare_fh(NFS_FH(fl_blocked->fl_file->f_dentry->d_inode) ,fh) != 0)
+		if (nfs_compare_fh(NFS_FH(fl_blocked->fl_file->f_path.dentry->d_inode) ,fh) != 0)
 			continue;
 		/* Alright, we found a lock. Set the return status
 		 * and wake up the caller
diff -puN fs/lockd/clntproc.c~struct-path-convert-lockd fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~struct-path-convert-lockd
+++ a/fs/lockd/clntproc.c
@@ -129,7 +129,7 @@ static void nlmclnt_setlockargs(struct n
 
 	nlmclnt_next_cookie(&argp->cookie);
 	argp->state   = nsm_local_state;
-	memcpy(&lock->fh, NFS_FH(fl->fl_file->f_dentry->d_inode), sizeof(struct nfs_fh));
+	memcpy(&lock->fh, NFS_FH(fl->fl_file->f_path.dentry->d_inode), sizeof(struct nfs_fh));
 	lock->caller  = utsname()->nodename;
 	lock->oh.data = req->a_owner;
 	lock->oh.len  = snprintf(req->a_owner, sizeof(req->a_owner), "%u@%s",
diff -puN fs/lockd/svclock.c~struct-path-convert-lockd fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~struct-path-convert-lockd
+++ a/fs/lockd/svclock.c
@@ -343,8 +343,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 	__be32			ret;
 
 	dprintk("lockd: nlmsvc_lock(%s/%ld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
-				file->f_file->f_dentry->d_inode->i_sb->s_id,
-				file->f_file->f_dentry->d_inode->i_ino,
+				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
+				file->f_file->f_path.dentry->d_inode->i_ino,
 				lock->fl.fl_type, lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end,
@@ -420,8 +420,8 @@ nlmsvc_testlock(struct nlm_file *file, s
 				       struct nlm_lock *conflock)
 {
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
-				file->f_file->f_dentry->d_inode->i_sb->s_id,
-				file->f_file->f_dentry->d_inode->i_ino,
+				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
+				file->f_file->f_path.dentry->d_inode->i_ino,
 				lock->fl.fl_type,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
@@ -454,8 +454,8 @@ nlmsvc_unlock(struct nlm_file *file, str
 	int	error;
 
 	dprintk("lockd: nlmsvc_unlock(%s/%ld, pi=%d, %Ld-%Ld)\n",
-				file->f_file->f_dentry->d_inode->i_sb->s_id,
-				file->f_file->f_dentry->d_inode->i_ino,
+				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
+				file->f_file->f_path.dentry->d_inode->i_ino,
 				lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
@@ -483,8 +483,8 @@ nlmsvc_cancel_blocked(struct nlm_file *f
 	int status = 0;
 
 	dprintk("lockd: nlmsvc_cancel(%s/%ld, pi=%d, %Ld-%Ld)\n",
-				file->f_file->f_dentry->d_inode->i_sb->s_id,
-				file->f_file->f_dentry->d_inode->i_ino,
+				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
+				file->f_file->f_path.dentry->d_inode->i_ino,
 				lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
diff -puN fs/lockd/svcsubs.c~struct-path-convert-lockd fs/lockd/svcsubs.c
--- a/fs/lockd/svcsubs.c~struct-path-convert-lockd
+++ a/fs/lockd/svcsubs.c
@@ -43,7 +43,7 @@ static inline void nlm_debug_print_fh(ch
 
 static inline void nlm_debug_print_file(char *msg, struct nlm_file *file)
 {
-	struct inode *inode = file->f_file->f_dentry->d_inode;
+	struct inode *inode = file->f_file->f_path.dentry->d_inode;
 
 	dprintk("lockd: %s %s/%ld\n",
 		msg, inode->i_sb->s_id, inode->i_ino);
diff -puN include/linux/lockd/lockd.h~struct-path-convert-lockd include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~struct-path-convert-lockd
+++ a/include/linux/lockd/lockd.h
@@ -206,7 +206,7 @@ void		  nlmsvc_invalidate_all(void);
 static __inline__ struct inode *
 nlmsvc_file_inode(struct nlm_file *file)
 {
-	return file->f_file->f_dentry->d_inode;
+	return file->f_file->f_path.dentry->d_inode;
 }
 
 /*
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-lockd.patch
struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
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

