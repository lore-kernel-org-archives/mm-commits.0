From: akpm@linux-foundation.org
Subject: [merged]
 nmi_backtrace-generate-one-line-reports-for-idle-cpus.patch removed from
 -mm tree
Date: Mon, 10 Oct 2016 15:57:58 -0700
Message-ID: <57fc1cf6.x/C9RDrfpxaT9foL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbcJJW57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@mellanox.com, atomlin@redhat.com, daniel.thompson@linaro.org, linux@arm.linux.org.uk, mingo@elte.hu, peterz@infradead.org, pmladek@suse.com, rjw@rjwysocki.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi_backtrace: generate one-line reports for idle cpus
has been removed from the -mm tree.  Its filename was
     nmi_backtrace-generate-one-line-reports-for-idle-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: nmi_backtrace: generate one-line reports for idle cpus

When doing an nmi backtrace of many cores, most of which are idle,
the output is a little overwhelming and very uninformative.  Suppress
messages for cpus that are idling when they are interrupted and just
emit one line, "NMI backtrace for N skipped: idling at pc 0xNNN".

We do this by grouping all the cpuidle code together into a new
.cpuidle.text section, and then checking the address of the
interrupted PC to see if it lies within that section.

This commit suitably tags x86 and tile idle routines, and only
adds in the minimal framework for other architectures.

Link: http://lkml.kernel.org/r/1472487169-14923-5-git-send-email-cmetcalf@mellanox.com
Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org> [arm]
Tested-by: Petr Mladek <pmladek@suse.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S      |    1 +
 arch/arc/kernel/vmlinux.lds.S        |    1 +
 arch/arm/kernel/vmlinux-xip.lds.S    |    1 +
 arch/arm/kernel/vmlinux.lds.S        |    1 +
 arch/arm64/kernel/vmlinux.lds.S      |    1 +
 arch/avr32/kernel/vmlinux.lds.S      |    1 +
 arch/blackfin/kernel/vmlinux.lds.S   |    1 +
 arch/c6x/kernel/vmlinux.lds.S        |    1 +
 arch/cris/kernel/vmlinux.lds.S       |    1 +
 arch/frv/kernel/vmlinux.lds.S        |    1 +
 arch/h8300/kernel/vmlinux.lds.S      |    1 +
 arch/hexagon/kernel/vmlinux.lds.S    |    1 +
 arch/ia64/kernel/vmlinux.lds.S       |    1 +
 arch/m32r/kernel/vmlinux.lds.S       |    1 +
 arch/m68k/kernel/vmlinux-nommu.lds   |    1 +
 arch/m68k/kernel/vmlinux-std.lds     |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds    |    1 +
 arch/metag/kernel/vmlinux.lds.S      |    1 +
 arch/microblaze/kernel/vmlinux.lds.S |    1 +
 arch/mips/kernel/vmlinux.lds.S       |    1 +
 arch/mn10300/kernel/vmlinux.lds.S    |    1 +
 arch/nios2/kernel/vmlinux.lds.S      |    1 +
 arch/openrisc/kernel/vmlinux.lds.S   |    1 +
 arch/parisc/kernel/vmlinux.lds.S     |    1 +
 arch/powerpc/kernel/vmlinux.lds.S    |    1 +
 arch/s390/kernel/vmlinux.lds.S       |    1 +
 arch/score/kernel/vmlinux.lds.S      |    1 +
 arch/sh/kernel/vmlinux.lds.S         |    1 +
 arch/sparc/kernel/vmlinux.lds.S      |    1 +
 arch/tile/kernel/entry.S             |    2 +-
 arch/tile/kernel/vmlinux.lds.S       |    1 +
 arch/um/kernel/dyn.lds.S             |    1 +
 arch/um/kernel/uml.lds.S             |    1 +
 arch/unicore32/kernel/vmlinux.lds.S  |    1 +
 arch/x86/include/asm/irqflags.h      |   12 ++++++++----
 arch/x86/kernel/acpi/cstate.c        |    2 +-
 arch/x86/kernel/process.c            |    4 ++--
 arch/x86/kernel/vmlinux.lds.S        |    1 +
 arch/xtensa/kernel/vmlinux.lds.S     |    3 +++
 drivers/acpi/processor_idle.c        |    5 +++--
 drivers/cpuidle/driver.c             |    5 +++--
 drivers/idle/intel_idle.c            |    4 ++--
 include/asm-generic/vmlinux.lds.h    |    6 ++++++
 include/linux/cpu.h                  |    5 +++++
 kernel/sched/idle.c                  |   13 +++++++++++--
 lib/nmi_backtrace.c                  |   16 +++++++++++-----
 scripts/mod/modpost.c                |    2 +-
 scripts/recordmcount.c               |    1 +
 scripts/recordmcount.pl              |    1 +
 49 files changed, 93 insertions(+), 22 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -22,6 +22,7 @@ SECTIONS
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		*(.fixup)
 		*(.gnu.warning)
diff -puN arch/arc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/arc/kernel/vmlinux.lds.S
--- a/arch/arc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/arc/kernel/vmlinux.lds.S
@@ -89,6 +89,7 @@ SECTIONS
 		_text = .;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		*(.fixup)
diff -puN arch/arm/kernel/vmlinux-xip.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/arm/kernel/vmlinux-xip.lds.S
--- a/arch/arm/kernel/vmlinux-xip.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/arm/kernel/vmlinux-xip.lds.S
@@ -98,6 +98,7 @@ SECTIONS
 			IRQENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
+			CPUIDLE_TEXT
 			LOCK_TEXT
 			KPROBES_TEXT
 			*(.gnu.warning)
diff -puN arch/arm/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -111,6 +111,7 @@ SECTIONS
 			SOFTIRQENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
+			CPUIDLE_TEXT
 			LOCK_TEXT
 			HYPERVISOR_TEXT
 			KPROBES_TEXT
diff -puN arch/arm64/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/arm64/kernel/vmlinux.lds.S
--- a/arch/arm64/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/arm64/kernel/vmlinux.lds.S
@@ -122,6 +122,7 @@ SECTIONS
 			ENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
+			CPUIDLE_TEXT
 			LOCK_TEXT
 			KPROBES_TEXT
 			HYPERVISOR_TEXT
diff -puN arch/avr32/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/avr32/kernel/vmlinux.lds.S
--- a/arch/avr32/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/avr32/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 		KPROBES_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		*(.fixup)
 		*(.gnu.warning)
diff -puN arch/blackfin/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/blackfin/kernel/vmlinux.lds.S
--- a/arch/blackfin/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/blackfin/kernel/vmlinux.lds.S
@@ -33,6 +33,7 @@ SECTIONS
 #ifndef CONFIG_SCHEDULE_L1
 		SCHED_TEXT
 #endif
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		IRQENTRY_TEXT
 		SOFTIRQENTRY_TEXT
diff -puN arch/c6x/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/c6x/kernel/vmlinux.lds.S
--- a/arch/c6x/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/c6x/kernel/vmlinux.lds.S
@@ -70,6 +70,7 @@ SECTIONS
 		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		IRQENTRY_TEXT
 		SOFTIRQENTRY_TEXT
diff -puN arch/cris/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/cris/kernel/vmlinux.lds.S
--- a/arch/cris/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/cris/kernel/vmlinux.lds.S
@@ -43,6 +43,7 @@ SECTIONS
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		*(.fixup)
 		*(.text.__*)
diff -puN arch/frv/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 	*(.text..tlbmiss)
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 #ifdef CONFIG_DEBUG_INFO
 	INIT_TEXT
diff -puN arch/h8300/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/h8300/kernel/vmlinux.lds.S
--- a/arch/h8300/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/h8300/kernel/vmlinux.lds.S
@@ -29,6 +29,7 @@ SECTIONS
 	_stext = . ;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 #if defined(CONFIG_ROMKERNEL)
 		*(.int_redirect)
diff -puN arch/hexagon/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/hexagon/kernel/vmlinux.lds.S
--- a/arch/hexagon/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/hexagon/kernel/vmlinux.lds.S
@@ -50,6 +50,7 @@ SECTIONS
 		_text = .;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		*(.fixup)
diff -puN arch/ia64/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -46,6 +46,7 @@ SECTIONS {
 		__end_ivt_text = .;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		*(.gnu.linkonce.t*)
diff -puN arch/m32r/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -31,6 +31,7 @@ SECTIONS
 	HEAD_TEXT
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 	*(.fixup)
 	*(.gnu.warning)
diff -puN arch/m68k/kernel/vmlinux-nommu.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/m68k/kernel/vmlinux-nommu.lds
--- a/arch/m68k/kernel/vmlinux-nommu.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/m68k/kernel/vmlinux-nommu.lds
@@ -45,6 +45,7 @@ SECTIONS {
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		*(.fixup)
 		. = ALIGN(16);
diff -puN arch/m68k/kernel/vmlinux-std.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/m68k/kernel/vmlinux-std.lds
--- a/arch/m68k/kernel/vmlinux-std.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/m68k/kernel/vmlinux-std.lds
@@ -16,6 +16,7 @@ SECTIONS
 	HEAD_TEXT
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 	*(.fixup)
 	*(.gnu.warning)
diff -puN arch/m68k/kernel/vmlinux-sun3.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/m68k/kernel/vmlinux-sun3.lds
--- a/arch/m68k/kernel/vmlinux-sun3.lds~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/m68k/kernel/vmlinux-sun3.lds
@@ -16,6 +16,7 @@ SECTIONS
 	HEAD_TEXT
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 	*(.fixup)
 	*(.gnu.warning)
diff -puN arch/metag/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/metag/kernel/vmlinux.lds.S
--- a/arch/metag/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/metag/kernel/vmlinux.lds.S
@@ -21,6 +21,7 @@ SECTIONS
   .text : {
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
 	IRQENTRY_TEXT
diff -puN arch/microblaze/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/microblaze/kernel/vmlinux.lds.S
--- a/arch/microblaze/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/microblaze/kernel/vmlinux.lds.S
@@ -33,6 +33,7 @@ SECTIONS {
 		EXIT_TEXT
 		EXIT_CALL
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/mips/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/mips/kernel/vmlinux.lds.S
@@ -55,6 +55,7 @@ SECTIONS
 	.text : {
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/mn10300/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/mn10300/kernel/vmlinux.lds.S
--- a/arch/mn10300/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/mn10300/kernel/vmlinux.lds.S
@@ -30,6 +30,7 @@ SECTIONS
 	HEAD_TEXT
 	TEXT_TEXT
 	SCHED_TEXT
+	CPUIDLE_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
 	*(.fixup)
diff -puN arch/nios2/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/nios2/kernel/vmlinux.lds.S
--- a/arch/nios2/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/nios2/kernel/vmlinux.lds.S
@@ -37,6 +37,7 @@ SECTIONS
 	.text : {
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		IRQENTRY_TEXT
 		SOFTIRQENTRY_TEXT
diff -puN arch/openrisc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/openrisc/kernel/vmlinux.lds.S
--- a/arch/openrisc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/openrisc/kernel/vmlinux.lds.S
@@ -47,6 +47,7 @@ SECTIONS
           _stext = .;
 	  TEXT_TEXT
 	  SCHED_TEXT
+	  CPUIDLE_TEXT
 	  LOCK_TEXT
 	  KPROBES_TEXT
 	  IRQENTRY_TEXT
diff -puN arch/parisc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/parisc/kernel/vmlinux.lds.S
@@ -69,6 +69,7 @@ SECTIONS
 	.text ALIGN(PAGE_SIZE) : {
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/powerpc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 		/* careful! __ftr_alt_* sections need to be close to .text */
 		*(.text .fixup __ftr_alt_* .ref.text)
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/s390/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/score/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/score/kernel/vmlinux.lds.S
--- a/arch/score/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/score/kernel/vmlinux.lds.S
@@ -40,6 +40,7 @@ SECTIONS
 		_text = .;	/* Text and read-only data */
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		*(.text.*)
diff -puN arch/sh/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/sh/kernel/vmlinux.lds.S
@@ -36,6 +36,7 @@ SECTIONS
 		TEXT_TEXT
 		EXTRA_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/sparc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/sparc/kernel/vmlinux.lds.S
@@ -49,6 +49,7 @@ SECTIONS
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
diff -puN arch/tile/kernel/entry.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/tile/kernel/entry.S
--- a/arch/tile/kernel/entry.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/tile/kernel/entry.S
@@ -50,7 +50,7 @@ STD_ENTRY(smp_nap)
  * When interrupted at _cpu_idle_nap, we bump the PC forward 8, and
  * as a result return to the function that called _cpu_idle().
  */
-STD_ENTRY(_cpu_idle)
+STD_ENTRY_SECTION(_cpu_idle, .cpuidle.text)
 	movei r1, 1
 	IRQ_ENABLE_LOAD(r2, r3)
 	mtspr INTERRUPT_CRITICAL_SECTION, r1
diff -puN arch/tile/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/tile/kernel/vmlinux.lds.S
--- a/arch/tile/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/tile/kernel/vmlinux.lds.S
@@ -42,6 +42,7 @@ SECTIONS
   .text : AT (ADDR(.text) - LOAD_OFFSET) {
     HEAD_TEXT
     SCHED_TEXT
+    CPUIDLE_TEXT
     LOCK_TEXT
     KPROBES_TEXT
     IRQENTRY_TEXT
diff -puN arch/um/kernel/dyn.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/um/kernel/dyn.lds.S
@@ -68,6 +68,7 @@ SECTIONS
     _stext = .;
     TEXT_TEXT
     SCHED_TEXT
+    CPUIDLE_TEXT
     LOCK_TEXT
     *(.fixup)
     *(.stub .text.* .gnu.linkonce.t.*)
diff -puN arch/um/kernel/uml.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/um/kernel/uml.lds.S
@@ -28,6 +28,7 @@ SECTIONS
     _stext = .;
     TEXT_TEXT
     SCHED_TEXT
+    CPUIDLE_TEXT
     LOCK_TEXT
     *(.fixup)
     /* .gnu.warning sections are handled specially by elf32.em.  */
diff -puN arch/unicore32/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/unicore32/kernel/vmlinux.lds.S
--- a/arch/unicore32/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/unicore32/kernel/vmlinux.lds.S
@@ -37,6 +37,7 @@ SECTIONS
 	.text : {		/* Real text segment */
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 
 		*(.fixup)
diff -puN arch/x86/include/asm/irqflags.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/x86/include/asm/irqflags.h
--- a/arch/x86/include/asm/irqflags.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/x86/include/asm/irqflags.h
@@ -4,6 +4,10 @@
 #include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
+
+/* Provide __cpuidle; we can't safely include <linux/cpu.h> */
+#define __cpuidle __attribute__((__section__(".cpuidle.text")))
+
 /*
  * Interrupt control:
  */
@@ -44,12 +48,12 @@ static inline void native_irq_enable(voi
 	asm volatile("sti": : :"memory");
 }
 
-static inline void native_safe_halt(void)
+static inline __cpuidle void native_safe_halt(void)
 {
 	asm volatile("sti; hlt": : :"memory");
 }
 
-static inline void native_halt(void)
+static inline __cpuidle void native_halt(void)
 {
 	asm volatile("hlt": : :"memory");
 }
@@ -86,7 +90,7 @@ static inline notrace void arch_local_ir
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
  */
-static inline void arch_safe_halt(void)
+static inline __cpuidle void arch_safe_halt(void)
 {
 	native_safe_halt();
 }
@@ -95,7 +99,7 @@ static inline void arch_safe_halt(void)
  * Used when interrupts are already enabled or to
  * shutdown the processor:
  */
-static inline void halt(void)
+static inline __cpuidle void halt(void)
 {
 	native_halt();
 }
diff -puN arch/x86/kernel/acpi/cstate.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/x86/kernel/acpi/cstate.c
--- a/arch/x86/kernel/acpi/cstate.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/x86/kernel/acpi/cstate.c
@@ -152,7 +152,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 
-void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
+void __cpuidle acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
 {
 	unsigned int cpu = smp_processor_id();
 	struct cstate_entry *percpu_entry;
diff -puN arch/x86/kernel/process.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/x86/kernel/process.c
@@ -302,7 +302,7 @@ void arch_cpu_idle(void)
 /*
  * We use this if we don't have any better idle routine..
  */
-void default_idle(void)
+void __cpuidle default_idle(void)
 {
 	trace_cpu_idle_rcuidle(1, smp_processor_id());
 	safe_halt();
@@ -417,7 +417,7 @@ static int prefer_mwait_c1_over_halt(con
  * with interrupts enabled and no flags, which is backwards compatible with the
  * original MWAIT implementation.
  */
-static void mwait_idle(void)
+static __cpuidle void mwait_idle(void)
 {
 	if (!current_set_polling_and_test()) {
 		trace_cpu_idle_rcuidle(1, smp_processor_id());
diff -puN arch/x86/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/x86/kernel/vmlinux.lds.S
--- a/arch/x86/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -97,6 +97,7 @@ SECTIONS
 		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
+		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
 		ENTRY_TEXT
diff -puN arch/xtensa/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -89,6 +89,9 @@ SECTIONS
     VMLINUX_SYMBOL(__sched_text_start) = .;
     *(.sched.literal .sched.text)
     VMLINUX_SYMBOL(__sched_text_end) = .;
+    VMLINUX_SYMBOL(__cpuidle_text_start) = .;
+    *(.cpuidle.literal .cpuidle.text)
+    VMLINUX_SYMBOL(__cpuidle_text_end) = .;
     VMLINUX_SYMBOL(__lock_text_start) = .;
     *(.spinlock.literal .spinlock.text)
     VMLINUX_SYMBOL(__lock_text_end) = .;
diff -puN drivers/acpi/processor_idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/drivers/acpi/processor_idle.c
@@ -31,6 +31,7 @@
 #include <linux/sched.h>       /* need_resched() */
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
+#include <linux/cpu.h>
 #include <acpi/processor.h>
 
 /*
@@ -115,7 +116,7 @@ static const struct dmi_system_id proces
  * Callers should disable interrupts before the call and enable
  * interrupts after return.
  */
-static void acpi_safe_halt(void)
+static void __cpuidle acpi_safe_halt(void)
 {
 	if (!tif_need_resched()) {
 		safe_halt();
@@ -645,7 +646,7 @@ static int acpi_idle_bm_check(void)
  *
  * Caller disables interrupt before call and enables interrupt after return.
  */
-static void acpi_idle_do_entry(struct acpi_processor_cx *cx)
+static void __cpuidle acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
diff -puN drivers/cpuidle/driver.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus drivers/cpuidle/driver.c
--- a/drivers/cpuidle/driver.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/drivers/cpuidle/driver.c
@@ -14,6 +14,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpumask.h>
 #include <linux/tick.h>
+#include <linux/cpu.h>
 
 #include "cpuidle.h"
 
@@ -178,8 +179,8 @@ static void __cpuidle_driver_init(struct
 }
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
+static int __cpuidle poll_idle(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index)
 {
 	local_irq_enable();
 	if (!current_set_polling_and_test()) {
diff -puN drivers/idle/intel_idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/drivers/idle/intel_idle.c
@@ -863,8 +863,8 @@ static struct cpuidle_state dnv_cstates[
  *
  * Must be called under local_irq_disable().
  */
-static int intel_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
+static __cpuidle int intel_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index)
 {
 	unsigned long ecx = 1; /* break on interrupt flag */
 	struct cpuidle_state *state = &drv->states[index];
diff -puN include/asm-generic/vmlinux.lds.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/include/asm-generic/vmlinux.lds.h
@@ -454,6 +454,12 @@
 		*(.spinlock.text)					\
 		VMLINUX_SYMBOL(__lock_text_end) = .;
 
+#define CPUIDLE_TEXT							\
+		ALIGN_FUNCTION();					\
+		VMLINUX_SYMBOL(__cpuidle_text_start) = .;		\
+		*(.cpuidle.text)					\
+		VMLINUX_SYMBOL(__cpuidle_text_end) = .;
+
 #define KPROBES_TEXT							\
 		ALIGN_FUNCTION();					\
 		VMLINUX_SYMBOL(__kprobes_text_start) = .;		\
diff -puN include/linux/cpu.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus include/linux/cpu.h
--- a/include/linux/cpu.h~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/include/linux/cpu.h
@@ -231,6 +231,11 @@ void cpu_startup_entry(enum cpuhp_state
 
 void cpu_idle_poll_ctrl(bool enable);
 
+/* Attach to any functions which should be considered cpuidle. */
+#define __cpuidle	__attribute__((__section__(".cpuidle.text")))
+
+bool cpu_in_idle(unsigned long pc);
+
 void arch_cpu_idle(void);
 void arch_cpu_idle_prepare(void);
 void arch_cpu_idle_enter(void);
diff -puN kernel/sched/idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus kernel/sched/idle.c
--- a/kernel/sched/idle.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/kernel/sched/idle.c
@@ -16,6 +16,9 @@
 
 #include "sched.h"
 
+/* Linker adds these: start and end of __cpuidle functions */
+extern char __cpuidle_text_start[], __cpuidle_text_end[];
+
 /**
  * sched_idle_set_state - Record idle state for the current CPU.
  * @idle_state: State to record.
@@ -53,7 +56,7 @@ static int __init cpu_idle_nopoll_setup(
 __setup("hlt", cpu_idle_nopoll_setup);
 #endif
 
-static inline int cpu_idle_poll(void)
+static noinline int __cpuidle cpu_idle_poll(void)
 {
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
@@ -84,7 +87,7 @@ void __weak arch_cpu_idle(void)
  *
  * To use when the cpuidle framework cannot be used.
  */
-void default_idle_call(void)
+void __cpuidle default_idle_call(void)
 {
 	if (current_clr_polling_and_test()) {
 		local_irq_enable();
@@ -271,6 +274,12 @@ static void cpu_idle_loop(void)
 	}
 }
 
+bool cpu_in_idle(unsigned long pc)
+{
+	return pc >= (unsigned long)__cpuidle_text_start &&
+		pc < (unsigned long)__cpuidle_text_end;
+}
+
 void cpu_startup_entry(enum cpuhp_state state)
 {
 	/*
diff -puN lib/nmi_backtrace.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus lib/nmi_backtrace.c
--- a/lib/nmi_backtrace.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/lib/nmi_backtrace.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
+#include <linux/cpu.h>
 
 #ifdef arch_trigger_cpumask_backtrace
 /* For reliability, we're prepared to waste bits here. */
@@ -87,11 +88,16 @@ bool nmi_cpu_backtrace(struct pt_regs *r
 	int cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		pr_warn("NMI backtrace for cpu %d\n", cpu);
-		if (regs)
-			show_regs(regs);
-		else
-			dump_stack();
+		if (regs && cpu_in_idle(instruction_pointer(regs))) {
+			pr_warn("NMI backtrace for cpu %d skipped: idling at pc %#lx\n",
+				cpu, instruction_pointer(regs));
+		} else {
+			pr_warn("NMI backtrace for cpu %d\n", cpu);
+			if (regs)
+				show_regs(regs);
+			else
+				dump_stack();
+		}
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return true;
 	}
diff -puN scripts/mod/modpost.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/scripts/mod/modpost.c
@@ -888,7 +888,7 @@ static void check_section(const char *mo
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
-		".kprobes.text"
+		".kprobes.text", ".cpuidle.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
 		".coldtext"
diff -puN scripts/recordmcount.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus scripts/recordmcount.c
--- a/scripts/recordmcount.c~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/scripts/recordmcount.c
@@ -365,6 +365,7 @@ is_mcounted_section_name(char const *con
 		strcmp(".irqentry.text", txtname) == 0 ||
 		strcmp(".softirqentry.text", txtname) == 0 ||
 		strcmp(".kprobes.text", txtname) == 0 ||
+		strcmp(".cpuidle.text", txtname) == 0 ||
 		strcmp(".text.unlikely", txtname) == 0;
 }
 
diff -puN scripts/recordmcount.pl~nmi_backtrace-generate-one-line-reports-for-idle-cpus scripts/recordmcount.pl
--- a/scripts/recordmcount.pl~nmi_backtrace-generate-one-line-reports-for-idle-cpus
+++ a/scripts/recordmcount.pl
@@ -136,6 +136,7 @@ my %text_sections = (
      ".irqentry.text" => 1,
      ".softirqentry.text" => 1,
      ".kprobes.text" => 1,
+     ".cpuidle.text" => 1,
      ".text.unlikely" => 1,
 );
 
_

Patches currently in -mm which might be from cmetcalf@mellanox.com are


