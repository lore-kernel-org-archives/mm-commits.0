From: akpm@linux-foundation.org
Subject: - fs-binfmt_elfc-fix-wrong-return-values.patch removed from -mm tree
Date: Sat, 10 May 2008 12:42:38 -0700
Message-ID: <200805101942.m4AJgcP4006064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755105AbYEJTmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 15:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_elf.c: fix wrong return values
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elfc-fix-wrong-return-values.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_elf.c: fix wrong return values
From: WANG Cong <xiyou.wangcong@gmail.com>

create_elf_tables() returns 0 on success.  But when strnlen_user() "fails", it
returns 0 directly.  So this is wrong.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-fix-wrong-return-values fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-fix-wrong-return-values
+++ a/fs/binfmt_elf.c
@@ -257,7 +257,7 @@ create_elf_tables(struct linux_binprm *b
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
-			return 0;
+			return -EINVAL;
 		p += len;
 	}
 	if (__put_user(0, argv))
@@ -269,7 +269,7 @@ create_elf_tables(struct linux_binprm *b
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
-			return 0;
+			return -EINVAL;
 		p += len;
 	}
 	if (__put_user(0, envp))
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
fs-binfmt_elfc-fix-wrong-return-values.patch

