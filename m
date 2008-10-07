From: akpm@linux-foundation.org
Subject: - cpualloc-make-the-per-cpu-reserve-configurable.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:35:22 -0700
Message-ID: <200810072335.m97NZMh2009248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbYJGXfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpualloc: make the per cpu reserve configurable
has been removed from the -mm tree.  Its filename was
     cpualloc-make-the-per-cpu-reserve-configurable.patch

This patch was dropped because it got shat on

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpualloc: make the per cpu reserve configurable
From: Christoph Lameter <cl@linux-foundation.org>

The per cpu reserve from which loadable modules allocate their percpu
sections is currently fixed at 8000 bytes.

Add a new kernel parameter

	percpu=<dynamically allocatable percpu bytes>

The per cpu reserve area will be used in following patches by the per cpu
allocator.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 include/linux/percpu.h              |    3 ++-
 init/main.c                         |   12 ++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~cpualloc-make-the-per-cpu-reserve-configurable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cpualloc-make-the-per-cpu-reserve-configurable
+++ a/Documentation/kernel-parameters.txt
@@ -1773,6 +1773,13 @@ and is between 256 and 4096 characters. 
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
+	percpu=		Configure the number of percpu bytes that can be
+			dynamically allocated. This is used for per cpu
+			variables of modules and other dynamic per cpu data
+			structures. Creation of per cpu structures after boot
+			may fail if this is set too low.
+			Default is 8000 bytes.
+
 	pf.		[PARIDE]
 			See Documentation/paride.txt.
 
diff -puN include/linux/percpu.h~cpualloc-make-the-per-cpu-reserve-configurable include/linux/percpu.h
--- a/include/linux/percpu.h~cpualloc-make-the-per-cpu-reserve-configurable
+++ a/include/linux/percpu.h
@@ -56,6 +56,7 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
+extern unsigned int percpu_reserve;
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
@@ -65,7 +66,7 @@
 #endif
 
 #define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+	(__per_cpu_end - __per_cpu_start + percpu_reserve)
 #endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
diff -puN init/main.c~cpualloc-make-the-per-cpu-reserve-configurable init/main.c
--- a/init/main.c~cpualloc-make-the-per-cpu-reserve-configurable
+++ a/init/main.c
@@ -258,6 +258,16 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
+unsigned int percpu_reserve = PERCPU_MODULE_RESERVE;
+
+static int __init init_percpu_reserve(char *str)
+{
+	get_option(&str, &percpu_reserve);
+	return 0;
+}
+
+early_param("percpu", init_percpu_reserve);
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * failed parameters
@@ -407,6 +417,8 @@ static void __init setup_per_cpu_areas(v
 	da_size = per_cpu_dyn_array_size(&align);
 	align = max_t(unsigned long, PAGE_SIZE, align);
 	size = ALIGN(old_size + da_size, align);
+	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
+			size, size - (__per_cpu_end - __per_cpu_start));
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
git-tip.patch
git-slab.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
cpualloc-make-the-per-cpu-reserve-configurable.patch
cpualloc-make-the-per-cpu-reserve-configurable-fix.patch
cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch
cpualloc-the-allocator.patch
cpu_alloc-remove-useless-variable.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
slab-leaks3-default-y.patch

