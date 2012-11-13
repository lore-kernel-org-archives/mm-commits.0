From: akpm@linux-foundation.org
Subject: + exec-do-not-leave-bprm-interp-on-stack.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:36:11 -0800
Message-ID: <20121113193612.D6370100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33865 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2KMTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:36:14 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so897967vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:36:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, me@halfdog.net, ppandit@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: do not leave bprm->interp on stack
has been added to the -mm tree.  Its filename is
     exec-do-not-leave-bprm-interp-on-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -176,7 +176,10 @@ static int load_misc_binary(struct linux
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
@@ -82,7 +82,9 @@ static int load_script(struct linux_binp
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
@@ -114,6 +114,7 @@ extern int setup_arg_pages(struct linux_
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
checkpatch-warn-about-using-config_experimental.patch
proc-dont-show-nonexistent-capabilities.patch
proc-pid-status-add-seccomp-field.patch
exec-do-not-leave-bprm-interp-on-stack.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

