From: akpm@linux-foundation.org
Subject: - uml-tidy-helper-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:39 -0800
Message-ID: <200802052237.m15MbKDd012844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761096AbYBEWmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: tidy helper code
has been removed from the -mm tree.  Its filename was
     uml-tidy-helper-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: tidy helper code
From: Jeff Dike <jdike@addtoit.com>

Style fixes to arch/um/os/helper.c and tidying up the breakpoint fix a
bit.

helper.c gets all the usual style fixes -
	 updated copyright
	 all printks get severities

Also -
	 errval changes to err in helper_child
	 fixed an obsolete comment
	 run_helper was killing a child process which is guaranteed to
be dead or dying anyway

Removed the nohang and pname arguments from helper_wait and fixed the
declaration and callers.  nohang was used only in the slirp driver and
I don't think it was needed.  I think pname was a bit of overkill in
putting out an error message when something goes wrong.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_user.c               |    2 
 arch/um/drivers/slip_user.c              |    2 
 arch/um/drivers/slirp_user.c             |    2 
 arch/um/include/os.h                     |    2 
 arch/um/os-Linux/drivers/ethertap_user.c |    2 
 arch/um/os-Linux/drivers/tuntap_user.c   |    2 
 arch/um/os-Linux/helper.c                |   74 ++++++++-------------
 7 files changed, 36 insertions(+), 50 deletions(-)

diff -puN arch/um/drivers/net_user.c~uml-tidy-helper-code arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-tidy-helper-code
+++ a/arch/um/drivers/net_user.c
@@ -201,7 +201,7 @@ static int change_tramp(char **argv, cha
 	close(fds[1]);
 
 	if (pid > 0)
-		helper_wait(pid, 0, "change_tramp");
+		helper_wait(pid);
 	return pid;
 }
 
diff -puN arch/um/drivers/slip_user.c~uml-tidy-helper-code arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-tidy-helper-code
+++ a/arch/um/drivers/slip_user.c
@@ -109,7 +109,7 @@ static int slip_tramp(char **argv, int f
 	read_output(fds[0], output, output_len);
 	printk("%s", output);
 
-	err = helper_wait(pid, 0, argv[0]);
+	err = helper_wait(pid);
 	close(fds[0]);
 
 out_free:
diff -puN arch/um/drivers/slirp_user.c~uml-tidy-helper-code arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-tidy-helper-code
+++ a/arch/um/drivers/slirp_user.c
@@ -98,7 +98,7 @@ static void slirp_close(int fd, void *da
 		       "(%d)\n", pri->pid, errno);
 	}
 #endif
-	err = helper_wait(pri->pid, 1, "slirp_close");
+	err = helper_wait(pri->pid);
 	if (err < 0)
 		return;
 
diff -puN arch/um/include/os.h~uml-tidy-helper-code arch/um/include/os.h
--- a/arch/um/include/os.h~uml-tidy-helper-code
+++ a/arch/um/include/os.h
@@ -207,7 +207,7 @@ extern int execvp_noalloc(char *buf, con
 extern int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv);
 extern int run_helper_thread(int (*proc)(void *), void *arg,
 			     unsigned int flags, unsigned long *stack_out);
-extern int helper_wait(int pid, int nohang, char *pname);
+extern int helper_wait(int pid);
 
 
 /* tls.c */
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-tidy-helper-code arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-tidy-helper-code
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -131,7 +131,7 @@ static int etap_tramp(char *dev, char *g
 	}
 	if (c != 1) {
 		printk(UM_KERN_ERR "etap_tramp : uml_net failed\n");
-		err = helper_wait(pid, 0, "uml_net");
+		err = helper_wait(pid);
 	}
 	return err;
 }
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-tidy-helper-code arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-tidy-helper-code
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -108,7 +108,7 @@ static int tuntap_open_tramp(char *gate,
 		       "errno = %d\n", errno);
 		return err;
 	}
-	helper_wait(pid, 0, "tuntap_open_tramp");
+	helper_wait(pid);
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
diff -puN arch/um/os-Linux/helper.c~uml-tidy-helper-code arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-tidy-helper-code
+++ a/arch/um/os-Linux/helper.c
@@ -1,22 +1,19 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
 #include <sched.h>
-#include <limits.h>
-#include <sys/signal.h>
-#include <sys/wait.h>
 #include <sys/socket.h>
-#include "user.h"
+#include <sys/wait.h>
+#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "kern_constants.h"
+#include "user.h"
 
 struct helper_data {
 	void (*pre_exec)(void*);
@@ -30,21 +27,19 @@ static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
-	int errval;
+	int err;
 
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
-	errval = execvp_noalloc(data->buf, argv[0], argv);
-	printk("helper_child - execvp of '%s' failed - errno = %d\n", argv[0],
-	       -errval);
-	write(data->fd, &errval, sizeof(errval));
-	kill(os_getpid(), SIGKILL);
+	err = execvp_noalloc(data->buf, argv[0], argv);
+
+	/* If the exec succeeds, we don't get here */
+	write(data->fd, &err, sizeof(err));
+
 	return 0;
 }
 
-/* Returns either the pid of the child process we run or -E* on failure.
- * XXX The alloc_stack here breaks if this is called in the tracing thread, so
- * we need to receive a preallocated stack (a local buffer is ok). */
+/* Returns either the pid of the child process we run or -E* on failure. */
 int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 {
 	struct helper_data data;
@@ -58,14 +53,15 @@ int run_helper(void (*pre_exec)(void *),
 	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
 	if (ret < 0) {
 		ret = -errno;
-		printk("run_helper : pipe failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "run_helper : pipe failed, errno = %d\n",
+		       errno);
 		goto out_free;
 	}
 
 	ret = os_set_exec_close(fds[1]);
 	if (ret < 0) {
-		printk("run_helper : setting FD_CLOEXEC failed, ret = %d\n",
-		       -ret);
+		printk(UM_KERN_ERR "run_helper : setting FD_CLOEXEC failed, "
+		       "ret = %d\n", -ret);
 		goto out_close;
 	}
 
@@ -79,7 +75,8 @@ int run_helper(void (*pre_exec)(void *),
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
-		printk("run_helper : clone failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "run_helper : clone failed, errno = %d\n",
+		       errno);
 		goto out_free2;
 	}
 
@@ -96,10 +93,9 @@ int run_helper(void (*pre_exec)(void *),
 	} else {
 		if (n < 0) {
 			n = -errno;
-			printk("run_helper : read on pipe failed, ret = %d\n",
-			       -n);
+			printk(UM_KERN_ERR "run_helper : read on pipe failed, "
+			       "ret = %d\n", -n);
 			ret = n;
-			kill(pid, SIGKILL);
 		}
 		CATCH_EINTR(waitpid(pid, NULL, __WCLONE));
 	}
@@ -129,50 +125,40 @@ int run_helper_thread(int (*proc)(void *
 	pid = clone(proc, (void *) sp, flags, arg);
 	if (pid < 0) {
 		err = -errno;
-		printk("run_helper_thread : clone failed, errno = %d\n",
-		       errno);
+		printk(UM_KERN_ERR "run_helper_thread : clone failed, "
+		       "errno = %d\n", errno);
 		return err;
 	}
 	if (stack_out == NULL) {
 		CATCH_EINTR(pid = waitpid(pid, &status, __WCLONE));
 		if (pid < 0) {
 			err = -errno;
-			printk("run_helper_thread - wait failed, errno = %d\n",
-			       errno);
+			printk(UM_KERN_ERR "run_helper_thread - wait failed, "
+			       "errno = %d\n", errno);
 			pid = err;
 		}
 		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-			printk("run_helper_thread - thread returned status "
-			       "0x%x\n", status);
+			printk(UM_KERN_ERR "run_helper_thread - thread "
+			       "returned status 0x%x\n", status);
 		free_stack(stack, 0);
 	} else
 		*stack_out = stack;
 	return pid;
 }
 
-int helper_wait(int pid, int nohang, char *pname)
+int helper_wait(int pid)
 {
 	int ret, status;
 	int wflags = __WCLONE;
 
-	if (nohang)
-		wflags |= WNOHANG;
-
-	if (!pname)
-		pname = "helper_wait";
-
 	CATCH_EINTR(ret = waitpid(pid, &status, wflags));
 	if (ret < 0) {
-		printk(UM_KERN_ERR "%s : waitpid process %d failed, "
-		       "errno = %d\n", pname, pid, errno);
+		printk(UM_KERN_ERR "helper_wait : waitpid process %d failed, "
+		       "errno = %d\n", pid, errno);
 		return -errno;
-	} else if (nohang && ret == 0) {
-		printk(UM_KERN_ERR "%s : process %d has not exited\n",
-		       pname, pid);
-		return -ECHILD;
 	} else if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
-		printk(UM_KERN_ERR "%s : process %d didn't exit with "
-		       "status 0\n", pname, pid);
+		printk(UM_KERN_ERR "helper_wait : process %d exited with "
+		       "status 0x%x\n", pid, status);
 		return -ECHILD;
 	} else
 		return 0;
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
