From: akpm@linux-foundation.org
Subject: - rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:42 -0700
Message-ID: <200704252039.l3PKdg3j012333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993144AbXDYUkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Rename the parainstructions symbols to be consistent with the others
has been removed from the -mm tree.  Its filename was
     rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/i386/kernel/alternative.c |    2 +-
 arch/i386/kernel/vmi.c         |    6 +++---
 arch/i386/kernel/vmlinux.lds.S |    4 ++--
 include/asm-i386/alternative.h |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/alternative.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~rename-the-parainstructions-symbols-to-be-consistent-with-the-others
+++ a/arch/i386/kernel/alternative.c
@@ -386,6 +386,6 @@ void __init alternative_instructions(voi
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
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
 
 /*
  * VMI patching routines.
@@ -920,7 +920,7 @@ static inline int __init activate_vmi(vo
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
@@ -124,8 +124,8 @@ static inline void
 apply_paravirt(struct paravirt_patch_site *start,
 	       struct paravirt_patch_site *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions	NULL
+#define __parainstructions_end	NULL
 #endif
 
 #endif /* _I386_ALTERNATIVE_H */
_

Patches currently in -mm which might be from jeremy@goop.org are

add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
