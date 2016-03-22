From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-add-kcov-code-coverage-makefile-tweaks.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:57:43 -0700
Message-ID: <56f1b1c7.9YSnr2Hgl+agZ3NO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcCVU5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, hpa@zytor.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-kcov-code-coverage-makefile-tweaks
has been removed from the -mm tree.  Its filename was
     kernel-add-kcov-code-coverage-makefile-tweaks.patch

This patch was dropped because it was folded into kernel-add-kcov-code-coverage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-kcov-code-coverage-makefile-tweaks

follow x86 Makefile layout standards

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/Makefile            |    2 +-
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/entry/vdso/Makefile      |    2 +-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/apic/Makefile     |    2 +-
 arch/x86/lib/Makefile             |    2 +-
 arch/x86/mm/Makefile              |    2 +-
 arch/x86/realmode/rm/Makefile     |    2 +-
 kernel/locking/Makefile           |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/boot/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/boot/Makefile
@@ -17,7 +17,7 @@ OBJECT_FILES_NON_STANDARD	:= y
 # callback into middle of per-cpu data enabling code. Thus the callback observed
 # inconsistent state and crashed. We are interested mostly in syscall coverage,
 # so boot code is not interesting anyway.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
diff -puN arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/boot/compressed/Makefile
@@ -20,7 +20,7 @@ KASAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
diff -puN arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/entry/vdso/Makefile
--- a/arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/entry/vdso/Makefile
@@ -8,7 +8,7 @@ UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
diff -puN arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/kernel/Makefile
@@ -30,7 +30,7 @@ OBJECT_FILES_NON_STANDARD_test_nx.o			:=
 # Probably could be more selective here, but note that files related to irqs,
 # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
 # non-deterministic coverage.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 CFLAGS_irq.o := -I$(src)/../include/asm/trace
 
diff -puN arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/kernel/apic/Makefile
--- a/arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/kernel/apic/Makefile
@@ -4,7 +4,7 @@
 
 # Leads to non-deterministic coverage that is not a function of syscall inputs.
 # In particualr, smp_apic_timer_interrupt() is called in random places.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o vector.o
 obj-y				+= hw_nmi.o
diff -puN arch/x86/lib/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/lib/Makefile
--- a/arch/x86/lib/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/lib/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Produces uninteresting flaky coverage.
-KCOV_INSTRUMENT_delay.o := n
+KCOV_INSTRUMENT_delay.o	:= n
 
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
diff -puN arch/x86/mm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/mm/Makefile
@@ -1,5 +1,5 @@
 # Kernel does not boot with instrumentation of tlb.c.
-KCOV_INSTRUMENT_tlb.o := n
+KCOV_INSTRUMENT_tlb.o	:= n
 
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o physaddr.o gup.o setup_nx.o
diff -puN arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/realmode/rm/Makefile
--- a/arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/realmode/rm/Makefile
@@ -10,7 +10,7 @@ KASAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 always := realmode.bin realmode.relocs
 
diff -puN kernel/locking/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks kernel/locking/Makefile
--- a/kernel/locking/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/kernel/locking/Makefile
@@ -1,6 +1,6 @@
 # Any varying coverage in these files is non-deterministic
 # and is generally not a function of system call inputs.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-add-kcov-code-coverage.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

