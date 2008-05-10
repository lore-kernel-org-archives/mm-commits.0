From: akpm@linux-foundation.org
Subject: - fs-binfmt_miscc-fix-resource-leaks.patch removed from -mm tree
Date: Sat, 10 May 2008 12:42:34 -0700
Message-ID: <200805101942.m4AJgY0O006058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639AbYEJTmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 15:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_misc.c: fix resource leaks
has been removed from the -mm tree.  Its filename was
     fs-binfmt_miscc-fix-resource-leaks.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_misc.c: fix resource leaks
From: WANG Cong <xiyou.wangcong@gmail.com>

->load_binary()'s caller only frees resources which ->load_binary() applied
when it succeeded, so ->load_binary() itself should free the resources on
failure.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-fix-resource-leaks fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-fix-resource-leaks
+++ a/fs/binfmt_misc.c
@@ -174,7 +174,7 @@ static int load_misc_binary(struct linux
 	/* add the interp as argv[0] */
 	retval = copy_strings_kernel (1, &iname_addr, bprm);
 	if (retval < 0)
-		goto _error;
+		goto _error_free;
 	bprm->argc ++;
 
 	bprm->interp = iname;	/* for binfmt_script */
@@ -182,7 +182,7 @@ static int load_misc_binary(struct linux
 	interp_file = open_exec (iname);
 	retval = PTR_ERR (interp_file);
 	if (IS_ERR (interp_file))
-		goto _error;
+		goto _error_free;
 
 	bprm->file = interp_file;
 	if (fmt->flags & MISC_FMT_CREDENTIALS) {
@@ -196,14 +196,22 @@ static int load_misc_binary(struct linux
 		retval = prepare_binprm (bprm);
 
 	if (retval < 0)
-		goto _error;
+		goto _error_file;
 
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
-		goto _error;
+		goto _error_file;
 
 _ret:
 	return retval;
+
+_error_file:
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+
+_error_free:
+	free_arg_pages(bprm);
+
 _error:
 	if (fd_binary > 0)
 		sys_close(fd_binary);
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
fs-binfmt_miscc-fix-resource-leaks.patch
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

