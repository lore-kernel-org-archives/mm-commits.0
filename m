From: akpm@linux-foundation.org
Subject: [merged]
 x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:48:17 -0700
Message-ID: <559adb81.WgYwf5RfZQnmjO9q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbbGFTsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, hpa@zytor.com, luto@kernel.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, thiago.macieira@intel.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
has been removed from the -mm tree.  Its filename was
     x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig             |    1 +
 arch/x86/kernel/process_32.c |    6 +++---
 arch/x86/kernel/process_64.c |    8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/x86/Kconfig~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/Kconfig
@@ -88,6 +88,7 @@ config X86
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING		if X86_64
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
diff -puN arch/x86/kernel/process_32.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit
+++ a/arch/x86/kernel/process_32.c
@@ -128,8 +128,8 @@ void release_thread(struct task_struct *
 	release_vm86_irqs(dead_task);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-	unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+	unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct task_struct *tsk;
@@ -184,7 +184,7 @@ int copy_thread(unsigned long clone_flag
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
@@ -150,8 +150,8 @@ static inline u32 read_32bit_tls(struct
 	return get_desc_base(&t->thread.tls_array[tls]);
 }
 
-int copy_thread(unsigned long clone_flags, unsigned long sp,
-		unsigned long arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
+		unsigned long arg, struct task_struct *p, unsigned long tls)
 {
 	int err;
 	struct pt_regs *childregs;
@@ -207,10 +207,10 @@ int copy_thread(unsigned long clone_flag
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


