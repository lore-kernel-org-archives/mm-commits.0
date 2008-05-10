From: akpm@linux-foundation.org
Subject: - fs-execc-fix-resource-leaks-and-wrong-gotos.patch removed from -mm tree
Date: Sat, 10 May 2008 12:42:26 -0700
Message-ID: <200805101942.m4AJgQ6J006046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbYEJTm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 15:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c: fix resource leaks and wrong goto's
has been removed from the -mm tree.  Its filename was
     fs-execc-fix-resource-leaks-and-wrong-gotos.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: fix resource leaks and wrong goto's
From: WANG Cong <xiyou.wangcong@gmail.com>

When ->load_binary() successed, free_arg_pages() should be called to clean the
pages allocated by copy_strings_kernel() within it.

And also fixes some wrong goto pathes.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~fs-execc-fix-resource-leaks-and-wrong-gotos fs/exec.c
--- a/fs/exec.c~fs-execc-fix-resource-leaks-and-wrong-gotos
+++ a/fs/exec.c
@@ -1220,6 +1220,7 @@ int search_binary_handler(struct linux_b
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
+				free_arg_pages(bprm);
 				current->did_exec = 1;
 				proc_exec_connector(current);
 				return retval;
@@ -1300,15 +1301,15 @@ int do_execve(char * filename,
 
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
 	retval = copy_strings(bprm->envc, envp, bprm);
@@ -1333,6 +1334,8 @@ int do_execve(char * filename,
 
 out:
 	free_arg_pages(bprm);
+
+out_sec:
 	if (bprm->security)
 		security_bprm_free(bprm);
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-redo-host-capability-detection-and-disabling.patch
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
fs-execc-fix-resource-leaks-and-wrong-gotos.patch
fs-compatc-fix-resource-leaks-and-wrong-gotos.patch
fs-binfmt_scriptc-fix-resource-leaks.patch
fs-binfmt_em86c-fix-resource-leaks.patch
fs-binfmt_miscc-fix-resource-leaks.patch
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

