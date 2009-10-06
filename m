From: akpm@linux-foundation.org
Subject: [merged] sparc32-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Tue, 06 Oct 2009 13:23:04 -0700
Message-ID: <200910062023.n96KN4EU017871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088AbZJFUY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sparc32: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     sparc32-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc32: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

[akpm@linux-foundation.org: /arch/sparc/include/asm/irq_32.h: move NR_IRQS definition]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/hardirq_32.h |   12 +-----------
 arch/sparc/include/asm/irq_32.h     |    4 ++--
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN arch/sparc/include/asm/hardirq_32.h~sparc32-convert-to-asm-generic-hardirqh arch/sparc/include/asm/hardirq_32.h
--- a/arch/sparc/include/asm/hardirq_32.h~sparc32-convert-to-asm-generic-hardirqh
+++ a/arch/sparc/include/asm/hardirq_32.h
@@ -7,17 +7,7 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/spinlock.h>
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */ /* XXX P3 Is it? */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS    8
+#include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
diff -puN arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh arch/sparc/include/asm/irq_32.h
--- a/arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh
+++ a/arch/sparc/include/asm/irq_32.h
@@ -6,10 +6,10 @@
 #ifndef _SPARC_IRQ_H
 #define _SPARC_IRQ_H
 
-#include <linux/interrupt.h>
