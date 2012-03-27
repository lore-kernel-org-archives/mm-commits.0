From: akpm@linux-foundation.org
Subject: + kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch added to -mm tree
Date: Tue, 27 Mar 2012 14:07:21 -0700
Message-ID: <20120327210721.F007DA032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43040 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2C0VHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 17:07:24 -0400
Received: by eekc41 with SMTP id c41so15197eek.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 14:07:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: kmod: move call_usermodehelper_fns() to .c file and unexport all it's helpers
has been added to the -mm tree.  Its filename is
     kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: kmod: move call_usermodehelper_fns() to .c file and unexport all it's helpers

If we move call_usermodehelper_fns() to kmod.c file and EXPORT_SYMBOL it
we can avoid exporting all it's helper functions:
	call_usermodehelper_setup
	call_usermodehelper_setfns
	call_usermodehelper_exec
And make all of them static to kmod.c

Since the optimizer will see all these as a single call site it will
inline them inside call_usermodehelper_fns().  So we loose the call to
_fns but gain 3 calls to the helpers.  (Not that it matters)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   30 ++----------------------------
 kernel/kmod.c        |   25 ++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 31 deletions(-)

diff -puN include/linux/kmod.h~kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers
+++ a/include/linux/kmod.h
@@ -66,36 +66,10 @@ struct subprocess_info {
 	void *data;
 };
 
-/* Allocate a subprocess_info structure */
-struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask);
-
-/* Set various pieces of state into the subprocess_info structure */
-void call_usermodehelper_setfns(struct subprocess_info *info,
-		    int (*init)(struct subprocess_info *info, struct cred *new),
-		    void (*cleanup)(struct subprocess_info *info),
-		    void *data);
-
-/* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, int wait);
-
-static inline int
+extern int
 call_usermodehelper_fns(char *path, char **argv, char **envp, int wait,
 			int (*init)(struct subprocess_info *info, struct cred *new),
-			void (*cleanup)(struct subprocess_info *), void *data)
-{
-	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
-
-	if (info == NULL)
-		return -ENOMEM;
-
-	call_usermodehelper_setfns(info, init, cleanup, data);
-
-	return call_usermodehelper_exec(info, wait);
-}
+			void (*cleanup)(struct subprocess_info *), void *data);
 
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, int wait)
diff -puN kernel/kmod.c~kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers kernel/kmod.c
--- a/kernel/kmod.c~kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers
+++ a/kernel/kmod.c
@@ -421,6 +421,7 @@ static void helper_unlock(void)
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
+static
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 						  char **envp, gfp_t gfp_mask)
 {
@@ -436,7 +437,6 @@ struct subprocess_info *call_usermodehel
   out:
 	return sub_info;
 }
-EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
  * call_usermodehelper_setfns - set a cleanup/init function
@@ -454,6 +454,7 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
+static
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info, struct cred *new),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -463,7 +464,6 @@ void call_usermodehelper_setfns(struct s
 	info->init = init;
 	info->data = data;
 }
-EXPORT_SYMBOL(call_usermodehelper_setfns);
 
 /**
  * call_usermodehelper_exec - start a usermode application
@@ -477,6 +477,7 @@ EXPORT_SYMBOL(call_usermodehelper_setfns
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
+static
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
@@ -518,7 +519,25 @@ unlock:
 	helper_unlock();
 	return retval;
 }
-EXPORT_SYMBOL(call_usermodehelper_exec);
+
+int call_usermodehelper_fns(
+	char *path, char **argv, char **envp, int wait,
+	int (*init)(struct subprocess_info *info, struct cred *new),
+	void (*cleanup)(struct subprocess_info *), void *data)
+{
+	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+
+	if (info == NULL)
+		return -ENOMEM;
+
+	call_usermodehelper_setfns(info, init, cleanup, data);
+
+	return call_usermodehelper_exec(info, wait);
+}
+EXPORT_SYMBOL(call_usermodehelper_fns);
 
 static int proc_cap_handler(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
_
Subject: Subject: kmod: move call_usermodehelper_fns() to .c file and unexport all it's helpers

Patches currently in -mm which might be from bharrosh@panasas.com are

origin.patch
linux-next.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch

