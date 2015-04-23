From: akpm@linux-foundation.org
Subject: + mm-new-mm-hook-framework.patch added to -mm tree
Date: Thu, 23 Apr 2015 15:29:08 -0700
Message-ID: <55397234.V6uW6NfCFVDaYeop%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381AbbDWW3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, akpm@linux-foundation.org, benh@kernel.crashing.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mingo@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: new mm hook framework
has been added to the -mm tree.  Its filename is
     mm-new-mm-hook-framework.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-new-mm-hook-framework.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-new-mm-hook-framework.patch

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
Subject: mm: new mm hook framework

CRIU is recreating the process memory layout by remapping the checkpointee
memory area on top of the current process (criu).  This includes remapping
the vDSO to the place it has at checkpoint time.

However some architectures like powerpc are keeping a reference to the
vDSO base address to build the signal return stack frame by calling the
vDSO sigreturn service.  So once the vDSO has been moved, this reference
is no more valid and the signal frame built later are not usable.

This patch serie is introducing a new mm hook framework, and a new
arch_remap hook which is called when mremap is done and the mm lock still
hold.  The next patch is adding the vDSO remap and unmap tracking to the
powerpc architecture.



This patch (of 3):

This patch introduces a new set of header file to manage mm hooks:
- per architecture empty header file (arch/x/include/asm/mm-arch-hooks.h)
- a generic header (include/linux/mm-arch-hooks.h)

The architecture which need to overwrite a hook as to redefine it in its
header file, while architecture which doesn't need have nothing to do.

The default hooks are defined in the generic header and are used in the
case the architecture is not defining it.

In a next step, mm hooks defined in include/asm-generic/mm_hooks.h should
be moved here.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/arc/include/asm/mm-arch-hooks.h        |   15 +++++++++++++++
 arch/arm/include/asm/mm-arch-hooks.h        |   15 +++++++++++++++
 arch/arm64/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/avr32/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/blackfin/include/asm/mm-arch-hooks.h   |   15 +++++++++++++++
 arch/c6x/include/asm/mm-arch-hooks.h        |   15 +++++++++++++++
 arch/cris/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/frv/include/asm/mm-arch-hooks.h        |   15 +++++++++++++++
 arch/hexagon/include/asm/mm-arch-hooks.h    |   15 +++++++++++++++
 arch/ia64/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/m32r/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/m68k/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/metag/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/microblaze/include/asm/mm-arch-hooks.h |   15 +++++++++++++++
 arch/mips/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/mn10300/include/asm/mm-arch-hooks.h    |   15 +++++++++++++++
 arch/nios2/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/openrisc/include/asm/mm-arch-hooks.h   |   15 +++++++++++++++
 arch/parisc/include/asm/mm-arch-hooks.h     |   15 +++++++++++++++
 arch/powerpc/include/asm/mm-arch-hooks.h    |   15 +++++++++++++++
 arch/s390/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/score/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/sh/include/asm/mm-arch-hooks.h         |   15 +++++++++++++++
 arch/sparc/include/asm/mm-arch-hooks.h      |   15 +++++++++++++++
 arch/tile/include/asm/mm-arch-hooks.h       |   15 +++++++++++++++
 arch/um/include/asm/mm-arch-hooks.h         |   15 +++++++++++++++
 arch/unicore32/include/asm/mm-arch-hooks.h  |   15 +++++++++++++++
 arch/x86/include/asm/mm-arch-hooks.h        |   15 +++++++++++++++
 arch/xtensa/include/asm/mm-arch-hooks.h     |   15 +++++++++++++++
 include/linux/mm-arch-hooks.h               |   16 ++++++++++++++++
 31 files changed, 466 insertions(+)

diff -puN /dev/null arch/alpha/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/alpha/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ALPHA_MM_ARCH_HOOKS_H
+#define _ASM_ALPHA_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_ALPHA_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/arc/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/arc/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_MM_ARCH_HOOKS_H
+#define _ASM_ARC_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_ARC_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/arm/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/arm/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARM_MM_ARCH_HOOKS_H
+#define _ASM_ARM_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_ARM_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/arm64/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/arm64/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARM64_MM_ARCH_HOOKS_H
+#define _ASM_ARM64_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_ARM64_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/avr32/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/avr32/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_AVR32_MM_ARCH_HOOKS_H
+#define _ASM_AVR32_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_AVR32_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/blackfin/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/blackfin/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_BLACKFIN_MM_ARCH_HOOKS_H
+#define _ASM_BLACKFIN_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_BLACKFIN_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/c6x/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/c6x/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_C6X_MM_ARCH_HOOKS_H
+#define _ASM_C6X_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_C6X_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/cris/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/cris/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_CRIS_MM_ARCH_HOOKS_H
+#define _ASM_CRIS_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_CRIS_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/frv/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/frv/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_FRV_MM_ARCH_HOOKS_H
+#define _ASM_FRV_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_FRV_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/hexagon/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/hexagon/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_HEXAGON_MM_ARCH_HOOKS_H
+#define _ASM_HEXAGON_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_HEXAGON_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/ia64/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/ia64/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_IA64_MM_ARCH_HOOKS_H
+#define _ASM_IA64_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_IA64_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/m32r/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/m32r/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_M32R_MM_ARCH_HOOKS_H
+#define _ASM_M32R_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_M32R_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/m68k/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/m68k/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_M68K_MM_ARCH_HOOKS_H
+#define _ASM_M68K_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_M68K_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/metag/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/metag/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_METAG_MM_ARCH_HOOKS_H
+#define _ASM_METAG_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_METAG_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/microblaze/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/microblaze/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_MICROBLAZE_MM_ARCH_HOOKS_H
+#define _ASM_MICROBLAZE_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_MICROBLAZE_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/mips/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/mips/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_MIPS_MM_ARCH_HOOKS_H
+#define _ASM_MIPS_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_MIPS_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/mn10300/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/mn10300/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_MN10300_MM_ARCH_HOOKS_H
+#define _ASM_MN10300_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_MN10300_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/nios2/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/nios2/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_NIOS2_MM_ARCH_HOOKS_H
+#define _ASM_NIOS2_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_NIOS2_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/openrisc/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/openrisc/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_OPENRISC_MM_ARCH_HOOKS_H
+#define _ASM_OPENRISC_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_OPENRISC_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/parisc/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/parisc/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_PARISC_MM_ARCH_HOOKS_H
+#define _ASM_PARISC_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_PARISC_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/powerpc/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/powerpc/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_POWERPC_MM_ARCH_HOOKS_H
+#define _ASM_POWERPC_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_POWERPC_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/s390/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/s390/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_S390_MM_ARCH_HOOKS_H
+#define _ASM_S390_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_S390_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/score/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/score/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_SCORE_MM_ARCH_HOOKS_H
+#define _ASM_SCORE_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_SCORE_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/sh/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/sh/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_SH_MM_ARCH_HOOKS_H
+#define _ASM_SH_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_SH_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/sparc/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/sparc/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_SPARC_MM_ARCH_HOOKS_H
+#define _ASM_SPARC_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_SPARC_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/tile/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/tile/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_TILE_MM_ARCH_HOOKS_H
+#define _ASM_TILE_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_TILE_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/um/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/um/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_UM_MM_ARCH_HOOKS_H
+#define _ASM_UM_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_UM_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/unicore32/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/unicore32/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_UNICORE32_MM_ARCH_HOOKS_H
+#define _ASM_UNICORE32_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_UNICORE32_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/x86/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/x86/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_X86_MM_ARCH_HOOKS_H
+#define _ASM_X86_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_X86_MM_ARCH_HOOKS_H */
diff -puN /dev/null arch/xtensa/include/asm/mm-arch-hooks.h
--- /dev/null
+++ a/arch/xtensa/include/asm/mm-arch-hooks.h
@@ -0,0 +1,15 @@
+/*
+ * Architecture specific mm hooks
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_XTENSA_MM_ARCH_HOOKS_H
+#define _ASM_XTENSA_MM_ARCH_HOOKS_H
+
+#endif /* _ASM_XTENSA_MM_ARCH_HOOKS_H */
diff -puN /dev/null include/linux/mm-arch-hooks.h
--- /dev/null
+++ a/include/linux/mm-arch-hooks.h
@@ -0,0 +1,16 @@
+/*
+ * Generic mm no-op hooks.
+ *
+ * Copyright (C) 2015, IBM Corporation
+ * Author: Laurent Dufour <ldufour@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_MM_ARCH_HOOKS_H
+#define _LINUX_MM_ARCH_HOOKS_H
+
+#include <asm/mm-arch-hooks.h>
+
+#endif /* _LINUX_MM_ARCH_HOOKS_H */
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch

