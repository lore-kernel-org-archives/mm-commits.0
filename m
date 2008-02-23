From: akpm@linux-foundation.org
Subject: + generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:37:25 -0800
Message-ID: <200802230738.m1N7cDD7018645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762442AbYBWIFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de


The patch titled
     generic: Percpu infrastructure to rebase the per cpu area to zero
has been added to the -mm tree.  Its filename is
     generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch

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
Subject: generic: Percpu infrastructure to rebase the per cpu area to zero
From: Mike Travis <travis@sgi.com>

    * Support an option

	CONFIG_HAVE_ZERO_BASED_PER_CPU

      that makes offsets for per cpu variables to start at zero.

      If a percpu area starts at zero then:

	-  We do not need RELOC_HIDE anymore

	-  Provides for the future capability of architectures providing
	   a per cpu allocator that returns offsets instead of pointers.
	   The offsets would be independent of the processor so that
	   address calculations can be done in a processor independent way.
	   Per cpu instructions can then add the processor specific offset
	   at the last minute possibly in an atomic instruction.

      The data the linker provides is different for zero based percpu segments:

	__per_cpu_load	-> The address at which the percpu area was loaded
	__per_cpu_size	-> The length of the per cpu area

      For non-zero-based percpu segments, the above symbols are adjusted to
      maintain compatibility with existing architectures.

    * Removes the &__per_cpu_x in lockdep. The __per_cpu_x are already
      pointers. There is no need to take the address.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/percpu.h      |    5 +++++
 include/asm-generic/sections.h    |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h |   16 ++++++++++++++++
 include/linux/percpu.h            |    9 ++++++++-
 kernel/lockdep.c                  |    4 ++--
 kernel/module.c                   |    7 ++++---
 6 files changed, 45 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/percpu.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/include/asm-generic/percpu.h
@@ -45,7 +45,12 @@ extern unsigned long __per_cpu_offset[NR
  * Only S390 provides its own means of moving the pointer.
  */
 #ifndef SHIFT_PERCPU_PTR
+#ifndef CONFIG_HAVE_ZERO_BASED_PER_CPU
 #define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+#else
+#define SHIFT_PERCPU_PTR(__p, __offset) \
+	((__typeof(__p))(((void *)(__p)) + (__offset)))
+#endif
 #endif
 
 /*
diff -puN include/asm-generic/sections.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/include/asm-generic/sections.h
@@ -9,7 +9,17 @@ extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
 extern char _end[];
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+extern char __per_cpu_load[];
+extern char ____per_cpu_size[];
+#define __per_cpu_size ((unsigned long)&____per_cpu_size)
+#define __per_cpu_start ((char *)0)
+#define __per_cpu_end ((char *)__per_cpu_size)
+#else
 extern char __per_cpu_start[], __per_cpu_end[];
+#define __per_cpu_load __per_cpu_start
+#define __per_cpu_size (__per_cpu_end - __per_cpu_start)
+#endif
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
diff -puN include/asm-generic/vmlinux.lds.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/include/asm-generic/vmlinux.lds.h
@@ -341,11 +341,27 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	percpu : { } :percpu						\
+	__per_cpu_load = .;						\
+	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+		____per_cpu_size = .;					\
+	}								\
+	. = __per_cpu_load + ____per_cpu_size;				\
+	data : { } :data
+#else
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+#endif
diff -puN include/linux/percpu.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 include/linux/percpu.h
--- a/include/linux/percpu.h~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/include/linux/percpu.h
@@ -18,11 +18,18 @@
 	__attribute__((__section__(".data.percpu.shared_aligned")))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	__attribute__((__section__(".data.percpu.first")))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
 	DEFINE_PER_CPU(type, name)
 #endif
 
diff -puN kernel/lockdep.c~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 kernel/lockdep.c
--- a/kernel/lockdep.c~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/kernel/lockdep.c
@@ -610,8 +610,8 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		start = (unsigned long) __per_cpu_start + per_cpu_offset(i);
+		end   = (unsigned long) __per_cpu_start + PERCPU_ENOUGH_ROOM
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))
diff -puN kernel/module.c~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3 kernel/module.c
--- a/kernel/module.c~generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3
+++ a/kernel/module.c
@@ -45,6 +45,7 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
+#include <asm/sections.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 
@@ -357,7 +358,7 @@ static void *percpu_modalloc(unsigned lo
 		align = PAGE_SIZE;
 	}
 
-	ptr = __per_cpu_start;
+	ptr = __per_cpu_load;
 	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
 		/* Extra for alignment requirement. */
 		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
@@ -392,7 +393,7 @@ static void *percpu_modalloc(unsigned lo
 static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	void *ptr = __per_cpu_load + block_size(pcpu_size[0]);
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -443,7 +444,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
+	pcpu_size[0] = -__per_cpu_size;
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {
_

Patches currently in -mm which might be from travis@sgi.com are

cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
x86-minor-cleanup-of-comments-in-processorh.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
