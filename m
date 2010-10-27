From: akpm@linux-foundation.org
Subject: + mmx86-fix-kmap_atomic_push-vs-ioremap_32c.patch added to -mm tree
Date: Wed, 27 Oct 2010 10:20:15 -0700
Message-ID: <201010271720.o9RHKg3f005011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0J0RVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 13:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, chris@chris-wilson.co.uk


The patch titled
     mm,x86: fix kmap_atomic_push vs ioremap_32.c
has been added to the -mm tree.  Its filename is
     mmx86-fix-kmap_atomic_push-vs-ioremap_32c.patch

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
Subject: mm,x86: fix kmap_atomic_push vs ioremap_32.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

It appears i386 uses kmap_atomic infrastructure regardless of
CONFIG_HIGHMEM which results in a compile error when highmem is disabled.

Cure this by providing the needed few bits for both CONFIG_HIGHMEM and
CONFIG_X86_32.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   46 ++++++++++++++++++++------------------
 mm/highmem.c            |    6 ++++
 2 files changed, 30 insertions(+), 22 deletions(-)

diff -puN include/linux/highmem.h~mmx86-fix-kmap_atomic_push-vs-ioremap_32c include/linux/highmem.h
--- a/include/linux/highmem.h~mmx86-fix-kmap_atomic_push-vs-ioremap_32c
+++ a/include/linux/highmem.h
@@ -37,27 +37,6 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
-DECLARE_PER_CPU(int, __kmap_atomic_idx);
-
-static inline int kmap_atomic_idx_push(void)
-{
-	int idx = __get_cpu_var(__kmap_atomic_idx)++;
-#ifdef CONFIG_DEBUG_HIGHMEM
-	WARN_ON_ONCE(in_irq() && !irqs_disabled());
-	BUG_ON(idx > KM_TYPE_NR);
-#endif
-	return idx;
-}
-
-static inline int kmap_atomic_idx_pop(void)
-{
-	int idx = --__get_cpu_var(__kmap_atomic_idx);
-#ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(idx < 0);
-#endif
-	return idx;
-}
-
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
@@ -95,6 +74,31 @@ static inline void __kunmap_atomic(void 
 
 #endif /* CONFIG_HIGHMEM */
 
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
+
+DECLARE_PER_CPU(int, __kmap_atomic_idx);
+
+static inline int kmap_atomic_idx_push(void)
+{
+	int idx = __get_cpu_var(__kmap_atomic_idx)++;
+#ifdef CONFIG_DEBUG_HIGHMEM
+	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	BUG_ON(idx > KM_TYPE_NR);
+#endif
+	return idx;
+}
+
+static inline int kmap_atomic_idx_pop(void)
+{
+	int idx = --__get_cpu_var(__kmap_atomic_idx);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx < 0);
+#endif
+	return idx;
+}
+
+#endif
+
 /*
  * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
  */
diff -puN mm/highmem.c~mmx86-fix-kmap_atomic_push-vs-ioremap_32c mm/highmem.c
--- a/mm/highmem.c~mmx86-fix-kmap_atomic_push-vs-ioremap_32c
+++ a/mm/highmem.c
@@ -29,6 +29,11 @@
 #include <linux/kgdb.h>
 #include <asm/tlbflush.h>
 
+
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
+DEFINE_PER_CPU(int, __kmap_atomic_idx);
+#endif
+
 /*
  * Virtual_count is not a pure "count".
  *  0 means that it is not mapped, and has not been mapped
@@ -43,7 +48,6 @@ unsigned long totalhigh_pages __read_mos
 EXPORT_SYMBOL(totalhigh_pages);
 
 
-DEFINE_PER_CPU(int, __kmap_atomic_idx);
 EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx);
 
 unsigned int nr_free_highpages (void)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
x86-access_error-api-cleanup.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
workqueues-s-on_stack-onstack.patch
kernel-remove-pf_flusher.patch
mmx86-fix-kmap_atomic_push-vs-ioremap_32c.patch
mm-fix-race-in-kunmap_atomic.patch
linux-next.patch

