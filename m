From: akpm@linux-foundation.org
Subject: [wrecked] kmod-add-init-function-to-usermodehelper.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:37:23 -0800
Message-ID: <201003102037.o2AKbNrB002344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab0CJUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kmod: add init function to usermodehelper
has been removed from the -mm tree.  Its filename was
     kmod-add-init-function-to-usermodehelper.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmod: add init function to usermodehelper
From: Neil Horman <nhorman@tuxdriver.com>

About 6 months ago, I made a set of changes to how the core-dump-to-a-pipe
feature in the kernel works.  We had reports of several races, including
some reports of apps bypassing our recursion check so that a process that
was forked as part of a core_pattern setup could infinitely crash and
refork until the system crashed.

We fixed those by improving our recursion checks.  The new check basically
refuses to fork a process if its core limit is zero, which works well.

Unfortunately, I've been getting grief from maintainer of user space
programs that are inserted as the forked process of core_pattern.  They
contend that in order for their programs (such as abrt and apport) to
work, all the running processes in a system must have their core limits
set to a non-zero value, to which I say 'yes'.  I did this by design, and
think thats the right way to do things.

But I've been asked to ease this burden on user space enough times that I
thought I would take a look at it.  The first suggestion was to make the
recursion check fail on a non-zero 'special' number, like one.  That way
the core collector process could set its core size ulimit to 1, and enable
the kernel's recursion detection.  This isn't a bad idea on the surface,
but I don't like it since its opt-in, in that if a program like abrt or
apport has a bug and fails to set such a core limit, we're left with a
recursively crashing system again.

So I've come up with this.  What I've done is modify the
call_usermodehelper api such that an extra parameter is added, a function
pointer which will be called by the user helper task, after it forks, but
before it exec's the required process.  This will give the caller the
opportunity to get a call back in the processes context, allowing it to do
whatever it needs to to the process in the kernel prior to exec-ing the
user space code.  In the case of do_coredump, this callback is ues to set
the core ulimit of the helper process to 1.  This elimnates the opt-in
problem that I had above, as it allows the ulimit for core sizes to be set
to the value of 1, which is what the recursion check looks for in
do_coredump.

This patch has been tested successfully by some of the Abrt maintainers
in fedora, with good results.


This patch:

Convert call_usermodehelper_cleanup() to usermodehelper_fns() and allow it
to assign both an init function and a cleanup function.

The init function is called from the context of the forked process and
allows for customization of the helper process prior to calling exec.  Its
return code gates the continuation of the process, or causes its exit. 
Also add an arbitrary data pointer to the subprocess_info struct allowing
for data to be passed from the caller to the new process, and the
subsequent cleanup process

Also, use this patch to cleanup the cleanup function.  It currently takes
an argp and envp pointer for freeing, which is ugly.  Lets instead just
make the subprocess_info structure public, and pass that to the cleanup
and init routines

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   46 ++++++++++++++++++++++++----------
 kernel/kmod.c        |   54 ++++++++++++++++++++++-------------------
 kernel/sys.c         |    6 ++--
 3 files changed, 65 insertions(+), 41 deletions(-)

diff -puN include/linux/kmod.h~kmod-add-init-function-to-usermodehelper include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-add-init-function-to-usermodehelper
+++ a/include/linux/kmod.h
@@ -44,7 +44,27 @@ static inline int request_module_nowait(
 
 struct key;
 struct file;
-struct subprocess_info;
+
+enum umh_wait {
+	UMH_NO_WAIT = -1,	/* don't wait at all */
+	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
+	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
+};
+
+struct subprocess_info {
+	struct work_struct work;
+	struct completion *complete;
+	struct cred *cred;
+	char *path;
+	char **argv;
+	char **envp;
+	enum umh_wait wait;
+	int retval;
+	struct file *stdin;
+	int (*init)(struct subprocess_info *info);
+	void (*cleanup)(struct subprocess_info *info);
+	void *data;
+};
 
 /* Allocate a subprocess_info structure */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
@@ -55,14 +75,10 @@ void call_usermodehelper_setkeys(struct 
 				 struct key *session_keyring);
 int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
 				  struct file **filp);
-void call_usermodehelper_setcleanup(struct subprocess_info *info,
-				    void (*cleanup)(char **argv, char **envp));
-
-enum umh_wait {
-	UMH_NO_WAIT = -1,	/* don't wait at all */
-	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
-	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
-};
+void call_usermodehelper_setfns(struct subprocess_info *info,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *info),
+		    void *data);
 
 /* Actually execute the sub-process */
 int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
@@ -72,8 +88,10 @@ int call_usermodehelper_exec(struct subp
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper_cleanup(char *path, char **argv, char **envp, enum umh_wait wait,
-			    void (*cleanup)(char **, char **))
+call_usermodehelper_fns(char *path, char **argv, char **envp,
+		    enum umh_wait wait,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *), void *data)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
@@ -81,15 +99,15 @@ call_usermodehelper_cleanup(char *path, 
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
-	if (cleanup)
-		call_usermodehelper_setcleanup(info, cleanup);
+	call_usermodehelper_setfns(info, init, cleanup, data);
 	return call_usermodehelper_exec(info, wait);
 }
 
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
-	return call_usermodehelper_cleanup(path, argv, envp, wait, NULL);
+	return call_usermodehelper_fns(path, argv, envp,
+				       wait, NULL, NULL, NULL);
 }
 
 static inline int
diff -puN kernel/kmod.c~kmod-add-init-function-to-usermodehelper kernel/kmod.c
--- a/kernel/kmod.c~kmod-add-init-function-to-usermodehelper
+++ a/kernel/kmod.c
@@ -51,9 +51,9 @@ static struct workqueue_struct *khelper_
 */
 char *modprobe_path = "/sbin/modprobe";
 
-static void free_arg(char **argv, char **env)
+static void free_arg(struct subprocess_info *info)
 {
-	kfree(argv[0]);
+	kfree(info->argv[0]);
 }
 
 /**
@@ -133,8 +133,9 @@ int __request_module(bool wait, const ch
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper_cleanup(mp_copy, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC, free_arg);
+	ret = call_usermodehelper_fns(mp_copy, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
+			NULL, free_arg, NULL);
 	mp_copy = NULL; /* free_arg frees */
 	atomic_dec(&kmod_concurrent);
 error:
@@ -144,19 +145,6 @@ error:
 EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
-struct subprocess_info {
-	struct work_struct work;
-	struct completion *complete;
-	struct cred *cred;
-	char *path;
-	char **argv;
-	char **envp;
-	enum umh_wait wait;
-	int retval;
-	struct file *stdin;
-	void (*cleanup)(char **argv, char **envp);
-};
-
 /*
  * This is the task which runs the usermode application
  */
@@ -198,6 +186,12 @@ static int ____call_usermodehelper(void 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
+	if (sub_info->init) {
+		retval = sub_info->init(sub_info);
+		if (retval)
+			goto fail;
+	}
+
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
 	 * Avoid propagating that into the userspace child.
@@ -207,6 +201,7 @@ static int ____call_usermodehelper(void 
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
+fail:
 	sub_info->retval = retval;
 	do_exit(0);
 }
@@ -214,7 +209,7 @@ static int ____call_usermodehelper(void 
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
-		(*info->cleanup)(info->argv, info->envp);
+		(*info->cleanup)(info);
 	if (info->cred)
 		put_cred(info->cred);
 	kfree(info);
@@ -426,21 +421,31 @@ void call_usermodehelper_setkeys(struct 
 EXPORT_SYMBOL(call_usermodehelper_setkeys);
 
 /**
- * call_usermodehelper_setcleanup - set a cleanup function
+ * call_usermodehelper_setfns - set a cleanup/init function
  * @info: a subprocess_info returned by call_usermodehelper_setup
  * @cleanup: a cleanup function
+ * @init: an init function
+ * @data: arbitrary context sensitive data
+ *
+ * The init function is used to customize the helper process prior to
+ * exec.  A non-zero return code causes the process to error out, exit,
+ * and return the failure to the calling process
  *
- * The cleanup function is just befor ethe subprocess_info is about to
+ * The cleanup function is just before ethe subprocess_info is about to
  * be freed.  This can be used for freeing the argv and envp.  The
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
-void call_usermodehelper_setcleanup(struct subprocess_info *info,
-				    void (*cleanup)(char **argv, char **envp))
+void call_usermodehelper_setfns(struct subprocess_info *info,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *info),
+		    void *data)
 {
 	info->cleanup = cleanup;
+	info->init = init;
+	info->data = data;
 }
-EXPORT_SYMBOL(call_usermodehelper_setcleanup);
+EXPORT_SYMBOL(call_usermodehelper_setfns);
 
 /**
  * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
@@ -535,7 +540,8 @@ int call_usermodehelper_pipe(char *path,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp,
+					     GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/sys.c~kmod-add-init-function-to-usermodehelper kernel/sys.c
--- a/kernel/sys.c~kmod-add-init-function-to-usermodehelper
+++ a/kernel/sys.c
@@ -1791,9 +1791,9 @@ SYSCALL_DEFINE3(getcpu, unsigned __user 
 
 char *poweroff_cmd = "/sbin/poweroff";
 
-static void argv_cleanup(char **argv, char **envp)
+static void argv_cleanup(struct subprocess_info *info)
 {
-	argv_free(argv);
+	argv_free(info->argv);
 }
 
 /**
@@ -1831,7 +1831,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	call_usermodehelper_setcleanup(info, argv_cleanup);
+	call_usermodehelper_setfns(info, NULL, argv_cleanup, NULL);
 
 	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch

