From: akpm@linux-foundation.org
Subject: + crisv32-add-cache-flush-operations.patch added to -mm tree
Date: Fri, 09 Nov 2007 19:57:00 -0800
Message-ID: <200711100357.lAA3v00X017605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757641AbXKJD5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 22:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com


The patch titled
     CRISv32: add cache flush operations
has been added to the -mm tree.  Its filename is
     crisv32-add-cache-flush-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRISv32: add cache flush operations
From: Jesper Nilsson <jesper.nilsson@axis.com>

These are needed due to a cache bug, and can be used to make sure that the
DMA descriptors are flushed to memory and can be safely handled by DMA.

flush_dma_descr - Flush one DMA descriptor.
flush_dma_list - Flush a complete list of DMA descriptors.
cris_flush_cache - Flush the complete cache.
cris_flush_cache_range - Flush only the specified range

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/kernel/cache.c      |   33 ++++++++
 arch/cris/arch-v32/kernel/cacheflush.S |   94 +++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff -puN /dev/null arch/cris/arch-v32/kernel/cache.c
--- /dev/null
+++ a/arch/cris/arch-v32/kernel/cache.c
@@ -0,0 +1,33 @@
+#include <linux/module.h>
+#include <asm/io.h>
+#include <asm/arch/cache.h>
+#include <asm/arch/hwregs/dma.h>
+
+/* This file is used to workaround a cache bug, Guinness TR 106. */
+
+inline void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
+{
+	/* Flush descriptor to make sure we get correct in_eop and after. */
+	asm volatile ("ftagd [%0]" :: "r" (descr));
+	/* Flush buffer pointed out by descriptor. */
+	if (flush_buf)
+		cris_flush_cache_range(phys_to_virt((unsigned)descr->buf),
+				(unsigned)(descr->after - descr->buf));
+}
+EXPORT_SYMBOL(flush_dma_descr);
+
+void flush_dma_list(struct dma_descr_data *descr)
+{
+	while (1) {
+		flush_dma_descr(descr, 1);
+		if (descr->eol)
+			break;
+		descr = phys_to_virt((unsigned)descr->next);
+	}
+}
+EXPORT_SYMBOL(flush_dma_list);
+
+/* From cacheflush.S */
+EXPORT_SYMBOL(cris_flush_cache);
+/* From cacheflush.S */
+EXPORT_SYMBOL(cris_flush_cache_range);
diff -puN /dev/null arch/cris/arch-v32/kernel/cacheflush.S
--- /dev/null
+++ a/arch/cris/arch-v32/kernel/cacheflush.S
@@ -0,0 +1,94 @@
+	.global cris_flush_cache_range
+cris_flush_cache_range:
+	move.d 1024, $r12
+	cmp.d $r11, $r12
+	bhi cris_flush_1KB
+	nop
+	add.d $r10, $r11
+	ftagd [$r10]
+cris_flush_last:
+	addq 32, $r10
+	cmp.d $r11, $r10
+	blt cris_flush_last
+	ftagd [$r10]
+	ret
+	nop
+cris_flush_1KB:
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ba cris_flush_cache_range
+	sub.d $r12, $r11
+
+	.global cris_flush_cache
+cris_flush_cache:
+	moveq 0, $r10
+cris_flush_line:
+	move.d 16*1024, $r11
+	addq 16, $r10
+	cmp.d $r10, $r11
+	blt cris_flush_line
+	fidxd [$r10]
+	ret
+	nop
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

git-mtd.patch
cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
crisv32-add-cache-flush-operations.patch
