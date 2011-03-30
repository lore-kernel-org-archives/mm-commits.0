From: akpm@linux-foundation.org
Subject: + x86-stop-including-linux-delayh-in-two-asm-header-files.patch added to -mm tree
Date: Wed, 30 Mar 2011 15:23:13 -0700
Message-ID: <201103302223.p2UMND1W015318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932977Ab1C3WYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, geert@linux-m68k.org, hpa@zytor.com, mingo@elte.hu, sfr@canb.auug.org.au, tglx@linutronix.de


The patch titled
     x86: stop including <linux/delay.h> in two asm header files
has been added to the -mm tree.  Its filename is
     x86-stop-including-linux-delayh-in-two-asm-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: stop including <linux/delay.h> in two asm header files
From: Jean Delvare <khali@linux-fr.org>

Stop including <linux/delay.h> in x86 header files which don't need it. 
This will let the compiler complain when this header is not included by
source files when it should, so that contributors can fix the problem
before building on other architectures starts to fail.

Credits go to Geert for the idea.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/apic.h        |    1 -
 arch/x86/include/asm/dma.h         |    1 -
 arch/x86/kernel/apic/hw_nmi.c      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 arch/x86/kernel/irq.c              |    1 +
 arch/x86/kernel/reboot.c           |    1 +
 arch/x86/platform/uv/tlb_uv.c      |    1 +
 drivers/media/rc/ite-cir.c         |    1 +
 drivers/scsi/ultrastor.c           |    1 +
 9 files changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/apic.h~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/include/asm/apic.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_APIC_H
 
 #include <linux/cpumask.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 
 #include <asm/alternative.h>
diff -puN arch/x86/include/asm/dma.h~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/include/asm/dma.h
--- a/arch/x86/include/asm/dma.h~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/include/asm/dma.h
@@ -10,7 +10,6 @@
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
diff -puN arch/x86/kernel/apic/hw_nmi.c~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
diff -puN arch/x86/kernel/apic/x2apic_uv_x.c~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/delay.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
diff -puN arch/x86/kernel/irq.c~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/kernel/irq.c
--- a/arch/x86/kernel/irq.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/kernel/irq.c
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/delay.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
diff -puN arch/x86/kernel/reboot.c~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/kernel/reboot.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/delay.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
diff -puN arch/x86/platform/uv/tlb_uv.c~x86-stop-including-linux-delayh-in-two-asm-header-files arch/x86/platform/uv/tlb_uv.c
--- a/arch/x86/platform/uv/tlb_uv.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/arch/x86/platform/uv/tlb_uv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
diff -puN drivers/media/rc/ite-cir.c~x86-stop-including-linux-delayh-in-two-asm-header-files drivers/media/rc/ite-cir.c
--- a/drivers/media/rc/ite-cir.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/drivers/media/rc/ite-cir.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <media/rc-core.h>
 #include <linux/pci_ids.h>
+#include <linux/delay.h>
 
 #include "ite-cir.h"
 
diff -puN drivers/scsi/ultrastor.c~x86-stop-including-linux-delayh-in-two-asm-header-files drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~x86-stop-including-linux-delayh-in-two-asm-header-files
+++ a/drivers/scsi/ultrastor.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
_

Patches currently in -mm which might be from khali@linux-fr.org are

x86-stop-including-linux-delayh-in-two-asm-header-files.patch

