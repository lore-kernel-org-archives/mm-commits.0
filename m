From: akpm@linux-foundation.org
Subject: + kmap-types-clean-up-and-optimization.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:48:37 -0800
Message-ID: <201012222248.oBMMmbcF023808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab0LVWtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, a.p.zijlstra@chello.nl, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kmap-types: clean up and optimization
has been added to the -mm tree.  Its filename is
     kmap-types-clean-up-and-optimization.patch

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
Subject: kmap-types: clean up and optimization
From: "Jan Beulich" <JBeulich@novell.com>

Several of the types aren't being used at all anymore - those can be
deleted altogether.  Others are used only by single components that can be
assumed to be enabled everywhere, so those are made dependent upon
CONFIG_* settings.  Since this somewhat conflicts with the sequential gap
markers used under __WITH_KM_FENCE, and since this can be simplified
anyway, fold the enumerator definitions with the (modified accordingly)
KMAP_D() macro always.

The whole point of the reduction is that, at least on ix86, the number of
kmap types can (depending on configuration) affect the amount of low
memory, and thus unused types should be avoided if possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kmap_types.h     |    6 --
 arch/powerpc/include/asm/kmap_types.h |   11 ----
 arch/tile/include/asm/kmap_types.h    |    5 --
 include/asm-generic/kmap_types.h      |   53 +++++++++++-------------
 4 files changed, 26 insertions(+), 49 deletions(-)

diff -puN arch/arm/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization arch/arm/include/asm/kmap_types.h
--- a/arch/arm/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization
+++ a/arch/arm/include/asm/kmap_types.h
@@ -24,10 +24,4 @@ enum km_type {
 	KM_TYPE_NR
 };
 
-#ifdef CONFIG_DEBUG_HIGHMEM
-#define KM_NMI		(-1)
-#define KM_NMI_PTE	(-1)
-#define KM_IRQ_PTE	(-1)
-#endif
-
 #endif
diff -puN arch/powerpc/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization arch/powerpc/include/asm/kmap_types.h
--- a/arch/powerpc/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization
+++ a/arch/powerpc/include/asm/kmap_types.h
@@ -30,16 +30,5 @@ enum km_type {
 	KM_TYPE_NR
 };
 
-/*
- * This is a temporary build fix that (so they say on lkml....) should no longer
- * be required after 2.6.33, because of changes planned to the kmap code.
- * Let's try to remove this cruft then.
- */
-#ifdef CONFIG_DEBUG_HIGHMEM
-#define KM_NMI		(-1)
-#define KM_NMI_PTE	(-1)
-#define KM_IRQ_PTE	(-1)
-#endif
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_KMAP_TYPES_H */
diff -puN arch/tile/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization arch/tile/include/asm/kmap_types.h
--- a/arch/tile/include/asm/kmap_types.h~kmap-types-clean-up-and-optimization
+++ a/arch/tile/include/asm/kmap_types.h
@@ -45,12 +45,7 @@ enum {
 	KM_IRQ1,
 	KM_SOFTIRQ0,
 	KM_SOFTIRQ1,
-	KM_SYNC_ICACHE,
-	KM_SYNC_DCACHE,
 	KM_UML_USERCOPY,
-	KM_IRQ_PTE,
-	KM_NMI,
-	KM_NMI_PTE,
 	KM_KDB
 };
 
diff -puN include/asm-generic/kmap_types.h~kmap-types-clean-up-and-optimization include/asm-generic/kmap_types.h
--- a/include/asm-generic/kmap_types.h~kmap-types-clean-up-and-optimization
+++ a/include/asm-generic/kmap_types.h
@@ -2,37 +2,36 @@
 #define _ASM_GENERIC_KMAP_TYPES_H
 
 #ifdef __WITH_KM_FENCE
-# define KMAP_D(n) __KM_FENCE_##n ,
+# define KMAP_D(n) __KM_FENCE_##n, KM_##n
 #else
-# define KMAP_D(n)
+# define KMAP_D(n) KM_##n
 #endif
 
 enum km_type {
-KMAP_D(0)	KM_BOUNCE_READ,
-KMAP_D(1)	KM_SKB_SUNRPC_DATA,
-KMAP_D(2)	KM_SKB_DATA_SOFTIRQ,
-KMAP_D(3)	KM_USER0,
-KMAP_D(4)	KM_USER1,
-KMAP_D(5)	KM_BIO_SRC_IRQ,
-KMAP_D(6)	KM_BIO_DST_IRQ,
-KMAP_D(7)	KM_PTE0,
-KMAP_D(8)	KM_PTE1,
-KMAP_D(9)	KM_IRQ0,
-KMAP_D(10)	KM_IRQ1,
-KMAP_D(11)	KM_SOFTIRQ0,
-KMAP_D(12)	KM_SOFTIRQ1,
-KMAP_D(13)	KM_SYNC_ICACHE,
-KMAP_D(14)	KM_SYNC_DCACHE,
-/* UML specific, for copy_*_user - used in do_op_one_page */
-KMAP_D(15)	KM_UML_USERCOPY,
-KMAP_D(16)	KM_IRQ_PTE,
-KMAP_D(17)	KM_NMI,
-KMAP_D(18)	KM_NMI_PTE,
-KMAP_D(19)	KM_KDB,
-/*
- * Remember to update debug_kmap_atomic() when adding new kmap types!
- */
-KMAP_D(20)	KM_TYPE_NR
+	KMAP_D(BOUNCE_READ),
+#if defined(CONFIG_SUNRPC) || defined(CONFIG_SUNRPC_MODULE)
+	KMAP_D(SKB_SUNRPC_DATA),
+#endif
+	KMAP_D(SKB_DATA_SOFTIRQ),
+	KMAP_D(USER0),
+	KMAP_D(USER1),
+	KMAP_D(BIO_SRC_IRQ),
+	KMAP_D(BIO_DST_IRQ),
+#if defined(CONFIG_X86) && defined(CONFIG_CRASH_DUMP)
+	KMAP_D(PTE0),
+#endif
+	KMAP_D(IRQ0),
+	KMAP_D(IRQ1),
+	KMAP_D(SOFTIRQ0),
+	KMAP_D(SOFTIRQ1),
+#ifdef CONFIG_UML /* for copy_*_user - used in do_op_one_page */
+	KMAP_D(UML_USERCOPY),
+#endif
+#ifdef CONFIG_KGDB_KDB
+	KMAP_D(KDB),
+#endif
+
+	KMAP_D(TYPE_NR)
 };
 
 #undef KMAP_D
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
kmap-types-clean-up-and-optimization.patch

