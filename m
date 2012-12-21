From: akpm@linux-foundation.org
Subject: [merged] exec-do-not-leave-bprm-interp-on-stack.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:24 -0800
Message-ID: <20121221203924.DC6EB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:56827 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LUUj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:26 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so205435ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, me@halfdog.net, ppandit@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: do not leave bprm->interp on stack
has been removed from the -mm tree.  Its filename was
     exec-do-not-leave-bprm-interp-on-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: do not leave bprm->interp on stack

If a series of scripts are executed, each triggering module loading via
unprintable bytes in the script header, kernel stack contents can leak
into the command line.

Normally execution of binfmt_script and binfmt_misc happens recursively. 
However, when modules are enabled, and unprintable bytes exist in the
bprm->buf, execution will restart after attempting to load matching binfmt
modules.  Unfortunately, the logic in binfmt_script and binfmt_misc does
not expect to get restarted.  They leave bprm->interp pointing to their
local stack.  This means on restart bprm->interp is left pointing into
unused stack memory which can then be copied into the userspace argv
areas.

After additional study, it seems that both recursion and restart remains
the desirable way to handle exec with scripts, misc, and modules.  As
such, we need to protect the changes to interp.

This changes the logic to require allocation for any changes to the
bprm->interp.  To avoid adding a new kmalloc to every exec, the default
value is left as-is.  Only when passing through binfmt_script or
binfmt_misc does an allocation take place.

For a proof of concept, see DoTest.sh from:
http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: halfdog <me@halfdog.net>
Cc: P J P <ppandit@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c        |    5 ++++-
 fs/binfmt_script.c      |    4 +++-
 fs/exec.c               |   15 +++++++++++++++
 include/linux/binfmts.h |    1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~exec-do-not-leave-bprm-interp-on-stack fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-do-not-leave-bprm-interp-on-stack
+++ a/fs/binfmt_misc.c
@@ -172,7 +172,10 @@ static int load_misc_binary(struct linux
 		goto _error;
 	bprm->argc ++;
 
-	bprm->interp = iname;	/* for binfmt_script */
+	/* Update interp in case binfmt_script needs it. */
+	retval = bprm_change_interp(iname, bprm);
+	if (retval < 0)
+		goto _error;
 
 	interp_file = open_exec (iname);
 	retval = PTR_ERR (interp_file);
diff -puN fs/binfmt_script.c~exec-do-not-leave-bprm-interp-on-stack fs/binfmt_script.c
--- a/fs/binfmt_script.c~exec-do-not-leave-bprm-interp-on-stack
+++ a/fs/binfmt_script.c
@@ -80,7 +80,9 @@ static int load_script(struct linux_binp
 	retval = copy_strings_kernel(1, &i_name, bprm);
 	if (retval) return retval; 
 	bprm->argc++;
-	bprm->interp = interp;
+	retval = bprm_change_interp(interp, bprm);
+	if (retval < 0)
+		return retval;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
diff -puN fs/exec.c~exec-do-not-leave-bprm-interp-on-stack fs/exec.c
--- a/fs/exec.c~exec-do-not-leave-bprm-interp-on-stack
+++ a/fs/exec.c
@@ -1175,9 +1175,24 @@ void free_bprm(struct linux_binprm *bprm
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	/* If a binfmt changed the interp, free it. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
 	kfree(bprm);
 }
 
+int bprm_change_interp(char *interp, struct linux_binprm *bprm)
+{
+	/* If a binfmt changed the interp, free it first. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
+	bprm->interp = kstrdup(interp, GFP_KERNEL);
+	if (!bprm->interp)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(bprm_change_interp);
+
 /*
  * install the new credentials for this executable
  */
diff -puN include/linux/binfmts.h~exec-do-not-leave-bprm-interp-on-stack include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-do-not-leave-bprm-interp-on-stack
+++ a/include/linux/binfmts.h
@@ -112,6 +112,7 @@ extern int setup_arg_pages(struct linux_
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
audit-create-explicit-audit_seccomp-event-type.patch
audit-catch-possible-null-audit-buffers.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

