From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-export-_exec-and-_setup-functions.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:06 -0700
Message-ID: <20130507174906.8C7BF5A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:57473 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:07 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so85414qcz.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: export call_usermodehelper_exec() and call_usermodehelper_setup()
has been removed from the -mm tree.  Its filename was
     usermodehelper-export-_exec-and-_setup-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: usermodehelper: export call_usermodehelper_exec() and call_usermodehelper_setup()

call_usermodehelper_setup() + call_usermodehelper_exec() need to be called
instead of call_usermodehelper_fns() when the cleanup function needs to be
called even when an ENOMEM error occurs.  In this case using
call_usermodehelper_fns() the user can't distinguish if the cleanup
function was called or not.

[akpm@linux-foundation.org: export call_usermodehelper_setup() to modules]
Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    8 +++++
 kernel/kmod.c        |   57 +++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 33 deletions(-)

diff -puN include/linux/kmod.h~usermodehelper-export-_exec-and-_setup-functions include/linux/kmod.h
--- a/include/linux/kmod.h~usermodehelper-export-_exec-and-_setup-functions
+++ a/include/linux/kmod.h
@@ -71,6 +71,14 @@ call_usermodehelper_fns(char *path, char
 			int (*init)(struct subprocess_info *info, struct cred *new),
 			void (*cleanup)(struct subprocess_info *), void *data);
 
+extern struct subprocess_info *
+call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
+			  int (*init)(struct subprocess_info *info, struct cred *new),
+			  void (*cleanup)(struct subprocess_info *), void *data);
+
+extern int
+call_usermodehelper_exec(struct subprocess_info *info, int wait);
+
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
diff -puN kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-export-_exec-and-_setup-functions
+++ a/kernel/kmod.c
@@ -502,14 +502,28 @@ static void helper_unlock(void)
  * @argv: arg vector for process
  * @envp: environment for process
  * @gfp_mask: gfp mask for memory allocation
+ * @cleanup: a cleanup function
+ * @init: an init function
+ * @data: arbitrary context sensitive data
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
+ *
+ * The init function is used to customize the helper process prior to
+ * exec.  A non-zero return code causes the process to error out, exit,
+ * and return the failure to the calling process
+ *
+ * The cleanup function is just before ethe subprocess_info is about to
+ * be freed.  This can be used for freeing the argv and envp.  The
+ * Function must be runnable in either a process context or the
+ * context in which call_usermodehelper_exec is called.
  */
-static
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask)
+		char **envp, gfp_t gfp_mask,
+		int (*init)(struct subprocess_info *info, struct cred *new),
+		void (*cleanup)(struct subprocess_info *info),
+		void *data)
 {
 	struct subprocess_info *sub_info;
 	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
@@ -520,36 +534,14 @@ struct subprocess_info *call_usermodehel
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
+
+	sub_info->cleanup = cleanup;
+	sub_info->init = init;
+	sub_info->data = data;
   out:
 	return sub_info;
 }
-
-/**
- * call_usermodehelper_setfns - set a cleanup/init function
- * @info: a subprocess_info returned by call_usermodehelper_setup
- * @cleanup: a cleanup function
- * @init: an init function
- * @data: arbitrary context sensitive data
- *
- * The init function is used to customize the helper process prior to
- * exec.  A non-zero return code causes the process to error out, exit,
- * and return the failure to the calling process
- *
- * The cleanup function is just before ethe subprocess_info is about to
- * be freed.  This can be used for freeing the argv and envp.  The
- * Function must be runnable in either a process context or the
- * context in which call_usermodehelper_exec is called.
- */
-static
-void call_usermodehelper_setfns(struct subprocess_info *info,
-		    int (*init)(struct subprocess_info *info, struct cred *new),
-		    void (*cleanup)(struct subprocess_info *info),
-		    void *data)
-{
-	info->cleanup = cleanup;
-	info->init = init;
-	info->data = data;
-}
+EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
  * call_usermodehelper_exec - start a usermode application
@@ -563,7 +555,6 @@ void call_usermodehelper_setfns(struct s
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
-static
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
@@ -615,6 +606,7 @@ unlock:
 	helper_unlock();
 	return retval;
 }
+EXPORT_SYMBOL(call_usermodehelper_exec);
 
 /*
  * call_usermodehelper_fns() will not run the caller-provided cleanup function
@@ -630,13 +622,12 @@ int call_usermodehelper_fns(
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
+					 init, cleanup, data);
 
 	if (info == NULL)
 		return -ENOMEM;
 
-	call_usermodehelper_setfns(info, init, cleanup, data);
