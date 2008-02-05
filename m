From: akpm@linux-foundation.org
Subject: - uml-style-fixes-in-filec.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:21 -0800
Message-ID: <200802052237.m15Mb2D1012821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762594AbYBEWmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: style fixes in file.c
has been removed from the -mm tree.  Its filename was
     uml-style-fixes-in-filec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style fixes in file.c
From: Jeff Dike <jdike@addtoit.com>

arch/um/os-Linux/file.c needed some style work -
	updated the copyright
	cleaned up the includes
	CodingStyle fixes
	added some missing CATCH_EINTRs
	os_set_owner was unused, so it is gone
	all printks now have severities
	fcntl(F_GETFL) was being called without checking the return
	removed an obsolete comment

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h    |    1 
 arch/um/os-Linux/file.c |  232 +++++++++++++++++++-------------------
 2 files changed, 118 insertions(+), 115 deletions(-)

diff -puN arch/um/include/os.h~uml-style-fixes-in-filec arch/um/include/os.h
--- a/arch/um/include/os.h~uml-style-fixes-in-filec
+++ a/arch/um/include/os.h
@@ -131,7 +131,6 @@ extern int os_set_exec_close(int fd);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
-extern int os_set_owner(int fd, int pid);
 extern int os_mode_fd(int fd, int mode);
 
 extern int os_seek_file(int fd, unsigned long long offset);
diff -puN arch/um/os-Linux/file.c~uml-style-fixes-in-filec arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-style-fixes-in-filec
+++ a/arch/um/os-Linux/file.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -8,13 +8,12 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <signal.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/socket.h>
-#include <sys/un.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
-#include <sys/uio.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/un.h>
+#include "kern_constants.h"
 #include "os.h"
 #include "user.h"
 
@@ -42,10 +41,10 @@ int os_stat_fd(const int fd, struct uml_
 	int err;
 
 	CATCH_EINTR(err = fstat64(fd, &sbuf));
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
-	if(ubuf != NULL)
+	if (ubuf != NULL)
 		copy_stat(ubuf, &sbuf);
 	return err;
 }
@@ -55,27 +54,26 @@ int os_stat_file(const char *file_name, 
 	struct stat64 sbuf;
 	int err;
 
-	do {
-		err = stat64(file_name, &sbuf);
-	} while((err < 0) && (errno == EINTR)) ;
-
-	if(err < 0)
+	CATCH_EINTR(err = stat64(file_name, &sbuf));
+	if (err < 0)
 		return -errno;
 
-	if(ubuf != NULL)
+	if (ubuf != NULL)
 		copy_stat(ubuf, &sbuf);
 	return err;
 }
 
-int os_access(const char* file, int mode)
+int os_access(const char *file, int mode)
 {
 	int amode, err;
 
-	amode=(mode&OS_ACC_R_OK ? R_OK : 0) | (mode&OS_ACC_W_OK ? W_OK : 0) |
-	      (mode&OS_ACC_X_OK ? X_OK : 0) | (mode&OS_ACC_F_OK ? F_OK : 0) ;
+	amode = (mode & OS_ACC_R_OK ? R_OK : 0) |
+		(mode & OS_ACC_W_OK ? W_OK : 0) |
+		(mode & OS_ACC_X_OK ? X_OK : 0) |
+		(mode & OS_ACC_F_OK ? F_OK : 0);
 
 	err = access(file, amode);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
 	return 0;
@@ -87,7 +85,7 @@ int os_ioctl_generic(int fd, unsigned in
 	int err;
 
 	err = ioctl(fd, cmd, arg);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
 	return err;
@@ -96,7 +94,7 @@ int os_ioctl_generic(int fd, unsigned in
 /* FIXME: ensure namebuf in os_get_if_name is big enough */
 int os_get_ifname(int fd, char* namebuf)
 {
-	if(ioctl(fd, SIOCGIFNAME, namebuf) < 0)
+	if (ioctl(fd, SIOCGIFNAME, namebuf) < 0)
 		return -errno;
 
 	return 0;
@@ -107,37 +105,22 @@ int os_set_slip(int fd)
 	int disc, sencap;
 
 	disc = N_SLIP;
-	if(ioctl(fd, TIOCSETD, &disc) < 0)
+	if (ioctl(fd, TIOCSETD, &disc) < 0)
 		return -errno;
 
 	sencap = 0;
-	if(ioctl(fd, SIOCSIFENCAP, &sencap) < 0)
+	if (ioctl(fd, SIOCSIFENCAP, &sencap) < 0)
 		return -errno;
 
 	return 0;
 }
 
-int os_set_owner(int fd, int pid)
-{
-	if(fcntl(fd, F_SETOWN, pid) < 0){
-		int save_errno = errno;
-
-		if(fcntl(fd, F_GETOWN, 0) != pid)
-			return -save_errno;
-	}
-
-	return 0;
-}
-
 int os_mode_fd(int fd, int mode)
 {
 	int err;
 
-	do {
-		err = fchmod(fd, mode);
-	} while((err < 0) && (errno==EINTR)) ;
-
-	if(err < 0)
+	CATCH_EINTR(err = fchmod(fd, mode));
+	if (err < 0)
 		return -errno;
 
 	return 0;
@@ -149,20 +132,20 @@ int os_file_type(char *file)
 	int err;
 
 	err = os_stat_file(file, &buf);
-	if(err < 0)
+	if (err < 0)
 		return err;
 
-	if(S_ISDIR(buf.ust_mode))
+	if (S_ISDIR(buf.ust_mode))
 		return OS_TYPE_DIR;
-	else if(S_ISLNK(buf.ust_mode))
+	else if (S_ISLNK(buf.ust_mode))
 		return OS_TYPE_SYMLINK;
-	else if(S_ISCHR(buf.ust_mode))
+	else if (S_ISCHR(buf.ust_mode))
 		return OS_TYPE_CHARDEV;
-	else if(S_ISBLK(buf.ust_mode))
+	else if (S_ISBLK(buf.ust_mode))
 		return OS_TYPE_BLOCKDEV;
-	else if(S_ISFIFO(buf.ust_mode))
+	else if (S_ISFIFO(buf.ust_mode))
 		return OS_TYPE_FIFO;
-	else if(S_ISSOCK(buf.ust_mode))
+	else if (S_ISSOCK(buf.ust_mode))
 		return OS_TYPE_SOCK;
 	else return OS_TYPE_FILE;
 }
@@ -174,15 +157,15 @@ int os_file_mode(const char *file, struc
 	*mode_out = OPENFLAGS();
 
 	err = access(file, W_OK);
-	if(err && (errno != EACCES))
+	if (err && (errno != EACCES))
 		return -errno;
-	else if(!err)
+	else if (!err)
 		*mode_out = of_write(*mode_out);
 
 	err = access(file, R_OK);
-	if(err && (errno != EACCES))
+	if (err && (errno != EACCES))
 		return -errno;
-	else if(!err)
+	else if (!err)
 		*mode_out = of_read(*mode_out);
 
 	return err;
@@ -192,21 +175,28 @@ int os_open_file(const char *file, struc
 {
 	int fd, err, f = 0;
 
-	if(flags.r && flags.w) f = O_RDWR;
-	else if(flags.r) f = O_RDONLY;
-	else if(flags.w) f = O_WRONLY;
+	if (flags.r && flags.w)
+		f = O_RDWR;
+	else if (flags.r)
+		f = O_RDONLY;
+	else if (flags.w)
+		f = O_WRONLY;
 	else f = 0;
 
-	if(flags.s) f |= O_SYNC;
-	if(flags.c) f |= O_CREAT;
-	if(flags.t) f |= O_TRUNC;
-	if(flags.e) f |= O_EXCL;
+	if (flags.s)
+		f |= O_SYNC;
+	if (flags.c)
+		f |= O_CREAT;
+	if (flags.t)
+		f |= O_TRUNC;
+	if (flags.e)
+		f |= O_EXCL;
 
 	fd = open64(file, f, mode);
-	if(fd < 0)
+	if (fd < 0)
 		return -errno;
 
-	if(flags.cl && fcntl(fd, F_SETFD, 1)){
+	if (flags.cl && fcntl(fd, F_SETFD, 1)) {
 		err = -errno;
 		close(fd);
 		return err;
@@ -224,13 +214,13 @@ int os_connect_socket(const char *name)
 	snprintf(sock.sun_path, sizeof(sock.sun_path), "%s", name);
 
 	fd = socket(AF_UNIX, SOCK_STREAM, 0);
-	if(fd < 0) {
+	if (fd < 0) {
 		err = -errno;
 		goto out;
 	}
 
 	err = connect(fd, (struct sockaddr *) &sock, sizeof(sock));
-	if(err) {
+	if (err) {
 		err = -errno;
 		goto out_close;
 	}
@@ -253,7 +243,7 @@ int os_seek_file(int fd, unsigned long l
 	unsigned long long actual;
 
 	actual = lseek64(fd, offset, SEEK_SET);
-	if(actual != offset)
+	if (actual != offset)
 		return -errno;
 	return 0;
 }
@@ -262,7 +252,7 @@ int os_read_file(int fd, void *buf, int 
 {
 	int n = read(fd, buf, len);
 
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 	return n;
 }
@@ -271,7 +261,7 @@ int os_write_file(int fd, const void *bu
 {
 	int n = write(fd, (void *) buf, len);
 
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 	return n;
 }
@@ -282,26 +272,27 @@ int os_file_size(const char *file, unsig
 	int err;
 
 	err = os_stat_file(file, &buf);
-	if(err < 0){
-		printk("Couldn't stat \"%s\" : err = %d\n", file, -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		       -err);
 		return err;
 	}
 
-	if(S_ISBLK(buf.ust_mode)){
+	if (S_ISBLK(buf.ust_mode)) {
 		int fd;
 		long blocks;
 
 		fd = open(file, O_RDONLY, 0);
-		if(fd < 0) {
+		if (fd < 0) {
 			err = -errno;
-			printk("Couldn't open \"%s\", errno = %d\n", file,
-			       errno);
+			printk(UM_KERN_ERR "Couldn't open \"%s\", "
+			       "errno = %d\n", file, errno);
 			return err;
 		}
-		if(ioctl(fd, BLKGETSIZE, &blocks) < 0){
+		if (ioctl(fd, BLKGETSIZE, &blocks) < 0) {
 			err = -errno;
-			printk("Couldn't get the block size of \"%s\", "
-			       "errno = %d\n", file, errno);
+			printk(UM_KERN_ERR "Couldn't get the block size of "
+			       "\"%s\", errno = %d\n", file, errno);
 			close(fd);
 			return err;
 		}
@@ -319,8 +310,9 @@ int os_file_modtime(const char *file, un
 	int err;
 
 	err = os_stat_file(file, &buf);
-	if(err < 0){
-		printk("Couldn't stat \"%s\" : err = %d\n", file, -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "Couldn't stat \"%s\" : err = %d\n", file,
+		       -err);
 		return err;
 	}
 
@@ -334,7 +326,7 @@ int os_set_exec_close(int fd)
 
 	CATCH_EINTR(err = fcntl(fd, F_SETFD, FD_CLOEXEC));
 
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 	return err;
 }
@@ -344,24 +336,25 @@ int os_pipe(int *fds, int stream, int cl
 	int err, type = stream ? SOCK_STREAM : SOCK_DGRAM;
 
 	err = socketpair(AF_UNIX, type, 0, fds);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
-	if(!close_on_exec)
+	if (!close_on_exec)
 		return 0;
 
 	err = os_set_exec_close(fds[0]);
-	if(err < 0)
+	if (err < 0)
 		goto error;
 
 	err = os_set_exec_close(fds[1]);
-	if(err < 0)
+	if (err < 0)
 		goto error;
 
 	return 0;
 
  error:
-	printk("os_pipe : Setting FD_CLOEXEC failed, err = %d\n", -err);
+	printk(UM_KERN_ERR "os_pipe : Setting FD_CLOEXEC failed, err = %d\n",
+	       -err);
 	close(fds[1]);
 	close(fds[0]);
 	return err;
@@ -378,15 +371,15 @@ int os_set_fd_async(int fd)
 	flags |= O_ASYNC | O_NONBLOCK;
 	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
-		printk("os_set_fd_async : failed to set O_ASYNC and "
-		       "O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
+		printk(UM_KERN_ERR "os_set_fd_async : failed to set O_ASYNC "
+		       "and O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
 		return err;
 	}
 
 	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
 	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
-		printk("os_set_fd_async : Failed to fcntl F_SETOWN "
+		printk(UM_KERN_ERR "os_set_fd_async : Failed to fcntl F_SETOWN "
 		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
 		return err;
 	}
@@ -396,10 +389,14 @@ int os_set_fd_async(int fd)
 
 int os_clear_fd_async(int fd)
 {
-	int flags = fcntl(fd, F_GETFL);
+	int flags;
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		return -errno;
 
 	flags &= ~(O_ASYNC | O_NONBLOCK);
-	if(fcntl(fd, F_SETFL, flags) < 0)
+	if (fcntl(fd, F_SETFL, flags) < 0)
 		return -errno;
 	return 0;
 }
@@ -409,11 +406,15 @@ int os_set_fd_block(int fd, int blocking
 	int flags;
 
 	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		return -errno;
 
-	if(blocking) flags &= ~O_NONBLOCK;
-	else flags |= O_NONBLOCK;
+	if (blocking)
+		flags &= ~O_NONBLOCK;
+	else
+		flags |= O_NONBLOCK;
 
-	if(fcntl(fd, F_SETFL, flags) < 0)
+	if (fcntl(fd, F_SETFL, flags) < 0)
 		return -errno;
 
 	return 0;
@@ -424,7 +425,7 @@ int os_accept_connection(int fd)
 	int new;
 
 	new = accept(fd, NULL, 0);
-	if(new < 0)
+	if (new < 0)
 		return -errno;
 	return new;
 }
@@ -445,15 +446,17 @@ int os_shutdown_socket(int fd, int r, in
 {
 	int what, err;
 
-	if(r && w) what = SHUT_RDWR;
-	else if(r) what = SHUT_RD;
-	else if(w) what = SHUT_WR;
-	else {
-		printk("os_shutdown_socket : neither r or w was set\n");
+	if (r && w)
+		what = SHUT_RDWR;
+	else if (r)
+		what = SHUT_RD;
+	else if (w)
+		what = SHUT_WR;
+	else
 		return -EINVAL;
-	}
+
 	err = shutdown(fd, what);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 	return 0;
 }
@@ -477,19 +480,20 @@ int os_rcv_fd(int fd, int *helper_pid_ou
 	msg.msg_flags = 0;
 
 	n = recvmsg(fd, &msg, 0);
-	if(n < 0)
+	if (n < 0)
 		return -errno;
-	else if(n != iov.iov_len)
+	else if (n != iov.iov_len)
 		*helper_pid_out = -1;
 
 	cmsg = CMSG_FIRSTHDR(&msg);
-	if(cmsg == NULL){
-		printk("rcv_fd didn't receive anything, error = %d\n", errno);
+	if (cmsg == NULL) {
+		printk(UM_KERN_ERR "rcv_fd didn't receive anything, "
+		       "error = %d\n", errno);
 		return -1;
 	}
-	if((cmsg->cmsg_level != SOL_SOCKET) ||
-	   (cmsg->cmsg_type != SCM_RIGHTS)){
-		printk("rcv_fd didn't receive a descriptor\n");
+	if ((cmsg->cmsg_level != SOL_SOCKET) ||
+	    (cmsg->cmsg_type != SCM_RIGHTS)) {
+		printk(UM_KERN_ERR "rcv_fd didn't receive a descriptor\n");
 		return -1;
 	}
 
@@ -503,23 +507,22 @@ int os_create_unix_socket(const char *fi
 	int sock, err;
 
 	sock = socket(PF_UNIX, SOCK_DGRAM, 0);
-	if(sock < 0)
+	if (sock < 0)
 		return -errno;
 
-	if(close_on_exec) {
+	if (close_on_exec) {
 		err = os_set_exec_close(sock);
-		if(err < 0)
-			printk("create_unix_socket : close_on_exec failed, "
-		       "err = %d", -err);
+		if (err < 0)
+			printk(UM_KERN_ERR "create_unix_socket : "
+			       "close_on_exec failed, err = %d", -err);
 	}
 
 	addr.sun_family = AF_UNIX;
 
-	/* XXX Be more careful about overflow */
 	snprintf(addr.sun_path, len, "%s", file);
 
 	err = bind(sock, (struct sockaddr *) &addr, sizeof(addr));
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
 	return sock;
@@ -540,17 +543,18 @@ int os_lock_file(int fd, int excl)
 	int err, save;
 
 	err = fcntl(fd, F_SETLK, &lock);
-	if(!err)
+	if (!err)
 		goto out;
 
 	save = -errno;
 	err = fcntl(fd, F_GETLK, &lock);
-	if(err){
+	if (err) {
 		err = -errno;
 		goto out;
 	}
 
-	printk("F_SETLK failed, file already locked by pid %d\n", lock.l_pid);
+	printk(UM_KERN_ERR "F_SETLK failed, file already locked by pid %d\n",
+	       lock.l_pid);
 	err = save;
  out:
 	return err;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
