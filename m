From: akpm@linux-foundation.org
Subject: + rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch added to -mm tree
Date: Thu, 05 Apr 2007 17:47:32 -0700
Message-ID: <200704060047.l360lWOI030805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59562 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767463AbXDFArm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 20:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     Rename the parainstructions symbols to be consistent with the others
has been added to the -mm tree.  Its filename is
     rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Rename the parainstructions symbols to be consistent with the others
From: Jeremy Fitzhardinge <jeremy@goop.org>

The other symbols used to delineate the alt-instructions sections have the
form __foo/__foo_end.  Rename parainstructions to match.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    6 +++---
 arch/i386/kernel/vmi.c         |    6 +++---
 arch/i386/kernel/vmlinux.lds.S |    4 ++--
 include/asm-i386/alternative.h |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/i386/kernel/alternative.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others
+++ a/arch/i386/kernel/alternative.c
@@ -339,8 +339,8 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
+extern struct paravirt_patch __parainstructions[],
+	__parainstructions_end[];
 #endif	/* CONFIG_PARAVIRT */
 
 void __init alternative_instructions(void)
@@ -379,6 +379,6 @@ void __init alternative_instructions(voi
 		alternatives_smp_switch(0);
 	}
 #endif
- 	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+ 	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
diff -puN arch/i386/kernel/vmi.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others
+++ a/arch/i386/kernel/vmi.c
@@ -73,8 +73,8 @@ static struct {
 } vmi_ops;
 
 /* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
+extern struct paravirt_patch __parainstructions[],
+	__parainstructions_end[];
 
 /*
  * VMI patching routines.
@@ -947,7 +947,7 @@ static inline int __init activate_vmi(vo
 	 * to do this before IRQs get reenabled.  Fortunately, it is
 	 * idempotent.
 	 */
-	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+	apply_paravirt(__parainstructions, __parainstructions_end);
 
 	vmi_bringup();
 
diff -puN arch/i386/kernel/vmlinux.lds.S~rename-the-parainstructions-symbols-to-be-consistent-with-the-others arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~rename-the-parainstructions-symbols-to-be-consistent-with-the-others
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -169,9 +169,9 @@ SECTIONS
   }
   . = ALIGN(4);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__start_parainstructions = .;
+  	__parainstructions = .;
 	*(.parainstructions)
-  	__stop_parainstructions = .;
+  	__parainstructions_end = .;
   }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
diff -puN include/asm-i386/alternative.h~rename-the-parainstructions-symbols-to-be-consistent-with-the-others include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~rename-the-parainstructions-symbols-to-be-consistent-with-the-others
+++ a/include/asm-i386/alternative.h
@@ -121,8 +121,8 @@ void apply_paravirt(struct paravirt_patc
 static inline void
 apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions	NULL
+#define __parainstructions_end	NULL
 #endif
 
 #endif /* _I386_ALTERNATIVE_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
