From: akpm@linux-foundation.org
Subject: - uml-simplify-helper-stack-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:25 -0700
Message-ID: <200707162051.l6GKpPMT001396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761569AbXGPV3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: simplify helper stack handling
has been removed from the -mm tree.  Its filename was
     uml-simplify-helper-stack-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: simplify helper stack handling
From: Jeff Dike <jdike@addtoit.com>

run_helper and run_helper_thread had arguments which were the same in all
callers.  run_helper's stack_out was always NULL and run_helper_thread's
stack_order was always 0.  These are now gone, and the constants folded
into the code.

Also fixed leaks of the helper stack in the AIO and SIGIO code.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c              |    2 +-
 arch/um/drivers/harddog_user.c           |    2 +-
 arch/um/drivers/net_user.c               |    2 +-
 arch/um/drivers/port_user.c              |    2 +-
 arch/um/drivers/slip_user.c              |    2 +-
 arch/um/drivers/slirp_user.c             |    2 +-
 arch/um/drivers/xterm.c                  |    2 +-
 arch/um/include/os.h                     |    6 ++----
 arch/um/os-Linux/aio.c                   |   11 ++++++-----
 arch/um/os-Linux/drivers/ethertap_user.c |    2 +-
 arch/um/os-Linux/drivers/tuntap_user.c   |    2 +-
 arch/um/os-Linux/helper.c                |   19 +++++++------------
 arch/um/os-Linux/sigio.c                 |   19 ++++++++++++-------
 13 files changed, 36 insertions(+), 37 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-simplify-helper-stack-handling arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/chan_user.c
@@ -161,7 +161,7 @@ static int winch_tramp(int fd, struct tt
 	 * problem with /dev/net/tun, which if held open by this
 	 * thread, prevents the TUN/TAP device from being reused.
 	 */
-	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out, 0);
+	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
 	if(err < 0){
 		printk("fork of winch_thread failed - errno = %d\n", -err);
 		goto out_close;
diff -puN arch/um/drivers/harddog_user.c~uml-simplify-helper-stack-handling arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/harddog_user.c
@@ -68,7 +68,7 @@ int start_watchdog(int *in_fd_ret, int *
 		args = pid_args;
 	}
 
-	pid = run_helper(pre_exec, &data, args, NULL);
+	pid = run_helper(pre_exec, &data, args);
 
 	os_close_file(out_fds[0]);
 	os_close_file(in_fds[1]);
diff -puN arch/um/drivers/net_user.c~uml-simplify-helper-stack-handling arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/net_user.c
@@ -187,7 +187,7 @@ static int change_tramp(char **argv, cha
 	}
 	pe_data.close_me = fds[0];
 	pe_data.stdout = fds[1];
-	pid = run_helper(change_pre_exec, &pe_data, argv, NULL);
+	pid = run_helper(change_pre_exec, &pe_data, argv);
 
 	if (pid > 0)	/* Avoid hang as we won't get data in failure case. */
 		read_output(fds[0], output, output_len);
diff -puN arch/um/drivers/port_user.c~uml-simplify-helper-stack-handling arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/port_user.c
@@ -188,7 +188,7 @@ int port_connection(int fd, int *socket,
 		{ .sock_fd  		= new,
 		  .pipe_fd 		= socket[1] });
 
-	err = run_helper(port_pre_exec, &data, argv, NULL);
+	err = run_helper(port_pre_exec, &data, argv);
 	if(err < 0)
 		goto out_shutdown;
 
diff -puN arch/um/drivers/slip_user.c~uml-simplify-helper-stack-handling arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/slip_user.c
@@ -85,7 +85,7 @@ static int slip_tramp(char **argv, int f
 	pe_data.stdin = fd;
 	pe_data.stdout = fds[1];
 	pe_data.close_me = fds[0];
-	err = run_helper(slip_pre_exec, &pe_data, argv, NULL);
+	err = run_helper(slip_pre_exec, &pe_data, argv);
 	if(err < 0)
 		goto out_close;
 	pid = err;
diff -puN arch/um/drivers/slirp_user.c~uml-simplify-helper-stack-handling arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/slirp_user.c
@@ -42,7 +42,7 @@ static int slirp_tramp(char **argv, int 
 
 	pe_data.stdin = fd;
 	pe_data.stdout = fd;
-	pid = run_helper(slirp_pre_exec, &pe_data, argv, NULL);
+	pid = run_helper(slirp_pre_exec, &pe_data, argv);
 
 	return(pid);
 }
diff -puN arch/um/drivers/xterm.c~uml-simplify-helper-stack-handling arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-simplify-helper-stack-handling
+++ a/arch/um/drivers/xterm.c
@@ -132,7 +132,7 @@ static int xterm_open(int input, int out
 	}
 
 	sprintf(title, data->title, data->device);
-	pid = run_helper(NULL, NULL, argv, NULL);
+	pid = run_helper(NULL, NULL, argv);
 	if (pid < 0) {
 		err = pid;
 		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
diff -puN arch/um/include/os.h~uml-simplify-helper-stack-handling arch/um/include/os.h
--- a/arch/um/include/os.h~uml-simplify-helper-stack-handling
+++ a/arch/um/include/os.h
@@ -239,11 +239,9 @@ extern unsigned long __do_user_copy(void
 /* execvp.c */
 extern int execvp_noalloc(char *buf, const char *file, char *const argv[]);
 /* helper.c */
-extern int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv,
-		      unsigned long *stack_out);
+extern int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv);
 extern int run_helper_thread(int (*proc)(void *), void *arg,
-			     unsigned int flags, unsigned long *stack_out,
-			     int stack_order);
+			     unsigned int flags, unsigned long *stack_out);
 extern int helper_wait(int pid);
 
 
diff -puN arch/um/os-Linux/aio.c~uml-simplify-helper-stack-handling arch/um/os-Linux/aio.c
--- a/arch/um/os-Linux/aio.c~uml-simplify-helper-stack-handling
+++ a/arch/um/os-Linux/aio.c
@@ -177,6 +177,7 @@ static int do_not_aio(struct aio_thread_
 static int aio_req_fd_r = -1;
 static int aio_req_fd_w = -1;
 static int aio_pid = -1;
+static unsigned long aio_stack;
 
 static int not_aio_thread(void *arg)
 {
@@ -212,7 +213,6 @@ static int not_aio_thread(void *arg)
 
 static int init_aio_24(void)
 {
-	unsigned long stack;
 	int fds[2], err;
 
 	err = os_pipe(fds, 1, 1);
@@ -227,7 +227,7 @@ static int init_aio_24(void)
 		goto out_close_pipe;
 
 	err = run_helper_thread(not_aio_thread, NULL,
-				CLONE_FILES | CLONE_VM | SIGCHLD, &stack, 0);
+				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
 	if(err < 0)
 		goto out_close_pipe;
 
@@ -252,7 +252,6 @@ out:
 #define DEFAULT_24_AIO 0
 static int init_aio_26(void)
 {
-	unsigned long stack;
 	int err;
 
 	if(io_setup(256, &ctx)){
@@ -263,7 +262,7 @@ static int init_aio_26(void)
 	}
 
 	err = run_helper_thread(aio_thread, NULL,
-				CLONE_FILES | CLONE_VM | SIGCHLD, &stack, 0);
+				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
 	if(err < 0)
 		return err;
 
@@ -365,8 +364,10 @@ __initcall(init_aio);
 
 static void exit_aio(void)
 {
-	if(aio_pid != -1)
+	if (aio_pid != -1) {
 		os_kill_process(aio_pid, 1);
+		free_stack(aio_stack, 0);
+	}
 }
 
 __uml_exitcall(exit_aio);
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-simplify-helper-stack-handling arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -117,7 +117,7 @@ static int etap_tramp(char *dev, char *g
 	pe_data.control_remote = control_remote;
 	pe_data.control_me = control_me;
 	pe_data.data_me = data_me;
-	pid = run_helper(etap_pre_exec, &pe_data, args, NULL);
+	pid = run_helper(etap_pre_exec, &pe_data, args);
 
 	if(pid < 0)
 		err = pid;
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-simplify-helper-stack-handling arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-simplify-helper-stack-handling
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -83,7 +83,7 @@ static int tuntap_open_tramp(char *gate,
 	data.stdout = remote;
 	data.close_me = me;
 
-	pid = run_helper(tuntap_pre_exec, &data, argv, NULL);
+	pid = run_helper(tuntap_pre_exec, &data, argv);
 
 	if(pid < 0)
 		return -pid;
diff -puN arch/um/os-Linux/helper.c~uml-simplify-helper-stack-handling arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-simplify-helper-stack-handling
+++ a/arch/um/os-Linux/helper.c
@@ -44,17 +44,13 @@ static int helper_child(void *arg)
 /* Returns either the pid of the child process we run or -E* on failure.
  * XXX The alloc_stack here breaks if this is called in the tracing thread, so
  * we need to receive a preallocated stack (a local buffer is ok). */
-int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv,
-	       unsigned long *stack_out)
+int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 {
 	struct helper_data data;
 	unsigned long stack, sp;
 	int pid, fds[2], ret, n;
 
-	if ((stack_out != NULL) && (*stack_out != 0))
-		stack = *stack_out;
-	else
-		stack = alloc_stack(0, __cant_sleep());
+	stack = alloc_stack(0, __cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
@@ -113,22 +109,21 @@ out_close:
 		close(fds[1]);
 	close(fds[0]);
 out_free:
-	if ((stack_out == NULL) || (*stack_out == 0))
-		free_stack(stack, 0);
+	free_stack(stack, 0);
 	return ret;
 }
 
 int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
-		      unsigned long *stack_out, int stack_order)
+		      unsigned long *stack_out)
 {
 	unsigned long stack, sp;
 	int pid, status, err;
 
-	stack = alloc_stack(stack_order, __cant_sleep());
+	stack = alloc_stack(0, __cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
-	sp = stack + (UM_KERN_PAGE_SIZE << stack_order) - sizeof(void *);
+	sp = stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 	pid = clone(proc, (void *) sp, flags | SIGCHLD, arg);
 	if (pid < 0) {
 		err = -errno;
@@ -147,7 +142,7 @@ int run_helper_thread(int (*proc)(void *
 		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
 			printk("run_helper_thread - thread returned status "
 			       "0x%x\n", status);
-		free_stack(stack, stack_order);
+		free_stack(stack, 0);
 	} else
 		*stack_out = stack;
 	return pid;
diff -puN arch/um/os-Linux/sigio.c~uml-simplify-helper-stack-handling arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-simplify-helper-stack-handling
+++ a/arch/um/os-Linux/sigio.c
@@ -26,6 +26,7 @@
  * exitcall.
  */
 static int write_sigio_pid = -1;
+static unsigned long write_sigio_stack;
 
 /* These arrays are initialized before the sigio thread is started, and
  * the descriptors closed after it is killed.  So, it can't see them change.
@@ -144,8 +145,10 @@ static void update_thread(void)
 	return;
  fail:
 	/* Critical section start */
-	if(write_sigio_pid != -1)
+	if (write_sigio_pid != -1) {
 		os_kill_process(write_sigio_pid, 1);
+		free_stack(write_sigio_stack, 0);
+	}
 	write_sigio_pid = -1;
 	close(sigio_private[0]);
 	close(sigio_private[1]);
@@ -243,7 +246,6 @@ static struct pollfd *setup_initial_poll
 
 static void write_sigio_workaround(void)
 {
-	unsigned long stack;
 	struct pollfd *p;
 	int err;
 	int l_write_sigio_fds[2];
@@ -293,7 +295,8 @@ static void write_sigio_workaround(void)
 	memcpy(sigio_private, l_sigio_private, sizeof(l_sigio_private));
 
 	write_sigio_pid = run_helper_thread(write_sigio_thread, NULL,
-					    CLONE_FILES | CLONE_VM, &stack, 0);
+					    CLONE_FILES | CLONE_VM,
+					    &write_sigio_stack);
 
 	if (write_sigio_pid < 0)
 		goto out_clear;
@@ -356,10 +359,12 @@ out:
 
 static void sigio_cleanup(void)
 {
-	if(write_sigio_pid != -1){
-		os_kill_process(write_sigio_pid, 1);
-		write_sigio_pid = -1;
-	}
+	if (write_sigio_pid == -1)
+		return;
+
+	os_kill_process(write_sigio_pid, 1);
+	free_stack(write_sigio_stack, 0);
+	write_sigio_pid = -1;
 }
 
 __uml_exitcall(sigio_cleanup);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
