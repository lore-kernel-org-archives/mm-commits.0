From: akpm@linux-foundation.org
Subject: - exec-remove-argv_len-from-struct-linux_binprm.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:19 -0700
Message-ID: <200804300540.m3U5eJui028951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbYD3Fk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, aaw@google.compenguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     exec: remove argv_len from struct linux_binprm
has been removed from the -mm tree.  Its filename was
     exec-remove-argv_len-from-struct-linux_binprm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1268,7 +1268,6 @@ int do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
-	unsigned long env_p;
 	struct files_struct *displaced;
 	int retval;
 
@@ -1321,11 +1320,9 @@ int do_execve(char * filename,
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

origin.patch

