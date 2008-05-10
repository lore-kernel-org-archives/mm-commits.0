From: akpm@linux-foundation.org
Subject: - fs-execc-fix-wrong-return-value-of-prepare_binprm.patch removed from -mm tree
Date: Sat, 10 May 2008 12:42:36 -0700
Message-ID: <200805101942.m4AJgalh006061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061AbYEJTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/exec.c: fix wrong return value of prepare_binprm()
has been removed from the -mm tree.  Its filename was
     fs-execc-fix-wrong-return-value-of-prepare_binprm.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: fix wrong return value of prepare_binprm()
From: WANG Cong <xiyou.wangcong@gmail.com>

All prepare_binprm()'s callers assume that prepare_binprm() fails when it
returns negative.  However, prepare_binprm() most probably returns the return
value of kernel_read(), which may return positive on failure!

Thus this should be fixed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~fs-execc-fix-wrong-return-value-of-prepare_binprm fs/exec.c
--- a/fs/exec.c~fs-execc-fix-wrong-return-value-of-prepare_binprm
+++ a/fs/exec.c
@@ -1064,10 +1064,14 @@ int prepare_binprm(struct linux_binprm *
 	if (retval)
 		return retval;
 
-	memset(bprm->buf,0,BINPRM_BUF_SIZE);
-	return kernel_read(bprm->file,0,bprm->buf,BINPRM_BUF_SIZE);
+	memset(bprm->buf, 0, BINPRM_BUF_SIZE);
+	retval = kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
+	if (retval < 0)
+		return retval;
+	if (retval != BINPRM_BUF_SIZE && retval != inode->i_size)
+		return -EIO;
+	return 0;
 }
-
 EXPORT_SYMBOL(prepare_binprm);
 
 static int unsafe_exec(struct task_struct *p)
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
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

