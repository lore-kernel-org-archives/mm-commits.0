From: akpm@linux-foundation.org
Subject: - remove-noreplacement-option.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:39 -0700
Message-ID: <200704132330.l3DNUd9B012757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161255AbXDMXao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Remove noreplacement option
has been removed from the -mm tree.  Its filename was
     remove-noreplacement-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove noreplacement option
From: Jeremy Fitzhardinge <jeremy@goop.org>

noreplacement is dangerous on modern systems because it will not replace the
context switch FNSAVE with SSE aware FXSAVE.  But other places in the kernel
still assume SSE and do FXSAVE and the CPU will then access FXSAVE information
with FNSAVE and cause corruption.

Easiest way to avoid this is to remove the option.  It was mostly for paranoia
reasons anyways and alternative()s have been stable for some time.

Thanks to Jeremy F. for reporting and helping debug it.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    4 ----
 arch/i386/kernel/alternative.c        |   21 ++-------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~remove-noreplacement-option Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~remove-noreplacement-option
+++ a/Documentation/x86_64/boot-options.txt
@@ -305,7 +305,3 @@ Debugging
 			stuck (default)
 
 Miscellaneous
-
-  noreplacement  Don't replace instructions with more appropriate ones
-		 for the CPU. This may be useful on asymmetric MP systems
-		 where some CPUs have less capabilities than others.
diff -puN arch/i386/kernel/alternative.c~remove-noreplacement-option arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~remove-noreplacement-option
+++ a/arch/i386/kernel/alternative.c
@@ -5,15 +5,9 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
-static int no_replacement    = 0;
 static int smp_alt_once      = 0;
 static int debug_alternative = 0;
 
-static int __init noreplacement_setup(char *s)
-{
-	no_replacement = 1;
-	return 1;
-}
 static int __init bootonly(char *str)
 {
 	smp_alt_once = 1;
@@ -25,7 +19,6 @@ static int __init debug_alt(char *str)
 	return 1;
 }
 
-__setup("noreplacement", noreplacement_setup);
 __setup("smp-alt-boot", bootonly);
 __setup("debug-alternative", debug_alt);
 
@@ -252,9 +245,6 @@ void alternatives_smp_module_add(struct 
 	struct smp_alt_module *smp;
 	unsigned long flags;
 
-	if (no_replacement)
-		return;
-
 	if (smp_alt_once) {
 		if (boot_cpu_has(X86_FEATURE_UP))
 			alternatives_smp_unlock(locks, locks_end,
@@ -289,7 +279,7 @@ void alternatives_smp_module_del(struct 
 	struct smp_alt_module *item;
 	unsigned long flags;
 
-	if (no_replacement || smp_alt_once)
+	if (smp_alt_once)
 		return;
 
 	spin_lock_irqsave(&smp_alt, flags);
@@ -320,7 +310,7 @@ void alternatives_smp_switch(int smp)
 	return;
 #endif
 
-	if (no_replacement || smp_alt_once)
+	if (smp_alt_once)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
@@ -378,13 +368,6 @@ extern struct paravirt_patch_site __star
 void __init alternative_instructions(void)
 {
 	unsigned long flags;
-	if (no_replacement) {
-		printk(KERN_INFO "(SMP-)alternatives turned off\n");
-		free_init_pages("SMP alternatives",
-				__pa_symbol(&__smp_alt_begin),
-				__pa_symbol(&__smp_alt_end));
-		return;
-	}
 
 	local_irq_save(flags);
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
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
