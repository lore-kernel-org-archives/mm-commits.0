From: akpm@linux-foundation.org
Subject: [merged] kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:40 -0700
Message-ID: <20120601193340.5682DA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:41 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248161yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: move call_usermodehelper_fns() to .c file and unexport all it's helpers
has been removed from the -mm tree.  Its filename was
     kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -478,6 +478,7 @@ static void helper_unlock(void)
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
+static
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 						  char **envp, gfp_t gfp_mask)
 {
@@ -493,7 +494,6 @@ struct subprocess_info *call_usermodehel
   out:
 	return sub_info;
 }
-EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
  * call_usermodehelper_setfns - set a cleanup/init function
@@ -511,6 +511,7 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
+static
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info, struct cred *new),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -520,7 +521,6 @@ void call_usermodehelper_setfns(struct s
 	info->init = init;
 	info->data = data;
 }
-EXPORT_SYMBOL(call_usermodehelper_setfns);
 
 /**
  * call_usermodehelper_exec - start a usermode application
@@ -534,6 +534,7 @@ EXPORT_SYMBOL(call_usermodehelper_setfns
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
+static
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
@@ -575,7 +576,25 @@ unlock:
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

Patches currently in -mm which might be from bharrosh@panasas.com are

origin.patch

