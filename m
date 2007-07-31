From: akpm@linux-foundation.org
Subject: + changing-include-asm-generic-pgtableh-for-non-mmu.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:19:31 -0700
Message-ID: <200707310119.l6V1JVaC008097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbXGaBTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, dhowells@redhat.com


The patch titled
     changing include/asm-generic/pgtable.h for non-mmu
has been added to the -mm tree.  Its filename is
     changing-include-asm-generic-pgtableh-for-non-mmu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: changing include/asm-generic/pgtable.h for non-mmu
From: Greg Ungerer <gerg@snapgear.com>

There are some parts of include/asm-generic/pgtable.h that are relevant to
the non-mmu architectures.  To make it easier to include this from them I
would like to ifdef the relevant parts.

Without this there is a handful of functions that are referenced in here
that are not defined on many non-mmu architectures.  They could be defined
out of course, as an alternative approach.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   73 ++++++++++++++++----------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff -puN include/asm-generic/pgtable.h~changing-include-asm-generic-pgtableh-for-non-mmu include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~changing-include-asm-generic-pgtableh-for-non-mmu
+++ a/include/asm-generic/pgtable.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_PGTABLE_H
 
 #ifndef __ASSEMBLY__
+#ifdef CONFIG_MMU
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
@@ -133,41 +134,6 @@ static inline void ptep_set_wrprotect(st
 #endif
 
 /*
- * A facility to provide lazy MMU batching.  This allows PTE updates and
- * page invalidations to be delayed until a call to leave lazy MMU mode
- * is issued.  Some architectures may benefit from doing this, and it is
- * beneficial for both shadow and direct mode hypervisors, which may batch
- * the PTE updates which happen during this window.  Note that using this
- * interface requires that read hazards be removed from the code.  A read
- * hazard could result in the direct mode hypervisor case, since the actual
- * write to the page tables may not yet have taken place, so reads though
- * a raw PTE pointer after it has been modified are not guaranteed to be
- * up to date.  This mode can only be entered and left under the protection of
- * the page table locks for all page tables which may be modified.  In the UP
- * case, this is required so that preemption is disabled, and in the SMP case,
- * it must synchronize the delayed page table writes properly on other CPUs.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
-#endif
-
-/*
- * A facility to provide batching of the reload of page tables with the
- * actual context switch code for paravirtualized guests.  By convention,
- * only one of the lazy modes (CPU, MMU) should be active at any given
- * time, entry should never be nested, and entry and exits should always
- * be paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
-#define arch_flush_lazy_cpu_mode()	do {} while (0)
-#endif
-
-/*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
  * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
@@ -233,6 +199,43 @@ static inline int pmd_none_or_clear_bad(
 	}
 	return 0;
 }
+#endif /* CONFIG_MMU */
+
+/*
+ * A facility to provide lazy MMU batching.  This allows PTE updates and
+ * page invalidations to be delayed until a call to leave lazy MMU mode
+ * is issued.  Some architectures may benefit from doing this, and it is
+ * beneficial for both shadow and direct mode hypervisors, which may batch
+ * the PTE updates which happen during this window.  Note that using this
+ * interface requires that read hazards be removed from the code.  A read
+ * hazard could result in the direct mode hypervisor case, since the actual
+ * write to the page tables may not yet have taken place, so reads though
+ * a raw PTE pointer after it has been modified are not guaranteed to be
+ * up to date.  This mode can only be entered and left under the protection of
+ * the page table locks for all page tables which may be modified.  In the UP
+ * case, this is required so that preemption is disabled, and in the SMP case,
+ * it must synchronize the delayed page table writes properly on other CPUs.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
+#endif
+
+/*
+ * A facility to provide batching of the reload of page tables with the
+ * actual context switch code for paravirtualized guests.  By convention,
+ * only one of the lazy modes (CPU, MMU) should be active at any given
+ * time, entry should never be nested, and entry and exits should always
+ * be paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+#define arch_flush_lazy_cpu_mode()	do {} while (0)
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
changing-include-asm-generic-pgtableh-for-non-mmu.patch
git-mtd.patch
