Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED321C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 18:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjLGS11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 13:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjLGS10 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 13:27:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED80A10E7
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 10:27:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70CC433C7;
        Thu,  7 Dec 2023 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701973652;
        bh=gpZ6lp0UN6Hd7/8ER33ysvYXWz2LxGI17HucZiBUb1w=;
        h=Date:To:From:Subject:From;
        b=xyw+J/w0Hv08rht/M0zpFgYWHaQ3X+9wU8w8bF9yxHTq707/Db6VqWZzsqqC3JS/u
         Ux+l5hHPS4jD8AcBEMgflaI5hI5pMZvva05q4342LOtOhz3M5Vu/3k/Vyw2lu3LWpU
         Intqs4kLWEKcIEC9q1LR4F0/3pnjuw5//7aLFac8=
Date:   Thu, 07 Dec 2023 10:27:31 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, eric_devolder@yahoo.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] kexec_core-change-dependency-of-object-files.patch removed from -mm tree
Message-Id: <20231207182732.7C70CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec_core: change dependency of object files
has been removed from the -mm tree.  Its filename was
     kexec_core-change-dependency-of-object-files.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec_core: change dependency of object files
Date: Fri, 1 Dec 2023 14:03:25 +0800

When dropping the select of KEXEC for CRASH_DUMP, compiling error will be
triggered if below config items are set on some architectures.

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

E.g the building error on loongarch:
---------------------------------------------------------------
loongarch64-linux-ld: kernel/kexec_core.o: in function `.L209':
>> kexec_core.c:(.text+0x1660): undefined reference to `machine_kexec_cleanup'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L287':
>> kexec_core.c:(.text+0x1c5c): undefined reference to `machine_crash_shutdown'
>> loongarch64-linux-ld: kexec_core.c:(.text+0x1c64): undefined reference to `machine_kexec'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L2^B5':
>> kexec_core.c:(.text+0x2090): undefined reference to `machine_shutdown'
   loongarch64-linux-ld: kexec_core.c:(.text+0x20a0): undefined reference to `machine_kexec'
---------------------------------------------------------------

The reason is that currently in arch/loongarch/kernel/Makefile, building
machine_kexec.o relocate_kernel.o depends on CONFIG_KEXEC.  So the
building of the two object files is skipped because CONFIG_KEXEC=n in that
case.

And this situation exists in m68k, mips and sh ARCH too.

Here, changing the dependency of machine_kexec.o relocate_kernel.o to
CONFIG_KEXEC_CORE for all relevant architectures.

Link: https://lkml.kernel.org/r/20231201060325.26940-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311300946.kHE9Iu71-lkp@intel.com/
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/Makefile |    2 +-
 arch/m68k/kernel/Makefile      |    2 +-
 arch/mips/kernel/Makefile      |    2 +-
 arch/sh/kernel/Makefile        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kernel/Makefile~kexec_core-change-dependency-of-object-files
+++ a/arch/loongarch/kernel/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 obj-$(CONFIG_UNWINDER_GUESS)	+= unwind_guess.o
--- a/arch/m68k/kernel/Makefile~kexec_core-change-dependency-of-object-files
+++ a/arch/m68k/kernel/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_PCI) += pcibios.o
 
 obj-$(CONFIG_M68K_NONCOHERENT_DMA) += dma.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_BOOTINFO_PROC)	+= bootinfo_proc.o
 obj-$(CONFIG_UBOOT)		+= uboot.o
 
--- a/arch/mips/kernel/Makefile~kexec_core-change-dependency-of-object-files
+++ a/arch/mips/kernel/Makefile
@@ -90,7 +90,7 @@ obj-$(CONFIG_GPIO_TXX9)		+= gpio_txx9.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_EARLY_PRINTK_8250)	+= early_printk_8250.o
--- a/arch/sh/kernel/Makefile~kexec_core-change-dependency-of-object-files
+++ a/arch/sh/kernel/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SH_STANDARD_BIOS)	+= sh_bios.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_MODULES)		+= sh_ksyms_32.o module.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_IO_TRAPPED)	+= io_trapped.o
_

Patches currently in -mm which might be from bhe@redhat.com are

kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch
riscv-fix-vmallc_start-definition.patch
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

