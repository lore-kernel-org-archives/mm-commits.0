From: akpm@linux-foundation.org
Subject: + cpualloc-make-the-per-cpu-reserve-configurable.patch added to -mm tree
Date: Fri, 03 Oct 2008 00:34:24 -0700
Message-ID: <200810030734.m937YOWH016744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbYJCHfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 03:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au


The patch titled
     cpualloc: make the per cpu reserve configurable
has been added to the -mm tree.  Its filename is
     cpualloc-make-the-per-cpu-reserve-configurable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
 init/main.c                         |   13 +++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

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
@@ -41,6 +41,7 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
+extern unsigned int percpu_reserve;
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
@@ -50,7 +51,7 @@
 #endif
 
 #define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+	(__per_cpu_end - __per_cpu_start + percpu_reserve)
 #endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
diff -puN init/main.c~cpualloc-make-the-per-cpu-reserve-configurable init/main.c
--- a/init/main.c~cpualloc-make-the-per-cpu-reserve-configurable
+++ a/init/main.c
@@ -256,6 +256,16 @@ static int __init loglevel(char *str)
 
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
@@ -400,6 +410,9 @@ static void __init setup_per_cpu_areas(v
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
+			size, size - (__per_cpu_end - __per_cpu_start));
+
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
git-x86.patch
git-slab.patch
mm-make-do_move_pages-complexity-linear.patch
mm-make-do_move_pages-complexity-linear-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
cpualloc-make-the-per-cpu-reserve-configurable.patch
cpualloc-make-the-per-cpu-reserve-configurable-fix.patch
cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch
cpualloc-the-allocator.patch
cpu_alloc-remove-useless-variable.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
slab-leaks3-default-y.patch

