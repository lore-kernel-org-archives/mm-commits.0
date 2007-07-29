From: akpm@linux-foundation.org
Subject: - include-asm-mips-add-missing-edac-h-file.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:21 -0700
Message-ID: <200707290612.l6T6CLIm011118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759070AbXG2GXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.h, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     include/asm-:mips add missing edac h file
has been removed from the -mm tree.  Its filename was
     include-asm-mips-add-missing-edac-h-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/asm-:mips add missing edac h file
From: Doug Thompson <dougthompson@xmission.h>

EDAC has a foundation to perform software memory scrubbing, but it requires a
per architecture (atomic_scrub) function for performing an atomic update
operation.  Under X86, this is done with a

lock:  add  [addr],0

in the file asm-x86/edac.h

This patch provides the MIPS arch with that atomic function, atomic_scrub() in

asm-mips/edac.h

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/edac.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN /dev/null include/asm-mips/edac.h
--- /dev/null
+++ a/include/asm-mips/edac.h
@@ -0,0 +1,35 @@
+#ifndef ASM_EDAC_H
+#define ASM_EDAC_H
+
+/* ECC atomic, DMA, SMP and interrupt safe scrub function */
+
+static inline void atomic_scrub(void *va, u32 size)
+{
+	unsigned long *virt_addr = va;
+	unsigned long temp;
+	u32 i;
+
+	for (i = 0; i < size / sizeof(unsigned long); i++, virt_addr++) {
+
+		/*
+		 * Very carefully read and write to memory atomically
+		 * so we are interrupt, DMA and SMP safe.
+		 *
+		 * Intel: asm("lock; addl $0, %0"::"m"(*virt_addr));
+		 */
+
+		__asm__ __volatile__ (
+		"       .set    mips3                                   \n"
+		"1:     ll      %0, %1          # atomic_add            \n"
+		"       ll      %0, %1          # atomic_add            \n"
+		"       addu    %0, $0                                  \n"
+		"       sc      %0, %1                                  \n"
+		"       beqz    %0, 1b                                  \n"
+		"       .set    mips0                                   \n"
+		: "=&r" (temp), "=m" (*virt_addr)
+		: "m" (*virt_addr));
+
+	}
+}
+
+#endif
_

Patches currently in -mm which might be from dougthompson@xmission.h are

origin.patch
