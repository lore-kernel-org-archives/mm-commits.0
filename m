From: akpm@linux-foundation.org
Subject: + fs-compatc-fix-resource-leaks-and-wrong-gotos.patch added to -mm tree
Date: Thu, 08 May 2008 13:22:11 -0700
Message-ID: <200805082022.m48KMB49004010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944AbYEHUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, wangcong@zeuux.org


The patch titled
     fs/compat.c: fix resource leaks and wrong goto's
has been added to the -mm tree.  Its filename is
     fs-compatc-fix-resource-leaks-and-wrong-gotos.patch

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
Subject: fs/compat.c: fix resource leaks and wrong goto's
From: WANG Cong <xiyou.wangcong@gmail.com>

Use free_arg_pages() to free the pages allocated by copy_strings_kernel() on
failure.  And fix some related wrong goto pathes.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/compat.c~fs-compatc-fix-resource-leaks-and-wrong-gotos fs/compat.c
--- a/fs/compat.c~fs-compatc-fix-resource-leaks-and-wrong-gotos
+++ a/fs/compat.c
@@ -1381,15 +1381,15 @@ int compat_do_execve(char * filename,
 
 	retval = security_bprm_alloc(bprm);
 	if (retval)
-		goto out;
+		goto out_mm;
 
 	retval = prepare_binprm(bprm);
 	if (retval < 0)
-		goto out;
+		goto out_sec;
 
 	retval = copy_strings_kernel(1, &bprm->filename, bprm);
 	if (retval < 0)
-		goto out;
+		goto out_sec;
 
 	bprm->exec = bprm->p;
 	retval = compat_copy_strings(bprm->envc, envp, bprm);
@@ -1403,6 +1403,7 @@ int compat_do_execve(char * filename,
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
 		/* execve success */
+		free_arg_pages(bprm);
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		kfree(bprm);
@@ -1410,6 +1411,9 @@ int compat_do_execve(char * filename,
 	}
 
 out:
+	free_arg_pages(bprm);
+
+out_sec:
 	if (bprm->security)
 		security_bprm_free(bprm);
 
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

