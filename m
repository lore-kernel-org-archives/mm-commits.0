Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A605C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  1 Dec 2023 18:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjLASJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Dec 2023 13:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjLASJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Dec 2023 13:09:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3286106
        for <mm-commits@vger.kernel.org>; Fri,  1 Dec 2023 10:09:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3B4C433C8;
        Fri,  1 Dec 2023 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701454184;
        bh=YMvFpLlYmYeG43wUvVivFS24ZsRNQuyoZOw00nOQmPo=;
        h=Date:To:From:Subject:From;
        b=fsYf/3WT7bvgRPGlHMDk6QZf71n65fx7Hv92Hp9mrKbdFnOuZyGct1RDqw8r8n4vx
         W7xn0aMOyPmuqO9EzzV2FtJrSsUX8JXWuKIKZKR+BbTacuZ+39N6IIKcVuMEAkrcxw
         DSobMC1MRM76FpSLoeSd6JUy428a+oyYkf3zwGLY=
Date:   Fri, 01 Dec 2023 10:09:43 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, eric_devolder@yahoo.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-change-dependency-of-object-files.patch added to mm-hotfixes-unstable branch
Message-Id: <20231201180944.7F3B4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_core: change dependency of object files
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec_core-change-dependency-of-object-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-change-dependency-of-object-files.patch

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

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
kexec_core-change-dependency-of-object-files.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch

