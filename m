From: akpm@linux-foundation.org
Subject: + uml-userspace-files-should-call-libc-directly.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:43:41 -0700
Message-ID: <200708201943.l7KJhfHA019637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307AbXHTTnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: userspace files should call libc directly
has been added to the -mm tree.  Its filename is
     uml-userspace-files-should-call-libc-directly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: userspace files should call libc directly
From: Jeff Dike <jdike@addtoit.com>

A number of files that were changed in the recent removal of tt mode
are userspace files which call the os_* wrappers instead of calling
libc directly.  A few other files were affected by this, through

This patch makes these call glibc directly.

There are also style fixes in the affected areas.

os_print_error has no remaining callers, so it is deleted.

There is a interface change to os_set_exec_close, eliminating a
parameter which was always the same.  The callers are fixed as well.

os_process_pc got its error path cleaned up.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h                     |    3 
 arch/um/kernel/ksyms.c                   |    1 
 arch/um/kernel/physmem.c                 |    4 
 arch/um/os-Linux/aio.c                   |    4 
 arch/um/os-Linux/drivers/ethertap_user.c |   61 ++++++++----
 arch/um/os-Linux/drivers/tuntap_user.c   |   24 ++--
 arch/um/os-Linux/file.c                  |  102 +++++++++------------
 arch/um/os-Linux/helper.c                |    8 +
 arch/um/os-Linux/mem.c                   |    6 -
 arch/um/os-Linux/process.c               |   37 ++++---
 arch/um/os-Linux/skas/process.c          |    4 
 arch/um/os-Linux/start_up.c              |    5 -
 12 files changed, 138 insertions(+), 121 deletions(-)

diff -puN arch/um/include/os.h~uml-userspace-files-should-call-libc-directly arch/um/include/os.h
--- a/arch/um/include/os.h~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/include/os.h
@@ -128,9 +128,8 @@ static inline struct openflags of_cloexe
 extern int os_stat_file(const char *file_name, struct uml_stat *buf);
 extern int os_stat_fd(const int fd, struct uml_stat *buf);
 extern int os_access(const char *file, int mode);
-extern void os_print_error(int error, const char* str);
 extern int os_get_exec_close(int fd, int *close_on_exec);
-extern int os_set_exec_close(int fd, int close_on_exec);
+extern int os_set_exec_close(int fd);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
diff -puN arch/um/kernel/ksyms.c~uml-userspace-files-should-call-libc-directly arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/kernel/ksyms.c
@@ -40,7 +40,6 @@ EXPORT_SYMBOL(uml_strdup);
 EXPORT_SYMBOL(os_stat_fd);
 EXPORT_SYMBOL(os_stat_file);
 EXPORT_SYMBOL(os_access);
-EXPORT_SYMBOL(os_print_error);
 EXPORT_SYMBOL(os_get_exec_close);
 EXPORT_SYMBOL(os_set_exec_close);
 EXPORT_SYMBOL(os_getpid);
diff -puN arch/um/kernel/physmem.c~uml-userspace-files-should-call-libc-directly arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/kernel/physmem.c
@@ -99,7 +99,9 @@ void __init setup_physmem(unsigned long 
 	err = os_map_memory((void *) uml_reserved, physmem_fd, offset,
 			    len - offset, 1, 1, 1);
 	if (err < 0) {
-		os_print_error(err, "Mapping memory");
+		printf("setup_physmem - mapping %ld bytes of memory at 0x%p "
+		       "failed - errno = %d\n", len - offset,
+		       (void *) uml_reserved, err);
 		exit(1);
 	}
 
diff -puN arch/um/os-Linux/aio.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/aio.c
@@ -226,8 +226,8 @@ static int init_aio_24(void)
 	goto out;
 
 out_close_pipe:
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
+	close(fds[0]);
+	close(fds[1]);
 	aio_req_fd_w = -1;
 	aio_req_fd_r = -1;
 out:
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -87,11 +87,11 @@ static void etap_pre_exec(void *arg)
 	struct etap_pre_exec_data *data = arg;
 
 	dup2(data->control_remote, 1);
-	os_close_file(data->data_me);
-	os_close_file(data->control_me);
+	close(data->data_me);
+	close(data->control_me);
 }
 
-static int etap_tramp(char *dev, char *gate, int control_me, 
+static int etap_tramp(char *dev, char *gate, int control_me,
 		      int control_remote, int data_me, int data_remote)
 {
 	struct etap_pre_exec_data pe_data;
@@ -101,7 +101,7 @@ static int etap_tramp(char *dev, char *g
 	char gate_buf[sizeof("nnn.nnn.nnn.nnn\0")];
 	char *setup_args[] = { "uml_net", version_buf, "ethertap", dev,
 			       data_fd_buf, gate_buf, NULL };
-	char *nosetup_args[] = { "uml_net", version_buf, "ethertap", 
+	char *nosetup_args[] = { "uml_net", version_buf, "ethertap",
 				 dev, data_fd_buf, NULL };
 	char **args, c;
 
@@ -121,8 +121,8 @@ static int etap_tramp(char *dev, char *g
 
 	if(pid < 0)
 		err = pid;
-	os_close_file(data_remote);
-	os_close_file(control_remote);
+	close(data_remote);
+	close(control_remote);
 	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
 	if(n != sizeof(c)){
 		err = -errno;
@@ -151,19 +151,23 @@ static int etap_open(void *data)
 	if(err)
 		return err;
 
-	err = os_pipe(data_fds, 0, 0);
-	if(err < 0){
-		printk("data os_pipe failed - err = %d\n", -err);
+	err = socketpair(AF_UNIX, SOCK_DGRAM, 0, data_fds);
+	if(err){
+		err = -errno;
+		printk("etap_open - data socketpair failed - err = %d\n",
+		       errno);
 		return err;
 	}
 
-	err = os_pipe(control_fds, 1, 0);
-	if(err < 0){
-		printk("control os_pipe failed - err = %d\n", -err);
-		return err;
+	err = socketpair(AF_UNIX, SOCK_STREAM, 0, control_fds);
+	if(err){
+		err = -errno;
+		printk("etap_open - control socketpair failed - err = %d\n",
+		       errno);
+		goto out_close_data;
 	}
 
-	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0], 
+	err = etap_tramp(pri->dev_name, pri->gate_addr, control_fds[0],
 			 control_fds[1], data_fds[0], data_fds[1]);
 	output_len = UM_KERN_PAGE_SIZE;
 	output = kmalloc(output_len, UM_GFP_KERNEL);
@@ -178,13 +182,21 @@ static int etap_open(void *data)
 
 	if(err < 0){
 		printk("etap_tramp failed - err = %d\n", -err);
-		return err;
+		goto out_close_control;
 	}
 
 	pri->data_fd = data_fds[0];
 	pri->control_fd = control_fds[0];
 	iter_addresses(pri->dev, etap_open_addr, &pri->control_fd);
 	return data_fds[0];
+
+out_close_control:
+	close(control_fds[0]);
+	close(control_fds[1]);
+out_close_data:
+	close(data_fds[0]);
+	close(data_fds[1]);
+	return err;
 }
 
 static void etap_close(int fd, void *data)
@@ -192,11 +204,19 @@ static void etap_close(int fd, void *dat
 	struct ethertap_data *pri = data;
 
 	iter_addresses(pri->dev, etap_close_addr, &pri->control_fd);
-	os_close_file(fd);
-	os_shutdown_socket(pri->data_fd, 1, 1);
-	os_close_file(pri->data_fd);
+	close(fd);
+
+	if(shutdown(pri->data_fd, SHUT_RDWR) < 0)
+		printk("etap_close - shutdown data socket failed, errno = %d\n",
+		       errno);
+
+	if(shutdown(pri->control_fd, SHUT_RDWR) < 0)
+		printk("etap_close - shutdown control socket failed, "
+		       "errno = %d\n", errno);
+
+	close(pri->data_fd);
 	pri->data_fd = -1;
-	os_close_file(pri->control_fd);
+	close(pri->control_fd);
 	pri->control_fd = -1;
 }
 
@@ -216,13 +236,14 @@ static void etap_add_addr(unsigned char 
 	etap_open_addr(addr, netmask, &pri->control_fd);
 }
 
-static void etap_del_addr(unsigned char *addr, unsigned char *netmask, 
+static void etap_del_addr(unsigned char *addr, unsigned char *netmask,
 			  void *data)
 {
 	struct ethertap_data *pri = data;
 
 	if(pri->control_fd == -1)
 		return;
+
 	etap_close_addr(addr, netmask, &pri->control_fd);
 }
 
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -62,7 +62,7 @@ static void tuntap_pre_exec(void *arg)
 	struct tuntap_pre_exec_data *data = arg;
 
 	dup2(data->stdout, 1);
-	os_close_file(data->close_me);
+	close(data->close_me);
 }
 
 static int tuntap_open_tramp(char *gate, int *fd_out, int me, int remote,
@@ -88,7 +88,7 @@ static int tuntap_open_tramp(char *gate,
 	if(pid < 0)
 		return -pid;
 
-	os_close_file(remote);
+	close(remote);
 
 	msg.msg_name = NULL;
 	msg.msg_namelen = 0;
@@ -125,7 +125,7 @@ static int tuntap_open_tramp(char *gate,
 		return -EINVAL;
 	}
 	*fd_out = ((int *) CMSG_DATA(cmsg))[0];
-	os_set_exec_close(*fd_out, 1);
+	os_set_exec_close(*fd_out);
 	return 0;
 }
 
@@ -154,20 +154,22 @@ static int tuntap_open(void *data)
 		if(ioctl(pri->fd, TUNSETIFF, (void *) &ifr) < 0){
 			err = -errno;
 			printk("TUNSETIFF failed, errno = %d\n", errno);
-			os_close_file(pri->fd);
+			close(pri->fd);
 			return err;
 		}
 	}
 	else {
-		err = os_pipe(fds, 0, 0);
-		if(err < 0){
-			printk("tuntap_open : os_pipe failed - err = %d\n",
-			       -err);
+		err = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
+		if(err){
+			err = -errno;
+			printk("tuntap_open : socketpair failed - errno = %d\n",
+			       errno);
 			return err;
 		}
 
 		buffer = get_output_buffer(&len);
-		if(buffer != NULL) len--;
+		if(buffer != NULL)
+			len--;
 		used = 0;
 
 		err = tuntap_open_tramp(pri->gate_addr, &pri->fd, fds[0],
@@ -186,7 +188,7 @@ static int tuntap_open(void *data)
 		printk("%s", output);
 		free_output_buffer(buffer);
 
-		os_close_file(fds[0]);
+		close(fds[0]);
 		iter_addresses(pri->dev, open_addr, pri->dev_name);
 	}
 
@@ -199,7 +201,7 @@ static void tuntap_close(int fd, void *d
 
 	if(!pri->fixed_config) 
 		iter_addresses(pri->dev, close_addr, pri->dev_name);
-	os_close_file(fd);
+	close(fd);
 	pri->fd = -1;
 }
 
diff -puN arch/um/os-Linux/file.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/file.c
@@ -82,13 +82,6 @@ int os_access(const char* file, int mode
 	return 0;
 }
 
-void os_print_error(int error, const char* str)
-{
-	errno = error < 0 ? -error : error;
-
-	perror(str);
-}
-
 /* FIXME? required only by hostaudio (because it passes ioctls verbatim) */
 int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg)
 {
@@ -181,19 +174,19 @@ int os_file_mode(char *file, struct open
 
 	*mode_out = OPENFLAGS();
 
-	err = os_access(file, OS_ACC_W_OK);
-	if((err < 0) && (err != -EACCES))
-		return(err);
-
-	*mode_out = of_write(*mode_out);
-
-	err = os_access(file, OS_ACC_R_OK);
-	if((err < 0) && (err != -EACCES))
-		return(err);
+	err = access(file, W_OK);
+	if(err && (errno != EACCES))
+		return -errno;
+	else if(!err)
+		*mode_out = of_write(*mode_out);
 
-	*mode_out = of_read(*mode_out);
+	err = access(file, R_OK);
+	if(err && (errno != EACCES))
+		return -errno;
+	else if(!err)
+		*mode_out = of_read(*mode_out);
 
-	return(0);
+	return err;
 }
 
 int os_open_file(char *file, struct openflags flags, int mode)
@@ -212,15 +205,15 @@ int os_open_file(char *file, struct open
 
 	fd = open64(file, f, mode);
 	if(fd < 0)
-		return(-errno);
+		return -errno;
 
 	if(flags.cl && fcntl(fd, F_SETFD, 1)){
 		err = -errno;
-		os_close_file(fd);
+		close(fd);
 		return err;
 	}
 
-	return(fd);
+	return fd;
 }
 
 int os_connect_socket(char *name)
@@ -292,31 +285,33 @@ int os_file_size(char *file, unsigned lo
 	err = os_stat_file(file, &buf);
 	if(err < 0){
 		printk("Couldn't stat \"%s\" : err = %d\n", file, -err);
-		return(err);
+		return err;
 	}
 
 	if(S_ISBLK(buf.ust_mode)){
 		int fd;
 		long blocks;
 
-		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
-		if(fd < 0){
-			printk("Couldn't open \"%s\", errno = %d\n", file, -fd);
-			return(fd);
+		fd = open(file, O_RDONLY, 0);
+		if(fd < 0) {
+			err = -errno;
+			printk("Couldn't open \"%s\", errno = %d\n", file,
+			       errno);
+			return err;
 		}
 		if(ioctl(fd, BLKGETSIZE, &blocks) < 0){
 			err = -errno;
 			printk("Couldn't get the block size of \"%s\", "
 			       "errno = %d\n", file, errno);
-			os_close_file(fd);
-			return(err);
+			close(fd);
+			return err;
 		}
 		*size_out = ((long long) blocks) * 512;
-		os_close_file(fd);
-		return(0);
+		close(fd);
 	}
-	*size_out = buf.ust_size;
-	return(0);
+	else *size_out = buf.ust_size;
+
+	return 0;
 }
 
 int os_file_modtime(char *file, unsigned long *modtime)
@@ -334,35 +329,28 @@ int os_file_modtime(char *file, unsigned
 	return 0;
 }
 
-int os_get_exec_close(int fd, int* close_on_exec)
+int os_get_exec_close(int fd, int *close_on_exec)
 {
 	int ret;
 
-	do {
-		ret = fcntl(fd, F_GETFD);
-	} while((ret < 0) && (errno == EINTR)) ;
+	CATCH_EINTR(ret = fcntl(fd, F_GETFD));
 
 	if(ret < 0)
-		return(-errno);
+		return -errno;
 
-	*close_on_exec = (ret&FD_CLOEXEC) ? 1 : 0;
-	return(ret);
+	*close_on_exec = (ret & FD_CLOEXEC) ? 1 : 0;
+	return ret;
 }
 
-int os_set_exec_close(int fd, int close_on_exec)
+int os_set_exec_close(int fd)
 {
-	int flag, err;
-
-	if(close_on_exec) flag = FD_CLOEXEC;
-	else flag = 0;
+	int err;
 
-	do {
-		err = fcntl(fd, F_SETFD, flag);
-	} while((err < 0) && (errno == EINTR)) ;
+	CATCH_EINTR(err = fcntl(fd, F_SETFD, FD_CLOEXEC));
 
 	if(err < 0)
-		return(-errno);
-	return(err);
+		return -errno;
+	return err;
 }
 
 int os_pipe(int *fds, int stream, int close_on_exec)
@@ -371,16 +359,16 @@ int os_pipe(int *fds, int stream, int cl
 
 	err = socketpair(AF_UNIX, type, 0, fds);
 	if(err < 0)
-		return(-errno);
+		return -errno;
 
 	if(!close_on_exec)
-		return(0);
+		return 0;
 
-	err = os_set_exec_close(fds[0], 1);
+	err = os_set_exec_close(fds[0]);
 	if(err < 0)
 		goto error;
 
-	err = os_set_exec_close(fds[1], 1);
+	err = os_set_exec_close(fds[1]);
 	if(err < 0)
 		goto error;
 
@@ -388,9 +376,9 @@ int os_pipe(int *fds, int stream, int cl
 
  error:
 	printk("os_pipe : Setting FD_CLOEXEC failed, err = %d\n", -err);
-	os_close_file(fds[1]);
-	os_close_file(fds[0]);
-	return(err);
+	close(fds[1]);
+	close(fds[0]);
+	return err;
 }
 
 int os_set_fd_async(int fd, int owner)
@@ -537,7 +525,7 @@ int os_create_unix_socket(char *file, in
 		return -errno;
 
 	if(close_on_exec) {
-		err = os_set_exec_close(sock, 1);
+		err = os_set_exec_close(sock);
 		if(err < 0)
 			printk("create_unix_socket : close_on_exec failed, "
 		       "err = %d", -err);
diff -puN arch/um/os-Linux/helper.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/helper.c
@@ -11,6 +11,7 @@
 #include <limits.h>
 #include <sys/signal.h>
 #include <sys/wait.h>
+#include <sys/socket.h>
 #include "user.h"
 #include "kern_util.h"
 #include "os.h"
@@ -54,13 +55,14 @@ int run_helper(void (*pre_exec)(void *),
 	if (stack == 0)
 		return -ENOMEM;
 
-	ret = os_pipe(fds, 1, 0);
+	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
 	if (ret < 0) {
-		printk("run_helper : pipe failed, ret = %d\n", -ret);
+		ret = -errno;
+		printk("run_helper : pipe failed, errno = %d\n", errno);
 		goto out_free;
 	}
 
-	ret = os_set_exec_close(fds[1], 1);
+	ret = os_set_exec_close(fds[1]);
 	if (ret < 0) {
 		printk("run_helper : setting FD_CLOEXEC failed, ret = %d\n",
 		       -ret);
diff -puN arch/um/os-Linux/mem.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/mem.c
@@ -218,7 +218,7 @@ int __init create_tmp_file(unsigned long
 
 	err = fchmod(fd, 0777);
 	if(err < 0){
-		perror("os_mode_fd");
+		perror("fchmod");
 		exit(1);
 	}
 
@@ -226,7 +226,7 @@ int __init create_tmp_file(unsigned long
 	 * increase the file size by one byte, to the desired length.
 	 */
 	if (lseek64(fd, len - 1, SEEK_SET) < 0) {
-		perror("os_seek_file");
+		perror("lseek64");
 		exit(1);
 	}
 
@@ -247,7 +247,7 @@ int __init create_mem_file(unsigned long
 
 	fd = create_tmp_file(len);
 
-	err = os_set_exec_close(fd, 1);
+	err = os_set_exec_close(fd);
 	if(err < 0){
 		errno = -err;
 		perror("exec_close");
diff -puN arch/um/os-Linux/process.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/process.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <signal.h>
+#include <fcntl.h>
 #include <sys/mman.h>
 #include <sys/ptrace.h>
 #include <sys/wait.h>
@@ -28,31 +29,32 @@
 unsigned long os_process_pc(int pid)
 {
 	char proc_stat[STAT_PATH_LEN], buf[256];
-	unsigned long pc;
+	unsigned long pc = ARBITRARY_ADDR;
 	int fd, err;
 
 	sprintf(proc_stat, "/proc/%d/stat", pid);
-	fd = os_open_file(proc_stat, of_read(OPENFLAGS()), 0);
+	fd = open(proc_stat, O_RDONLY, 0);
 	if (fd < 0) {
 		printk(UM_KERN_ERR "os_process_pc - couldn't open '%s', "
-		       "err = %d\n", proc_stat, -fd);
-		return ARBITRARY_ADDR;
+		       "errno = %d\n", proc_stat, errno);
+		goto out;
 	}
 	CATCH_EINTR(err = read(fd, buf, sizeof(buf)));
 	if (err < 0) {
 		printk(UM_KERN_ERR "os_process_pc - couldn't read '%s', "
 		       "err = %d\n", proc_stat, errno);
-		os_close_file(fd);
-		return ARBITRARY_ADDR;
+		goto out_close;
 	}
 	os_close_file(fd);
 	pc = ARBITRARY_ADDR;
 	if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
-		  "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
-		  "%*d %*d %*d %*d %*d %lu", &pc) != 1) {
+		   "%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d "
+		   "%*d %*d %*d %*d %*d %lu", &pc) != 1)
 		printk(UM_KERN_ERR "os_process_pc - couldn't find pc in '%s'\n",
 		       buf);
-	}
+ out_close:
+	close(fd);
+ out:
 	return pc;
 }
 
@@ -60,25 +62,26 @@ int os_process_parent(int pid)
 {
 	char stat[STAT_PATH_LEN];
 	char data[256];
-	int parent, n, fd;
+	int parent = FAILURE_PID, n, fd;
 
 	if (pid == -1)
-		return -1;
+		return parent;
 
 	snprintf(stat, sizeof(stat), "/proc/%d/stat", pid);
-	fd = os_open_file(stat, of_read(OPENFLAGS()), 0);
+	fd = open(stat, O_RDONLY, 0);
 	if (fd < 0) {
-		printk(UM_KERN_ERR "Couldn't open '%s', err = %d\n", stat, -fd);
-		return FAILURE_PID;
+		printk(UM_KERN_ERR "Couldn't open '%s', errno = %d\n", stat,
+		       errno);
+		return parent;
 	}
 
 	CATCH_EINTR(n = read(fd, data, sizeof(data)));
-	os_close_file(fd);
+	close(fd);
 
 	if (n < 0) {
-		printk(UM_KERN_ERR "Couldn't read '%s', err = %d\n", stat,
+		printk(UM_KERN_ERR "Couldn't read '%s', errno = %d\n", stat,
 		       errno);
-		return FAILURE_PID;
+		return parent;
 	}
 
 	parent = FAILURE_PID;
diff -puN arch/um/os-Linux/skas/process.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/skas/process.c
@@ -28,7 +28,7 @@
 
 int is_skas_winch(int pid, int fd, void *data)
 {
-	if (pid != os_getpgrp())
+	if (pid != getpgrp())
 		return 0;
 
 	register_winch_irq(-1, fd, -1, data, 0);
@@ -233,7 +233,7 @@ static int userspace_tramp(void *stack)
 			      "failed - errno = %d\n", errno);
 	}
 
-	os_stop_process(os_getpid());
+	kill(os_getpid(), SIGSTOP);
 	return 0;
 }
 
diff -puN arch/um/os-Linux/start_up.c~uml-userspace-files-should-call-libc-directly arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-userspace-files-should-call-libc-directly
+++ a/arch/um/os-Linux/start_up.c
@@ -28,13 +28,14 @@
 static int ptrace_child(void)
 {
 	int ret;
+	/* Calling os_getpid because some libcs cached getpid incorrectly */
 	int pid = os_getpid(), ppid = getppid();
 	int sc_result;
 
 	change_sig(SIGWINCH, 0);
 	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
 		perror("ptrace");
-		os_kill_process(pid, 0);
+		kill(pid, SIGKILL);
 	}
 	kill(pid, SIGSTOP);
 
@@ -496,7 +497,7 @@ int __init parse_iomem(char *str, int *a
 	file++;
 	fd = open(file, O_RDWR, 0);
 	if (fd < 0) {
-		os_print_error(fd, "parse_iomem - Couldn't open io file");
+		perror("parse_iomem - Couldn't open io file");
 		goto out;
 	}
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
