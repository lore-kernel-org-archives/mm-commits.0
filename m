From: akpm@linux-foundation.org
Subject: + fs-execc-make-do_coredump-void.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:09:11 -0800
Message-ID: <200812302309.mBUN9BTo018296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbYL3XJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, viro@zeniv.linux.org.uk


The patch titled
     fs/exec.c: make do_coredump() void
has been added to the -mm tree.  Its filename is
     fs-execc-make-do_coredump-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: make do_coredump() void
From: WANG Cong <wangcong@zeuux.org>

No one cares do_coredump()'s return value, and also it seems that it
is also not necessary. So make it void.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    4 ++--
 include/linux/binfmts.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~fs-execc-make-do_coredump-void fs/exec.c
--- a/fs/exec.c~fs-execc-make-do_coredump-void
+++ a/fs/exec.c
@@ -1724,7 +1724,7 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
-int do_coredump(long signr, int exit_code, struct pt_regs * regs)
+void do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
@@ -1880,5 +1880,5 @@ fail_unlock:
 	put_cred(cred);
 	coredump_finish(mm);
 fail:
-	return retval;
+	return;
 }
diff -puN include/linux/binfmts.h~fs-execc-make-do_coredump-void include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-execc-make-do_coredump-void
+++ a/include/linux/binfmts.h
@@ -107,7 +107,7 @@ extern int setup_arg_pages(struct linux_
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
-extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
+extern void do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
_

Patches currently in -mm which might be from wangcong@zeuux.org are

origin.patch
fs-nfs-nfs4procc-make-nfs4_map_errors-static.patch
fs-execc-make-do_coredump-void.patch
ipc-clean-up-ipc-shmc.patch
ipc-do-not-goto-to-the-next-line.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

