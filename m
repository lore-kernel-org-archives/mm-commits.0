From: akpm@linux-foundation.org
Subject: + uml-remove-os_-usage-from-userspace-files.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:36 -0700
Message-ID: <200708162114.l7GLEaOo007113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759632AbXHPVOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove os_* usage from userspace files
has been added to the -mm tree.  Its filename is
     uml-remove-os_-usage-from-userspace-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove os_* usage from userspace files
From: Jeff Dike <jdike@addtoit.com>

This patch fixes some userspace files which were calling libc through the os_*
wrappers.

It turns out that there was only one user of os_new_tty_pgrp, so it can be
deleted.

There are also some style and whitespace fixes in here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c            |   37 +++--
 arch/um/drivers/harddog_user.c         |   54 ++++----
 arch/um/include/mconsole.h             |   13 -
 arch/um/include/os.h                   |    1 
 arch/um/include/sysdep-i386/ptrace.h   |    3 
 arch/um/include/sysdep-x86_64/ptrace.h |  152 +++++++++++------------
 arch/um/kernel/skas/uaccess.c          |  134 +++++++++-----------
 arch/um/os-Linux/file.c                |   11 -
 8 files changed, 186 insertions(+), 219 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-remove-os_-usage-from-userspace-files arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/drivers/chan_user.c
@@ -134,12 +134,12 @@ static int winch_thread(void *arg)
 	struct winch_data *data = arg;
 	sigset_t sigs;
 	int pty_fd, pipe_fd;
-	int count, err;
+	int count;
 	char c = 1;
 
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
-	count = os_write_file(pipe_fd, &c, sizeof(c));
+	count = write(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
 		printk(UM_KERN_ERR "winch_thread : failed to write "
 		       "synchronization byte, err = %d\n", -count);
@@ -167,10 +167,15 @@ static int winch_thread(void *arg)
 		exit(1);
 	}
 
-	err = os_new_tty_pgrp(pty_fd, os_getpid());
-	if (err < 0) {
-		printk(UM_KERN_ERR "winch_thread : new_tty_pgrp failed on "
-		       "fd %d err = %d\n", pty_fd, -err);
+	if(ioctl(pty_fd, TIOCSCTTY, 0) < 0){
+		printk(UM_KERN_ERR "winch_thread : TIOCSCTTY failed on "
+		       "fd %d err = %d\n", pty_fd, errno);
+		exit(1);
+	}
+
+	if(tcsetpgrp(pty_fd, os_getpid()) < 0){
+		printk(UM_KERN_ERR "winch_thread : tcsetpgrp failed on "
+		       "fd %d err = %d\n", pty_fd, errno);
 		exit(1);
 	}
 
@@ -180,10 +185,10 @@ static int winch_thread(void *arg)
 	 * kernel semaphores. We don't use SysV semaphores because they are
 	 * persistent.
 	 */
-	count = os_read_file(pipe_fd, &c, sizeof(c));
+	count = read(pipe_fd, &c, sizeof(c));
 	if (count != sizeof(c))
 		printk(UM_KERN_ERR "winch_thread : failed to read "
-		       "synchronization byte, err = %d\n", -count);
+		       "synchronization byte, err = %d\n", errno);
 
 	while(1) {
 		/*
@@ -192,10 +197,10 @@ static int winch_thread(void *arg)
 		 */
 		sigsuspend(&sigs);
 
-		count = os_write_file(pipe_fd, &c, sizeof(c));
+		count = write(pipe_fd, &c, sizeof(c));
 		if (count != sizeof(c))
 			printk(UM_KERN_ERR "winch_thread : write failed, "
-			       "err = %d\n", -count);
+			       "err = %d\n", errno);
 	}
 }
 
@@ -229,11 +234,11 @@ static int winch_tramp(int fd, struct tt
 	}
 
 	*fd_out = fds[0];
-	n = os_read_file(fds[0], &c, sizeof(c));
+	n = read(fds[0], &c, sizeof(c));
 	if (n != sizeof(c)) {
 		printk(UM_KERN_ERR "winch_tramp : failed to read "
 		       "synchronization byte\n");
-		printk(UM_KERN_ERR "read failed, err = %d\n", -n);
+		printk(UM_KERN_ERR "read failed, err = %d\n", errno);
 		printk(UM_KERN_ERR "fd %d will not support SIGWINCH\n", fd);
 		err = -EINVAL;
 		goto out_close;
@@ -248,8 +253,8 @@ static int winch_tramp(int fd, struct tt
 	return err;
 
  out_close:
-	os_close_file(fds[1]);
-	os_close_file(fds[0]);
+	close(fds[1]);
+	close(fds[0]);
  out:
 	return err;
 }
@@ -271,9 +276,9 @@ void register_winch(int fd, struct tty_s
 
 		register_winch_irq(thread_fd, fd, thread, tty, stack);
 
-		count = os_write_file(thread_fd, &c, sizeof(c));
+		count = write(thread_fd, &c, sizeof(c));
 		if (count != sizeof(c))
 			printk(UM_KERN_ERR "register_winch : failed to write "
-			       "synchronization byte, err = %d\n", -count);
+			       "synchronization byte, err = %d\n", errno);
 	}
 }
diff -puN arch/um/drivers/harddog_user.c~uml-remove-os_-usage-from-userspace-files arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/drivers/harddog_user.c
@@ -1,14 +1,13 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
-#include "user.h"
-#include "mconsole.h"
 #include "os.h"
+#include "user.h"
 
 struct dog_data {
 	int stdin;
@@ -23,10 +22,10 @@ static void pre_exec(void *d)
 	dup2(data->stdin, 0);
 	dup2(data->stdout, 1);
 	dup2(data->stdout, 2);
-	os_close_file(data->stdin);
-	os_close_file(data->stdout);
-	os_close_file(data->close_me[0]);
-	os_close_file(data->close_me[1]);
+	close(data->stdin);
+	close(data->stdout);
+	close(data->close_me[0]);
+	close(data->close_me[1]);
 }
 
 int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
@@ -40,13 +39,13 @@ int start_watchdog(int *in_fd_ret, int *
 	char **args = NULL;
 
 	err = os_pipe(in_fds, 1, 0);
-	if(err < 0){
+	if (err < 0) {
 		printk("harddog_open - os_pipe failed, err = %d\n", -err);
 		goto out;
 	}
 
 	err = os_pipe(out_fds, 1, 0);
-	if(err < 0){
+	if (err < 0) {
 		printk("harddog_open - os_pipe failed, err = %d\n", -err);
 		goto out_close_in;
 	}
@@ -56,7 +55,7 @@ int start_watchdog(int *in_fd_ret, int *
 	data.close_me[0] = out_fds[1];
 	data.close_me[1] = in_fds[0];
 
-	if(sock != NULL){
+	if (sock != NULL) {
 		mconsole_args[2] = sock;
 		args = mconsole_args;
 	}
@@ -68,25 +67,25 @@ int start_watchdog(int *in_fd_ret, int *
 
 	pid = run_helper(pre_exec, &data, args);
 
-	os_close_file(out_fds[0]);
-	os_close_file(in_fds[1]);
+	close(out_fds[0]);
+	close(in_fds[1]);
 
-	if(pid < 0){
+	if (pid < 0) {
 		err = -pid;
 		printk("harddog_open - run_helper failed, errno = %d\n", -err);
 		goto out_close_out;
 	}
 
-	n = os_read_file(in_fds[0], &c, sizeof(c));
-	if(n == 0){
+	n = read(in_fds[0], &c, sizeof(c));
+	if (n == 0) {
 		printk("harddog_open - EOF on watchdog pipe\n");
 		helper_wait(pid);
 		err = -EIO;
 		goto out_close_out;
 	}
-	else if(n < 0){
+	else if (n < 0) {
 		printk("harddog_open - read of watchdog pipe failed, "
-		       "err = %d\n", -n);
+		       "err = %d\n", errno);
 		helper_wait(pid);
 		err = n;
 		goto out_close_out;
@@ -96,19 +95,19 @@ int start_watchdog(int *in_fd_ret, int *
 	return 0;
 
  out_close_in:
-	os_close_file(in_fds[0]);
-	os_close_file(in_fds[1]);
+	close(in_fds[0]);
+	close(in_fds[1]);
  out_close_out:
-	os_close_file(out_fds[0]);
-	os_close_file(out_fds[1]);
+	close(out_fds[0]);
+	close(out_fds[1]);
  out:
 	return err;
 }
 
 void stop_watchdog(int in_fd, int out_fd)
 {
-	os_close_file(in_fd);
-	os_close_file(out_fd);
+	close(in_fd);
+	close(out_fd);
 }
 
 int ping_watchdog(int fd)
@@ -116,10 +115,11 @@ int ping_watchdog(int fd)
 	int n;
 	char c = '\n';
 
-	n = os_write_file(fd, &c, sizeof(c));
-	if(n != sizeof(c)){
-		printk("ping_watchdog - write failed, err = %d\n", -n);
-		if(n < 0)
+	n = write(fd, &c, sizeof(c));
+	if (n != sizeof(c)) {
+		printk("ping_watchdog - write failed, ret = %d, err = %d\n",
+		       n, errno);
+		if (n < 0)
 			return n;
 		return -EIO;
 	}
diff -puN arch/um/include/mconsole.h~uml-remove-os_-usage-from-userspace-files arch/um/include/mconsole.h
--- a/arch/um/include/mconsole.h~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/include/mconsole.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -96,14 +96,3 @@ extern void lock_notify(void);
 extern void unlock_notify(void);
 
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
diff -puN arch/um/include/os.h~uml-remove-os_-usage-from-userspace-files arch/um/include/os.h
--- a/arch/um/include/os.h~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/include/os.h
@@ -132,7 +132,6 @@ extern void os_print_error(int error, co
 extern int os_get_exec_close(int fd, int *close_on_exec);
 extern int os_set_exec_close(int fd, int close_on_exec);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
-extern int os_new_tty_pgrp(int fd, int pid);
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
 extern int os_set_owner(int fd, int pid);
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-remove-os_-usage-from-userspace-files arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
@@ -130,7 +130,6 @@ struct syscall_args {
 		} \
 	        val; \
 	})
-	
 
 #define UPT_SET(regs, reg, val) \
 	do { \
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-remove-os_-usage-from-userspace-files arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -143,87 +143,87 @@ struct syscall_args {
 };
 
 #define SYSCALL_ARGS(r) ((struct syscall_args) \
-                        { .args = { UPT_SYSCALL_ARG1(r), \
-                                    UPT_SYSCALL_ARG2(r), \
- 			            UPT_SYSCALL_ARG3(r), \
-                                    UPT_SYSCALL_ARG4(r), \
-		                    UPT_SYSCALL_ARG5(r), \
-                                    UPT_SYSCALL_ARG6(r) } } )
+			 { .args = { UPT_SYSCALL_ARG1(r),	 \
+				     UPT_SYSCALL_ARG2(r),	 \
+				     UPT_SYSCALL_ARG3(r),	 \
+				     UPT_SYSCALL_ARG4(r),	 \
+				     UPT_SYSCALL_ARG5(r),	 \
+				     UPT_SYSCALL_ARG6(r) } } )
 
 #define UPT_REG(regs, reg) \
-        ({      unsigned long val; \
-                switch(reg){ \
-		case R8: val = UPT_R8(regs); break; \
-		case R9: val = UPT_R9(regs); break; \
-		case R10: val = UPT_R10(regs); break; \
-		case R11: val = UPT_R11(regs); break; \
-		case R12: val = UPT_R12(regs); break; \
-		case R13: val = UPT_R13(regs); break; \
-		case R14: val = UPT_R14(regs); break; \
-		case R15: val = UPT_R15(regs); break; \
-                case RIP: val = UPT_IP(regs); break; \
-                case RSP: val = UPT_SP(regs); break; \
-                case RAX: val = UPT_RAX(regs); break; \
-                case RBX: val = UPT_RBX(regs); break; \
-                case RCX: val = UPT_RCX(regs); break; \
-                case RDX: val = UPT_RDX(regs); break; \
-                case RSI: val = UPT_RSI(regs); break; \
-                case RDI: val = UPT_RDI(regs); break; \
-                case RBP: val = UPT_RBP(regs); break; \
-                case ORIG_RAX: val = UPT_ORIG_RAX(regs); break; \
-                case CS: val = UPT_CS(regs); break; \
-                case SS: val = UPT_SS(regs); break; \
-		case FS_BASE: val = UPT_FS_BASE(regs); break; \
-                case GS_BASE: val = UPT_GS_BASE(regs); break; \
-                case DS: val = UPT_DS(regs); break; \
-                case ES: val = UPT_ES(regs); break; \
-                case FS : val = UPT_FS (regs); break; \
-		case GS: val = UPT_GS(regs); break;	    \
-                case EFLAGS: val = UPT_EFLAGS(regs); break; \
-                default :  \
-                        panic("Bad register in UPT_REG : %d\n", reg);  \
-                        val = -1; \
-                } \
-                val; \
-        })
+	({      unsigned long val;		\
+		switch(reg){						\
+		case R8: val = UPT_R8(regs); break;			\
+		case R9: val = UPT_R9(regs); break;			\
+		case R10: val = UPT_R10(regs); break;			\
+		case R11: val = UPT_R11(regs); break;			\
+		case R12: val = UPT_R12(regs); break;			\
+		case R13: val = UPT_R13(regs); break;			\
+		case R14: val = UPT_R14(regs); break;			\
+		case R15: val = UPT_R15(regs); break;			\
+		case RIP: val = UPT_IP(regs); break;			\
+		case RSP: val = UPT_SP(regs); break;			\
+		case RAX: val = UPT_RAX(regs); break;			\
+		case RBX: val = UPT_RBX(regs); break;			\
+		case RCX: val = UPT_RCX(regs); break;			\
+		case RDX: val = UPT_RDX(regs); break;			\
+		case RSI: val = UPT_RSI(regs); break;			\
+		case RDI: val = UPT_RDI(regs); break;			\
+		case RBP: val = UPT_RBP(regs); break;			\
+		case ORIG_RAX: val = UPT_ORIG_RAX(regs); break;		\
+		case CS: val = UPT_CS(regs); break;			\
+		case SS: val = UPT_SS(regs); break;			\
+		case FS_BASE: val = UPT_FS_BASE(regs); break;		\
+		case GS_BASE: val = UPT_GS_BASE(regs); break;		\
+		case DS: val = UPT_DS(regs); break;			\
+		case ES: val = UPT_ES(regs); break;			\
+		case FS : val = UPT_FS (regs); break;			\
+		case GS: val = UPT_GS(regs); break;			\
+		case EFLAGS: val = UPT_EFLAGS(regs); break;		\
+		default :						\
+			panic("Bad register in UPT_REG : %d\n", reg);	\
+			val = -1;					\
+		}							\
+		val;							\
+	})
 
 
 #define UPT_SET(regs, reg, val) \
-        ({      unsigned long __upt_val = val; \
-                switch(reg){ \
-                case R8: UPT_R8(regs) = __upt_val; break; \
-                case R9: UPT_R9(regs) = __upt_val; break; \
-                case R10: UPT_R10(regs) = __upt_val; break; \
-                case R11: UPT_R11(regs) = __upt_val; break; \
-                case R12: UPT_R12(regs) = __upt_val; break; \
-                case R13: UPT_R13(regs) = __upt_val; break; \
-                case R14: UPT_R14(regs) = __upt_val; break; \
-                case R15: UPT_R15(regs) = __upt_val; break; \
-                case RIP: UPT_IP(regs) = __upt_val; break; \
-                case RSP: UPT_SP(regs) = __upt_val; break; \
-                case RAX: UPT_RAX(regs) = __upt_val; break; \
-                case RBX: UPT_RBX(regs) = __upt_val; break; \
-                case RCX: UPT_RCX(regs) = __upt_val; break; \
-                case RDX: UPT_RDX(regs) = __upt_val; break; \
-                case RSI: UPT_RSI(regs) = __upt_val; break; \
-                case RDI: UPT_RDI(regs) = __upt_val; break; \
-                case RBP: UPT_RBP(regs) = __upt_val; break; \
-                case ORIG_RAX: UPT_ORIG_RAX(regs) = __upt_val; break; \
-                case CS: UPT_CS(regs) = __upt_val; break; \
-                case SS: UPT_SS(regs) = __upt_val; break; \
-                case FS_BASE: UPT_FS_BASE(regs) = __upt_val; break; \
-                case GS_BASE: UPT_GS_BASE(regs) = __upt_val; break; \
-                case DS: UPT_DS(regs) = __upt_val; break; \
-                case ES: UPT_ES(regs) = __upt_val; break; \
-                case FS: UPT_FS(regs) = __upt_val; break; \
-                case GS: UPT_GS(regs) = __upt_val; break; \
-                case EFLAGS: UPT_EFLAGS(regs) = __upt_val; break; \
-                default :  \
-                        panic("Bad register in UPT_SET : %d\n", reg);  \
-			break; \
-                } \
-                __upt_val; \
-        })
+	({      unsigned long __upt_val = val;	\
+		switch(reg){						\
+		case R8: UPT_R8(regs) = __upt_val; break;		\
+		case R9: UPT_R9(regs) = __upt_val; break;		\
+		case R10: UPT_R10(regs) = __upt_val; break;		\
+		case R11: UPT_R11(regs) = __upt_val; break;		\
+		case R12: UPT_R12(regs) = __upt_val; break;		\
+		case R13: UPT_R13(regs) = __upt_val; break;		\
+		case R14: UPT_R14(regs) = __upt_val; break;		\
+		case R15: UPT_R15(regs) = __upt_val; break;		\
+		case RIP: UPT_IP(regs) = __upt_val; break;		\
+		case RSP: UPT_SP(regs) = __upt_val; break;		\
+		case RAX: UPT_RAX(regs) = __upt_val; break;		\
+		case RBX: UPT_RBX(regs) = __upt_val; break;		\
+		case RCX: UPT_RCX(regs) = __upt_val; break;		\
+		case RDX: UPT_RDX(regs) = __upt_val; break;		\
+		case RSI: UPT_RSI(regs) = __upt_val; break;		\
+		case RDI: UPT_RDI(regs) = __upt_val; break;		\
+		case RBP: UPT_RBP(regs) = __upt_val; break;		\
+		case ORIG_RAX: UPT_ORIG_RAX(regs) = __upt_val; break;	\
+		case CS: UPT_CS(regs) = __upt_val; break;		\
+		case SS: UPT_SS(regs) = __upt_val; break;		\
+		case FS_BASE: UPT_FS_BASE(regs) = __upt_val; break;	\
+		case GS_BASE: UPT_GS_BASE(regs) = __upt_val; break;	\
+		case DS: UPT_DS(regs) = __upt_val; break;		\
+		case ES: UPT_ES(regs) = __upt_val; break;		\
+		case FS: UPT_FS(regs) = __upt_val; break;		\
+		case GS: UPT_GS(regs) = __upt_val; break;		\
+		case EFLAGS: UPT_EFLAGS(regs) = __upt_val; break;	\
+		default :						\
+			panic("Bad register in UPT_SET : %d\n", reg);	\
+			break;						\
+		}							\
+		__upt_val;						\
+	})
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
 	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
diff -puN arch/um/kernel/skas/uaccess.c~uml-remove-os_-usage-from-userspace-files arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/kernel/skas/uaccess.c
@@ -1,18 +1,14 @@
 /*
- * Copyright (C) 2002 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/compiler.h"
-#include "linux/stddef.h"
-#include "linux/kernel.h"
-#include "linux/string.h"
-#include "linux/fs.h"
-#include "linux/hardirq.h"
+#include "linux/err.h"
 #include "linux/highmem.h"
+#include "linux/mm.h"
+#include "asm/current.h"
 #include "asm/page.h"
 #include "asm/pgtable.h"
-#include "asm/uaccess.h"
 #include "kern_util.h"
 #include "os.h"
 
@@ -27,16 +23,16 @@ static unsigned long maybe_map(unsigned 
 	void *phys = um_virt_to_phys(current, virt, &pte);
 	int dummy_code;
 
-	if(IS_ERR(phys) || (is_write && !pte_write(pte))){
+	if (IS_ERR(phys) || (is_write && !pte_write(pte))) {
 		err = handle_page_fault(virt, 0, is_write, 1, &dummy_code);
-		if(err)
-			return(-1UL);
+		if (err)
+			return -1UL;
 		phys = um_virt_to_phys(current, virt, NULL);
 	}
-        if(IS_ERR(phys))
-                phys = (void *) -1;
+	if (IS_ERR(phys))
+		phys = (void *) -1;
 
-	return((unsigned long) phys);
+	return (unsigned long) phys;
 }
 
 static int do_op_one_page(unsigned long addr, int len, int is_write,
@@ -46,17 +42,18 @@ static int do_op_one_page(unsigned long 
 	int n;
 
 	addr = maybe_map(addr, is_write);
-	if(addr == -1UL)
-		return(-1);
+	if (addr == -1UL)
+		return -1;
 
 	page = phys_to_page(addr);
-	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) + (addr & ~PAGE_MASK);
+	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
+		(addr & ~PAGE_MASK);
 
 	n = (*op)(addr, len, arg);
 
 	kunmap_atomic(page, KM_UML_USERCOPY);
 
-	return(n);
+	return n;
 }
 
 static void do_buffer_op(void *jmpbuf, void *arg_ptr)
@@ -81,21 +78,21 @@ static void do_buffer_op(void *jmpbuf, v
 
 	current->thread.fault_catcher = jmpbuf;
 	n = do_op_one_page(addr, size, is_write, op, arg);
-	if(n != 0){
+	if (n != 0) {
 		*res = (n < 0 ? remain : 0);
 		goto out;
 	}
 
 	addr += size;
 	remain -= size;
-	if(remain == 0){
+	if (remain == 0) {
 		*res = 0;
 		goto out;
 	}
 
-	while(addr < ((addr + remain) & PAGE_MASK)){
+	while(addr < ((addr + remain) & PAGE_MASK)) {
 		n = do_op_one_page(addr, PAGE_SIZE, is_write, op, arg);
-		if(n != 0){
+		if (n != 0) {
 			*res = (n < 0 ? remain : 0);
 			goto out;
 		}
@@ -103,13 +100,13 @@ static void do_buffer_op(void *jmpbuf, v
 		addr += PAGE_SIZE;
 		remain -= PAGE_SIZE;
 	}
-	if(remain == 0){
+	if (remain == 0) {
 		*res = 0;
 		goto out;
 	}
 
 	n = do_op_one_page(addr, remain, is_write, op, arg);
-	if(n != 0)
+	if (n != 0)
 		*res = (n < 0 ? remain : 0);
 	else *res = 0;
  out:
@@ -124,10 +121,10 @@ static int buffer_op(unsigned long addr,
 
 	faulted = setjmp_wrapper(do_buffer_op, addr, len, is_write, op, arg,
 				 &res);
-	if(!faulted)
-		return(res);
+	if (!faulted)
+		return res;
 
-	return(addr + len - (unsigned long) current->thread.fault_addr);
+	return addr + len - (unsigned long) current->thread.fault_addr;
 }
 
 static int copy_chunk_from_user(unsigned long from, int len, void *arg)
@@ -136,19 +133,19 @@ static int copy_chunk_from_user(unsigned
 
 	memcpy((void *) to, (void *) from, len);
 	*to_ptr += len;
-	return(0);
+	return 0;
 }
 
 int copy_from_user(void *to, const void __user *from, int n)
 {
-	if(segment_eq(get_fs(), KERNEL_DS)){
+	if (segment_eq(get_fs(), KERNEL_DS)) {
 		memcpy(to, (__force void*)from, n);
-		return(0);
+		return 0;
 	}
 
-	return(access_ok(VERIFY_READ, from, n) ?
+	return access_ok(VERIFY_READ, from, n) ?
 	       buffer_op((unsigned long) from, n, 0, copy_chunk_from_user, &to):
-	       n);
+	       n;
 }
 
 static int copy_chunk_to_user(unsigned long to, int len, void *arg)
@@ -157,19 +154,19 @@ static int copy_chunk_to_user(unsigned l
 
 	memcpy((void *) to, (void *) from, len);
 	*from_ptr += len;
-	return(0);
+	return 0;
 }
 
 int copy_to_user(void __user *to, const void *from, int n)
 {
-	if(segment_eq(get_fs(), KERNEL_DS)){
-		memcpy((__force void*)to, from, n);
-		return(0);
+	if (segment_eq(get_fs(), KERNEL_DS)) {
+		memcpy((__force void *) to, from, n);
+		return 0;
 	}
 
-	return(access_ok(VERIFY_WRITE, to, n) ?
+	return access_ok(VERIFY_WRITE, to, n) ?
 	       buffer_op((unsigned long) to, n, 1, copy_chunk_to_user, &from) :
-	       n);
+	       n;
 }
 
 static int strncpy_chunk_from_user(unsigned long from, int len, void *arg)
@@ -181,9 +178,9 @@ static int strncpy_chunk_from_user(unsig
 	n = strnlen(to, len);
 	*to_ptr += n;
 
-	if(n < len)
-	        return(1);
-	return(0);
+	if (n < len)
+	        return 1;
+	return 0;
 }
 
 int strncpy_from_user(char *dst, const char __user *src, int count)
@@ -191,41 +188,41 @@ int strncpy_from_user(char *dst, const c
 	int n;
 	char *ptr = dst;
 
-	if(segment_eq(get_fs(), KERNEL_DS)){
-		strncpy(dst, (__force void*)src, count);
-		return(strnlen(dst, count));
+	if (segment_eq(get_fs(), KERNEL_DS)) {
+		strncpy(dst, (__force void *) src, count);
+		return strnlen(dst, count);
 	}
 
-	if(!access_ok(VERIFY_READ, src, 1))
-		return(-EFAULT);
+	if (!access_ok(VERIFY_READ, src, 1))
+		return -EFAULT;
 
 	n = buffer_op((unsigned long) src, count, 0, strncpy_chunk_from_user,
 		      &ptr);
-	if(n != 0)
-		return(-EFAULT);
-	return(strnlen(dst, count));
+	if (n != 0)
+		return -EFAULT;
+	return strnlen(dst, count);
 }
 
 static int clear_chunk(unsigned long addr, int len, void *unused)
 {
 	memset((void *) addr, 0, len);
-	return(0);
+	return 0;
 }
 
 int __clear_user(void __user *mem, int len)
 {
-	return(buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL));
+	return buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL);
 }
 
 int clear_user(void __user *mem, int len)
 {
-	if(segment_eq(get_fs(), KERNEL_DS)){
+	if (segment_eq(get_fs(), KERNEL_DS)) {
 		memset((__force void*)mem, 0, len);
-		return(0);
+		return 0;
 	}
 
-	return(access_ok(VERIFY_WRITE, mem, len) ?
-	       buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL) : len);
+	return access_ok(VERIFY_WRITE, mem, len) ?
+	       buffer_op((unsigned long) mem, len, 1, clear_chunk, NULL) : len;
 }
 
 static int strnlen_chunk(unsigned long str, int len, void *arg)
@@ -235,31 +232,20 @@ static int strnlen_chunk(unsigned long s
 	n = strnlen((void *) str, len);
 	*len_ptr += n;
 
-	if(n < len)
-		return(1);
-	return(0);
+	if (n < len)
+		return 1;
+	return 0;
 }
 
 int strnlen_user(const void __user *str, int len)
 {
 	int count = 0, n;
 
-	if(segment_eq(get_fs(), KERNEL_DS))
-		return(strnlen((__force char*)str, len) + 1);
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return strnlen((__force char*)str, len) + 1;
 
 	n = buffer_op((unsigned long) str, len, 0, strnlen_chunk, &count);
-	if(n == 0)
-		return(count + 1);
-	return(-EFAULT);
+	if (n == 0)
+		return count + 1;
+	return -EFAULT;
 }
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
diff -puN arch/um/os-Linux/file.c~uml-remove-os_-usage-from-userspace-files arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-remove-os_-usage-from-userspace-files
+++ a/arch/um/os-Linux/file.c
@@ -101,17 +101,6 @@ int os_ioctl_generic(int fd, unsigned in
 	return err;
 }
 
-int os_new_tty_pgrp(int fd, int pid)
-{
-	if(ioctl(fd, TIOCSCTTY, 0) < 0)
-		return -errno;
-
-	if(tcsetpgrp(fd, pid) < 0)
-		return -errno;
-
-	return 0;
-}
-
 /* FIXME: ensure namebuf in os_get_if_name is big enough */
 int os_get_ifname(int fd, char* namebuf)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
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
