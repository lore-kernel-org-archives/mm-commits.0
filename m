Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233B3B297
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CLt0GTl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0FAC433C8;
	Fri,  8 Dec 2023 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065021;
	bh=m5Ccv3LLzHHqyMKY2ILaDdBhO67mXia9YuGjO4CIlEA=;
	h=Date:To:From:Subject:From;
	b=CLt0GTl8xSvsEfzFPf0KjSluEDzBTM9inIWa7dmemN5OOyRV5LL/F52GcFUlDXyDz
	 3W8Y8xdiUpzgmmmZt1ipQl2hA7nEBMYk6sfxJkoCrjH4gbwsF560dV11Rwq87dFn77
	 PjTD+YdM3dfrhVVW9y1gu7Jbbu+/rG+pshNCystQ=
Date: Fri, 08 Dec 2023 11:50:20 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195021.6C0FAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips, kexec: fix the incorrect ifdeffery and dependency of CONFIG_KEXEC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mips, kexec: fix the incorrect ifdeffery and dependency of CONFIG_KEXEC
Date: Fri, 8 Dec 2023 15:30:34 +0800

The select of KEXEC for CRASH_DUMP in kernel/Kconfig.kexec will be
dropped, then compiling errors will be triggered if below config items are
set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

--------------------------------------------------------------------
mipsel-linux-ld: kernel/kexec_core.o: in function `kimage_free':
kernel/kexec_core.c:(.text+0x2200): undefined reference to `machine_kexec_cleanup'
mipsel-linux-ld: kernel/kexec_core.o: in function `__crash_kexec':
kernel/kexec_core.c:(.text+0x2480): undefined reference to `machine_crash_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x2488): undefined reference to `machine_kexec'
mipsel-linux-ld: kernel/kexec_core.o: in function `kernel_kexec':
kernel/kexec_core.c:(.text+0x29b8): undefined reference to `machine_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x29c0): undefined reference to `machine_kexec'
--------------------------------------------------------------------

Here, change the dependency of building kexec_core related object files,
and the ifdeffery in mips from CONFIG_KEXEC to CONFIG_KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231208073036.7884-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311302042.sn8cDPIX-lkp@intel.com/
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/smp.c   |    4 ++--
 arch/mips/include/asm/kexec.h   |    2 +-
 arch/mips/include/asm/smp-ops.h |    2 +-
 arch/mips/include/asm/smp.h     |    2 +-
 arch/mips/kernel/Makefile       |    2 +-
 arch/mips/kernel/smp-bmips.c    |    4 ++--
 arch/mips/kernel/smp-cps.c      |   10 +++++-----
 arch/mips/loongson64/reset.c    |    4 ++--
 arch/mips/loongson64/smp.c      |    2 +-
 9 files changed, 16 insertions(+), 16 deletions(-)

--- a/arch/mips/cavium-octeon/smp.c~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/cavium-octeon/smp.c
@@ -422,7 +422,7 @@ static const struct plat_smp_ops octeon_
 	.cpu_disable		= octeon_cpu_disable,
 	.cpu_die		= octeon_cpu_die,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu	= kexec_nonboot_cpu_jump,
 #endif
 };
@@ -502,7 +502,7 @@ static const struct plat_smp_ops octeon_
 	.cpu_disable		= octeon_cpu_disable,
 	.cpu_die		= octeon_cpu_die,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu	= kexec_nonboot_cpu_jump,
 #endif
 };
--- a/arch/mips/include/asm/kexec.h~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/include/asm/kexec.h
@@ -31,7 +31,7 @@ static inline void crash_setup_regs(stru
 		prepare_frametrace(newregs);
 }
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 struct kimage;
 extern unsigned long kexec_args[4];
 extern int (*_machine_kexec_prepare)(struct kimage *);
--- a/arch/mips/include/asm/smp.h~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/include/asm/smp.h
@@ -93,7 +93,7 @@ static inline void __cpu_die(unsigned in
 extern void __noreturn play_dead(void);
 #endif
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 static inline void kexec_nonboot_cpu(void)
 {
 	extern const struct plat_smp_ops *mp_ops;	/* private */
--- a/arch/mips/include/asm/smp-ops.h~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/include/asm/smp-ops.h
@@ -35,7 +35,7 @@ struct plat_smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*cleanup_dead_cpu)(unsigned cpu);
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	void (*kexec_nonboot_cpu)(void);
 #endif
 };
--- a/arch/mips/kernel/Makefile~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/kernel/Makefile
@@ -90,7 +90,7 @@ obj-$(CONFIG_GPIO_TXX9)		+= gpio_txx9.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_EARLY_PRINTK_8250)	+= early_printk_8250.o
--- a/arch/mips/kernel/smp-bmips.c~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/kernel/smp-bmips.c
@@ -434,7 +434,7 @@ const struct plat_smp_ops bmips43xx_smp_
 	.cpu_disable		= bmips_cpu_disable,
 	.cpu_die		= bmips_cpu_die,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu	= kexec_nonboot_cpu_jump,
 #endif
 };
@@ -451,7 +451,7 @@ const struct plat_smp_ops bmips5000_smp_
 	.cpu_disable		= bmips_cpu_disable,
 	.cpu_die		= bmips_cpu_die,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu	= kexec_nonboot_cpu_jump,
 #endif
 };
--- a/arch/mips/kernel/smp-cps.c~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/kernel/smp-cps.c
@@ -392,7 +392,7 @@ static void cps_smp_finish(void)
 	local_irq_enable();
 }
 
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_KEXEC)
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_KEXEC_CORE)
 
 enum cpu_death {
 	CPU_DEATH_HALT,
@@ -429,7 +429,7 @@ static void cps_shutdown_this_cpu(enum c
 	}
 }
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 
 static void cps_kexec_nonboot_cpu(void)
 {
@@ -439,9 +439,9 @@ static void cps_kexec_nonboot_cpu(void)
 		cps_shutdown_this_cpu(CPU_DEATH_POWER);
 }
 
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
-#endif /* CONFIG_HOTPLUG_CPU || CONFIG_KEXEC */
+#endif /* CONFIG_HOTPLUG_CPU || CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -610,7 +610,7 @@ static const struct plat_smp_ops cps_smp
 	.cpu_die		= cps_cpu_die,
 	.cleanup_dead_cpu	= cps_cleanup_dead_cpu,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu	= cps_kexec_nonboot_cpu,
 #endif
 };
--- a/arch/mips/loongson64/reset.c~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/loongson64/reset.c
@@ -53,7 +53,7 @@ static void loongson_halt(void)
 	}
 }
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 
 /* 0X80000000~0X80200000 is safe */
 #define MAX_ARGS	64
@@ -158,7 +158,7 @@ static int __init mips_reboot_setup(void
 	_machine_halt = loongson_halt;
 	pm_power_off = loongson_poweroff;
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
 	if (WARN_ON(!kexec_argv))
 		return -ENOMEM;
--- a/arch/mips/loongson64/smp.c~mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/mips/loongson64/smp.c
@@ -864,7 +864,7 @@ const struct plat_smp_ops loongson3_smp_
 	.cpu_disable = loongson3_cpu_disable,
 	.cpu_die = loongson3_cpu_die,
 #endif
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.kexec_nonboot_cpu = kexec_nonboot_cpu_jump,
 #endif
 };
_

Patches currently in -mm which might be from bhe@redhat.com are

riscv-fix-vmallc_start-definition.patch
loongarch-kexec-change-dependency-of-object-files.patch
m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch
mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

