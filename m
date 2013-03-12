From: akpm@linux-foundation.org
Subject: + kmod-remove-call_usermodehelper_fns.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:42 -0700
Message-ID: <20130312203242.DA8505A4305@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:44431 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:44 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so47402qah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: kmod: remove call_usermodehelper_fns()
has been added to the -mm tree.  Its filename is
     kmod-remove-call_usermodehelper_fns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -554,8 +554,8 @@ struct subprocess_info *call_usermodehel
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
@@ -615,29 +615,32 @@ unlock:
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
