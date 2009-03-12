From: akpm@linux-foundation.org
Subject: + introduce-debug_kmap_atomic.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:31:51 -0700
Message-ID: <200903122231.n2CMVqh0012276__40164.6934020848$1236897393$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbZCLWey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de


The patch titled
     mm: introduce debug_kmap_atomic
has been added to the -mm tree.  Its filename is
     introduce-debug_kmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce debug_kmap_atomic
From: Akinobu Mita <akinobu.mita@gmail.com>

x86 has debug_kmap_atomic_prot() which is error checking function for
kmap_atomic.  It is usefull for the other architectures, although it needs
CONFIG_TRACE_IRQFLAGS_SUPPORT.

This patch exposes it to the other architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |   45 -------------------------------------
 include/linux/highmem.h  |   12 +++++++++
 mm/highmem.c             |   45 +++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 44 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~introduce-debug_kmap_atomic arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~introduce-debug_kmap_atomic
+++ a/arch/x86/mm/highmem_32.c
@@ -19,49 +19,6 @@ void kunmap(struct page *page)
 	kunmap_high(page);
 }
 
-static void debug_kmap_atomic_prot(enum km_type type)
-{
-#ifdef CONFIG_DEBUG_HIGHMEM
-	static unsigned warn_count = 10;
-
-	if (unlikely(warn_count == 0))
-		return;
-
-	if (unlikely(in_interrupt())) {
-		if (in_irq()) {
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		} else if (!irqs_disabled()) {	/* softirq */
-			if (type != KM_IRQ0 && type != KM_IRQ1 &&
-			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
-			    type != KM_SKB_SUNRPC_DATA &&
-			    type != KM_SKB_DATA_SOFTIRQ &&
-			    type != KM_BOUNCE_READ) {
-				WARN_ON(1);
-				warn_count--;
-			}
-		}
-	}
-
-	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
-			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
-		if (!irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
-		if (irq_count() == 0 && !irqs_disabled()) {
-			WARN_ON(1);
-			warn_count--;
-		}
-	}
-#endif
-}
-
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
@@ -81,7 +38,7 @@ void *kmap_atomic_prot(struct page *page
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	debug_kmap_atomic_prot(type);
+	debug_kmap_atomic(type);
 
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
diff -puN include/linux/highmem.h~introduce-debug_kmap_atomic include/linux/highmem.h
--- a/include/linux/highmem.h~introduce-debug_kmap_atomic
+++ a/include/linux/highmem.h
@@ -187,4 +187,16 @@ static inline void copy_highpage(struct 
 	kunmap_atomic(vto, KM_USER1);
 }
 
+#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+
+void debug_kmap_atomic(enum km_type type);
+
+#else
+
+static inline void debug_kmap_atomic(enum km_type type)
+{
+}
+
+#endif
+
 #endif /* _LINUX_HIGHMEM_H */
diff -puN mm/highmem.c~introduce-debug_kmap_atomic mm/highmem.c
--- a/mm/highmem.c~introduce-debug_kmap_atomic
+++ a/mm/highmem.c
@@ -373,3 +373,48 @@ void __init page_address_init(void)
 }
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
+
+#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+
+void debug_kmap_atomic(enum km_type type)
+{
+	static unsigned warn_count = 10;
+
+	if (unlikely(warn_count == 0))
+		return;
+
+	if (unlikely(in_interrupt())) {
+		if (in_irq()) {
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_BIO_SRC_IRQ && type != KM_BIO_DST_IRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		} else if (!irqs_disabled()) {	/* softirq */
+			if (type != KM_IRQ0 && type != KM_IRQ1 &&
+			    type != KM_SOFTIRQ0 && type != KM_SOFTIRQ1 &&
+			    type != KM_SKB_SUNRPC_DATA &&
+			    type != KM_SKB_DATA_SOFTIRQ &&
+			    type != KM_BOUNCE_READ) {
+				WARN_ON(1);
+				warn_count--;
+			}
+		}
+	}
+
+	if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
+			type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
+		if (!irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	} else if (type == KM_SOFTIRQ0 || type == KM_SOFTIRQ1) {
+		if (irq_count() == 0 && !irqs_disabled()) {
+			WARN_ON(1);
+			warn_count--;
+		}
+	}
+}
+
+#endif
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-depend-on-config_debug_kernel.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
loop-add-ioctl-to-resize-a-loop-device.patch

