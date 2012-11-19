From: akpm@linux-foundation.org
Subject: + exec-use-eloop-for-max-recursion-depth.patch added to -mm tree
Date: Mon, 19 Nov 2012 14:19:05 -0800
Message-ID: <20121119221906.28BD220005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33514 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KSWTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 17:19:08 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so356068eei.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 14:19:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, me@halfdog.net, ppandit@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: use -ELOOP for max recursion depth
has been added to the -mm tree.  Its filename is
     exec-use-eloop-for-max-recursion-depth.patch

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
Subject: exec: use -ELOOP for max recursion depth

To avoid an explosion of request_module calls on a chain of abusive
scripts, fail maximum recursion with -ELOOP instead of -ENOEXEC. As soon
as maximum recursion depth is hit, the error will fail all the way back
up the chain, aborting immediately.

This also has the side-effect of stopping the user's shell from attempting
to reexecute the top-level file as a shell script. As seen in the
dash source:

        if (cmd != path_bshell && errno == ENOEXEC) {
                *argv-- = cmd;
                *argv = cmd = path_bshell;
                goto repeat;
        }

The above logic was designed for running scripts automatically that lacked
the "#!" header, not to re-try failed recursion. On a legitimate -ENOEXEC,
things continue to behave as the shell expects.

Additionally, when tracking recursion, the binfmt handlers should not be
involved. The recursion being tracked is the depth of calls through
search_binary_handler(), so that function should be exclusively responsible
for tracking the depth.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: halfdog <me@halfdog.net>
Cc: P J P <ppandit@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c        |    1 -
 fs/binfmt_misc.c        |    6 ------
 fs/binfmt_script.c      |    4 +---
 fs/exec.c               |   10 +++++-----
 include/linux/binfmts.h |    2 --
 5 files changed, 6 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_em86.c~exec-use-eloop-for-max-recursion-depth fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~exec-use-eloop-for-max-recursion-depth
+++ a/fs/binfmt_em86.c
@@ -42,7 +42,6 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/binfmt_misc.c~exec-use-eloop-for-max-recursion-depth fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-use-eloop-for-max-recursion-depth
+++ a/fs/binfmt_misc.c
@@ -117,10 +117,6 @@ static int load_misc_binary(struct linux
 	if (!enabled)
 		goto _ret;
 
-	retval = -ENOEXEC;
-	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
-		goto _ret;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -200,8 +196,6 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
-	bprm->recursion_depth++;
-
 	retval = search_binary_handler(bprm);
 	if (retval < 0)
 		goto _error;
diff -puN fs/binfmt_script.c~exec-use-eloop-for-max-recursion-depth fs/binfmt_script.c
--- a/fs/binfmt_script.c~exec-use-eloop-for-max-recursion-depth
+++ a/fs/binfmt_script.c
@@ -22,15 +22,13 @@ static int load_script(struct linux_binp
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
-	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
-	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
+	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/exec.c~exec-use-eloop-for-max-recursion-depth fs/exec.c
--- a/fs/exec.c~exec-use-eloop-for-max-recursion-depth
+++ a/fs/exec.c
@@ -1371,6 +1371,10 @@ int search_binary_handler(struct linux_b
 	struct linux_binfmt *fmt;
 	pid_t old_pid, old_vpid;
 
+	/* This allows 4 levels of binfmt rewrites before failing hard. */
+	if (depth > 5)
+		return -ELOOP;
+
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
@@ -1395,12 +1399,8 @@ int search_binary_handler(struct linux_b
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
+			bprm->recursion_depth = depth + 1;
 			retval = fn(bprm);
-			/*
-			 * Restore the depth counter to its starting value
-			 * in this call, so we don't have to rely on every
-			 * load_binary function to restore it on return.
-			 */
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0) {
diff -puN include/linux/binfmts.h~exec-use-eloop-for-max-recursion-depth include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-use-eloop-for-max-recursion-depth
+++ a/include/linux/binfmts.h
@@ -54,8 +54,6 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
-#define BINPRM_MAX_RECURSION 4
