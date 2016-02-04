From: akpm@linux-foundation.org
Subject: + kernel-add-kcov-code-coverage.patch added to -mm tree
Date: Thu, 04 Feb 2016 14:31:47 -0800
Message-ID: <56b3d153.LFrso0ANNp6u6YvM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbcBDWbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 17:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, ard.biesheuvel@linaro.org, bhelgaas@google.com, catalin.marinas@arm.com, drysdale@google.com, edumazet@google.com, glider@google.com, hpa@zytor.com, jslaby@suse.cz, kcc@google.com, keescook@chromium.org, keescook@google.com, kirill@shutemov.name, mingo@elte.hu, quentin.casasnovas@oracle.com, ryabinin.a.a@gmail.com, sasha.levin@oracle.com, syzkaller@googlegroups.com, taviso@google.com, tglx@linutronix.de, vegard.nossum@oracle.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add kcov code coverage
has been added to the -mm tree.  Its filename is
     kernel-add-kcov-code-coverage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-kcov-code-coverage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-kcov-code-coverage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kernel: add kcov code coverage

kcov provides code coverage collection for coverage-guided fuzzing
(randomized testing). Coverage-guided fuzzing is a testing technique
that uses coverage feedback to determine new interesting inputs to a
system. A notable user-space example is AFL
(http://lcamtuf.coredump.cx/afl/). However, this technique is not
widely used for kernel testing due to missing compiler and kernel
support.

kcov does not aim to collect as much coverage as possible. It aims
to collect more or less stable coverage that is function of syscall
inputs. To achieve this goal it does not collect coverage in
soft/hard interrupts and instrumentation of some inherently
non-deterministic or non-interesting parts of kernel is disbled
(e.g. scheduler, locking).

Currently there is a single coverage collection mode (tracing),
but the API anticipates additional collection modes.
Initially I also implemented a second mode which exposes
coverage in a fixed-size hash table of counters (what Quentin
used in his original patch). I've dropped the second mode for
simplicity.

This patch adds the necessary support on kernel side.
The complimentary compiler support was added in gcc revision 231296.

We've used this support to build syzkaller system call fuzzer,
which has found 90 kernel bugs in just 2 months:
https://github.com/google/syzkaller/wiki/Found-Bugs
We've also found 30+ bugs in our internal systems with syzkaller.
Another (yet unexplored) direction where kcov coverage would greatly
help is more traditional "blob mutation". For example, mounting
a random blob as a filesystem, or receiving a random blob over wire.

Why not gcov. Typical fuzzing loop looks as follows: (1) reset
coverage, (2) execute a bit of code, (3) collect coverage, repeat.
A typical coverage can be just a dozen of basic blocks (e.g. an
invalid input). In such context gcov becomes prohibitively expensive
as reset/collect coverage steps depend on total number of basic
blocks/edges in program (in case of kernel it is about 2M). Cost of
kcov depends only on number of executed basic blocks/edges. On top of
that, kernel requires per-thread coverage because there are
always background threads and unrelated processes that also produce
coverage. With inlined gcov instrumentation per-thread coverage is not
possible.

kcov exposes kernel PCs and control flow to user-space which
is insecure. But debugfs should not be mapped as user accessible.

Based on a patch by Quentin Casasnovas.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: syzkaller <syzkaller@googlegroups.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tavis Ormandy <taviso@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Drysdale <drysdale@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kcov.txt                |  111 +++++++++
 Makefile                              |   10 
 arch/x86/Kconfig                      |    1 
 arch/x86/boot/Makefile                |    6 
 arch/x86/boot/compressed/Makefile     |    2 
 arch/x86/entry/vdso/Makefile          |    2 
 arch/x86/kernel/Makefile              |    5 
 arch/x86/kernel/apic/Makefile         |    4 
 arch/x86/kernel/cpu/Makefile          |    4 
 arch/x86/lib/Makefile                 |    3 
 arch/x86/mm/Makefile                  |    3 
 arch/x86/realmode/rm/Makefile         |    2 
 drivers/firmware/efi/libstub/Makefile |    2 
 include/linux/kcov.h                  |   19 +
 include/linux/sched.h                 |   10 
 include/uapi/linux/kcov.h             |   10 
 kernel/Makefile                       |   12 +
 kernel/exit.c                         |    2 
 kernel/fork.c                         |    3 
 kernel/kcov.c                         |  269 ++++++++++++++++++++++++
 kernel/locking/Makefile               |    3 
 kernel/rcu/Makefile                   |    4 
 kernel/sched/Makefile                 |    4 
 lib/Kconfig.debug                     |   21 +
 lib/Makefile                          |   12 +
 mm/Makefile                           |   15 +
 mm/kasan/Makefile                     |    1 
 scripts/Makefile.lib                  |    6 
 28 files changed, 545 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/kcov.txt
--- /dev/null
+++ a/Documentation/kcov.txt
@@ -0,0 +1,111 @@
+kcov: code coverage for fuzzing
+===============================
+
+kcov exposes kernel code coverage information in a form suitable for coverage-
+guided fuzzing (randomized testing). Coverage data of a running kernel is
+exported via the "kcov" debugfs file. Coverage collection is enabled on a task
+basis, and thus it can capture precise coverage of a single system call.
+
+Note that kcov does not aim to collect as much coverage as possible. It aims
+to collect more or less stable coverage that is function of syscall inputs.
+To achieve this goal it does not collect coverage in soft/hard interrupts
+and instrumentation of some inherently non-deterministic parts of kernel is
+disbled (e.g. scheduler, locking).
+
+Usage:
+======
+
+Configure kernel with:
+
+        CONFIG_KCOV=y
+
+CONFIG_KCOV requires gcc built on revision 231296 or later.
+Profiling data will only become accessible once debugfs has been mounted:
+
+        mount -t debugfs none /sys/kernel/debug
+
+The following program demonstrates kcov usage from within a test program:
+
+#include <stdio.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
+#define KCOV_ENABLE			_IO('c', 100)
+#define KCOV_DISABLE			_IO('c', 101)
+#define COVER_SIZE			(64<<10)
+
+int main(int argc, char **argv)
+{
+	int fd;
+	unsigned long *cover, n, i;
+
+	/* A single fd descriptor allows coverage collection on a single
+	 * thread.
+	 */
+	fd = open("/sys/kernel/debug/kcov", O_RDWR);
+	if (fd == -1)
+		perror("open"), exit(1);
+	/* Setup trace mode and trace size. */
+	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
+		perror("ioctl"), exit(1);
+	/* Mmap buffer shared between kernel- and user-space. */
+	cover = (unsigned long*)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
+				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if ((void*)cover == MAP_FAILED)
+		perror("mmap"), exit(1);
+	/* Enable coverage collection on the current thread. */
+	if (ioctl(fd, KCOV_ENABLE, 0))
+		perror("ioctl"), exit(1);
+	/* Reset coverage from the tail of the ioctl() call. */
+	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
+	/* That's the target syscal call. */
+	read(-1, NULL, 0);
+	/* Read number of PCs collected. */
+	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
+	for (i = 0; i < n; i++)
+		printf("0x%lx\n", cover[i + 1]);
+	/* Disable coverage collection for the current thread. After this call
+	 * coverage can be enabled for a different thread.
+	 */
+	if (ioctl(fd, KCOV_DISABLE, 0))
+		perror("ioctl"), exit(1);
+	/* Free resources. */
+	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
+		perror("munmap"), exit(1);
+	if (close(fd))
+		perror("close"), exit(1);
+	return 0;
+}
+
+After piping through addr2line output of the program looks as follows:
+
+SyS_read
+fs/read_write.c:562
+__fdget_pos
+fs/file.c:774
+__fget_light
+fs/file.c:746
+__fget_light
+fs/file.c:750
+__fget_light
+fs/file.c:760
+__fdget_pos
+fs/file.c:784
+SyS_read
+fs/read_write.c:562
+
+If a program needs to collect coverage from several threads (independently),
+it needs to open /sys/kernel/debug/kcov in each thread separately.
+
+The interface is fine-grained to allow efficient forking of test processes.
+That is, a parent process opens /sys/kernel/debug/kcov, enables trace mode,
+mmaps coverage buffer and then forks child processes in a loop. Child processes
+only need to enable coverage (disable happens automatically on thread end).
diff -puN Makefile~kernel-add-kcov-code-coverage Makefile
--- a/Makefile~kernel-add-kcov-code-coverage
+++ a/Makefile
@@ -365,6 +365,7 @@ LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
+CFLAGS_KCOV	= -fsanitize-coverage=trace-pc
 
 
 # Use USERINCLUDE when you must reference the UAPI directories only.
@@ -411,7 +412,7 @@ export MAKE AWK GENKSYMS INSTALLKERNEL P
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV CFLAGS_KASAN CFLAGS_UBSAN
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV CFLAGS_KCOV CFLAGS_KASAN CFLAGS_UBSAN
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
@@ -673,6 +674,13 @@ endif
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
+ifdef CONFIG_KCOV
+  ifeq ($(call cc-option, $(CFLAGS_KCOV)),)
+    $(warning Cannot use CONFIG_KCOV: \
+             -fsanitize-coverage=trace-pc is not supported by compiler)
+  endif
+endif
+
 ifeq ($(cc-name),clang)
 KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
 KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
diff -puN arch/x86/Kconfig~kernel-add-kcov-code-coverage arch/x86/Kconfig
--- a/arch/x86/Kconfig~kernel-add-kcov-code-coverage
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_SG_CHAIN
diff -puN arch/x86/boot/Makefile~kernel-add-kcov-code-coverage arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/boot/Makefile
@@ -10,6 +10,12 @@
 #
 
 KASAN_SANITIZE := n
+# Kernel does not boot with kcov instrumentation here.
+# One of the problems observed was insertion of __sanitizer_cov_trace_pc()
+# callback into middle of per-cpu data enabling code. Thus the callback observed
+# inconsistent state and crashed. We are interested mostly in syscall coverage,
+# so boot code is not interesting anyway.
+KCOV_INSTRUMENT := n
 
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
diff -puN arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/boot/compressed/Makefile
@@ -17,6 +17,8 @@
 #	compressed vmlinux.bin.all + u32 size of vmlinux.bin.all
 
 KASAN_SANITIZE := n
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT := n
 
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
diff -puN arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage arch/x86/entry/vdso/Makefile
--- a/arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/entry/vdso/Makefile
@@ -5,6 +5,8 @@
 KBUILD_CFLAGS += $(DISABLE_LTO)
 KASAN_SANITIZE := n
 UBSAN_SANITIZE := n
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT := n
 
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
diff -puN arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/kernel/Makefile
@@ -19,6 +19,11 @@ endif
 KASAN_SANITIZE_head$(BITS).o := n
 KASAN_SANITIZE_dumpstack.o := n
 KASAN_SANITIZE_dumpstack_$(BITS).o := n
+# If instrumentation of this dir is enabled, boot hangs during first second.
+# Probably could be more selective here, but note that files related to irqs,
+# boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
+# non-deterministic coverage.
+KCOV_INSTRUMENT := n
 
 CFLAGS_irq.o := -I$(src)/../include/asm/trace
 
diff -puN arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage arch/x86/kernel/apic/Makefile
--- a/arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/kernel/apic/Makefile
@@ -2,6 +2,10 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
+# Leads to non-deterministic coverage that is not a function of syscall inputs.
+# In particualr, smp_apic_timer_interrupt() is called in random places.
+KCOV_INSTRUMENT := n
+
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o vector.o
 obj-y				+= hw_nmi.o
 
diff -puN arch/x86/kernel/cpu/Makefile~kernel-add-kcov-code-coverage arch/x86/kernel/cpu/Makefile
--- a/arch/x86/kernel/cpu/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/kernel/cpu/Makefile
@@ -8,6 +8,10 @@ CFLAGS_REMOVE_common.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
+# If these files are instrumented, boot hangs during the first second.
+KCOV_INSTRUMENT_common.o := n
+KCOV_INSTRUMENT_perf_event.o := n
+
 # Make sure load_percpu_segment has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
diff -puN arch/x86/lib/Makefile~kernel-add-kcov-code-coverage arch/x86/lib/Makefile
--- a/arch/x86/lib/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/lib/Makefile
@@ -2,6 +2,9 @@
 # Makefile for x86 specific library files.
 #
 
+# Produces uninteresting flaky coverage.
+KCOV_INSTRUMENT_delay.o := n
+
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
diff -puN arch/x86/mm/Makefile~kernel-add-kcov-code-coverage arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/mm/Makefile
@@ -1,3 +1,6 @@
+# Kernel does not boot with instrumentation of tlb.c.
+KCOV_INSTRUMENT_tlb.o := n
+
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o physaddr.o gup.o setup_nx.o
 
diff -puN arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage arch/x86/realmode/rm/Makefile
--- a/arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage
+++ a/arch/x86/realmode/rm/Makefile
@@ -7,6 +7,8 @@
 #
 #
 KASAN_SANITIZE := n
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT := n
 
 always := realmode.bin realmode.relocs
 
diff -puN drivers/firmware/efi/libstub/Makefile~kernel-add-kcov-code-coverage drivers/firmware/efi/libstub/Makefile
--- a/drivers/firmware/efi/libstub/Makefile~kernel-add-kcov-code-coverage
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -23,6 +23,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT			:= n
 
 lib-y				:= efi-stub-helper.o
 
diff -puN /dev/null include/linux/kcov.h
--- /dev/null
+++ a/include/linux/kcov.h
@@ -0,0 +1,19 @@
+#ifndef _LINUX_KCOV_H
+#define _LINUX_KCOV_H
+
+#include <uapi/linux/kcov.h>
+
+struct task_struct;
+
+#ifdef CONFIG_KCOV
+
+void kcov_task_init(struct task_struct *t);
+void kcov_task_exit(struct task_struct *t);
+
+#else
+
+static inline void kcov_task_init(struct task_struct *t) {}
+static inline void kcov_task_exit(struct task_struct *t) {}
+
+#endif /* CONFIG_KCOV */
+#endif /* _LINUX_KCOV_H */
diff -puN include/linux/sched.h~kernel-add-kcov-code-coverage include/linux/sched.h
--- a/include/linux/sched.h~kernel-add-kcov-code-coverage
+++ a/include/linux/sched.h
@@ -1812,6 +1812,16 @@ struct task_struct {
 	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
+#ifdef CONFIG_KCOV
+	/* Coverage collection mode enabled for this task (0 if disabled). */
+	int		kcov_mode;
+	/* Size of the kcov_area. */
+	unsigned	kcov_size;
+	/* Buffer for coverage collection. */
+	void		*kcov_area;
+	/* kcov desciptor wired with this task or NULL. */
+	struct kcov	*kcov;
+#endif
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg_in_oom;
 	gfp_t memcg_oom_gfp_mask;
diff -puN /dev/null include/uapi/linux/kcov.h
--- /dev/null
+++ a/include/uapi/linux/kcov.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_KCOV_IOCTLS_H
+#define _LINUX_KCOV_IOCTLS_H
+
+#include <linux/types.h>
+
+#define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
+#define KCOV_ENABLE			_IO('c', 100)
+#define KCOV_DISABLE			_IO('c', 101)
+
+#endif /* _LINUX_KCOV_IOCTLS_H */
diff -puN kernel/Makefile~kernel-add-kcov-code-coverage kernel/Makefile
--- a/kernel/Makefile~kernel-add-kcov-code-coverage
+++ a/kernel/Makefile
@@ -19,6 +19,17 @@ CFLAGS_REMOVE_cgroup-debug.o = $(CC_FLAG
 CFLAGS_REMOVE_irq_work.o = $(CC_FLAGS_FTRACE)
 endif
 
+# Prevents flicker of uninteresting __do_softirq()/__local_bh_disable_ip()
+# in coverage traces.
+KCOV_INSTRUMENT_softirq.o := n
+# These are called from save_stack_trace() on slub debug path,
+# and produce insane amounts of uninteresting coverage.
+KCOV_INSTRUMENT_module.o := n
+KCOV_INSTRUMENT_extable.o := n
+# Don't self-instrument.
+KCOV_INSTRUMENT_kcov.o := n
+KASAN_SANITIZE_kcov.o := n
+
 # cond_syscall is currently not LTO compatible
 CFLAGS_sys_ni.o = $(DISABLE_LTO)
 
@@ -69,6 +80,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o audit_fsnotify.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
+obj-$(CONFIG_KCOV) += kcov.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
diff -puN kernel/exit.c~kernel-add-kcov-code-coverage kernel/exit.c
--- a/kernel/exit.c~kernel-add-kcov-code-coverage
+++ a/kernel/exit.c
@@ -53,6 +53,7 @@
 #include <linux/oom.h>
 #include <linux/writeback.h>
 #include <linux/shm.h>
+#include <linux/kcov.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -655,6 +656,7 @@ void do_exit(long code)
 	TASKS_RCU(int tasks_rcu_i);
 
 	profile_task_exit(tsk);
+	kcov_task_exit(tsk);
 
 	WARN_ON(blk_needs_flush_plug(tsk));
 
diff -puN kernel/fork.c~kernel-add-kcov-code-coverage kernel/fork.c
--- a/kernel/fork.c~kernel-add-kcov-code-coverage
+++ a/kernel/fork.c
@@ -75,6 +75,7 @@
 #include <linux/aio.h>
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
+#include <linux/kcov.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -384,6 +385,8 @@ static struct task_struct *dup_task_stru
 
 	account_kernel_stack(ti, 1);
 
+	kcov_task_init(tsk);
+
 	return tsk;
 
 free_ti:
diff -puN /dev/null kernel/kcov.c
--- /dev/null
+++ a/kernel/kcov.c
@@ -0,0 +1,269 @@
+#define pr_fmt(fmt) "kcov: " fmt
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/kcov.h>
+
+enum kcov_mode {
+	/*
+	 * Tracing coverage collection mode.
+	 * Covered PCs are collected in a per-task buffer.
+	 */
+	KCOV_MODE_TRACE = 1,
+};
+
+/*
+ * kcov descriptor (one per opened debugfs file).
+ * State transitions of the descriptor:
+ *  - initial state after open()
+ *  - then there must be a single ioctl(KCOV_INIT_TRACE) call
+ *  - then, mmap() call (several calls are allowed but not useful)
+ *  - then, repeated enable/disable for a task (only one task a time allowed)
+ */
+struct kcov {
+	/*
+	 * Reference counter. We keep one for:
+	 *  - opened file descriptor
+	 *  - task with enabled coverage (we can't unwire it from another task)
+	 */
+	atomic_t		rc;
+	/* The lock protects mode, size, area and t. */
+	spinlock_t		lock;
+	enum kcov_mode		mode;
+	unsigned		size;
+	void			*area;
+	struct task_struct	*t;
+};
+
+/*
+ * Entry point from instrumented code.
+ * This is called once per basic-block/edge.
+ */
+void __sanitizer_cov_trace_pc(void)
+{
+	struct task_struct *t;
+	enum kcov_mode mode;
+
+	t = current;
+	/*
+	 * We are interested in code coverage as a function of a syscall inputs,
+	 * so we ignore code executed in interrupts.
+	 */
+	if (!t || in_interrupt())
+		return;
+	mode = READ_ONCE(t->kcov_mode);
+	if (mode == KCOV_MODE_TRACE) {
+		unsigned long *area;
+		unsigned long pos;
+
+		/*
+		 * There is some code that runs in interrupts but for which
+		 * in_interrupt() returns false (e.g. preempt_schedule_irq()).
+		 * READ_ONCE()/barrier() effectively provides load-acquire wrt
+		 * interrupts, there are paired barrier()/WRITE_ONCE() in
+		 * kcov_ioctl_locked().
+		 */
+		barrier();
+		area = t->kcov_area;
+		/* The first word is number of subsequent PCs. */
+		pos = READ_ONCE(area[0]) + 1;
+		if (likely(pos < t->kcov_size)) {
+			area[pos] = _RET_IP_;
+			WRITE_ONCE(area[0], pos);
+		}
+	}
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
+
+static void kcov_get(struct kcov *kcov)
+{
+	atomic_inc(&kcov->rc);
+}
+
+static void kcov_put(struct kcov *kcov)
+{
+	if (atomic_dec_and_test(&kcov->rc)) {
+		vfree(kcov->area);
+		kfree(kcov);
+	}
+}
+
+void kcov_task_init(struct task_struct *t)
+{
+	t->kcov_mode = 0;
+	t->kcov_size = 0;
+	t->kcov_area = NULL;
+	t->kcov = NULL;
+}
+
+void kcov_task_exit(struct task_struct *t)
+{
+	struct kcov *kcov;
+
+	kcov = t->kcov;
+	if (kcov == NULL)
+		return;
+	spin_lock(&kcov->lock);
+	if (WARN_ON(kcov->t != t)) {
+		spin_unlock(&kcov->lock);
+		return;
+	}
+	/* Just to not leave dangling references behind. */
+	kcov_task_init(t);
+	kcov->t = NULL;
+	spin_unlock(&kcov->lock);
+	kcov_put(kcov);
+}
+
+static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	int res = 0;
+	void *area;
+	struct kcov *kcov = vma->vm_file->private_data;
+	unsigned long size, off;
+	struct page *page;
+
+	area = vmalloc_user(vma->vm_end - vma->vm_start);
+	if (!area)
+		return -ENOMEM;
+
+	spin_lock(&kcov->lock);
+	size = kcov->size * sizeof(unsigned long);
+	if (kcov->mode == 0 || vma->vm_pgoff != 0 ||
+	    vma->vm_end - vma->vm_start != size) {
+		res = -EINVAL;
+		goto exit;
+	}
+	if (!kcov->area) {
+		kcov->area = area;
+		vma->vm_flags |= VM_DONTEXPAND;
+		spin_unlock(&kcov->lock);
+		for (off = 0; off < size; off += PAGE_SIZE) {
+			page = vmalloc_to_page(kcov->area + off);
+			if (vm_insert_page(vma, vma->vm_start + off, page))
+				WARN_ONCE(1, "vm_insert_page() failed");
+		}
+		return 0;
+	}
+exit:
+	spin_unlock(&kcov->lock);
+	vfree(area);
+	return res;
+}
+
+static int kcov_open(struct inode *inode, struct file *filep)
+{
+	struct kcov *kcov;
+
+	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
+	if (!kcov)
+		return -ENOMEM;
+	atomic_set(&kcov->rc, 1);
+	spin_lock_init(&kcov->lock);
+	filep->private_data = kcov;
+	return nonseekable_open(inode, filep);
+}
+
+static int kcov_close(struct inode *inode, struct file *filep)
+{
+	kcov_put(filep->private_data);
+	return 0;
+}
+
+static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct task_struct *t;
+
+	switch (cmd) {
+	case KCOV_INIT_TRACE:
+		/*
+		 * Enable kcov in trace mode and setup buffer size.
+		 * Must happen before anything else.
+		 * Size must be at least 2 to hold current position and one PC.
+		 */
+		if (arg < 2 || arg > INT_MAX)
+			return -EINVAL;
+		if (kcov->mode != 0)
+			return -EBUSY;
+		kcov->mode = KCOV_MODE_TRACE;
+		kcov->size = arg;
+		return 0;
+	case KCOV_ENABLE:
+		/*
+		 * Enable coverage for the current task.
+		 * At this point user must have been enabled trace mode,
+		 * and mmapped the file. Coverage collection is disabled only
+		 * at task exit or voluntary by KCOV_DISABLE. After that it can
+		 * be enabled for another task.
+		 */
+		if (arg != 0 || kcov->mode == 0 || kcov->area == NULL)
+			return -EINVAL;
+		if (kcov->t != NULL)
+			return -EBUSY;
+		t = current;
+		/* Cache in task struct for performance. */
+		t->kcov_size = kcov->size;
+		t->kcov_area = kcov->area;
+		/* See comment in __sanitizer_cov_trace_pc(). */
+		barrier();
+		WRITE_ONCE(t->kcov_mode, kcov->mode);
+		t->kcov = kcov;
+		kcov->t = t;
+		/* This is put either in kcov_task_exit() or in KCOV_DISABLE. */
+		kcov_get(kcov);
+		return 0;
+	case KCOV_DISABLE:
+		/* Disable coverage for the current task. */
+		if (arg != 0 || current->kcov != kcov)
+			return -EINVAL;
+		t = current;
+		if (WARN_ON(kcov->t != t))
+			return -EINVAL;
+		kcov_task_init(t);
+		kcov->t = NULL;
+		kcov_put(kcov);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static long kcov_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	struct kcov *kcov;
+	int res;
+
+	kcov = filep->private_data;
+	spin_lock(&kcov->lock);
+	res = kcov_ioctl_locked(kcov, cmd, arg);
+	spin_unlock(&kcov->lock);
+	return res;
+}
+
+static const struct file_operations kcov_fops = {
+	.open		= kcov_open,
+	.unlocked_ioctl	= kcov_ioctl,
+	.mmap		= kcov_mmap,
+	.release        = kcov_close,
+};
+
+static int __init kcov_init(void)
+{
+	if (!debugfs_create_file("kcov", 0600, NULL, NULL, &kcov_fops)) {
+		pr_err("failed to create kcov in debugfs\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+device_initcall(kcov_init);
diff -puN kernel/locking/Makefile~kernel-add-kcov-code-coverage kernel/locking/Makefile
--- a/kernel/locking/Makefile~kernel-add-kcov-code-coverage
+++ a/kernel/locking/Makefile
@@ -1,3 +1,6 @@
+# Any varying coverage in these files is non-deterministic
+# and is generally not a function of system call inputs.
+KCOV_INSTRUMENT := n
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 
diff -puN kernel/rcu/Makefile~kernel-add-kcov-code-coverage kernel/rcu/Makefile
--- a/kernel/rcu/Makefile~kernel-add-kcov-code-coverage
+++ a/kernel/rcu/Makefile
@@ -1,3 +1,7 @@
+# Any varying coverage in these files is non-deterministic
+# and is generally not a function of system call inputs.
+KCOV_INSTRUMENT := n
+
 obj-y += update.o sync.o
 obj-$(CONFIG_SRCU) += srcu.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
diff -puN kernel/sched/Makefile~kernel-add-kcov-code-coverage kernel/sched/Makefile
--- a/kernel/sched/Makefile~kernel-add-kcov-code-coverage
+++ a/kernel/sched/Makefile
@@ -2,6 +2,10 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_clock.o = $(CC_FLAGS_FTRACE)
 endif
 
+# These files are disabled because they produce non-interesting flaky coverage
+# that is not a function of syscall inputs. E.g. involuntary context switches.
+KCOV_INSTRUMENT := n
+
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
diff -puN lib/Kconfig.debug~kernel-add-kcov-code-coverage lib/Kconfig.debug
--- a/lib/Kconfig.debug~kernel-add-kcov-code-coverage
+++ a/lib/Kconfig.debug
@@ -684,6 +684,27 @@ source "lib/Kconfig.kasan"
 
 endmenu # "Memory Debugging"
 
+config ARCH_HAS_KCOV
+	bool
+	help
+	  KCOV does not have any arch-specific code, but currently it is enabled
+	  only for x86_64. KCOV requires testing on other archs, and most likely
+	  disabling of instrumentation for some early boot code.
+
+config KCOV
+	bool "Code coverage for fuzzing"
+	depends on ARCH_HAS_KCOV
+	select DEBUG_FS
+	help
+	  KCOV exposes kernel code coverage information in a form suitable
+	  for coverage-guided fuzzing (randomized testing).
+
+	  If RANDOMIZE_BASE is enabled, PC values will not be stable across
+	  different machines and across reboots. If you need stable PC values,
+	  disable RANDOMIZE_BASE.
+
+	  For more details, see Documentation/kcov.txt.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL
diff -puN lib/Makefile~kernel-add-kcov-code-coverage lib/Makefile
--- a/lib/Makefile~kernel-add-kcov-code-coverage
+++ a/lib/Makefile
@@ -7,6 +7,18 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
 endif
 
+# These files are disabled because they produce lots of non-interesting and/or
+# flaky coverage that is not a function of syscall inputs. For example,
+# rbtree can be global and individual rotations don't correlate with inputs.
+KCOV_INSTRUMENT_string.o := n
+KCOV_INSTRUMENT_rbtree.o := n
+KCOV_INSTRUMENT_list_debug.o := n
+KCOV_INSTRUMENT_debugobjects.o := n
+KCOV_INSTRUMENT_dynamic_debug.o := n
+# Kernel does not boot if we instrument this file as it uses custom calling
+# convention (see CONFIG_ARCH_HWEIGHT_CFLAGS).
+KCOV_INSTRUMENT_hweight.o := n
+
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
diff -puN mm/Makefile~kernel-add-kcov-code-coverage mm/Makefile
--- a/mm/Makefile~kernel-add-kcov-code-coverage
+++ a/mm/Makefile
@@ -5,6 +5,21 @@
 KASAN_SANITIZE_slab_common.o := n
 KASAN_SANITIZE_slub.o := n
 
+# These files are disabled because they produce non-interesting and/or
+# flaky coverage that is not a function of syscall inputs. E.g. slab is out of
+# free pages, or a task is migrated between nodes.
+KCOV_INSTRUMENT_slab_common.o := n
+KCOV_INSTRUMENT_slob.o := n
+KCOV_INSTRUMENT_slab.o := n
+KCOV_INSTRUMENT_slub.o := n
+KCOV_INSTRUMENT_page_alloc.o := n
+KCOV_INSTRUMENT_debug-pagealloc.o := n
+KCOV_INSTRUMENT_kmemleak.o := n
+KCOV_INSTRUMENT_kmemcheck.o := n
+KCOV_INSTRUMENT_memcontrol.o := n
+KCOV_INSTRUMENT_mmzone.o := n
+KCOV_INSTRUMENT_vmstat.o := n
+
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
diff -puN mm/kasan/Makefile~kernel-add-kcov-code-coverage mm/kasan/Makefile
--- a/mm/kasan/Makefile~kernel-add-kcov-code-coverage
+++ a/mm/kasan/Makefile
@@ -1,5 +1,6 @@
 KASAN_SANITIZE := n
 UBSAN_SANITIZE_kasan.o := n
+KCOV_INSTRUMENT := n
 
 CFLAGS_REMOVE_kasan.o = -pg
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
diff -puN scripts/Makefile.lib~kernel-add-kcov-code-coverage scripts/Makefile.lib
--- a/scripts/Makefile.lib~kernel-add-kcov-code-coverage
+++ a/scripts/Makefile.lib
@@ -136,6 +136,12 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_UBSAN))
 endif
 
+ifeq ($(CONFIG_KCOV),y)
+_c_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)y), \
+	$(CFLAGS_KCOV))
+endif
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
_

Patches currently in -mm which might be from dvyukov@google.com are

kernel-add-kcov-code-coverage.patch

