From: akpm@linux-foundation.org
Subject: + mm-cleaning-per-architecture-mm-hook-header-files.patch added
 to -mm tree
Date: Thu, 09 Jul 2015 16:10:27 -0700
Message-ID: <559eff63.WqQU4gFni96BA9ih%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbGIXK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 19:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, Vineet.Gupta1@synopsys.com, geert@linux-m68k.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up per architecture MM hook header files
has been added to the -mm tree.  Its filename is
     mm-cleaning-per-architecture-mm-hook-header-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleaning-per-architecture-mm-hook-header-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleaning-per-architecture-mm-hook-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: clean up per architecture MM hook header files

Commit 2ae416b142b6 ("mm: new mm hook framework") introduced an empty
header file (mm-arch-hooks.h) for every architecture, even those which
doesn't need to define mm hooks.

As suggested by Geert Uytterhoeven, this could be cleaned through the use
of a generic header file included via each per architecture
asm/include/Kbuild file.

The PowerPC architecture is not impacted here since this architecture has
to defined the arch_remap MM hook.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/Kbuild               |    1 +
 arch/alpha/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/arc/include/asm/Kbuild                 |    1 +
 arch/arc/include/asm/mm-arch-hooks.h        |   15 ---------------
 arch/arm/include/asm/Kbuild                 |    1 +
 arch/arm/include/asm/mm-arch-hooks.h        |   15 ---------------
 arch/arm64/include/asm/Kbuild               |    1 +
 arch/arm64/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/avr32/include/asm/Kbuild               |    1 +
 arch/avr32/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/blackfin/include/asm/Kbuild            |    1 +
 arch/blackfin/include/asm/mm-arch-hooks.h   |   15 ---------------
 arch/c6x/include/asm/Kbuild                 |    1 +
 arch/c6x/include/asm/mm-arch-hooks.h        |   15 ---------------
 arch/cris/include/asm/Kbuild                |    1 +
 arch/cris/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/frv/include/asm/Kbuild                 |    1 +
 arch/frv/include/asm/mm-arch-hooks.h        |   15 ---------------
 arch/h8300/include/asm/Kbuild               |    1 +
 arch/hexagon/include/asm/Kbuild             |    1 +
 arch/hexagon/include/asm/mm-arch-hooks.h    |   15 ---------------
 arch/ia64/include/asm/Kbuild                |    1 +
 arch/ia64/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/m32r/include/asm/Kbuild                |    1 +
 arch/m32r/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/m68k/include/asm/Kbuild                |    1 +
 arch/m68k/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/metag/include/asm/Kbuild               |    1 +
 arch/metag/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/microblaze/include/asm/Kbuild          |    1 +
 arch/microblaze/include/asm/mm-arch-hooks.h |   15 ---------------
 arch/mips/include/asm/Kbuild                |    1 +
 arch/mips/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/mn10300/include/asm/Kbuild             |    1 +
 arch/mn10300/include/asm/mm-arch-hooks.h    |   15 ---------------
 arch/nios2/include/asm/Kbuild               |    1 +
 arch/nios2/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/openrisc/include/asm/Kbuild            |    1 +
 arch/openrisc/include/asm/mm-arch-hooks.h   |   15 ---------------
 arch/parisc/include/asm/Kbuild              |    1 +
 arch/parisc/include/asm/mm-arch-hooks.h     |   15 ---------------
 arch/s390/include/asm/Kbuild                |    1 +
 arch/s390/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/score/include/asm/Kbuild               |    1 +
 arch/score/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/sh/include/asm/Kbuild                  |    1 +
 arch/sh/include/asm/mm-arch-hooks.h         |   15 ---------------
 arch/sparc/include/asm/Kbuild               |    1 +
 arch/sparc/include/asm/mm-arch-hooks.h      |   15 ---------------
 arch/tile/include/asm/Kbuild                |    1 +
 arch/tile/include/asm/mm-arch-hooks.h       |   15 ---------------
 arch/um/include/asm/Kbuild                  |    1 +
 arch/um/include/asm/mm-arch-hooks.h         |   15 ---------------
 arch/unicore32/include/asm/Kbuild           |    1 +
 arch/unicore32/include/asm/mm-arch-hooks.h  |   15 ---------------
 arch/x86/include/asm/Kbuild                 |    1 +
 arch/x86/include/asm/mm-arch-hooks.h        |   15 ---------------
 arch/xtensa/include/asm/Kbuild              |    1 +
 arch/xtensa/include/asm/mm-arch-hooks.h     |   15 ---------------
 include/asm-generic/mm-arch-hooks.h         |   16 ++++++++++++++++
 60 files changed, 46 insertions(+), 435 deletions(-)

diff -puN arch/alpha/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/alpha/include/asm/Kbuild
--- a/arch/alpha/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/alpha/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += cputime.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
diff -puN arch/alpha/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/alpha/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ALPHA_MM_ARCH_HOOKS_H
-#define _ASM_ALPHA_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_ALPHA_MM_ARCH_HOOKS_H */
diff -puN arch/arc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/arc/include/asm/Kbuild
--- a/arch/arc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/arc/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff -puN arch/arc/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/arc/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ARC_MM_ARCH_HOOKS_H
-#define _ASM_ARC_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_ARC_MM_ARCH_HOOKS_H */
diff -puN arch/arm/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/arm/include/asm/Kbuild
--- a/arch/arm/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/arm/include/asm/Kbuild
@@ -13,6 +13,7 @@ generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
diff -puN arch/arm/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/arm/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ARM_MM_ARCH_HOOKS_H
-#define _ASM_ARM_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_ARM_MM_ARCH_HOOKS_H */
diff -puN arch/arm64/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/arm64/include/asm/Kbuild
--- a/arch/arm64/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/arm64/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += msi.h
diff -puN arch/arm64/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/arm64/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ARM64_MM_ARCH_HOOKS_H
-#define _ASM_ARM64_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_ARM64_MM_ARCH_HOOKS_H */
diff -puN arch/avr32/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/avr32/include/asm/Kbuild
--- a/arch/avr32/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/avr32/include/asm/Kbuild
@@ -12,6 +12,7 @@ generic-y += irq_work.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += preempt.h
diff -puN arch/avr32/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/avr32/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_AVR32_MM_ARCH_HOOKS_H
-#define _ASM_AVR32_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_AVR32_MM_ARCH_HOOKS_H */
diff -puN arch/blackfin/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/blackfin/include/asm/Kbuild
--- a/arch/blackfin/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/blackfin/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff -puN arch/blackfin/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/blackfin/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_BLACKFIN_MM_ARCH_HOOKS_H
-#define _ASM_BLACKFIN_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_BLACKFIN_MM_ARCH_HOOKS_H */
diff -puN arch/c6x/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/c6x/include/asm/Kbuild
--- a/arch/c6x/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/c6x/include/asm/Kbuild
@@ -26,6 +26,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += mmu.h
 generic-y += mmu_context.h
diff -puN arch/c6x/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/c6x/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_C6X_MM_ARCH_HOOKS_H
-#define _ASM_C6X_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_C6X_MM_ARCH_HOOKS_H */
diff -puN arch/cris/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/cris/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += module.h
 generic-y += percpu.h
 generic-y += preempt.h
diff -puN arch/cris/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/cris/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_CRIS_MM_ARCH_HOOKS_H
-#define _ASM_CRIS_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_CRIS_MM_ARCH_HOOKS_H */
diff -puN arch/frv/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/frv/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += cputime.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff -puN arch/frv/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/frv/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_FRV_MM_ARCH_HOOKS_H
-#define _ASM_FRV_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_FRV_MM_ARCH_HOOKS_H */
diff -puN arch/h8300/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/h8300/include/asm/Kbuild
--- a/arch/h8300/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/h8300/include/asm/Kbuild
@@ -33,6 +33,7 @@ generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += mmu.h
 generic-y += mmu_context.h
diff -puN arch/hexagon/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/hexagon/include/asm/Kbuild
--- a/arch/hexagon/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/hexagon/include/asm/Kbuild
@@ -28,6 +28,7 @@ generic-y += kmap_types.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += pci.h
diff -puN arch/hexagon/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/hexagon/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_HEXAGON_MM_ARCH_HOOKS_H
-#define _ASM_HEXAGON_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_HEXAGON_MM_ARCH_HOOKS_H */
diff -puN arch/ia64/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/ia64/include/asm/Kbuild
--- a/arch/ia64/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/ia64/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += exec.h
 generic-y += irq_work.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff -puN arch/ia64/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/ia64/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_IA64_MM_ARCH_HOOKS_H
-#define _ASM_IA64_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_IA64_MM_ARCH_HOOKS_H */
diff -puN arch/m32r/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/m32r/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += cputime.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += sections.h
diff -puN arch/m32r/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/m32r/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_M32R_MM_ARCH_HOOKS_H
-#define _ASM_M32R_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_M32R_MM_ARCH_HOOKS_H */
diff -puN arch/m68k/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/m68k/include/asm/Kbuild
--- a/arch/m68k/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/m68k/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
diff -puN arch/m68k/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/m68k/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_M68K_MM_ARCH_HOOKS_H
-#define _ASM_M68K_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_M68K_MM_ARCH_HOOKS_H */
diff -puN arch/metag/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/metag/include/asm/Kbuild
--- a/arch/metag/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/metag/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff -puN arch/metag/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/metag/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_METAG_MM_ARCH_HOOKS_H
-#define _ASM_METAG_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_METAG_MM_ARCH_HOOKS_H */
diff -puN arch/microblaze/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/microblaze/include/asm/Kbuild
--- a/arch/microblaze/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/microblaze/include/asm/Kbuild
@@ -6,6 +6,7 @@ generic-y += device.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += syscalls.h
 generic-y += trace_clock.h
diff -puN arch/microblaze/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/microblaze/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_MICROBLAZE_MM_ARCH_HOOKS_H
-#define _ASM_MICROBLAZE_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_MICROBLAZE_MM_ARCH_HOOKS_H */
diff -puN arch/mips/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/mips/include/asm/Kbuild
--- a/arch/mips/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/mips/include/asm/Kbuild
@@ -7,6 +7,7 @@ generic-y += emergency-restart.h
 generic-y += irq_work.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mutex.h
 generic-y += parport.h
 generic-y += percpu.h
diff -puN arch/mips/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/mips/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_MIPS_MM_ARCH_HOOKS_H
-#define _ASM_MIPS_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_MIPS_MM_ARCH_HOOKS_H */
diff -puN arch/mn10300/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/mn10300/include/asm/Kbuild
--- a/arch/mn10300/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/mn10300/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += cputime.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
diff -puN arch/mn10300/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/mn10300/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_MN10300_MM_ARCH_HOOKS_H
-#define _ASM_MN10300_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_MN10300_MM_ARCH_HOOKS_H */
diff -puN arch/nios2/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/nios2/include/asm/Kbuild
--- a/arch/nios2/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/nios2/include/asm/Kbuild
@@ -30,6 +30,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff -puN arch/nios2/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/nios2/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_NIOS2_MM_ARCH_HOOKS_H
-#define _ASM_NIOS2_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_NIOS2_MM_ARCH_HOOKS_H */
diff -puN arch/openrisc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/openrisc/include/asm/Kbuild
--- a/arch/openrisc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/openrisc/include/asm/Kbuild
@@ -36,6 +36,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff -puN arch/openrisc/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/openrisc/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_OPENRISC_MM_ARCH_HOOKS_H
-#define _ASM_OPENRISC_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_OPENRISC_MM_ARCH_HOOKS_H */
diff -puN arch/parisc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/parisc/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += percpu.h
diff -puN arch/parisc/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/parisc/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_PARISC_MM_ARCH_HOOKS_H
-#define _ASM_PARISC_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_PARISC_MM_ARCH_HOOKS_H */
diff -puN arch/s390/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/s390/include/asm/Kbuild
--- a/arch/s390/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/s390/include/asm/Kbuild
@@ -3,5 +3,6 @@
 generic-y += clkdev.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff -puN arch/s390/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/s390/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_S390_MM_ARCH_HOOKS_H
-#define _ASM_S390_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_S390_MM_ARCH_HOOKS_H */
diff -puN arch/score/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/score/include/asm/Kbuild
@@ -7,6 +7,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
diff -puN arch/score/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/score/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_SCORE_MM_ARCH_HOOKS_H
-#define _ASM_SCORE_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_SCORE_MM_ARCH_HOOKS_H */
diff -puN arch/sh/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/sh/include/asm/Kbuild
--- a/arch/sh/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/sh/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff -puN arch/sh/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/sh/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_SH_MM_ARCH_HOOKS_H
-#define _ASM_SH_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_SH_MM_ARCH_HOOKS_H */
diff -puN arch/sparc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/sparc/include/asm/Kbuild
--- a/arch/sparc/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/sparc/include/asm/Kbuild
@@ -12,6 +12,7 @@ generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += module.h
 generic-y += mutex.h
 generic-y += preempt.h
diff -puN arch/sparc/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/sparc/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_SPARC_MM_ARCH_HOOKS_H
-#define _ASM_SPARC_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_SPARC_MM_ARCH_HOOKS_H */
diff -puN arch/tile/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/tile/include/asm/Kbuild
--- a/arch/tile/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/tile/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff -puN arch/tile/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/tile/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_TILE_MM_ARCH_HOOKS_H
-#define _ASM_TILE_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_TILE_MM_ARCH_HOOKS_H */
diff -puN arch/um/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/um/include/asm/Kbuild
--- a/arch/um/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/um/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += pci.h
diff -puN arch/um/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/um/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_UM_MM_ARCH_HOOKS_H
-#define _ASM_UM_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_UM_MM_ARCH_HOOKS_H */
diff -puN arch/unicore32/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/unicore32/include/asm/Kbuild
--- a/arch/unicore32/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/unicore32/include/asm/Kbuild
@@ -26,6 +26,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff -puN arch/unicore32/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/unicore32/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_UNICORE32_MM_ARCH_HOOKS_H
-#define _ASM_UNICORE32_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_UNICORE32_MM_ARCH_HOOKS_H */
diff -puN arch/x86/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/x86/include/asm/Kbuild
--- a/arch/x86/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/x86/include/asm/Kbuild
@@ -9,3 +9,4 @@ generic-y += cputime.h
 generic-y += dma-contiguous.h
 generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
diff -puN arch/x86/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/x86/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_X86_MM_ARCH_HOOKS_H
-#define _ASM_X86_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_X86_MM_ARCH_HOOKS_H */
diff -puN arch/xtensa/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files arch/xtensa/include/asm/Kbuild
--- a/arch/xtensa/include/asm/Kbuild~mm-cleaning-per-architecture-mm-hook-header-files
+++ a/arch/xtensa/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += mm-arch-hooks.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += resource.h
diff -puN arch/xtensa/include/asm/mm-arch-hooks.h~mm-cleaning-per-architecture-mm-hook-header-files /dev/null
--- a/arch/xtensa/include/asm/mm-arch-hooks.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Architecture specific mm hooks
- *
- * Copyright (C) 2015, IBM Corporation
- * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_XTENSA_MM_ARCH_HOOKS_H
-#define _ASM_XTENSA_MM_ARCH_HOOKS_H
-
-#endif /* _ASM_XTENSA_MM_ARCH_HOOKS_H */
diff -puN /dev/null include/asm-generic/mm-arch-hooks.h
--- /dev/null
+++ a/include/asm-generic/mm-arch-hooks.h
@@ -0,0 +1,16 @@
+/*
+ * Architecture specific mm hooks
+ */
+
+#ifndef _ASM_GENERIC_MM_ARCH_HOOKS_H
+#define _ASM_GENERIC_MM_ARCH_HOOKS_H
+
+/*
+ * This file should be included through arch/../include/asm/Kbuild for
+ * the architecture which doesn't need specific mm hooks.
+ *
+ * In that case, the generic hooks defined in include/linux/mm-arch-hooks.h
+ * are used.
+ */
+
+#endif /* _ASM_GENERIC_MM_ARCH_HOOKS_H */
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-cleaning-per-architecture-mm-hook-header-files.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch

