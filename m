From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-safely-increment-argv-pointers.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:27:29 -0700
Message-ID: <20170711192729.VZC7KJVx1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdGKT1a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, dsafonov@virtuozzo.com, grzegorz.andrejczuk@intel.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@redhat.com, mm-commits@vger.kernel.org, qsa@qualys.com, riel@redhat.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, yamada.masahiro@socionext.com


The patch titled
     Subject: binfmt_elf: safely increment argv pointers
has been removed from the -mm tree.  Its filename was
     binfmt_elf-safely-increment-argv-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: binfmt_elf: safely increment argv pointers

When building the argv/envp pointers, the envp is needlessly
pre-incremented instead of just continuing after the argv pointers are
finished.  In some (likely impossible) race where the strings could be
changed from userspace between copy_strings() and here, it might be
possible to confuse the envp position.  Instead, just use sp like
everything else.

Link: http://lkml.kernel.org/r/20170622173838.GA43308@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Qualys Security Advisory <qsa@qualys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-safely-increment-argv-pointers fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-safely-increment-argv-pointers
+++ a/fs/binfmt_elf.c
@@ -163,8 +163,6 @@ create_elf_tables(struct linux_binprm *b
 	unsigned long p = bprm->p;
 	int argc = bprm->argc;
 	int envc = bprm->envc;
-	elf_addr_t __user *argv;
-	elf_addr_t __user *envp;
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
 	elf_addr_t __user *u_base_platform;
@@ -304,38 +302,38 @@ create_elf_tables(struct linux_binprm *b
 	/* Now, let's put argc (and argv, envp if appropriate) on the stack */
 	if (__put_user(argc, sp++))
 		return -EFAULT;
-	argv = sp;
-	envp = argv + argc + 1;
 
-	/* Populate argv and envp */
+	/* Populate list of argv pointers back to argv strings. */
 	p = current->mm->arg_end = current->mm->arg_start;
 	while (argc-- > 0) {
 		size_t len;
-		if (__put_user((elf_addr_t)p, argv++))
+		if (__put_user((elf_addr_t)p, sp++))
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
 			return -EINVAL;
 		p += len;
 	}
-	if (__put_user(0, argv))
+	if (__put_user(0, sp++))
 		return -EFAULT;
-	current->mm->arg_end = current->mm->env_start = p;
+	current->mm->arg_end = p;
+
+	/* Populate list of envp pointers back to envp strings. */
+	current->mm->env_end = current->mm->env_start = p;
 	while (envc-- > 0) {
 		size_t len;
-		if (__put_user((elf_addr_t)p, envp++))
+		if (__put_user((elf_addr_t)p, sp++))
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
 			return -EINVAL;
 		p += len;
 	}
-	if (__put_user(0, envp))
+	if (__put_user(0, sp++))
 		return -EFAULT;
 	current->mm->env_end = p;
 
 	/* Put the elf_info on the stack in the right place.  */
-	sp = (elf_addr_t __user *)envp + 1;
 	if (copy_to_user(sp, elf_info, ei_index * sizeof(elf_addr_t)))
 		return -EFAULT;
 	return 0;
_

Patches currently in -mm which might be from keescook@chromium.org are

random-do-not-ignore-early-device-randomness.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

