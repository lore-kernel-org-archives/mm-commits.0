From: akpm@linux-foundation.org
Subject: + fs-execc-export-free_arg_pages.patch added to -mm tree
Date: Thu, 08 May 2008 13:22:07 -0700
Message-ID: <200805082022.m48KM7YB004004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883AbYEHUWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, wangcong@zeuux.org


The patch titled
     fs/exec.c: export free_arg_pages
has been added to the -mm tree.  Its filename is
     fs-execc-export-free_arg_pages.patch

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
Subject: fs/exec.c: export free_arg_pages
From: WANG Cong <xiyou.wangcong@gmail.com>

free_arg_pages() is used to clean the pages allocated by copy_strings_kenrel().
Since copy_strings_kernel() is exported, so should be free_arg_pages().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    6 ++++--
 include/linux/binfmts.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-export-free_arg_pages fs/exec.c
--- a/fs/exec.c~fs-execc-export-free_arg_pages
+++ a/fs/exec.c
@@ -210,7 +210,7 @@ static void free_arg_page(struct linux_b
 {
 }
 
-static void free_arg_pages(struct linux_binprm *bprm)
+void free_arg_pages(struct linux_binprm *bprm)
 {
 }
 
@@ -301,7 +301,7 @@ static void free_arg_page(struct linux_b
 	}
 }
 
-static void free_arg_pages(struct linux_binprm *bprm)
+void free_arg_pages(struct linux_binprm *bprm)
 {
 	int i;
 
@@ -327,6 +327,8 @@ static bool valid_arg_len(struct linux_b
 
 #endif /* CONFIG_MMU */
 
+EXPORT_SYMBOL(free_arg_pages);
+
 /*
  * Create a new mm_struct and populate it with a temporary stack
  * vm_area_struct.  We don't have enough context at this point to set the stack
diff -puN include/linux/binfmts.h~fs-execc-export-free_arg_pages include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-execc-export-free_arg_pages
+++ a/include/linux/binfmts.h
@@ -96,6 +96,7 @@ extern int setup_arg_pages(struct linux_
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
+extern void free_arg_pages(struct linux_binprm *bprm);
 extern void compute_creds(struct linux_binprm *binprm);
 extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
uml-use-div_round_up.patch
uml-use-page_size-in-linker-scripts.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
fs-binfmt_elfc-fix-a-wrong-free.patch
cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
fs-execc-export-free_arg_pages.patch
fs-execc-fix-resource-leaks-and-wrong-gotos.patch
fs-compatc-fix-resource-leaks-and-wrong-gotos.patch
fs-binfmt_scriptc-fix-resource-leaks.patch
fs-binfmt_em86c-fix-resource-leaks.patch
fs-binfmt_miscc-fix-resource-leaks.patch
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

