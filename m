From: akpm@linux-foundation.org
Subject: [merged] mmx86um-move-cmpxchg_double-config-option.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:59 -0800
Message-ID: <20120113203159.B4AFE1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55751 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab2AMUcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:00 -0500
Received: by yenl1 with SMTP id l1so72024yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, cl@linux.com, hpa@zytor.com, mingo@elte.hu, penberg@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,x86,um: move CMPXCHG_DOUBLE config option
has been removed from the -mm tree.  Its filename was
     mmx86um-move-cmpxchg_double-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -62,6 +62,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
+	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
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
 		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
@@ -400,7 +401,8 @@ static inline bool cmpxchg_double_slab(s
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
@@ -3014,7 +3016,8 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
-#if defined(CONFIG_CMPXCHG_DOUBLE) && defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

