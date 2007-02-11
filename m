From: akpm@linux-foundation.org
Subject: - uml-libc-dependent-code-should-call-libc-directly.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:25 -0800
Message-ID: <200702112249.l1BMnPCs015746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703AbXBKWt1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: libc-dependent code should call libc directly
has been removed from the -mm tree.  Its filename was
     uml-libc-dependent-code-should-call-libc-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: libc-dependent code should call libc directly
From: Jeff Dike <jdike@addtoit.com>

We shouldn't be using the os wrappers from os code - we can use libc directly.
This patch replaces wrapper calls with libc calls.

It turns out that os_sigio_async had only one caller, which was in startup.c,
so that function is moved there and its name changed.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h        |    1 
 arch/um/os-Linux/file.c     |   19 ----------------
 arch/um/os-Linux/start_up.c |   39 ++++++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 31 deletions(-)

diff -puN arch/um/include/os.h~uml-libc-dependent-code-should-call-libc-directly arch/um/include/os.h
--- a/arch/um/include/os.h~uml-libc-dependent-code-should-call-libc-directly
+++ a/arch/um/include/os.h
@@ -137,7 +137,6 @@ extern int os_new_tty_pgrp(int fd, int p
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
 extern int os_set_owner(int fd, int pid);
-extern int os_sigio_async(int master, int slave);
 extern int os_mode_fd(int fd, int mode);
 
 extern int os_seek_file(int fd, __u64 offset);
diff -puN arch/um/os-Linux/file.c~uml-libc-dependent-code-should-call-libc-directly arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-libc-dependent-code-should-call-libc-directly
+++ a/arch/um/os-Linux/file.c
@@ -162,25 +162,6 @@ int os_set_owner(int fd, int pid)
 	return 0;
 }
 
-/* FIXME? moved wholesale from sigio_user.c to get fcntls out of that file */
-int os_sigio_async(int master, int slave)
-{
-	int flags;
-
-	flags = fcntl(master, F_GETFL);
-	if(flags < 0)
-		return -errno;
-
-	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
-	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
-		return -errno;
-
-	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
-		return -errno;
-
-	return(0);
-}
-
 int os_mode_fd(int fd, int mode)
 {
 	int err;
diff -puN arch/um/os-Linux/start_up.c~uml-libc-dependent-code-should-call-libc-directly arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-libc-dependent-code-should-call-libc-directly
+++ a/arch/um/os-Linux/start_up.c
@@ -54,7 +54,7 @@ static int ptrace_child(void *arg)
 		perror("ptrace");
 		os_kill_process(pid, 0);
 	}
-	os_stop_process(pid);
+	kill(pid, SIGSTOP);
 
 	/*This syscall will be intercepted by the parent. Don't call more than
 	 * once, please.*/
@@ -417,7 +417,7 @@ static inline void check_skas3_ptrace_ld
 static inline void check_skas3_proc_mm(void)
 {
 	printf("  - /proc/mm...");
-	if (os_access("/proc/mm", OS_ACC_W_OK) < 0) {
+	if (access("/proc/mm", W_OK) < 0) {
 		proc_mm = 0;
 		printf("not found\n");
 	}
@@ -452,9 +452,9 @@ int can_do_skas(void)
 int __init parse_iomem(char *str, int *add)
 {
 	struct iomem_region *new;
-	struct uml_stat buf;
+	struct stat64 buf;
 	char *file, *driver;
-	int fd, err, size;
+	int fd, size;
 
 	driver = str;
 	file = strchr(str,',');
@@ -464,15 +464,14 @@ int __init parse_iomem(char *str, int *a
 	}
 	*file = '\0';
 	file++;
-	fd = os_open_file(file, of_rdwr(OPENFLAGS()), 0);
+	fd = open(file, O_RDWR, 0);
 	if(fd < 0){
 		os_print_error(fd, "parse_iomem - Couldn't open io file");
 		goto out;
 	}
 
-	err = os_stat_fd(fd, &buf);
-	if(err < 0){
-		os_print_error(err, "parse_iomem - cannot stat_fd file");
+	if(fstat64(fd, &buf) < 0){
+		perror("parse_iomem - cannot stat_fd file");
 		goto out_close;
 	}
 
@@ -482,7 +481,7 @@ int __init parse_iomem(char *str, int *a
 		goto out_close;
 	}
 
-	size = (buf.ust_size + UM_KERN_PAGE_SIZE) & ~(UM_KERN_PAGE_SIZE - 1);
+	size = (buf.st_size + UM_KERN_PAGE_SIZE) & ~(UM_KERN_PAGE_SIZE - 1);
 
 	*new = ((struct iomem_region) { .next		= iomem_regions,
 					.driver		= driver,
@@ -495,7 +494,7 @@ int __init parse_iomem(char *str, int *a
 
 	return 0;
  out_close:
-	os_close_file(fd);
+	close(fd);
  out:
 	return 1;
 }
@@ -528,6 +527,24 @@ static void openpty_cb(void *arg)
 		info->err = -errno;
 }
 
+static int async_pty(int master, int slave)
+{
+	int flags;
+
+	flags = fcntl(master, F_GETFL);
+	if(flags < 0)
+		return -errno;
+
+	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
+	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
+		return -errno;
+
+	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
+		return -errno;
+
+	return(0);
+}
+
 static void __init check_one_sigio(void (*proc)(int, int))
 {
 	struct sigaction old, new;
@@ -553,7 +570,7 @@ static void __init check_one_sigio(void 
 	if (err < 0)
 		panic("check_sigio : __raw failed, errno = %d\n", -err);
 
-	err = os_sigio_async(master, slave);
+	err = async_pty(master, slave);
 	if(err < 0)
 		panic("tty_fds : sigio_async failed, err = %d\n", -err);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
