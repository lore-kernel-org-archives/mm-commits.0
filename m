Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6B918C900
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349577; cv=none; b=NZ7lB9AjVWlSISJmLzyCQBAAszoYU0vXGqga5FH/zhoUMwV8MJsKUbygiZx7s7ZE2NdRhImLAu0ATl6EIRsiDu+aWKL5+mtNbXs3Ugcc8CZUTR46Px29kfUBNNkiF+i4aHGUkwIWBpjjDHKtQjCLRHzx0iqctUXCRiKtxjy4Rug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349577; c=relaxed/simple;
	bh=y7/YO8xpNuPl68HiJVnvjNuFE4zdcJh3ZbfI9fDZnOM=;
	h=Date:To:From:Subject:Message-Id; b=KoWp0M0RhMUueXkJZkdmtCM4aYjyg9iWyByU502YhbWsW56jagfnHjz3CWcB7rytu8rjTyPhcSjS4y0YQjSw/VDBHx18n0SXYvGvInNjELd3pcitin7VvlMr8FUOYpRmU1AkcdYQDkGWDqT3HYJltn+jxfokwkxhWdz1MRKRLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d8kGrZEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d8kGrZEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C393C4CECD;
	Wed,  4 Dec 2024 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733349577;
	bh=y7/YO8xpNuPl68HiJVnvjNuFE4zdcJh3ZbfI9fDZnOM=;
	h=Date:To:From:Subject:From;
	b=d8kGrZEchghwA4GXwuB1vgJQoWN71/hCsFkIPV9S/M7IbaAm5I3VDx+hRHPGVJOhi
	 TKEe+NTCe+QruxLaCWySgX3U93vo+uZkYCiaOKEw3bZFWHo8PXQKfTUuGpALNqznAk
	 6bf5iu8I/GlL+ve2n9LHMFF1hFQKEgl1DRAlpxdY=
Date: Wed, 04 Dec 2024 13:59:36 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,takakura@valinux.co.jp,sourabhjain@linux.ibm.com,songshuaishuai@tinylab.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,linux@armlinux.org.uk,jonnyc@amazon.com,hbathini@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,adityag@linux.ibm.com,farbere@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-consolidate-machine_kexec_mask_interrupts-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20241204215937.2C393C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: consolidate machine_kexec_mask_interrupts() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-consolidate-machine_kexec_mask_interrupts-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-consolidate-machine_kexec_mask_interrupts-implementation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Eliav Farber <farbere@amazon.com>
Subject: kexec: consolidate machine_kexec_mask_interrupts() implementation
Date: Wed, 4 Dec 2024 14:20:02 +0000

Patch series "Improve interrupt handling during machine kexec", v6.

This patch series focuses on improving the machine_kexec_mask_interrupts()
function by consolidating its implementation and optimizing its behavior to
avoid redundant interrupt masking.

Patch Summary:
[PATCH v6 1/2] Move machine_kexec_mask_interrupts() to kernel/irq/kexec.c,
               removing duplicate architecture-specific implementations.
[PATCH v6 2/2] Refine machine_kexec_mask_interrupts() to avoid re-masking
               already-masked interrupts, resolving specific warnings
               triggered in GPIO IRQ flows.


This patch (of 2):

Consolidate the machine_kexec_mask_interrupts implementation into a common
function located in a new file: kernel/irq/kexec.c.  This removes
duplicate implementations from architecture-specific files in arch/arm,
arch/arm64, arch/powerpc, and arch/riscv, reducing code duplication and
improving maintainability.

The new implementation retains architecture-specific behavior for
CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD, which was previously
implemented for ARM64.  When enabled (currently for ARM64), it clears the
active state of interrupts forwarded to virtual machines (VMs) before
handling other interrupt masking operations.

Link: https://lkml.kernel.org/r/20241204142003.32859-1-farbere@amazon.com
Link: https://lkml.kernel.org/r/20241204142003.32859-2-farbere@amazon.com
Signed-off-by: Eliav Farber <farbere@amazon.com>
Cc: Aditya Gupta <adityag@linux.ibm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jonathan Chocron <jonnyc@amazon.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryo Takakura <takakura@valinux.co.jp>
Cc: Song Shuai <songshuaishuai@tinylab.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/machine_kexec.c   |   23 ----------------
 arch/arm64/Kconfig                |    1 
 arch/arm64/kernel/machine_kexec.c |   31 ---------------------
 arch/powerpc/include/asm/kexec.h  |    1 
 arch/powerpc/kexec/core.c         |   22 ---------------
 arch/powerpc/kexec/core_32.c      |    1 
 arch/riscv/kernel/machine_kexec.c |   23 ----------------
 include/linux/irq.h               |    3 ++
 kernel/irq/Kconfig                |    6 ++++
 kernel/irq/Makefile               |    2 -
 kernel/irq/kexec.c                |   40 ++++++++++++++++++++++++++++
 11 files changed, 52 insertions(+), 101 deletions(-)

--- a/arch/arm64/Kconfig~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/arm64/Kconfig
@@ -149,6 +149,7 @@ config ARM64
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IOREMAP
 	select GENERIC_IRQ_IPI
+	select GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
--- a/arch/arm64/kernel/machine_kexec.c~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -207,37 +207,6 @@ void machine_kexec(struct kimage *kimage
 	BUG(); /* Should never get here. */
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-		int ret;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		/*
-		 * First try to remove the active state. If this
-		 * fails, try to EOI the interrupt.
-		 */
-		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
-
-		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
-		    chip->irq_eoi)
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 /**
  * machine_crash_shutdown - shutdown non-crashing cpus and save registers
  */
--- a/arch/arm/kernel/machine_kexec.c~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/arm/kernel/machine_kexec.c
@@ -127,29 +127,6 @@ void crash_smp_send_stop(void)
 	cpus_stopped = 1;
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 void machine_crash_shutdown(struct pt_regs *regs)
 {
 	local_irq_disable();
--- a/arch/powerpc/include/asm/kexec.h~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/powerpc/include/asm/kexec.h
@@ -61,7 +61,6 @@ struct pt_regs;
 extern void kexec_smp_wait(void);	/* get and clear naca physid, wait for
 					  master to copy new code to 0 */
 extern void default_machine_kexec(struct kimage *image);
-extern void machine_kexec_mask_interrupts(void);
 
 void relocate_new_kernel(unsigned long indirection_page, unsigned long reboot_code_buffer,
 			 unsigned long start_address) __noreturn;
--- a/arch/powerpc/kexec/core_32.c~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/powerpc/kexec/core_32.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2005 IBM Corporation.
  */
 
+#include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/mm.h>
 #include <linux/string.h>
--- a/arch/powerpc/kexec/core.c~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/powerpc/kexec/core.c
@@ -22,28 +22,6 @@
 #include <asm/setup.h>
 #include <asm/firmware.h>
 
-void machine_kexec_mask_interrupts(void) {
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 #ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
--- a/arch/riscv/kernel/machine_kexec.c~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/arch/riscv/kernel/machine_kexec.c
@@ -114,29 +114,6 @@ void machine_shutdown(void)
 #endif
 }
 
-static void machine_kexec_mask_interrupts(void)
-{
-	unsigned int i;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(i, desc) {
-		struct irq_chip *chip;
-
-		chip = irq_desc_get_chip(desc);
-		if (!chip)
-			continue;
-
-		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
-			chip->irq_eoi(&desc->irq_data);
-
-		if (chip->irq_mask)
-			chip->irq_mask(&desc->irq_data);
-
-		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
-			chip->irq_disable(&desc->irq_data);
-	}
-}
-
 /*
  * machine_crash_shutdown - Prepare to kexec after a kernel crash
  *
--- a/include/linux/irq.h~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/include/linux/irq.h
@@ -694,6 +694,9 @@ extern int irq_chip_request_resources_pa
 extern void irq_chip_release_resources_parent(struct irq_data *data);
 #endif
 
+/* Disable or mask interrupts during a kernel kexec */
+extern void machine_kexec_mask_interrupts(void);
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(struct irq_desc *desc, irqreturn_t action_ret);
 
--- a/kernel/irq/Kconfig~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/kernel/irq/Kconfig
@@ -141,6 +141,12 @@ config GENERIC_IRQ_DEBUGFS
 
 	  If you don't know what to do here, say N.
 
+# Clear forwarded VM interrupts during kexec.
+# This option ensures the kernel clears active states for interrupts
+# forwarded to virtual machines (VMs) during a machine kexec.
+config GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD
+	bool
+
 endmenu
 
 config GENERIC_IRQ_MULTI_HANDLER
diff --git a/kernel/irq/kexec.c a/kernel/irq/kexec.c
new file mode 100644
--- /dev/null
+++ a/kernel/irq/kexec.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
+#include <linux/irqnr.h>
+
+#include "internals.h"
+
+void machine_kexec_mask_interrupts(void)
+{
+	struct irq_desc *desc;
+	unsigned int i;
+
+	for_each_irq_desc(i, desc) {
+		struct irq_chip *chip;
+		int check_eoi = 1;
+
+		chip = irq_desc_get_chip(desc);
+		if (!chip)
+			continue;
+
+		if (IS_ENABLED(CONFIG_GENERIC_IRQ_KEXEC_CLEAR_VM_FORWARD)) {
+			/*
+			 * First try to remove the active state from an interrupt which is forwarded
+			 * to a VM. If the interrupt is not forwarded, try to EOI the interrupt.
+			 */
+			check_eoi = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
+		}
+
+		if (check_eoi && chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
+			chip->irq_eoi(&desc->irq_data);
+
+		if (chip->irq_mask)
+			chip->irq_mask(&desc->irq_data);
+
+		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
+			chip->irq_disable(&desc->irq_data);
+	}
+}
--- a/kernel/irq/Makefile~kexec-consolidate-machine_kexec_mask_interrupts-implementation
+++ a/kernel/irq/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o kexec.o
 obj-$(CONFIG_IRQ_TIMINGS) += timings.o
 ifeq ($(CONFIG_TEST_IRQ_TIMINGS),y)
 	CFLAGS_timings.o += -DDEBUG
_

Patches currently in -mm which might be from farbere@amazon.com are

kexec-consolidate-machine_kexec_mask_interrupts-implementation.patch
kexec-prevent-redundant-irq-masking-by-checking-state-before-shutdown.patch

