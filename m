From: akpm@osdl.org
Subject: - struct-path-convert-sparc64.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:10 -0800
Message-ID: <200612082005.kB8K5Au8002273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426317AbWLHUFP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sparc64
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sparc64
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sparc64/kernel/binfmt_aout32.c |    4 ++--
 arch/sparc64/kernel/sys_sunos32.c   |    4 ++--
 arch/sparc64/solaris/fs.c           |    4 ++--
 arch/sparc64/solaris/ioctl.c        |    6 +++---
 arch/sparc64/solaris/misc.c         |    2 +-
 arch/sparc64/solaris/socksys.c      |   14 +++++++-------
 arch/sparc64/solaris/timod.c        |   10 +++++-----
 7 files changed, 22 insertions(+), 22 deletions(-)

diff -puN arch/sparc64/kernel/binfmt_aout32.c~struct-path-convert-sparc64 arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~struct-path-convert-sparc64
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -209,7 +209,7 @@ static int load_aout32_binary(struct lin
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
-	    bprm->file->f_dentry->d_inode->i_size < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    bprm->file->f_path.dentry->d_inode->i_size < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
 		return -ENOEXEC;
 	}
 
@@ -349,7 +349,7 @@ static int load_aout32_library(struct fi
 	int retval;
 	struct exec ex;
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	retval = -ENOEXEC;
 	error = kernel_read(file, 0, (char *) &ex, sizeof(ex));
diff -puN arch/sparc64/kernel/sys_sunos32.c~struct-path-convert-sparc64 arch/sparc64/kernel/sys_sunos32.c
--- a/arch/sparc64/kernel/sys_sunos32.c~struct-path-convert-sparc64
+++ a/arch/sparc64/kernel/sys_sunos32.c
@@ -83,7 +83,7 @@ asmlinkage u32 sunos_mmap(u32 addr, u32 
  		file = fget(fd);
 		if (!file)
 			goto out;
-		inode = file->f_dentry->d_inode;
+		inode = file->f_path.dentry->d_inode;
 		if (imajor(inode) == MEM_MAJOR && iminor(inode) == 5) {
 			flags |= MAP_ANONYMOUS;
 			fput(file);
@@ -615,7 +615,7 @@ sunos_nfs_get_server_fd (int fd, struct 
 	if (!file)
 		return 0;
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	socket = SOCKET_I(inode);
 	local.sin_family = AF_INET;
diff -puN arch/sparc64/solaris/fs.c~struct-path-convert-sparc64 arch/sparc64/solaris/fs.c
--- a/arch/sparc64/solaris/fs.c~struct-path-convert-sparc64
+++ a/arch/sparc64/solaris/fs.c
@@ -449,7 +449,7 @@ asmlinkage int solaris_fstatvfs(unsigned
 	error = -EBADF;
 	file = fget(fd);
 	if (file) {
-		error = report_statvfs(file->f_vfsmnt, file->f_dentry->d_inode, buf);
+		error = report_statvfs(file->f_path.mnt, file->f_path.dentry->d_inode, buf);
 		fput(file);
 	}
 
@@ -481,7 +481,7 @@ asmlinkage int solaris_fstatvfs64(unsign
 	file = fget(fd);
 	if (file) {
 		lock_kernel();
-		error = report_statvfs64(file->f_vfsmnt, file->f_dentry->d_inode, buf);
+		error = report_statvfs64(file->f_path.mnt, file->f_path.dentry->d_inode, buf);
 		unlock_kernel();
 		fput(file);
 	}
diff -puN arch/sparc64/solaris/ioctl.c~struct-path-convert-sparc64 arch/sparc64/solaris/ioctl.c
--- a/arch/sparc64/solaris/ioctl.c~struct-path-convert-sparc64
+++ a/arch/sparc64/solaris/ioctl.c
@@ -299,8 +299,8 @@ static inline int solaris_sockmod(unsign
 	rcu_read_lock();
 	fdt = files_fdtable(current->files);
 	if (! fdt->fd[fd] ||
-	    ! fdt->fd[fd]->f_dentry ||
-	    ! (ino = fdt->fd[fd]->f_dentry->d_inode) ||
+	    ! fdt->fd[fd]->f_path.dentry ||
+	    ! (ino = fdt->fd[fd]->f_path.dentry->d_inode) ||
 	    ! S_ISSOCK(ino->i_mode)) {
 		rcu_read_unlock();
 		return TBADF;
@@ -480,7 +480,7 @@ static inline int solaris_S(struct file 
         struct sol_socket_struct *sock;
         struct module_info *mi;
 
-        ino = filp->f_dentry->d_inode;
+        ino = filp->f_path.dentry->d_inode;
         if (!S_ISSOCK(ino->i_mode))
 		return -EBADF;
         sock = filp->private_data;
diff -puN arch/sparc64/solaris/misc.c~struct-path-convert-sparc64 arch/sparc64/solaris/misc.c
--- a/arch/sparc64/solaris/misc.c~struct-path-convert-sparc64
+++ a/arch/sparc64/solaris/misc.c
@@ -77,7 +77,7 @@ static u32 do_solaris_mmap(u32 addr, u32
 		if (!file)
 			goto out;
 		else {
-			struct inode * inode = file->f_dentry->d_inode;
+			struct inode * inode = file->f_path.dentry->d_inode;
 			if(imajor(inode) == MEM_MAJOR &&
 			   iminor(inode) == 5) {
 				flags |= MAP_ANONYMOUS;
diff -puN arch/sparc64/solaris/socksys.c~struct-path-convert-sparc64 arch/sparc64/solaris/socksys.c
--- a/arch/sparc64/solaris/socksys.c~struct-path-convert-sparc64
+++ a/arch/sparc64/solaris/socksys.c
@@ -96,13 +96,13 @@ static int socksys_open(struct inode * i
 	 * No shit.  WTF is it supposed to do, anyway?
 	 *
 	 * Try instead:
-	 * d_delete(filp->f_dentry), then d_instantiate with sock inode
+	 * d_delete(filp->f_path.dentry), then d_instantiate with sock inode
 	 */
-	dentry = filp->f_dentry;
-	filp->f_dentry = dget(fcheck(fd)->f_dentry);
-	filp->f_dentry->d_inode->i_rdev = inode->i_rdev;
-	filp->f_dentry->d_inode->i_flock = inode->i_flock;
-	SOCKET_I(filp->f_dentry->d_inode)->file = filp;
+	dentry = filp->f_path.dentry;
+	filp->f_path.dentry = dget(fcheck(fd)->f_path.dentry);
+	filp->f_path.dentry->d_inode->i_rdev = inode->i_rdev;
+	filp->f_path.dentry->d_inode->i_flock = inode->i_flock;
+	SOCKET_I(filp->f_path.dentry->d_inode)->file = filp;
 	filp->f_op = &socksys_file_ops;
         sock = (struct sol_socket_struct*) 
         	mykmalloc(sizeof(struct sol_socket_struct), GFP_KERNEL);
@@ -148,7 +148,7 @@ static unsigned int socksys_poll(struct 
 	struct inode *ino;
 	unsigned int mask = 0;
 
-	ino=filp->f_dentry->d_inode;
+	ino=filp->f_path.dentry->d_inode;
 	if (ino && S_ISSOCK(ino->i_mode)) {
 		struct sol_socket_struct *sock;
 		sock = (struct sol_socket_struct*)filp->private_data;
diff -puN arch/sparc64/solaris/timod.c~struct-path-convert-sparc64 arch/sparc64/solaris/timod.c
--- a/arch/sparc64/solaris/timod.c~struct-path-convert-sparc64
+++ a/arch/sparc64/solaris/timod.c
@@ -147,7 +147,7 @@ static void timod_wake_socket(unsigned i
 
 	SOLD("wakeing socket");
 	fdt = files_fdtable(current->files);
-	sock = SOCKET_I(fdt->fd[fd]->f_dentry->d_inode);
+	sock = SOCKET_I(fdt->fd[fd]->f_path.dentry->d_inode);
 	wake_up_interruptible(&sock->wait);
 	read_lock(&sock->sk->sk_callback_lock);
 	if (sock->fasync_list && !test_bit(SOCK_ASYNC_WAITDATA, &sock->flags))
@@ -361,7 +361,7 @@ int timod_putmsg(unsigned int fd, char _
 
 	fdt = files_fdtable(current->files);
 	filp = fdt->fd[fd];
-	ino = filp->f_dentry->d_inode;
+	ino = filp->f_path.dentry->d_inode;
 	sock = (struct sol_socket_struct *)filp->private_data;
 	SOLD("entry");
 	if (get_user(ret, (int __user *)A(ctl_buf)))
@@ -644,7 +644,7 @@ int timod_getmsg(unsigned int fd, char _
 	SOLDD(("%u %p %d %p %p %d %p %d\n", fd, ctl_buf, ctl_maxlen, ctl_len, data_buf, data_maxlen, data_len, *flags_p));
 	fdt = files_fdtable(current->files);
 	filp = fdt->fd[fd];
-	ino = filp->f_dentry->d_inode;
+	ino = filp->f_path.dentry->d_inode;
 	sock = (struct sol_socket_struct *)filp->private_data;
 	SOLDD(("%p %p\n", sock->pfirst, sock->pfirst ? sock->pfirst->next : NULL));
 	if ( ctl_maxlen > 0 && !sock->pfirst && SOCKET_I(ino)->type == SOCK_STREAM
@@ -865,7 +865,7 @@ asmlinkage int solaris_getmsg(unsigned i
 	filp = fdt->fd[fd];
 	if(!filp) goto out;
 
-	ino = filp->f_dentry->d_inode;
+	ino = filp->f_path.dentry->d_inode;
 	if (!ino || !S_ISSOCK(ino->i_mode))
 		goto out;
 
@@ -933,7 +933,7 @@ asmlinkage int solaris_putmsg(unsigned i
 	filp = fdt->fd[fd];
 	if(!filp) goto out;
 
-	ino = filp->f_dentry->d_inode;
+	ino = filp->f_path.dentry->d_inode;
 	if (!ino) goto out;
 
 	if (!S_ISSOCK(ino->i_mode) &&
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

