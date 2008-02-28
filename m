From: akpm@linux-foundation.org
Subject: + exec-remove-argv_len-from-struct-linux_binprm.patch added to -mm tree
Date: Wed, 27 Feb 2008 18:43:09 -0800
Message-ID: <200802280243.m1S2h98J011789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758779AbYB1Cnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 21:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jp, aaw@google.compenguin-kernel@i-love.sakura.ne.jp


The patch titled
     exec: remove argv_len from struct linux_binprm
has been added to the -mm tree.  Its filename is
     exec-remove-argv_len-from-struct-linux_binprm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: remove argv_len from struct linux_binprm
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

I noticed that 2.6.24.2 calculates bprm->argv_len at do_execve().  But it
doesn't update bprm->argv_len after "remove_arg_zero() +
copy_strings_kernel()" at load_script() etc.

audit_bprm() is called from search_binary_handler() and
search_binary_handler() is called from load_script() etc.  Thus, I think the
condition check

  if (bprm->argv_len > (audit_argv_kb << 10))
          return -E2BIG;

in audit_bprm() might return wrong result when strlen(removed_arg) !=
strlen(spliced_args).  Why not update bprm->argv_len at load_script() etc.  ?

By the way, 2.6.25-rc3 seems to not doing the condition check.  Is the field
bprm->argv_len no longer needed?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Ollie Wild <aaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    3 ---
 include/linux/binfmts.h |    1 -
 2 files changed, 4 deletions(-)

diff -puN fs/exec.c~exec-remove-argv_len-from-struct-linux_binprm fs/exec.c
--- a/fs/exec.c~exec-remove-argv_len-from-struct-linux_binprm
+++ a/fs/exec.c
@@ -1274,7 +1274,6 @@ int do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
-	unsigned long env_p;
 	int retval;
 
 	retval = -ENOMEM;
@@ -1322,11 +1321,9 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	env_p = bprm->p;
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
-	bprm->argv_len = env_p - bprm->p;
 
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
diff -puN include/linux/binfmts.h~exec-remove-argv_len-from-struct-linux_binprm include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-remove-argv_len-from-struct-linux_binprm
+++ a/include/linux/binfmts.h
@@ -48,7 +48,6 @@ struct linux_binprm{
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-	unsigned long argv_len;
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

exec-remove-argv_len-from-struct-linux_binprm.patch
random-clean-up-checkpatch-complaints-fix.patch
