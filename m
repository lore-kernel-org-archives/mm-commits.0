From: akpm@linux-foundation.org
Subject: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:22:23 -0800
Message-ID: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab1CIXW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86/mm: handle mm_fault_error() in kernel space
has been added to the -mm tree.  Its filename is
     x86-mm-handle-mm_fault_error-in-kernel-space.patch

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
Subject: x86/mm: handle mm_fault_error() in kernel space
From: Andrey Vagin <avagin@openvz.org>

mm_fault_error() should not execute oom-killer, if page fault occurs in
kernel space.  E.g.  in copy_from_user/copy_to_user.

This would happen if we find ourselves in OOM on a copy_to_user(), or a
copy_from_user() which faults.

Without this patch, the kernels hangs up in copy_from_user, because OOM
killer sends SIG_KILL to current process, but it can't handle a signal
while in syscall, then the kernel returns to copy_from_user, reexcute
current command and provokes page_fault again.

With this patch the kernel return -EFAULT from copy_from_user.

The code, which checks that page fault occurred in kernel space, has been
copied from do_sigbus.

This situation is handled by the same way on powerpc, xtensa, tile, ...

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/mm/fault.c~x86-mm-handle-mm_fault_error-in-kernel-space arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-mm-handle-mm_fault_error-in-kernel-space
+++ a/arch/x86/mm/fault.c
@@ -827,6 +827,13 @@ mm_fault_error(struct pt_regs *regs, uns
 	       unsigned long address, unsigned int fault)
 {
 	if (fault & VM_FAULT_OOM) {
+		/* Kernel mode? Handle exceptions or die: */
+		if (!(error_code & PF_USER)) {
+			up_read(&current->mm->mmap_sem);
+			no_context(regs, error_code, address);
+			return;
+		}
+
 		out_of_memory(regs, error_code, address);
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
_

Patches currently in -mm which might be from avagin@openvz.org are

x86-mm-handle-mm_fault_error-in-kernel-space.patch
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
oom-skip-zombies-when-iterating-tasklist.patch
fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch
fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch

