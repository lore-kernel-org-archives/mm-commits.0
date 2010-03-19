From: akpm@linux-foundation.org
Subject: + exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:04:50 -0700
Message-ID: <201003192204.o2JM4pFK014898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab0CSWFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, andi@firstfloor.org, oleg@redhat.com


The patch titled
     exec: replace call_usermodehelper_pipe with use of umh init function and resolve limit
has been added to the -mm tree.  Its filename is
     exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: replace call_usermodehelper_pipe with use of umh init function and resolve limit
From: Neil Horman <nhorman@tuxdriver.com>

The first patch in this series introduced an init function to the
call_usermodehelper api so that processes could be customized by caller. 
This patch takes advantage of that fact, by customizing the helper in
do_coredump to create the pipe and set its core limit to one (for our
recusrsion check).  This lets us clean up the previous uglyness in the
usermodehelper internals and factor call_usermodehelper out entirely. 
While I'm at it, we can also modify the helper setup to look for a core
limit value of 1 rather than zero for our recursion check

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c            |   63 ++++++++++++++++++++++++++++---
 include/linux/kmod.h |    7 ---
 kernel/kmod.c        |   82 -----------------------------------------
 3 files changed, 56 insertions(+), 96 deletions(-)

diff -puN fs/exec.c~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit fs/exec.c
--- a/fs/exec.c~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit
+++ a/fs/exec.c
@@ -1784,6 +1784,50 @@ static void wait_for_dump_helpers(struct
 }
 
 
+/*
+ * uhm_pipe_setup
+ * helper function to customize the process used
+ * to collect the core in userspace.  Specifically
+ * it sets up a pipe and installs it as fd 0 (stdin)
+ * for the process.  Returns 0 on success, or
+ * PTR_ERR on failure.
+ * Note that it also sets the core limit to 1.  This
+ * is a special value that we use to trap recursive
+ * core dumps
+ */
+static int umh_pipe_setup(struct subprocess_info *info)
+{
+	struct file *rp, *wp;
+	struct fdtable *fdt;
+	struct coredump_params *cp = (struct coredump_params *)info->data;
+	struct files_struct *cf = current->files;
+
+	wp = create_write_pipe(0);
+	if (IS_ERR(wp))
+		return PTR_ERR(wp);
+
+	rp = create_read_pipe(wp, 0);
+	if (IS_ERR(rp)) {
+		free_write_pipe(wp);
+		return PTR_ERR(rp);
+	}
+
+	cp->file = wp;
+
+	sys_close(0);
+	fd_install(0, rp);
+	spin_lock(&cf->file_lock);
+	fdt = files_fdtable(cf);
+	FD_SET(0, fdt->open_fds);
+	FD_CLR(0, fdt->close_on_exec);
+	spin_unlock(&cf->file_lock);
+
+	/* and disallow core files too */
+	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
+
+	return 0;
+}
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
@@ -1871,15 +1915,15 @@ void do_coredump(long signr, int exit_co
 		goto fail_unlock;
 
  	if (ispipe) {
-		if (cprm.limit == 0) {
+		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 0 here as a speacial value. Any
-			 * non-zero limit gets set to RLIM_INFINITY below, but
+			 * cprm.limit of 1 here as a speacial value. Any
+			 * non-1 limit gets set to RLIM_INFINITY below, but
 			 * a limit of 0 skips the dump.  This is a consistent
 			 * way to catch recursive crashes.  We can still crash
-			 * if the core_pattern binary sets RLIM_CORE =  !0
+			 * if the core_pattern binary sets RLIM_CORE =  !1
 			 * but it runs as root, and can do lots of stupid things
 			 * Note that we use task_tgid_vnr here to grab the pid
 			 * of the process group leader.  That way we get the
@@ -1887,7 +1931,7 @@ void do_coredump(long signr, int exit_co
 			 * core_pattern process dies.
 			 */
 			printk(KERN_WARNING
-				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				"Process %d(%s) has RLIMIT_CORE set to 1\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
@@ -1911,8 +1955,13 @@ void do_coredump(long signr, int exit_co
 		cprm.limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
-		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&cprm.file)) {
+		cprm.file = NULL;
+		if (call_usermodehelper_fns(helper_argv[0], helper_argv, NULL,
+					    UMH_WAIT_EXEC, umh_pipe_setup,
+					    NULL, &cprm)) {
+			if (cprm.file)
+				filp_close(cprm.file, NULL);
+
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
diff -puN include/linux/kmod.h~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit include/linux/kmod.h
--- a/include/linux/kmod.h~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit
+++ a/include/linux/kmod.h
@@ -62,7 +62,6 @@ struct subprocess_info {
 	char **envp;
 	enum umh_wait wait;
 	int retval;
-	struct file *stdin;
 	int (*init)(struct subprocess_info *info);
 	void (*cleanup)(struct subprocess_info *info);
 	void *data;
@@ -75,8 +74,6 @@ struct subprocess_info *call_usermodehel
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
 				 struct key *session_keyring);
-int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
-				  struct file **filp);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -132,10 +129,6 @@ call_usermodehelper_keys(char *path, cha
 
 extern void usermodehelper_init(void);
 
-struct file;
-extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
-				    struct file **filp);
-
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 
diff -puN kernel/kmod.c~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit kernel/kmod.c
--- a/kernel/kmod.c~exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit
+++ a/kernel/kmod.c
@@ -147,23 +147,6 @@ static int ____call_usermodehelper(void 
 	commit_creds(sub_info->cred);
 	sub_info->cred = NULL;
 
-	/* Install input pipe when needed */
-	if (sub_info->stdin) {
-		struct files_struct *f = current->files;
-		struct fdtable *fdt;
-		/* no races because files should be private here */
-		sys_close(0);
-		fd_install(0, sub_info->stdin);
-		spin_lock(&f->file_lock);
-		fdt = files_fdtable(f);
-		FD_SET(0, fdt->open_fds);
-		FD_CLR(0, fdt->close_on_exec);
-		spin_unlock(&f->file_lock);
-
-		/* and disallow core files too */
-		current->signal->rlim[RLIMIT_CORE] = (struct rlimit){0, 0};
-	}
-
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
@@ -429,35 +412,6 @@ void call_usermodehelper_setfns(struct s
 EXPORT_SYMBOL(call_usermodehelper_setfns);
 
 /**
- * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
- * @sub_info: a subprocess_info returned by call_usermodehelper_setup
- * @filp: set to the write-end of a pipe
- *
- * This constructs a pipe, and sets the read end to be the stdin of the
- * subprocess, and returns the write-end in *@filp.
- */
-int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
-				  struct file **filp)
-{
-	struct file *f;
-
-	f = create_write_pipe(0);
-	if (IS_ERR(f))
-		return PTR_ERR(f);
-	*filp = f;
-
-	f = create_read_pipe(f, 0);
-	if (IS_ERR(f)) {
-		free_write_pipe(*filp);
-		return PTR_ERR(f);
-	}
-	sub_info->stdin = f;
-
-	return 0;
-}
-EXPORT_SYMBOL(call_usermodehelper_stdinpipe);
-
-/**
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
@@ -504,42 +458,6 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
-/**
- * call_usermodehelper_pipe - call a usermode helper process with a pipe stdin
- * @path: path to usermode executable
- * @argv: arg vector for process
- * @envp: environment for process
- * @filp: set to the write-end of a pipe
- *
- * This is a simple wrapper which executes a usermode-helper function
- * with a pipe as stdin.  It is implemented entirely in terms of
- * lower-level call_usermodehelper_* functions.
- */
-int call_usermodehelper_pipe(char *path, char **argv, char **envp,
-			     struct file **filp)
-{
-	struct subprocess_info *sub_info;
-	int ret;
-
-	sub_info = call_usermodehelper_setup(path, argv, envp,
-					     GFP_KERNEL);
-	if (sub_info == NULL)
-		return -ENOMEM;
-
-	ret = call_usermodehelper_stdinpipe(sub_info, filp);
-	if (ret < 0) {
-		call_usermodehelper_freeinfo(sub_info);
-		return ret;
-	}
-
-	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
-	if (ret < 0)	/* Failed to execute helper, close pipe */
-		filp_close(*filp, NULL);
-
-	return ret;
-}
-EXPORT_SYMBOL(call_usermodehelper_pipe);
