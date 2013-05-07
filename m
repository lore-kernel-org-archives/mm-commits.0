From: akpm@linux-foundation.org
Subject: [merged] kmod-remove-call_usermodehelper_fns.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:21 -0700
Message-ID: <20130507174921.8C21F5A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:37989 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:23 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so85308vbg.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: remove call_usermodehelper_fns()
has been removed from the -mm tree.  Its filename was
     kmod-remove-call_usermodehelper_fns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: kmod: remove call_usermodehelper_fns()

This function suffers from not being able to determine if the cleanup is
called in case it returns -ENOMEM.  Nobody is using it anymore, so let's
remove it.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   11 +----------
 kernel/kmod.c        |   31 +++++++++++++++++--------------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff -puN include/linux/kmod.h~kmod-remove-call_usermodehelper_fns include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-remove-call_usermodehelper_fns
+++ a/include/linux/kmod.h
@@ -67,9 +67,7 @@ struct subprocess_info {
 };
 
 extern int
-call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
-			int (*init)(struct subprocess_info *info, struct cred *new),
-			void (*cleanup)(struct subprocess_info *), void *data);
+call_usermodehelper(char *path, char **argv, char **envp, int wait);
 
 extern struct subprocess_info *
 call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
@@ -79,13 +77,6 @@ call_usermodehelper_setup(char *path, ch
 extern int
 call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
-static inline int
-call_usermodehelper(char *path, char **argv, char **envp, int wait)
-{
-	return call_usermodehelper_fns(path, argv, envp, wait,
-				       NULL, NULL, NULL);
-}
-
 extern struct ctl_table usermodehelper_table[];
 
 enum umh_disable_depth {
diff -puN kernel/kmod.c~kmod-remove-call_usermodehelper_fns kernel/kmod.c
--- a/kernel/kmod.c~kmod-remove-call_usermodehelper_fns
+++ a/kernel/kmod.c
@@ -555,8 +555,8 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
- *        when -1 don't wait at all, but you get no useful error back when
- *        the program couldn't be exec'ed. This makes it safe to call
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
  *        from interrupt context.
  *
  * Runs a user-space application.  The application is started
@@ -616,29 +616,32 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
-/*
- * call_usermodehelper_fns() will not run the caller-provided cleanup function
- * if a memory allocation failure is experienced.  So the caller might need to
- * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
- * the necessaary cleanup within the caller.
+/**
+ * call_usermodehelper() - prepare and start a usermode application
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
+ * @wait: wait for the application to finish and return status.
+ *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
+ *        when the program couldn't be exec'ed. This makes it safe to call
+ *        from interrupt context.
+ *
+ * This function is the equivalent to use call_usermodehelper_setup() and
+ * call_usermodehelper_exec().
  */
-int call_usermodehelper_fns(
-	char *path, char **argv, char **envp, int wait,
-	int (*init)(struct subprocess_info *info, struct cred *new),
-	void (*cleanup)(struct subprocess_info *), void *data)
+int call_usermodehelper(char *path, char **argv, char **envp, int wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
-					 init, cleanup, data);
