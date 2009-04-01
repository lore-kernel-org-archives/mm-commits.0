From: akpm@linux-foundation.org
Subject: [merged] pm-cleanup-includes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:19 -0700
Message-ID: <200904011839.n31IdJmY008647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933442AbZDASm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, lethal@linux-sh.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: cleanup includes
has been removed from the -mm tree.  Its filename was
     pm-cleanup-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: cleanup includes
From: Magnus Damm <damm@igel.co.jp>

Remove unused/duplicate cruft from asm/suspend.h:

 - x86_32: remove unused acpi code
 - powerpc: remove duplicate prototypes, see linux/suspend.h

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/suspend.h |    3 ---
 arch/x86/include/asm/suspend_32.h  |   24 ------------------------
 2 files changed, 27 deletions(-)

diff -puN arch/powerpc/include/asm/suspend.h~pm-cleanup-includes arch/powerpc/include/asm/suspend.h
--- a/arch/powerpc/include/asm/suspend.h~pm-cleanup-includes
+++ a/arch/powerpc/include/asm/suspend.h
@@ -3,7 +3,4 @@
 
 static inline int arch_prepare_suspend(void) { return 0; }
 
-void save_processor_state(void);
-void restore_processor_state(void);
-
 #endif /* __ASM_POWERPC_SUSPEND_H */
diff -puN arch/x86/include/asm/suspend_32.h~pm-cleanup-includes arch/x86/include/asm/suspend_32.h
--- a/arch/x86/include/asm/suspend_32.h~pm-cleanup-includes
+++ a/arch/x86/include/asm/suspend_32.h
@@ -24,28 +24,4 @@ struct saved_context {
 	unsigned long return_address;
 } __attribute__((packed));
 
-#ifdef CONFIG_ACPI
-extern unsigned long saved_eip;
-extern unsigned long saved_esp;
-extern unsigned long saved_ebp;
-extern unsigned long saved_ebx;
-extern unsigned long saved_esi;
-extern unsigned long saved_edi;
-
-static inline void acpi_save_register_state(unsigned long return_point)
-{
-	saved_eip = return_point;
-	asm volatile("movl %%esp,%0" : "=m" (saved_esp));
-	asm volatile("movl %%ebp,%0" : "=m" (saved_ebp));
-	asm volatile("movl %%ebx,%0" : "=m" (saved_ebx));
-	asm volatile("movl %%edi,%0" : "=m" (saved_edi));
-	asm volatile("movl %%esi,%0" : "=m" (saved_esi));
-}
-
-#define acpi_restore_register_state()  do {} while (0)
-
-/* routines for saving/restoring kernel state */
-extern int acpi_save_state_mem(void);
-#endif
