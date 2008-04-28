From: akpm@linux-foundation.org
Subject: - mm-move-cache_line_size-to-linux-cacheh.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:20 -0700
Message-ID: <200804282151.m3SLpKW1017571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964905AbYD1Vvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mm: move cache_line_size() to <linux/cache.h>
has been removed from the -mm tree.  Its filename was
     mm-move-cache_line_size-to-linux-cacheh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move cache_line_size() to <linux/cache.h>
From: Pekka Enberg <penberg@cs.helsinki.fi>

Not all architectures define cache_line_size() so as suggested by Andrew move
the private implementations in mm/slab.c and mm/slob.c to <linux/cache.h>.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    3 +++
 include/linux/cache.h |    4 ++++
 mm/slab.c             |    4 ----
 mm/slub.c             |    5 -----
 4 files changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/x86/Kconfig~mm-move-cache_line_size-to-linux-cacheh arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-move-cache_line_size-to-linux-cacheh
+++ a/arch/x86/Kconfig
@@ -114,6 +114,9 @@ config GENERIC_TIME_VSYSCALL
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
+config ARCH_HAS_CACHE_LINE_SIZE
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)
 
diff -puN include/linux/cache.h~mm-move-cache_line_size-to-linux-cacheh include/linux/cache.h
--- a/include/linux/cache.h~mm-move-cache_line_size-to-linux-cacheh
+++ a/include/linux/cache.h
@@ -60,4 +60,8 @@
 #endif
 #endif
 
+#ifndef CONFIG_ARCH_HAS_CACHE_LINE_SIZE
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
 #endif /* __LINUX_CACHE_H */
diff -puN mm/slab.c~mm-move-cache_line_size-to-linux-cacheh mm/slab.c
--- a/mm/slab.c~mm-move-cache_line_size-to-linux-cacheh
+++ a/mm/slab.c
@@ -139,10 +139,6 @@
 #define	BYTES_PER_WORD		sizeof(void *)
 #define	REDZONE_ALIGN		max(BYTES_PER_WORD, __alignof__(unsigned long long))
 
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
-
 #ifndef ARCH_KMALLOC_MINALIGN
 /*
  * Enforce a minimum alignment for the kmalloc caches.
diff -puN mm/slub.c~mm-move-cache_line_size-to-linux-cacheh mm/slub.c
--- a/mm/slub.c~mm-move-cache_line_size-to-linux-cacheh
+++ a/mm/slub.c
@@ -207,11 +207,6 @@ static inline void ClearSlabDebug(struct
 #define __KMALLOC_CACHE		0x20000000 /* objects freed using kfree */
 #define __PAGE_ALLOC_FALLBACK	0x10000000 /* Allow fallback to page alloc */
 
-/* Not all arches define cache_line_size */
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
