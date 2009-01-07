From: akpm@linux-foundation.org
Subject: - fs-execc-make-do_coredump-void.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:30 -0800
Message-ID: <200901072220.n07MKU3p019739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762983AbZAGWfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:35:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c: make do_coredump() void
has been removed from the -mm tree.  Its filename was
     fs-execc-make-do_coredump-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: make do_coredump() void
From: WANG Cong <wangcong@zeuux.org>

No one cares do_coredump()'s return value, and also it seems that it
is also not necessary. So make it void.

[akpm@linux-foundation.org: coding-style fixes]
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
@@ -1686,7 +1686,7 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
-int do_coredump(long signr, int exit_code, struct pt_regs * regs)
+void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
@@ -1842,5 +1842,5 @@ fail_unlock:
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
+extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
 extern int set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
_

Patches currently in -mm which might be from wangcong@zeuux.org are

origin.patch

