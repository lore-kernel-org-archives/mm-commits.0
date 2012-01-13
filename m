From: akpm@linux-foundation.org
Subject: [merged] mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:51 -0800
Message-ID: <20120113203151.C4E9810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52529 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2AMUbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:52 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so355515ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOCAL
has been removed from the -mm tree.  Its filename was
     mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOCAL

While implementing cmpxchg_double() on s390 I realized that we don't set
CONFIG_CMPXCHG_LOCAL besides the fact that we have support for it. 
However setting that option will increase the size of struct page by eight
bytes on 64 bit, which we certainly do not want.  Also, it doesn't make
sense that a present cpu feature should increase the size of struct page.

Besides that it looks like the dependency to CMPXCHG_LOCAL is wrong and
that it should depend on CMPXCHG_DOUBLE instead.



This patch:

If an architecture supports CMPXCHG_LOCAL this shouldn't result
automatically in larger struct pages if the SLUB allocator is used. 
Instead introduce a new config option "HAVE_ALIGNED_STRUCT_PAGE" which can
be selected if a double word aligned struct page is required.  Also update
x86 Kconfig so that it should work as before.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig             |    8 ++++++++
 arch/x86/Kconfig         |    1 +
 include/linux/mm_types.h |    9 ++++-----
 mm/slub.c                |    6 +++---
 4 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/Kconfig~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local arch/Kconfig
--- a/arch/Kconfig~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local
+++ a/arch/Kconfig
@@ -185,4 +185,12 @@ config HAVE_RCU_TABLE_FREE
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
+config HAVE_ALIGNED_STRUCT_PAGE
+	bool
+	help
+	  This makes sure that struct pages are double word aligned and that
+	  e.g. the SLUB allocator can perform double word atomic operations
+	  on a struct page for better performance. However selecting this
+	  might increase the size of a struct page by a word.
+
 source "kernel/gcov/Kconfig"
diff -puN arch/x86/Kconfig~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local arch/x86/Kconfig
--- a/arch/x86/Kconfig~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local
+++ a/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
diff -puN include/linux/mm_types.h~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local include/linux/mm_types.h
--- a/include/linux/mm_types.h~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local
+++ a/include/linux/mm_types.h
@@ -151,12 +151,11 @@ struct page {
 #endif
 }
 /*
- * If another subsystem starts using the double word pairing for atomic
- * operations on struct page then it must change the #if to ensure
- * proper alignment of the page struct.
+ * The struct page can be forced to be double word aligned so that atomic ops
+ * on double words work. The SLUB allocator can make use of such a feature.
  */
-#if defined(CONFIG_SLUB) && defined(CONFIG_CMPXCHG_LOCAL)
-	__attribute__((__aligned__(2*sizeof(unsigned long))))
+#ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
+	__aligned(2 * sizeof(unsigned long))
 #endif
 ;
 
diff -puN mm/slub.c~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local mm/slub.c
--- a/mm/slub.c~mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local
+++ a/mm/slub.c
@@ -366,7 +366,7 @@ static inline bool __cmpxchg_double_slab
 		const char *n)
 {
 	VM_BUG_ON(!irqs_disabled());
-#ifdef CONFIG_CMPXCHG_DOUBLE
+#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
@@ -400,7 +400,7 @@ static inline bool cmpxchg_double_slab(s
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#ifdef CONFIG_CMPXCHG_DOUBLE
+#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
@@ -3014,7 +3014,7 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
-#ifdef CONFIG_CMPXCHG_DOUBLE
+#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

