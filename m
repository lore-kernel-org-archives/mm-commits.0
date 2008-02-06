From: akpm@linux-foundation.org
Subject: + uml-style-fixes-in-arch-um-os-linux.patch added to -mm tree
Date: Wed, 06 Feb 2008 14:20:17 -0800
Message-ID: <200802062220.m16MKIKp000627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760084AbYBFWU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 17:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: style fixes in arch/um/os-Linux
has been added to the -mm tree.  Its filename is
     uml-style-fixes-in-arch-um-os-linux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style fixes in arch/um/os-Linux
From: Jeff Dike <jdike@addtoit.com>

Style changes under arch/um/os-Linux:
	include trimming
	CodingStyle fixes
	some printks needed severity indicators

make_tempfile turns out not to be used outside of mem.c, so it is now static. 
Its declaration in tempfile.h is no longer needed, and tempfile.h itself is no
longer needed.

create_tmp_file was also made static.

checkpatch moans about an EXPORT_SYMBOL in user_syms.c which is part of a
macro definition - this is copying a bit of kernel infrastructure into the
libc side of UML because the kernel headers can't be included there.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/tempfile.h               |   11 --
 arch/um/os-Linux/aio.c                   |    2 
 arch/um/os-Linux/drivers/ethertap_kern.c |    8 -
 arch/um/os-Linux/drivers/tuntap_kern.c   |    6 -
 arch/um/os-Linux/include/file.h          |   13 --
 arch/um/os-Linux/mem.c                   |  101 ++++++++++-----------
 arch/um/os-Linux/process.c               |    2 
 arch/um/os-Linux/signal.c                |    2 
 arch/um/os-Linux/skas/process.c          |    6 -
 arch/um/os-Linux/sys-i386/registers.c    |    4 
 arch/um/os-Linux/sys-x86_64/registers.c  |   21 ++--
 arch/um/os-Linux/uaccess.c               |    4 
 arch/um/os-Linux/user_syms.c             |    4 
 arch/um/os-Linux/util.c                  |   43 +++-----
 14 files changed, 98 insertions(+), 129 deletions(-)

diff -puN arch/um/include/tempfile.h~uml-style-fixes-in-arch-um-os-linux /dev/null
--- a/arch/um/include/tempfile.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TEMPFILE_H__
-#define __TEMPFILE_H__
-
-extern int make_tempfile(const char *template, char **tempname, int do_unlink);
-
-#endif
diff -puN arch/um/os-Linux/aio.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/aio.c
@@ -142,7 +142,7 @@ static int do_not_aio(struct aio_thread_
 	if (actual != req->offset)
 		return -errno;
 
-	switch(req->type) {
+	switch (req->type) {
 	case AIO_READ:
 		n = read(req->io_fd, req->buf, req->len);
 		break;
diff -puN arch/um/os-Linux/drivers/ethertap_kern.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/drivers/ethertap_kern.c
--- a/arch/um/os-Linux/drivers/ethertap_kern.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -6,7 +6,7 @@
  * Licensed under the GPL.
  */
 
-#include "linux/init.h"
+#include <linux/init.h>
 #include <linux/netdevice.h>
 #include "etap.h"
 #include "net_kern.h"
@@ -30,10 +30,10 @@ static void etap_init(struct net_device 
 	epri->control_fd = -1;
 	epri->dev = dev;
 
-	printk("ethertap backend - %s", epri->dev_name);
+	printk(KERN_INFO "ethertap backend - %s", epri->dev_name);
 	if (epri->gate_addr != NULL)
-		printk(", IP = %s", epri->gate_addr);
-	printk("\n");
+		printk(KERN_CONT ", IP = %s", epri->gate_addr);
+	printk(KERN_CONT "\n");
 }
 
 static int etap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff -puN arch/um/os-Linux/drivers/tuntap_kern.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/drivers/tuntap_kern.c
--- a/arch/um/os-Linux/drivers/tuntap_kern.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/drivers/tuntap_kern.c
@@ -29,10 +29,10 @@ static void tuntap_init(struct net_devic
 	tpri->fd = -1;
 	tpri->dev = dev;
 
-	printk("TUN/TAP backend - ");
+	printk(KERN_INFO "TUN/TAP backend - ");
 	if (tpri->gate_addr != NULL)
-		printk("IP = %s", tpri->gate_addr);
-	printk("\n");
+		printk(KERN_CONT "IP = %s", tpri->gate_addr);
+	printk(KERN_CONT "\n");
 }
 
 static int tuntap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff -puN arch/um/os-Linux/include/file.h~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/include/file.h
--- a/arch/um/os-Linux/include/file.h~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/include/file.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -9,14 +9,3 @@
 #define DEV_NULL "/dev/null"
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/os-Linux/mem.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/mem.c
@@ -1,22 +1,21 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
 #include <stdio.h>
-#include <stdlib.h>
 #include <stddef.h>
-#include <stdarg.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <string.h>
 #include <fcntl.h>
-#include <sys/types.h>
+#include <string.h>
 #include <sys/mman.h>
-#include <sys/statfs.h>
-#include "user.h"
-#include "mem_user.h"
+#include <sys/param.h>
 #include "init.h"
-#include "os.h"
-#include "tempfile.h"
 #include "kern_constants.h"
-
-#include <sys/param.h>
+#include "os.h"
+#include "user.h"
 
 /* Modified by which_tmpdir, which is called during early boot */
 static char *default_tmpdir = "/tmp";
@@ -33,18 +32,19 @@ static void __init find_tempdir(void)
 	int i;
 	char *dir = NULL;
 
-	if(tempdir != NULL) /* We've already been called */
+	if (tempdir != NULL)
+		/* We've already been called */
 		return;
-	for(i = 0; dirs[i]; i++){
+	for (i = 0; dirs[i]; i++) {
 		dir = getenv(dirs[i]);
-		if((dir != NULL) && (*dir != '\0'))
+		if ((dir != NULL) && (*dir != '\0'))
 			break;
 	}
-	if((dir == NULL) || (*dir == '\0'))
+	if ((dir == NULL) || (*dir == '\0'))
 		dir = default_tmpdir;
 
 	tempdir = malloc(strlen(dir) + 2);
-	if(tempdir == NULL){
+	if (tempdir == NULL) {
 		fprintf(stderr, "Failed to malloc tempdir, "
 			"errno = %d\n", errno);
 		return;
@@ -53,7 +53,8 @@ static void __init find_tempdir(void)
 	strcat(tempdir, "/");
 }
 
-/* This will return 1, with the first character in buf being the
+/*
+ * This will return 1, with the first character in buf being the
  * character following the next instance of c in the file.  This will
  * read the file as needed.  If there's an error, -errno is returned;
  * if the end of the file is reached, 0 is returned.
@@ -64,11 +65,11 @@ static int next(int fd, char *buf, size_
 	size_t len;
 	char *ptr;
 
-	while((ptr = strchr(buf, c)) == NULL){
+	while ((ptr = strchr(buf, c)) == NULL) {
 		n = read(fd, buf, size - 1);
-		if(n == 0)
+		if (n == 0)
 			return 0;
-		else if(n < 0)
+		else if (n < 0)
 			return -errno;
 
 		buf[n] = '\0';
@@ -78,11 +79,12 @@ static int next(int fd, char *buf, size_
 	len = strlen(ptr);
 	memmove(buf, ptr, len + 1);
 
-	/* Refill the buffer so that if there's a partial string that we care
+	/*
+	 * Refill the buffer so that if there's a partial string that we care
 	 * about, it will be completed, and we can recognize it.
 	 */
 	n = read(fd, &buf[len], size - len - 1);
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 
 	buf[len + n] = '\0';
@@ -92,7 +94,8 @@ static int next(int fd, char *buf, size_
 /* which_tmpdir is called only during early boot */
 static int checked_tmpdir = 0;
 
-/* Look for a tmpfs mounted at /dev/shm.  I couldn't find a cleaner
+/*
+ * Look for a tmpfs mounted at /dev/shm.  I couldn't find a cleaner
  * way to do this than to parse /proc/mounts.  statfs will return the
  * same filesystem magic number and fs id for both /dev and /dev/shm
  * when they are both tmpfs, so you can't tell if they are different
@@ -107,7 +110,7 @@ static void which_tmpdir(void)
 	int fd, found;
 	char buf[128] = { '\0' };
 
-	if(checked_tmpdir)
+	if (checked_tmpdir)
 		return;
 
 	checked_tmpdir = 1;
@@ -115,28 +118,28 @@ static void which_tmpdir(void)
 	printf("Checking for tmpfs mount on /dev/shm...");
 
 	fd = open("/proc/mounts", O_RDONLY);
-	if(fd < 0){
+	if (fd < 0) {
 		printf("failed to open /proc/mounts, errno = %d\n", errno);
 		return;
 	}
 
-	while(1){
+	while (1) {
 		found = next(fd, buf, ARRAY_SIZE(buf), ' ');
-		if(found != 1)
+		if (found != 1)
 			break;
 
-		if(!strncmp(buf, "/dev/shm", strlen("/dev/shm")))
+		if (!strncmp(buf, "/dev/shm", strlen("/dev/shm")))
 			goto found;
 
 		found = next(fd, buf, ARRAY_SIZE(buf), '\n');
-		if(found != 1)
+		if (found != 1)
 			break;
 	}
 
 err:
-	if(found == 0)
+	if (found == 0)
 		printf("nothing mounted on /dev/shm\n");
-	else if(found < 0)
+	else if (found < 0)
 		printf("read returned errno %d\n", -found);
 
 out:
@@ -146,10 +149,10 @@ out:
 
 found:
 	found = next(fd, buf, ARRAY_SIZE(buf), ' ');
-	if(found != 1)
+	if (found != 1)
 		goto err;
 
-	if(strncmp(buf, "tmpfs", strlen("tmpfs"))){
+	if (strncmp(buf, "tmpfs", strlen("tmpfs"))) {
 		printf("not tmpfs\n");
 		goto out;
 	}
@@ -164,8 +167,8 @@ found:
  * (file: kernel/tt/ptproxy/proxy.c, proc: start_debugger).
  * So it isn't 'static' yet.
  */
-int __init make_tempfile(const char *template, char **out_tempname,
-			 int do_unlink)
+static int __init make_tempfile(const char *template, char **out_tempname,
+				int do_unlink)
 {
 	char *tempname;
 	int fd;
@@ -182,16 +185,16 @@ int __init make_tempfile(const char *tem
 		tempname[0] = '\0';
 	strncat(tempname, template, MAXPATHLEN-1-strlen(tempname));
 	fd = mkstemp(tempname);
-	if(fd < 0){
+	if (fd < 0) {
 		fprintf(stderr, "open - cannot create %s: %s\n", tempname,
 			strerror(errno));
 		goto out;
 	}
-	if(do_unlink && (unlink(tempname) < 0)){
+	if (do_unlink && (unlink(tempname) < 0)) {
 		perror("unlink");
 		goto out;
 	}
-	if(out_tempname){
+	if (out_tempname) {
 		*out_tempname = tempname;
 	} else {
 		free(tempname);
@@ -204,27 +207,23 @@ out:
 
 #define TEMPNAME_TEMPLATE "vm_file-XXXXXX"
 
-/*
- * This proc is used in start_up.c
- * So it isn't 'static'.
- */
-int __init create_tmp_file(unsigned long long len)
+static int __init create_tmp_file(unsigned long long len)
 {
 	int fd, err;
 	char zero;
 
 	fd = make_tempfile(TEMPNAME_TEMPLATE, NULL, 1);
-	if(fd < 0) {
+	if (fd < 0)
 		exit(1);
-	}
 
 	err = fchmod(fd, 0777);
-	if(err < 0){
+	if (err < 0) {
 		perror("fchmod");
 		exit(1);
 	}
 
-	/* Seek to len - 1 because writing a character there will
+	/*
+	 * Seek to len - 1 because writing a character there will
 	 * increase the file size by one byte, to the desired length.
 	 */
 	if (lseek64(fd, len - 1, SEEK_SET) < 0) {
@@ -235,7 +234,7 @@ int __init create_tmp_file(unsigned long
 	zero = 0;
 
 	err = write(fd, &zero, 1);
-	if(err != 1){
+	if (err != 1) {
 		perror("write");
 		exit(1);
 	}
@@ -250,7 +249,7 @@ int __init create_mem_file(unsigned long
 	fd = create_tmp_file(len);
 
 	err = os_set_exec_close(fd);
-	if(err < 0){
+	if (err < 0) {
 		errno = -err;
 		perror("exec_close");
 	}
@@ -267,11 +266,11 @@ void __init check_tmpexec(void)
 		    PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE, fd, 0);
 	printf("Checking PROT_EXEC mmap in %s...",tempdir);
 	fflush(stdout);
-	if(addr == MAP_FAILED){
+	if (addr == MAP_FAILED) {
 		err = errno;
 		perror("failed");
 		close(fd);
-		if(err == EPERM)
+		if (err == EPERM)
 			printf("%s must be not mounted noexec\n",tempdir);
 		exit(1);
 	}
diff -puN arch/um/os-Linux/process.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/process.c
@@ -224,7 +224,7 @@ int __init can_drop_memory(void)
 		goto out_unmap;
 	}
 
-	printk("OK\n");
+	printk(UM_KERN_CONT "OK\n");
 	ok = 1;
 
 out_unmap:
diff -puN arch/um/os-Linux/signal.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/signal.c
@@ -237,7 +237,7 @@ void unblock_signals(void)
 	 * interrupts may have arrived and we need to re-enable them and
 	 * recheck signals_pending.
 	 */
-	while(1) {
+	while (1) {
 		/*
 		 * Save and reset save_pending after enabling signals.  This
 		 * way, signals_pending won't be changed while we're reading it.
diff -puN arch/um/os-Linux/skas/process.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/skas/process.c
@@ -341,7 +341,7 @@ void userspace(struct uml_pt_regs *regs)
 	int local_using_sysemu;
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
-		printk("Failed to get itimer, errno = %d\n", errno);
+		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
 	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
 		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
@@ -388,7 +388,7 @@ void userspace(struct uml_pt_regs *regs)
 
 		if (WIFSTOPPED(status)) {
 			int sig = WSTOPSIG(status);
-		  	switch(sig) {
+			switch (sig) {
 			case SIGSEGV:
 				if (PTRACE_FULL_FAULTINFO ||
 				    !ptrace_faultinfo) {
@@ -641,7 +641,7 @@ int start_idle_thread(void *stack, jmp_b
 	 * after returning to the jumper.
 	 */
 	n = setjmp(initial_jmpbuf);
-	switch(n) {
+	switch (n) {
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
 		(*switch_buf)[0].JB_SP = (unsigned long) stack +
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -62,10 +62,10 @@ void arch_init_registers(int pid)
 	int err;
 
 	err = ptrace(PTRACE_GETFPXREGS, pid, 0, fpx_regs);
-	if(!err)
+	if (!err)
 		return;
 
-	if(errno != EIO)
+	if (errno != EIO)
 		panic("check_ptrace : PTRACE_GETFPXREGS failed, errno = %d",
 		      errno);
 
diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006-2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2006 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -7,31 +7,36 @@
 #include <sys/ptrace.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
+#include "kern_constants.h"
 #include "longjmp.h"
 #include "user.h"
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
-	switch(reg){
-	case RIP: return buf[0]->__rip;
-	case RSP: return buf[0]->__rsp;
-	case RBP: return buf[0]->__rbp;
+	switch (reg) {
+	case RIP:
+		return buf[0]->__rip;
+	case RSP:
+		return buf[0]->__rsp;
+	case RBP:
+		return buf[0]->__rbp;
 	default:
-		printk("get_thread_regs - unknown register %d\n", reg);
+		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
+		       reg);
 		return 0;
 	}
 }
diff -puN arch/um/os-Linux/uaccess.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/uaccess.c
--- a/arch/um/os-Linux/uaccess.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/uaccess.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 Chris Emerson (cemerson@chiark.greenend.org.uk)
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -16,7 +16,7 @@ unsigned long __do_user_copy(void *to, c
 
 	jmp_buf jbuf;
 	*fault_catcher = &jbuf;
-	if(UML_SETJMP(&jbuf) == 0){
+	if (UML_SETJMP(&jbuf) == 0) {
 		(*op)(to, from, n);
 		ret = 0;
 		*faulted_out = 0;
diff -puN arch/um/os-Linux/user_syms.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/user_syms.c
--- a/arch/um/os-Linux/user_syms.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/user_syms.c
@@ -34,8 +34,8 @@ EXPORT_SYMBOL(printf);
  * good; so the versions of these symbols will always match
  */
 #define EXPORT_SYMBOL_PROTO(sym)       \
-       int sym(void);                  \
-       EXPORT_SYMBOL(sym);
+	int sym(void);                  \
+	EXPORT_SYMBOL(sym);
 
 extern void readdir64(void) __attribute__((weak));
 EXPORT_SYMBOL(readdir64);
diff -puN arch/um/os-Linux/util.c~uml-style-fixes-in-arch-um-os-linux arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-style-fixes-in-arch-um-os-linux
+++ a/arch/um/os-Linux/util.c
@@ -1,39 +1,24 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <limits.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/utsname.h>
-#include <sys/param.h>
-#include <sys/time.h>
-#include "asm/types.h"
-#include <ctype.h>
-#include <signal.h>
-#include <wait.h>
 #include <errno.h>
-#include <stdarg.h>
-#include <sched.h>
-#include <termios.h>
+#include <signal.h>
 #include <string.h>
-#include "kern_util.h"
-#include "user.h"
-#include "mem_user.h"
-#include "init.h"
-#include "ptrace_user.h"
-#include "uml-config.h"
-#include "os.h"
-#include "longjmp.h"
+#include <termios.h>
+#include <wait.h>
+#include <sys/mman.h>
+#include <sys/utsname.h>
 #include "kern_constants.h"
+#include "os.h"
+#include "user.h"
 
 void stack_protections(unsigned long address)
 {
-	if(mprotect((void *) address, UM_THREAD_SIZE,
+	if (mprotect((void *) address, UM_THREAD_SIZE,
 		    PROT_READ | PROT_WRITE | PROT_EXEC) < 0)
 		panic("protecting stack failed, errno = %d", errno);
 }
@@ -44,17 +29,19 @@ int raw(int fd)
 	int err;
 
 	CATCH_EINTR(err = tcgetattr(fd, &tt));
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
 	cfmakeraw(&tt);
 
 	CATCH_EINTR(err = tcsetattr(fd, TCSADRAIN, &tt));
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
-	/* XXX tcsetattr could have applied only some changes
-	 * (and cfmakeraw() is a set of changes) */
+	/*
+	 * XXX tcsetattr could have applied only some changes
+	 * (and cfmakeraw() is a set of changes)
+	 */
 	return 0;
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
git-kvm.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
