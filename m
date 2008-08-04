From: akpm@linux-foundation.org
Subject: + h8300-generic_bug-support.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:17:50 -0700
Message-ID: <200808042317.m74NHo6g004931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633AbYHDXSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: GENERIC_BUG support
has been added to the -mm tree.  Its filename is
     h8300-generic_bug-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: GENERIC_BUG support
From: Yoshinori Sato <ysato@users.sourceforge.jp>

CONFIG_GENERIC_BUG support.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig         |    4 ++++
 arch/h8300/kernel/module.c |    3 ++-
 arch/h8300/kernel/traps.c  |   17 +++++++++++------
 arch/h8300/mm/fault.c      |    5 ++---
 include/asm-h8300/bug.h    |    4 ++++
 include/asm-h8300/system.h |    2 ++
 6 files changed, 25 insertions(+), 10 deletions(-)

diff -puN arch/h8300/Kconfig~h8300-generic_bug-support arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~h8300-generic_bug-support
+++ a/arch/h8300/Kconfig
@@ -62,6 +62,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_BUG
+        bool
+        depends on BUG
+
 config TIME_LOW_RES
 	bool
 	default y
diff -puN arch/h8300/kernel/module.c~h8300-generic_bug-support arch/h8300/kernel/module.c
--- a/arch/h8300/kernel/module.c~h8300-generic_bug-support
+++ a/arch/h8300/kernel/module.c
@@ -114,9 +114,10 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
-	return 0;
+	return module_bug_finalize(hdr, sechdrs, me);
 }
 
 void module_arch_cleanup(struct module *mod)
 {
+	module_bug_cleanup(mod);
 }
diff -puN arch/h8300/kernel/traps.c~h8300-generic_bug-support arch/h8300/kernel/traps.c
--- a/arch/h8300/kernel/traps.c~h8300-generic_bug-support
+++ a/arch/h8300/kernel/traps.c
@@ -20,12 +20,14 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/bug.h>
 
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/page.h>
-#include <asm/gpio.h>
+
+static DEFINE_SPINLOCK(die_lock);
 
 /*
  * this must be called very early as the kernel might
@@ -94,16 +96,19 @@ static void dump(struct pt_regs *fp)
 	printk("\n\n");
 }
 
-void die_if_kernel (char *str, struct pt_regs *fp, int nr)
+void die(char *str, struct pt_regs *fp, unsigned long err)
 {
-	extern int console_loglevel;
+	static int diecount = 0;
 
-	if (!(fp->ccr & PS_S))
-		return;
+	oops_enter();
 
-	console_loglevel = 15;
+	console_verbose();
+	spin_lock_irq(&die_lock);
+	report_bug(fp->pc, fp);
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++diecount);
 	dump(fp);
 
+	spin_unlock_irq(&die_lock);
 	do_exit(SIGSEGV);
 }
 
diff -puN arch/h8300/mm/fault.c~h8300-generic_bug-support arch/h8300/mm/fault.c
--- a/arch/h8300/mm/fault.c~h8300-generic_bug-support
+++ a/arch/h8300/mm/fault.c
@@ -20,8 +20,6 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 
-extern void die_if_kernel(char *, struct pt_regs *, long);
-
 /*
  * This routine handles page faults.  It determines the problem, and
  * then passes it off to one of the appropriate routines.
@@ -50,7 +48,8 @@ asmlinkage int do_page_fault(struct pt_r
 	} else
 		printk(KERN_ALERT "Unable to handle kernel access");
 	printk(" at virtual address %08lx\n",address);
-	die_if_kernel("Oops", regs, error_code);
+	if (!user_mode(regs))
+		die("Oops", regs, error_code);
 	do_exit(SIGKILL);
 
 	return 1;
diff -puN include/asm-h8300/bug.h~h8300-generic_bug-support include/asm-h8300/bug.h
--- a/include/asm-h8300/bug.h~h8300-generic_bug-support
+++ a/include/asm-h8300/bug.h
@@ -1,4 +1,8 @@
 #ifndef _H8300_BUG_H
 #define _H8300_BUG_H
+
+/* always true */
+#define is_valid_bugaddr(addr) (1)
+
 #include <asm-generic/bug.h>
 #endif
diff -puN include/asm-h8300/system.h~h8300-generic_bug-support include/asm-h8300/system.h
--- a/include/asm-h8300/system.h~h8300-generic_bug-support
+++ a/include/asm-h8300/system.h
@@ -155,4 +155,6 @@ static inline unsigned long __xchg(unsig
 
 #define arch_align_stack(x) (x)
 
+void die(char *str, struct pt_regs *fp, unsigned long err);
+
 #endif /* _H8300_SYSTEM_H */
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch
h8300-kconfig-cleanup.patch
h8300-generic_bug-support.patch

