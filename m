From: akpm@linux-foundation.org
Subject: + mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:52:42 -0800
Message-ID: <201111102252.pAAMqg8V002766@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wy0-f202.google.com ([74.125.82.202]:34226 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KJWwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:52:47 -0500
Received: by wyg8 with SMTP id 8so79478wyg.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:52:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de


The patch titled
     Subject: mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOCAL
has been added to the -mm tree.  Its filename is
     mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch

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
@@ -76,6 +76,7 @@ config X86
 	select HAVE_BPF_JIT if (X86_64 && NET)
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
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
 		if (cmpxchg_double(&page->freelist,
 			freelist_old, counters_old,
@@ -400,7 +400,7 @@ static inline bool cmpxchg_double_slab(s
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#ifdef CONFIG_CMPXCHG_DOUBLE
+#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist,
 			freelist_old, counters_old,
@@ -2990,7 +2990,7 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
-#ifdef CONFIG_CMPXCHG_DOUBLE
+#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
_
Subject: Subject: mm,slub,x86: decouple size of struct page from CONFIG_CMPXCHG_LOCAL

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
mmslubx86-decouple-size-of-struct-page-from-config_cmpxchg_local.patch
mmx86um-move-cmpxchg_local-config-option.patch
mmx86um-move-cmpxchg_double-config-option.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch

