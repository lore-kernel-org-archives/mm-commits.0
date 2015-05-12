From: akpm@linux-foundation.org
Subject: +
 x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch added to -mm tree
Date: Tue, 12 May 2015 14:23:09 -0700
Message-ID: <55526f3d.iGYtTRrrBiGtBoyp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608AbbELVXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 17:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, hpa@zytor.com, luto@kernel.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, thiago.macieira@intel.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
has been added to the -mm tree.  Its filename is
     x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: x86: opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit

For 32-bit userspace on a 64-bit kernel, this requires modifying
stub32_clone to actually swap the appropriate arguments to match
CONFIG_CLONE_BACKWARDS, rather than just leaving the C argument for tls
broken.

Patch co-authored by Josh Triplett and Thiago Macieira.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig             |    1 +
 arch/x86/ia32/ia32entry.S    |    2 +-
 arch/x86/kernel/process_32.c |    6 +++---
 arch/x86/kernel/process_64.c |    8 ++++----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/x86/Kconfig~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
+	select HAVE_COPY_THREAD_TLS
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
diff -puN arch/x86/ia32/ia32entry.S~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/ia32/ia32entry.S
@@ -584,7 +584,7 @@ GLOBAL(\label)
 	ALIGN
 GLOBAL(stub32_clone)
 	leaq sys_clone(%rip),%rax
-	mov	%r8, %rcx
+	xchg %r8, %rcx
 	jmp  ia32_ptregs_common	
 
 	ALIGN
diff -puN arch/x86/kernel/process_32.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/kernel/process_32.c
@@ -129,8 +129,8 @@ void release_thread(struct task_struct *
 	release_vm86_irqs(dead_task);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-	unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+	unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct task_struct *tsk;
@@ -185,7 +185,7 @@ int copy_thread(unsigned long clone_flag
 	 */
 	if (clone_flags & CLONE_SETTLS)
 		err = do_set_thread_area(p, -1,
-			(struct user_desc __user *)childregs->si, 0);
+			(struct user_desc __user *)tls, 0);
 
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
diff -puN arch/x86/kernel/process_64.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/kernel/process_64.c
@@ -151,8 +151,8 @@ static inline u32 read_32bit_tls(struct
 	return get_desc_base(&t->thread.tls_array[tls]);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-		unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+		unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	int err;
 	struct pt_regs *childregs;
@@ -208,10 +208,10 @@ int copy_thread(unsigned long clone_flag
 #ifdef CONFIG_IA32_EMULATION
 		if (is_ia32_task())
 			err = do_set_thread_area(p, -1,
-				(struct user_desc __user *)childregs->si, 0);
+				(struct user_desc __user *)tls, 0);
 		else
 #endif
-			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
+			err = do_arch_prctl(p, ARCH_SET_FS, tls);
 		if (err)
 			goto out;
 	}
_

Patches currently in -mm which might be from josh@joshtriplett.org are

uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch

