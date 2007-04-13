From: akpm@linux-foundation.org
Subject: - paravirt_ops-remove-config_debug_paravirt.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:56 -0700
Message-ID: <200704132329.l3DNTune012664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161172AbXDMXaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: Remove CONFIG_DEBUG_PARAVIRT
has been removed from the -mm tree.  Its filename was
     paravirt_ops-remove-config_debug_paravirt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: Remove CONFIG_DEBUG_PARAVIRT
From: Jeremy Fitzhardinge <jeremy@goop.org>

Remove CONFIG_DEBUG_PARAVIRT.  When inlining code, this option attempts to
trash registers in the patch-site's "clobber" field, on the grounds that this
should find bugs with incorrect clobbers.  Unfortunately, the clobber field
really means "registers modified by this patch site", which includes return
values.

Because of this, this option has outlived its usefulness, so remove it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.debug        |   10 ----------
 arch/i386/kernel/alternative.c |   14 +-------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN arch/i386/Kconfig.debug~paravirt_ops-remove-config_debug_paravirt arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug~paravirt_ops-remove-config_debug_paravirt
+++ a/arch/i386/Kconfig.debug
@@ -85,14 +85,4 @@ config DOUBLEFAULT
           option saves about 4k and might cause you much additional grey
           hair.
 
-config DEBUG_PARAVIRT
-	bool "Enable some paravirtualization debugging"
-	default n
-	depends on PARAVIRT && DEBUG_KERNEL
-	help
-	  Currently deliberately clobbers regs which are allowed to be
-	  clobbered in inlined paravirt hooks, even in native mode.
-	  If turning this off solves a problem, then DISABLE_INTERRUPTS() or
-	  ENABLE_INTERRUPTS() is lying about what registers can be clobbered.
-
 endmenu
diff -puN arch/i386/kernel/alternative.c~paravirt_ops-remove-config_debug_paravirt arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~paravirt_ops-remove-config_debug_paravirt
+++ a/arch/i386/kernel/alternative.c
@@ -359,19 +359,7 @@ void apply_paravirt(struct paravirt_patc
 
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, p->instr,
 					  p->len);
-#ifdef CONFIG_DEBUG_PARAVIRT
-		{
-		int i;
-		/* Deliberately clobber regs using "not %reg" to find bugs. */
-		for (i = 0; i < 3; i++) {
-			if (p->len - used >= 2 && (p->clobbers & (1 << i))) {
-				memcpy(p->instr + used, "\xf7\xd0", 2);
-				p->instr[used+1] |= i;
-				used += 2;
-			}
-		}
-		}
-#endif
+
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
 	}
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
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
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
