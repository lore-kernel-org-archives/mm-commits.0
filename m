From: akpm@linux-foundation.org
Subject: + pm-cleanup-includes.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:48:36 -0800
Message-ID: <200902262048.n1QKmaUx020857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZBZUtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, lethal@linux-sh.org, rjw@sisk.pl


The patch titled
     pm: cleanup includes
has been added to the -mm tree.  Its filename is
     pm-cleanup-includes.patch

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
Subject: pm: cleanup includes
From: Magnus Damm <damm@igel.co.jp>

Remove unused/duplicate cruft from asm/suspend.h:

 - x86_32: remove unused acpi code
 - powerpc: remove duplicate prototypes, see linux/suspend.h

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
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
