From: akpm@linux-foundation.org
Subject: + mm-move-cache_line_size-to-linux-cacheh.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:48:39 -0800
Message-ID: <200803032148.m23Lmd7Y008318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYCCVuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     mm: move cache_line_size() to <linux/cache.h>
has been added to the -mm tree.  Its filename is
     mm-move-cache_line_size-to-linux-cacheh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -116,6 +116,9 @@ config GENERIC_TIME_VSYSCALL
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
+config ARCH_HAS_CACHE_LINE_SIZE
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
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
@@ -189,11 +189,6 @@ static inline void ClearSlabDebug(struct
 #define __OBJECT_POISON		0x80000000 /* Poison object */
 #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
 
-/* Not all arches define cache_line_size */
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
