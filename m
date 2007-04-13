From: akpm@linux-foundation.org
Subject: - account-for-module-percpu-space-separately-from-kernel.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:49 -0700
Message-ID: <200704132329.l3DNTnvL012654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030900AbXDMXaZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, davem@davemloft.net, ebiederm@xmission.com, ink@jurassic.park.msu.ru, jeremy@xensource.com, rth@twiddle.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Account for module percpu space separately from kernel percpu
has been removed from the -mm tree.  Its filename was
     account-for-module-percpu-space-separately-from-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
