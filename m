From: akpm@linux-foundation.org
Subject: - cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:35:27 -0700
Message-ID: <200810072335.m97NZRUD009257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbYJGXfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpualloc: percpu: rename variables PERCPU_ENOUGH_ROOM -> PERCPU_AREA_SIZE
has been removed from the -mm tree.  Its filename was
     cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch

This patch was dropped because it got shat on

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpualloc: percpu: rename variables PERCPU_ENOUGH_ROOM -> PERCPU_AREA_SIZE
From: Christoph Lameter <cl@linux-foundation.org>

Rename PERCPU_ENOUGH_ROOM to PERCPU_AREA_SIZE since its really specifying
the size of the percpu areas.

Rename PERCPU_MODULE_RESERVE to PERCPU_RESERVE_SIZE in anticipation of
more general use of that reserve.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/percpu.h |    2 +-
 arch/powerpc/kernel/setup_64.c |    4 ++--
 arch/sparc64/kernel/smp.c      |    2 +-
 arch/x86/kernel/setup_percpu.c |    3 +--
 include/linux/percpu.h         |   10 +++++-----
 init/main.c                    |    4 ++--
 kernel/lockdep.c               |    2 +-
 kernel/module.c                |    2 +-
 8 files changed, 14 insertions(+), 15 deletions(-)

diff -puN arch/ia64/include/asm/percpu.h~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size arch/ia64/include/asm/percpu.h
--- a/arch/ia64/include/asm/percpu.h~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/arch/ia64/include/asm/percpu.h
@@ -6,7 +6,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
+#define PERCPU_AREA_SIZE PERCPU_PAGE_SIZE
 
 #ifdef __ASSEMBLY__
 # define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
diff -puN arch/powerpc/kernel/setup_64.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/arch/powerpc/kernel/setup_64.c
@@ -600,8 +600,8 @@ void __init setup_per_cpu_areas(void)
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
 #ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
+	if (size < PERCPU_AREA_SIZE)
+		size = PERCPU_AREA_SIZE;
 #endif
 
 	for_each_possible_cpu(i) {
diff -puN arch/sparc64/kernel/smp.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/arch/sparc64/kernel/smp.c
@@ -1386,7 +1386,7 @@ void __init real_setup_per_cpu_areas(voi
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
-	goal = PERCPU_ENOUGH_ROOM;
+	goal = PERCPU_AREA_SIZE;
 
 	__per_cpu_shift = PAGE_SHIFT;
 	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
diff -puN arch/x86/kernel/setup_percpu.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,7 @@ static void __init setup_cpu_pda_map(voi
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size = PERCPU_ENOUGH_ROOM;
+	ssize_t size = PERCPU_AREA_SIZE;
 	char *ptr;
 	int cpu;
 
@@ -148,7 +148,6 @@ void __init setup_per_cpu_areas(void)
 	setup_cpu_pda_map();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
diff -puN include/linux/percpu.h~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size include/linux/percpu.h
--- a/include/linux/percpu.h~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/include/linux/percpu.h
@@ -43,16 +43,16 @@
 
 extern unsigned int percpu_reserve;
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
-#ifndef PERCPU_ENOUGH_ROOM
+#ifndef PERCPU_AREA_SIZE
 #ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE	8192
+#define PERCPU_RESERVE_SIZE	8192
 #else
-#define PERCPU_MODULE_RESERVE	0
+#define PERCPU_RESERVE_SIZE	0
 #endif
 
-#define PERCPU_ENOUGH_ROOM						\
+#define PERCPU_AREA_SIZE						\
 	(__per_cpu_end - __per_cpu_start + percpu_reserve)
-#endif	/* PERCPU_ENOUGH_ROOM */
+#endif	/* PERCPU_AREA_SIZE */
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
diff -puN init/main.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size init/main.c
--- a/init/main.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/init/main.c
@@ -256,7 +256,7 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
-unsigned int percpu_reserve = PERCPU_MODULE_RESERVE;
+unsigned int percpu_reserve = PERCPU_RESERVE_SIZE;
 
 static int __init init_percpu_reserve(char *str)
 {
@@ -409,7 +409,7 @@ static void __init setup_per_cpu_areas(v
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	size = ALIGN(PERCPU_AREA_SIZE, PAGE_SIZE);
 	printk(KERN_INFO "percpu area: %lu bytes total, %lu available.\n",
 			size, size - (__per_cpu_end - __per_cpu_start));
 
diff -puN kernel/lockdep.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size kernel/lockdep.c
--- a/kernel/lockdep.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/kernel/lockdep.c
@@ -639,7 +639,7 @@ static int static_obj(void *obj)
 	 */
 	for_each_possible_cpu(i) {
 		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		end   = (unsigned long) &__per_cpu_start + PERCPU_AREA_SIZE
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
diff -puN kernel/module.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size kernel/module.c
--- a/kernel/module.c~cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size
+++ a/kernel/module.c
@@ -478,7 +478,7 @@ static int percpu_modinit(void)
 	/* Static in-kernel percpu data (used). */
 	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
 	/* Free room. */
-	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
+	pcpu_size[1] = PERCPU_AREA_SIZE + pcpu_size[0];
 	if (pcpu_size[1] < 0) {
 		printk(KERN_ERR "No per-cpu room for modules.\n");
 		pcpu_num_used = 1;
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
git-tip.patch
git-slab.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch
cpualloc-the-allocator.patch
cpu_alloc-remove-useless-variable.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
slab-leaks3-default-y.patch

