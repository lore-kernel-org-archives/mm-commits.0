From: akpm@linux-foundation.org
Subject: + account-for-module-percpu-space-separately-from-kernel.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:19:48 -0700
Message-ID: <200704110019.l3B0JmlU023915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200AbXDKAUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, davem@davemloft.net, ebiederm@xmission.com, ink@jurassic.park.msu.ru, jeremy@xensource.com, rth@twiddle.net, rusty@rustcorp.com.au


The patch titled
     Account for module percpu space separately from kernel percpu
has been added to the -mm tree.  Its filename is
     account-for-module-percpu-space-separately-from-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Account for module percpu space separately from kernel percpu
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rather than using a single constant PERCPU_ENOUGH_ROOM, compute it as the
sum of kernel_percpu + PERCPU_MODULE_RESERVE.  This is now common to all
architectures; if an architecture wants to set PERCPU_ENOUGH_ROOM to
something special, then it may do so (ia64 is the only one which does).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/percpu.h   |   14 --------------
 include/asm-sparc64/percpu.h |   10 ----------
 include/asm-x86_64/percpu.h  |   10 ----------
 include/linux/percpu.h       |    9 ++++++++-
 init/main.c                  |    7 ++-----
 kernel/module.c              |    2 +-
 6 files changed, 11 insertions(+), 41 deletions(-)

diff -puN include/asm-alpha/percpu.h~account-for-module-percpu-space-separately-from-kernel include/asm-alpha/percpu.h
--- a/include/asm-alpha/percpu.h~account-for-module-percpu-space-separately-from-kernel
+++ a/include/asm-alpha/percpu.h
@@ -1,20 +1,6 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
 
-/*
- * Increase the per cpu area for Alpha so that
- * modules using percpu area can load.
- */
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
-
 #include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
diff -puN include/asm-sparc64/percpu.h~account-for-module-percpu-space-separately-from-kernel include/asm-sparc64/percpu.h
--- a/include/asm-sparc64/percpu.h~account-for-module-percpu-space-separately-from-kernel
+++ a/include/asm-sparc64/percpu.h
@@ -5,16 +5,6 @@
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
-
 extern void setup_per_cpu_areas(void);
 
 extern unsigned long __per_cpu_base;
diff -puN include/asm-x86_64/percpu.h~account-for-module-percpu-space-separately-from-kernel include/asm-x86_64/percpu.h
--- a/include/asm-x86_64/percpu.h~account-for-module-percpu-space-separately-from-kernel
+++ a/include/asm-x86_64/percpu.h
@@ -11,16 +11,6 @@
 
 #include <asm/pda.h>
 
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
-
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
 #define __my_cpu_offset() read_pda(data_offset)
 
diff -puN include/linux/percpu.h~account-for-module-percpu-space-separately-from-kernel include/linux/percpu.h
--- a/include/linux/percpu.h~account-for-module-percpu-space-separately-from-kernel
+++ a/include/linux/percpu.h
@@ -11,9 +11,16 @@
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#define PERCPU_ENOUGH_ROOM 32768
+#ifdef CONFIG_MODULES
+#define PERCPU_MODULE_RESERVE	8192
+#else
+#define PERCPU_MODULE_RESERVE	0
 #endif
 
+#define PERCPU_ENOUGH_ROOM						\
+	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+#endif	/* PERCPU_ENOUGH_ROOM */
+
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
  * we force a syntax error here if it isn't.
diff -puN init/main.c~account-for-module-percpu-space-separately-from-kernel init/main.c
--- a/init/main.c~account-for-module-percpu-space-separately-from-kernel
+++ a/init/main.c
@@ -369,11 +369,8 @@ static void __init setup_per_cpu_areas(v
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
-#ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
-#endif
+
+	size = ALIGN(PERCPU_ENOUGH_ROOM, SMP_CACHE_BYTES);
 	ptr = alloc_bootmem(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
diff -puN kernel/module.c~account-for-module-percpu-space-separately-from-kernel kernel/module.c
--- a/kernel/module.c~account-for-module-percpu-space-separately-from-kernel
+++ a/kernel/module.c
@@ -430,7 +430,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
+	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {
_

Patches currently in -mm which might be from jeremy@goop.org are

proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
account-for-module-percpu-space-separately-from-kernel.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-clean-up-paravirt-patchable-wrappers.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-clean-up-asm-i386-bugsh.patch
x86_64-clean-up-asm-x86_64-bugsh.patch
x86-clean-up-identify_cpu.patch
x86-clean-up-identify_cpu-update.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
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
