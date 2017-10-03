From: akpm@linux-foundation.org
Subject: [patch 28/51] exec: load_script: kill the onstack
 interp[BINPRM_BUF_SIZE] array
Date: Tue, 03 Oct 2017 16:15:42 -0700
Message-ID: <59d41a1e.ElFCGHmqwcckS28C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com

From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: load_script: kill the onstack interp[BINPRM_BUF_SIZE] array

Patch series "exec: binfmt_misc: fix use-after-free, kill
iname[BINPRM_BUF_SIZE]".

Looks like this code was always wrong, then 948b701a607f ("binfmt_misc:
add persistent opened binary handler for containers") added more problems.

This patch (of 6):

load_script() can simply use i_name instead, it points into bprm->buf[]
and nobody can change this memory until we call prepare_binprm().

The only complication is that we need to also change the signature of
bprm_change_interp() but this change looks good too.

While at it, do whitespace/style cleanups.

NOTE: the real motivation for this change is that people want to increase
BINPRM_BUF_SIZE, we need to change load_misc_binary() too but this looks
more complicated because afaics it is very buggy.

Link: http://lkml.kernel.org/r/20170918163446.GA26793@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Travis Gummels <tgummels@redhat.com>
Cc: Ben Woodard <woodard@redhat.com>
Cc: Jim Foraker <foraker1@llnl.gov>
Cc: <tdhooge@llnl.gov>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_script.c      |   17 +++++++++--------
 fs/exec.c               |    2 +-
 include/linux/binfmts.h |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/binfmt_script.c~exec-load_script-kill-the-onstack-interp-array fs/binfmt_script.c
--- a/fs/binfmt_script.c~exec-load_script-kill-the-onstack-interp-array
+++ a/fs/binfmt_script.c
@@ -19,7 +19,6 @@ static int load_script(struct linux_binp
 	const char *i_arg, *i_name;
 	char *cp;
 	struct file *file;
-	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
@@ -55,7 +54,7 @@ static int load_script(struct linux_binp
 			break;
 	}
 	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
-	if (*cp == '\0') 
+	if (*cp == '\0')
 		return -ENOEXEC; /* No interpreter name found */
 	i_name = cp;
 	i_arg = NULL;
@@ -65,7 +64,6 @@ static int load_script(struct linux_binp
 		*cp++ = '\0';
 	if (*cp)
 		i_arg = cp;
-	strcpy (interp, i_name);
 	/*
 	 * OK, we've parsed out the interpreter name and
 	 * (optional) argument.
@@ -80,24 +78,27 @@ static int load_script(struct linux_binp
 	if (retval)
 		return retval;
 	retval = copy_strings_kernel(1, &bprm->interp, bprm);
-	if (retval < 0) return retval; 
+	if (retval < 0)
+		return retval;
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0)
+			return retval;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval; 
+	if (retval)
+		return retval;
 	bprm->argc++;
-	retval = bprm_change_interp(interp, bprm);
+	retval = bprm_change_interp(i_name, bprm);
 	if (retval < 0)
 		return retval;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
 	 */
-	file = open_exec(interp);
+	file = open_exec(i_name);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff -puN fs/exec.c~exec-load_script-kill-the-onstack-interp-array fs/exec.c
--- a/fs/exec.c~exec-load_script-kill-the-onstack-interp-array
+++ a/fs/exec.c
@@ -1410,7 +1410,7 @@ static void free_bprm(struct linux_binpr
 	kfree(bprm);
 }
 
-int bprm_change_interp(char *interp, struct linux_binprm *bprm)
+int bprm_change_interp(const char *interp, struct linux_binprm *bprm)
 {
 	/* If a binfmt changed the interp, free it first. */
 	if (bprm->interp != bprm->filename)
diff -puN include/linux/binfmts.h~exec-load_script-kill-the-onstack-interp-array include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-load_script-kill-the-onstack-interp-array
+++ a/include/linux/binfmts.h
@@ -131,7 +131,7 @@ extern int setup_arg_pages(struct linux_
 			   int executable_stack);
 extern int transfer_args_to_stack(struct linux_binprm *bprm,
 				  unsigned long *sp_location);
-extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
+extern int bprm_change_interp(const char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
_
