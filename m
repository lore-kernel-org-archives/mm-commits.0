From: akpm@linux-foundation.org
Subject: + mmx86um-move-cmpxchg_double-config-option.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:52:49 -0800
Message-ID: <201111102252.pAAMqoYY018862@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wy0-f202.google.com ([74.125.82.202]:34226 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KJWwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:52:53 -0500
Received: by mail-wy0-f202.google.com with SMTP id 8so79478wyg.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:52:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de


The patch titled
     Subject: mm,x86,um: move CMPXCHG_DOUBLE config option
has been added to the -mm tree.  Its filename is
     mmx86um-move-cmpxchg_double-config-option.patch

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
Subject: mm,x86,um: move CMPXCHG_DOUBLE config option

Move CMPXCHG_DOUBLE and rename it to HAVE_CMPXCHG_DOUBLE so architectures
can simply select the option if it is supported.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig         |    3 +++
 arch/x86/Kconfig     |    1 +
 arch/x86/Kconfig.cpu |    3 ---
 arch/x86/um/Kconfig  |    4 ----
 mm/slub.c            |    9 ++++++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/Kconfig~mmx86um-move-cmpxchg_double-config-option arch/Kconfig
--- a/arch/Kconfig~mmx86um-move-cmpxchg_double-config-option
+++ a/arch/Kconfig
@@ -196,4 +196,7 @@ config HAVE_ALIGNED_STRUCT_PAGE
 config HAVE_CMPXCHG_LOCAL
 	bool
 
+config HAVE_CMPXCHG_DOUBLE
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/x86/Kconfig~mmx86um-move-cmpxchg_double-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~mmx86um-move-cmpxchg_double-config-option
+++ a/arch/x86/Kconfig
@@ -78,6 +78,7 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
+	select HAVE_CMPXCHG_DOUBLE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff -puN arch/x86/Kconfig.cpu~mmx86um-move-cmpxchg_double-config-option arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~mmx86um-move-cmpxchg_double-config-option
+++ a/arch/x86/Kconfig.cpu
@@ -309,9 +309,6 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
-config CMPXCHG_DOUBLE
-	def_bool y
-
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
diff -puN arch/x86/um/Kconfig~mmx86um-move-cmpxchg_double-config-option arch/x86/um/Kconfig
--- a/arch/x86/um/Kconfig~mmx86um-move-cmpxchg_double-config-option
+++ a/arch/x86/um/Kconfig
@@ -6,10 +6,6 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
-config CMPXCHG_DOUBLE
-	bool
-	default n
-
 source "arch/x86/Kconfig.cpu"
 
 endmenu
diff -puN mm/slub.c~mmx86um-move-cmpxchg_double-config-option mm/slub.c
--- a/mm/slub.c~mmx86um-move-cmpxchg_double-config-option
+++ a/mm/slub.c
@@ -366,7 +366,8 @@ static inline bool __cmpxchg_double_slab
 		const char *n)
 {
 	VM_BUG_ON(!irqs_disabled());
-#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist,
 			freelist_old, counters_old,
@@ -400,7 +401,8 @@ static inline bool cmpxchg_double_slab(s
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist,
 			freelist_old, counters_old,
@@ -2990,7 +2992,8 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
-#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
_
Subject: Subject: mm,x86,um: move CMPXCHG_DOUBLE config option

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

