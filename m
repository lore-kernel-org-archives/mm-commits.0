From: akpm@linux-foundation.org
Subject: - split-usermodehelper-setup-from-execution.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:51 -0700
Message-ID: <200705212317.l4LNHodU022510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758581AbXEUXXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, B.Steinbrink@gmx.de, ak@suse.de, dhowells@redhat.com, jeremy@xensource.com, randy.dunlap@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     split usermodehelper setup from execution
has been removed from the -mm tree.  Its filename was
     split-usermodehelper-setup-from-execution.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: split usermodehelper setup from execution
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rather than having hundreds of variations of call_usermodehelper for various
pieces of usermode state which could be set up, split the info allocation and
initialization from the actual process execution.

This means the general pattern becomes:
 info = call_usermodehelper_setup(path, argv, envp); /* basic state */
 call_usermodehelper_<SET EXTRA STATE>(info, stuff...);	/* extra state */
 call_usermodehelper_exec(info, wait);	/* run process and free info */

This patch introduces wrappers for all the existing calling styles for
call_usermodehelper_*, but folds their implementations into one.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   44 ++++++++-
 kernel/kmod.c        |  195 ++++++++++++++++++++++++++++-------------
 2 files changed, 178 insertions(+), 61 deletions(-)

diff -puN include/linux/kmod.h~split-usermodehelper-setup-from-execution include/linux/kmod.h
--- a/include/linux/kmod.h~split-usermodehelper-setup-from-execution
+++ a/include/linux/kmod.h
@@ -36,13 +36,51 @@ static inline int request_module(const c
 #define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x)))
 
 struct key;
-extern int call_usermodehelper_keys(char *path, char *argv[], char *envp[],
-				    struct key *session_keyring, int wait);
+struct file;
+struct subprocess_info;
+
+/* Allocate a subprocess_info structure */
+struct subprocess_info *call_usermodehelper_setup(char *path,
+						  char **argv, char **envp);
+
+/* Set various pieces of state into the subprocess_info structure */
+void call_usermodehelper_setkeys(struct subprocess_info *info,
+				 struct key *session_keyring);
+int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
+				  struct file **filp);
+void call_usermodehelper_setcleanup(struct subprocess_info *info,
+				    void (*cleanup)(char **argv, char **envp));
+
+/* Actually execute the sub-process */
+int call_usermodehelper_exec(struct subprocess_info *info, int wait);
+
+/* Free the subprocess_info. This is only needed if you're not going
+   to call call_usermodehelper_exec */
+void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
-	return call_usermodehelper_keys(path, argv, envp, NULL, wait);
+	struct subprocess_info *info;
+
+	info = call_usermodehelper_setup(path, argv, envp);
+	if (info == NULL)
+		return -ENOMEM;
+	return call_usermodehelper_exec(info, wait);
+}
+
+static inline int
+call_usermodehelper_keys(char *path, char **argv, char **envp,
+			 struct key *session_keyring, int wait)
+{
+	struct subprocess_info *info;
+
+	info = call_usermodehelper_setup(path, argv, envp);
+	if (info == NULL)
+		return -ENOMEM;
+
+	call_usermodehelper_setkeys(info, session_keyring);
+	return call_usermodehelper_exec(info, wait);
 }
 
 extern void usermodehelper_init(void);
diff -puN kernel/kmod.c~split-usermodehelper-setup-from-execution kernel/kmod.c
--- a/kernel/kmod.c~split-usermodehelper-setup-from-execution
+++ a/kernel/kmod.c
@@ -122,6 +122,7 @@ struct subprocess_info {
 	int wait;
 	int retval;
 	struct file *stdin;
+	void (*cleanup)(char **argv, char **envp);
 };
 
 /*
@@ -180,6 +181,14 @@ static int ____call_usermodehelper(void 
 	do_exit(0);
 }
 
+void call_usermodehelper_freeinfo(struct subprocess_info *info)
+{
+	if (info->cleanup)
+		(*info->cleanup)(info->argv, info->envp);
+	kfree(info);
+}
+EXPORT_SYMBOL(call_usermodehelper_freeinfo);
+
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -217,7 +226,7 @@ static int wait_for_helper(void *data)
 	}
 
 	if (sub_info->wait < 0)
-		kfree(sub_info);
+		call_usermodehelper_freeinfo(sub_info);
 	else
 		complete(sub_info->complete);
 	return 0;
@@ -252,11 +261,94 @@ static void __call_usermodehelper(struct
 }
 
 /**
- * call_usermodehelper_keys - start a usermode application
- * @path: pathname for the application
- * @argv: null-terminated argument list
- * @envp: null-terminated environment list
- * @session_keyring: session keyring for process (NULL for an empty keyring)
+ * call_usermodehelper_setup - prepare to call a usermode helper
+ * @path - path to usermode executable
+ * @argv - arg vector for process
+ * @envp - environment for process
+ *
+ * Returns either NULL on allocation failure, or a subprocess_info
+ * structure.  This should be passed to call_usermodehelper_exec to
+ * exec the process and free the structure.
+ */
+struct subprocess_info *call_usermodehelper_setup(char *path,
+						  char **argv, char **envp)
+{
+	struct subprocess_info *sub_info;
+	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
+	if (!sub_info)
+		goto out;
+
+	INIT_WORK(&sub_info->work, __call_usermodehelper);
+	sub_info->path = path;
+	sub_info->argv = argv;
+	sub_info->envp = envp;
+
+  out:
+	return sub_info;
+}
+EXPORT_SYMBOL(call_usermodehelper_setup);
+
+/**
+ * call_usermodehelper_setkeys - set the session keys for usermode helper
+ * @info: a subprocess_info returned by call_usermodehelper_setup
+ * @session_keyring: the session keyring for the process
+ */
+void call_usermodehelper_setkeys(struct subprocess_info *info,
+				 struct key *session_keyring)
+{
+	info->ring = session_keyring;
+}
+EXPORT_SYMBOL(call_usermodehelper_setkeys);
+
+/**
+ * call_usermodehelper_setcleanup - set a cleanup function
+ * @info: a subprocess_info returned by call_usermodehelper_setup
+ * @cleanup: a cleanup function
+ *
+ * The cleanup function is just befor ethe subprocess_info is about to
+ * be freed.  This can be used for freeing the argv and envp.  The
+ * Function must be runnable in either a process context or the
+ * context in which call_usermodehelper_exec is called.
+ */
+void call_usermodehelper_setcleanup(struct subprocess_info *info,
+				    void (*cleanup)(char **argv, char **envp))
+{
+	info->cleanup = cleanup;
+}
+EXPORT_SYMBOL(call_usermodehelper_setcleanup);
+
+/**
+ * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
+ * @sub_info: a subprocess_info returned by call_usermodehelper_setup
+ * @filp: set to the write-end of a pipe
+ *
+ * This constructs a pipe, and sets the read end to be the stdin of the
+ * subprocess, and returns the write-end in *@filp.
+ */
+int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
+				  struct file **filp)
+{
+	struct file *f;
+
+	f = create_write_pipe();
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+	*filp = f;
+
+	f = create_read_pipe(f);
+	if (IS_ERR(f)) {
+		free_write_pipe(*filp);
+		return PTR_ERR(f);
+	}
+	sub_info->stdin = f;
+
+	return 0;
+}
+EXPORT_SYMBOL(call_usermodehelper_stdinpipe);
+
+/**
+ * call_usermodehelper_exec - start a usermode application
+ * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
  *        when -1 don't wait at all, but you get no useful error back when
  *        the program couldn't be exec'ed. This makes it safe to call
@@ -265,33 +357,24 @@ static void __call_usermodehelper(struct
  * Runs a user-space application.  The application is started
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
- *
- * Must be called from process context.  Returns a negative error code
- * if program was not execed successfully, or 0.
  */
-int call_usermodehelper_keys(char *path, char **argv, char **envp,
-			     struct key *session_keyring, int wait)
+int call_usermodehelper_exec(struct subprocess_info *sub_info,
+			     int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
-	struct subprocess_info *sub_info;
 	int retval;
 
-	if (!khelper_wq)
-		return -EBUSY;
-
-	if (path[0] == '\0')
-		return 0;
+	if (sub_info->path[0] == '\0') {
+		retval = 0;
+		goto out;
+	}
 
-	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
-	if (!sub_info)
-		return -ENOMEM;
+	if (!khelper_wq) {
+		retval = -EBUSY;
+		goto out;
+	}
 
-	INIT_WORK(&sub_info->work, __call_usermodehelper);
 	sub_info->complete = &done;
-	sub_info->path = path;
-	sub_info->argv = argv;
-	sub_info->envp = envp;
-	sub_info->ring = session_keyring;
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
@@ -299,47 +382,43 @@ int call_usermodehelper_keys(char *path,
 		return 0;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
-	kfree(sub_info);
+
+  out:
+	call_usermodehelper_freeinfo(sub_info);
 	return retval;
 }
-EXPORT_SYMBOL(call_usermodehelper_keys);
+EXPORT_SYMBOL(call_usermodehelper_exec);
 
+/**
+ * call_usermodehelper_pipe - call a usermode helper process with a pipe stdin
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
+ * @filp: set to the write-end of a pipe
+ *
+ * This is a simple wrapper which executes a usermode-helper function
+ * with a pipe as stdin.  It is implemented entirely in terms of
+ * lower-level call_usermodehelper_* functions.
+ */
 int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 			     struct file **filp)
 {
-	DECLARE_COMPLETION(done);
-	struct subprocess_info sub_info = {
-		.work		= __WORK_INITIALIZER(sub_info.work,
-						     __call_usermodehelper),
-		.complete	= &done,
-		.path		= path,
-		.argv		= argv,
-		.envp		= envp,
-		.retval		= 0,
-	};
-	struct file *f;
-
-	if (!khelper_wq)
-		return -EBUSY;
-
-	if (path[0] == '\0')
-		return 0;
-
-	f = create_write_pipe();
-	if (IS_ERR(f))
-		return PTR_ERR(f);
-	*filp = f;
+	struct subprocess_info *sub_info;
+	int ret;
 
-	f = create_read_pipe(f);
-	if (IS_ERR(f)) {
-		free_write_pipe(*filp);
-		return PTR_ERR(f);
-	}
-	sub_info.stdin = f;
+	sub_info = call_usermodehelper_setup(path, argv, envp);
+	if (sub_info == NULL)
+		return -ENOMEM;
 
-	queue_work(khelper_wq, &sub_info.work);
-	wait_for_completion(&done);
-	return sub_info.retval;
+	ret = call_usermodehelper_stdinpipe(sub_info, filp);
+	if (ret < 0)
+		goto out;
+
+	return call_usermodehelper_exec(sub_info, 1);
+
+  out:
+	call_usermodehelper_freeinfo(sub_info);
+	return ret;
 }
 EXPORT_SYMBOL(call_usermodehelper_pipe);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kstrndup-fix.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
