From: akpm@linux-foundation.org
Subject: [merged] avr32-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:45 -0800
Message-ID: <200912152159.nBFLxjnk015930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933880AbZLOWAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     avr32-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: avr32: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/hardirq.h |   19 +------------------
 arch/avr32/kernel/irq.c          |    9 ---------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff -puN arch/avr32/include/asm/hardirq.h~avr32-convert-to-asm-generic-hardirqh arch/avr32/include/asm/hardirq.h
--- a/arch/avr32/include/asm/hardirq.h~avr32-convert-to-asm-generic-hardirqh
+++ a/arch/avr32/include/asm/hardirq.h
@@ -1,23 +1,6 @@
 #ifndef __ASM_AVR32_HARDIRQ_H
 #define __ASM_AVR32_HARDIRQ_H
-
-#include <linux/threads.h>
-#include <asm/irq.h>
-
 #ifndef __ASSEMBLY__
-
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-void ack_bad_irq(unsigned int irq);
-
-/* Standard mappings for irq_cpustat_t above */
-#include <linux/irq_cpustat.h>
-
+#include <asm-generic/hardirq.h>
 #endif /* __ASSEMBLY__ */
-
 #endif /* __ASM_AVR32_HARDIRQ_H */
diff -puN arch/avr32/kernel/irq.c~avr32-convert-to-asm-generic-hardirqh arch/avr32/kernel/irq.c
--- a/arch/avr32/kernel/irq.c~avr32-convert-to-asm-generic-hardirqh
+++ a/arch/avr32/kernel/irq.c
@@ -16,15 +16,6 @@
 #include <linux/seq_file.h>
 #include <linux/sysdev.h>
 
-/*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ %u\n", irq);
-}
