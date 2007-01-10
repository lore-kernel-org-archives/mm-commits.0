From: akpm@osdl.org
Subject: - remove-fastcall-references-in-x86_64-code.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:48 -0800
Message-ID: <200701102303.l0AN3mP1010856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33493 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965285AbXAJXEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:04:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Remove fastcall references in x86_64 code
has been removed from the -mm tree.  Its filename was
     remove-fastcall-references-in-x86_64-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove fastcall references in x86_64 code
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Unlike x86, x86_64 already passes arguments in registers.  The use of
regparm attribute makes no difference in produced code, and the use of
fastcall just bloats the code.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/acpi/sleep.c  |    2 +-
 arch/x86_64/kernel/x8664_ksyms.c |    4 ++--
 include/asm-x86_64/hw_irq.h      |    2 +-
 include/asm-x86_64/mutex.h       |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/acpi/sleep.c~remove-fastcall-references-in-x86_64-code arch/x86_64/kernel/acpi/sleep.c
--- a/arch/x86_64/kernel/acpi/sleep.c~remove-fastcall-references-in-x86_64-code
+++ a/arch/x86_64/kernel/acpi/sleep.c
@@ -58,7 +58,7 @@ unsigned long acpi_wakeup_address = 0;
 unsigned long acpi_video_flags;
 extern char wakeup_start, wakeup_end;
 
-extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
+extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 
 static pgd_t low_ptr;
 
diff -puN arch/x86_64/kernel/x8664_ksyms.c~remove-fastcall-references-in-x86_64-code arch/x86_64/kernel/x8664_ksyms.c
--- a/arch/x86_64/kernel/x8664_ksyms.c~remove-fastcall-references-in-x86_64-code
+++ a/arch/x86_64/kernel/x8664_ksyms.c
@@ -35,8 +35,8 @@ EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 
 #ifdef CONFIG_SMP
-extern void FASTCALL( __write_lock_failed(rwlock_t *rw));
-extern void FASTCALL( __read_lock_failed(rwlock_t *rw));
+extern void  __write_lock_failed(rwlock_t *rw);
+extern void  __read_lock_failed(rwlock_t *rw);
 EXPORT_SYMBOL(__write_lock_failed);
 EXPORT_SYMBOL(__read_lock_failed);
 #endif
diff -puN include/asm-x86_64/hw_irq.h~remove-fastcall-references-in-x86_64-code include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~remove-fastcall-references-in-x86_64-code
+++ a/include/asm-x86_64/hw_irq.h
@@ -91,7 +91,7 @@ extern void enable_8259A_irq(unsigned in
 extern int i8259A_irq_pending(unsigned int irq);
 extern void make_8259A_irq(unsigned int irq);
 extern void init_8259A(int aeoi);
-extern void FASTCALL(send_IPI_self(int vector));
+extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
diff -puN include/asm-x86_64/mutex.h~remove-fastcall-references-in-x86_64-code include/asm-x86_64/mutex.h
--- a/include/asm-x86_64/mutex.h~remove-fastcall-references-in-x86_64-code
+++ a/include/asm-x86_64/mutex.h
@@ -21,7 +21,7 @@ do {									\
 	unsigned long dummy;						\
 									\
 	typecheck(atomic_t *, v);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   decl (%%rdi)	\n"			\
@@ -47,7 +47,7 @@ do {									\
  */
 static inline int
 __mutex_fastpath_lock_retval(atomic_t *count,
-			     int fastcall (*fail_fn)(atomic_t *))
+			     int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -67,7 +67,7 @@ do {									\
 	unsigned long dummy;						\
 									\
 	typecheck(atomic_t *, v);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   incl (%%rdi)	\n"			\
_

Patches currently in -mm which might be from gcosta@redhat.com are
