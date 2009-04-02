From: akpm@linux-foundation.org
Subject: + generic-debug-pagealloc-build-fix.patch added to -mm tree
Date: Thu, 02 Apr 2009 09:46:22 -0700
Message-ID: <200904021646.n32GkMHM027540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297AbZDBQsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 12:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, a.beregalov@gmail.com


The patch titled
     generic debug pagealloc: build fix 
has been added to the -mm tree.  Its filename is
     generic-debug-pagealloc-build-fix.patch

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
Subject: generic debug pagealloc: build fix 
From: Akinobu Mita <akinobu.mita@gmail.com>

mm/debug-pagealloc.c: In function 'set_page_poison':
mm/debug-pagealloc.c:8: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: In function 'clear_page_poison':
mm/debug-pagealloc.c:13: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: In function 'page_poison':
mm/debug-pagealloc.c:18: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: At top level:
mm/debug-pagealloc.c:120: error: redefinition of 'kernel_map_pages'
include/linux/mm.h:1278: error: previous definition of
'kernel_map_pages' was here
mm/debug-pagealloc.c: In function 'kernel_map_pages':
mm/debug-pagealloc.c:122: error: 'debug_pagealloc_enabled' undeclared
(first use in this function)

This patch fixes build failure with generic debug pagealloc:

 - debug_flags should be in struct page
 - define DEBUG_PAGEALLOC config option for all architectures

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig.debug |   10 ----------
 arch/s390/Kconfig.debug    |    9 ---------
 arch/sparc/Kconfig.debug   |    9 ---------
 arch/x86/Kconfig.debug     |    9 ---------
 include/linux/mm_types.h   |    6 +++---
 mm/Kconfig.debug           |    9 +++++++++
 6 files changed, 12 insertions(+), 40 deletions(-)

diff -puN arch/powerpc/Kconfig.debug~generic-debug-pagealloc-build-fix arch/powerpc/Kconfig.debug
--- a/arch/powerpc/Kconfig.debug~generic-debug-pagealloc-build-fix
+++ a/arch/powerpc/Kconfig.debug
@@ -27,16 +27,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PAGEALLOC
-        bool "Debug page memory allocations"
-        depends on DEBUG_KERNEL && !HIBERNATION
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-        help
-          Unmap pages from the kernel linear mapping after free_pages().
-          This results in a large slowdown, but helps to find certain types
-          of memory corruptions.
-
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS
diff -puN arch/s390/Kconfig.debug~generic-debug-pagealloc-build-fix arch/s390/Kconfig.debug
--- a/arch/s390/Kconfig.debug~generic-debug-pagealloc-build-fix
+++ a/arch/s390/Kconfig.debug
@@ -6,13 +6,4 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	help
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a slowdown, but helps to find certain types of
-	  memory corruptions.
-
 endmenu
diff -puN arch/sparc/Kconfig.debug~generic-debug-pagealloc-build-fix arch/sparc/Kconfig.debug
--- a/arch/sparc/Kconfig.debug~generic-debug-pagealloc-build-fix
+++ a/arch/sparc/Kconfig.debug
@@ -22,15 +22,6 @@ config DEBUG_DCFLUSH
 config STACK_DEBUG
 	bool "Stack Overflow Detection Support"
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !HIBERNATION
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	help
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
-
 config MCOUNT
 	bool
 	depends on SPARC64
diff -puN arch/x86/Kconfig.debug~generic-debug-pagealloc-build-fix arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~generic-debug-pagealloc-build-fix
+++ a/arch/x86/Kconfig.debug
@@ -72,15 +72,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL
-	depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	---help---
-	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
-
 config DEBUG_PER_CPU_MAPS
 	bool "Debug access to per_cpu maps"
 	depends on DEBUG_KERNEL
diff -puN include/linux/mm_types.h~generic-debug-pagealloc-build-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~generic-debug-pagealloc-build-fix
+++ a/include/linux/mm_types.h
@@ -95,6 +95,9 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
+#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
+	unsigned long debug_flags;	/* Use atomic bitops on this */
+#endif
 };
 
 /*
@@ -175,9 +178,6 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
-#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
-	unsigned long debug_flags;	/* Use atomic bitops on this */
-#endif
 };
 
 struct core_thread {
diff -puN mm/Kconfig.debug~generic-debug-pagealloc-build-fix mm/Kconfig.debug
--- a/mm/Kconfig.debug~generic-debug-pagealloc-build-fix
+++ a/mm/Kconfig.debug
@@ -1,3 +1,12 @@
+config DEBUG_PAGEALLOC
+	bool "Debug page memory allocations"
+	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on !HIBERNATION || !PPC && !SPARC
+	---help---
+	  Unmap pages from the kernel linear mapping after free_pages().
+	  This results in a large slowdown, but helps to find certain types
+	  of memory corruptions.
+
 config WANT_PAGE_DEBUG_FLAGS
 	bool
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
generic-debug-pagealloc-build-fix.patch
mm-fix-misuse-of-debug_kmap_atomic.patch

