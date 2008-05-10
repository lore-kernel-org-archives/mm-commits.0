From: akpm@linux-foundation.org
Subject: - fs-binfmt_em86c-fix-resource-leaks.patch removed from -mm tree
Date: Sat, 10 May 2008 12:42:32 -0700
Message-ID: <200805101942.m4AJgWHI006055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbYEJTmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 15:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_em86.c: fix resource leaks
has been removed from the -mm tree.  Its filename was
     fs-binfmt_em86c-fix-resource-leaks.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_em86.c: fix resource leaks
From: WANG Cong <xiyou.wangcong@gmail.com>

->load_binary()'s caller only frees resources which ->load_binary() applied
when it succeeded, so ->load_binary() itself should free the resources on
failure.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_em86.c~fs-binfmt_em86c-fix-resource-leaks fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~fs-binfmt_em86c-fix-resource-leaks
+++ a/fs/binfmt_em86.c
@@ -69,11 +69,13 @@ static int load_em86(struct linux_binprm
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0)
+			goto out;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval < 0)	return retval;
+	if (retval < 0)
+		goto out;
 	bprm->argc++;
 
 	/*
@@ -82,16 +84,27 @@ static int load_em86(struct linux_binprm
 	 * space, and we don't need to copy it.
 	 */
 	file = open_exec(interp);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
+	if (IS_ERR(file)) {
+		retval = PTR_ERR(file);
+		goto out;
+	}
 
 	bprm->file = file;
 
 	retval = prepare_binprm(bprm);
-	if (retval < 0)
-		return retval;
+	if (retval < 0) {
+		if (bprm->file) {
+			allow_write_access(bprm->file);
+			fput(bprm->file);
+		}
+		goto out;
+	}
 
 	return search_binary_handler(bprm, regs);
+
+out:
+	free_arg_pages(bprm);
+	return retval;
 }
 
 static struct linux_binfmt em86_format = {
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
fs-binfmt_em86c-fix-resource-leaks.patch
fs-binfmt_miscc-fix-resource-leaks.patch
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

