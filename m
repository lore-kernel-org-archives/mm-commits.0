From: akpm@linux-foundation.org
Subject: + treewide-move-set_memory_-functions-away-from-cacheflushh.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:49:52 -0800
Message-ID: <58ba0120.tvH9KiQyrL4VEv6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdCCXtz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, airlied@linux.ie, alexander.shishkin@linux.intel.com, arnd@arndb.de, catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, jeyu@redhat.com, keescook@chromium.org, linux@roeck-us.net, mark.rutland@arm.com, mingo@kernel.org, rmk+kernel@armlinux.org.uk, schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: move set_memory_* functions away from cacheflush.h
has been added to the -mm tree.  Its filename is
     treewide-move-set_memory_-functions-away-from-cacheflushh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-move-set_memory_-functions-away-from-cacheflushh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-move-set_memory_-functions-away-from-cacheflushh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: treewide: move set_memory_* functions away from cacheflush.h

Patch series "set_memory_* functions header refactor", v2.

This is v2 of my proposal to move set_memory_* function prototypes out of
cacheflush.h and into their own header file.  This came out of a comment
Russell made while reviewing RODATA test cases
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-January/480855.html
While the final result of that series was the rodata code was refactored
into its own header file, the set_memory_* APIs are still out of place.

This version refactored the common set_memory_* functions into an
asm-generic header.  s390x added some features so it can't just use the
asm-generic header.  I debated how much more to try and shove into the
asm-generic version (e.g.  stub prototypes for the ARM nommu case,
set_kernel_text_*) but decided to stick with just the basics for this
version.

I split out the cacheflush.h -> set_memory.h conversions into separate
patches to hopefully make merging easier.  Worst case, the final patch to
completely separate the two can be delayed if there are more problems
found.  I'd like for this to eventually go through the -mm tree so I'd
like Acks where appropriate.


This patch (of 14):

The set_memory_* APIs came out of a desire to have a better way to
change memory attributes. Many of these attributes were linked to cache
functionality so the prototypes were put in cacheflush.h. These days,
the APIs have grown and have a much wider use than just cache APIs. To
support this growth, split off set_memory_* and friends into a separate
header file to avoid growing cacheflush.h for APIs that have nothing to
do with caches.

Link: http://lkml.kernel.org/r/1488413706-9739-2-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h   |   21 ------
 arch/arm/include/asm/set_memory.h   |   32 +++++++++
 arch/arm64/include/asm/Kbuild       |    1 
 arch/arm64/include/asm/cacheflush.h |    6 -
 arch/s390/include/asm/cacheflush.h  |   28 --------
 arch/s390/include/asm/set_memory.h  |   31 +++++++++
 arch/x86/include/asm/cacheflush.h   |   86 -------------------------
 arch/x86/include/asm/set_memory.h   |   87 ++++++++++++++++++++++++++
 include/asm-generic/set_memory.h    |   12 +++
 9 files changed, 167 insertions(+), 137 deletions(-)

diff -puN arch/arm/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh arch/arm/include/asm/cacheflush.h
--- a/arch/arm/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh
+++ a/arch/arm/include/asm/cacheflush.h
@@ -16,6 +16,7 @@
 #include <asm/shmparam.h>
 #include <asm/cachetype.h>
 #include <asm/outercache.h>
+#include <asm/set_memory.h>
 
 #define CACHE_COLOUR(vaddr)	((vaddr & (SHMLBA - 1)) >> PAGE_SHIFT)
 
@@ -478,26 +479,6 @@ static inline void __sync_cache_range_r(
 	: : : "r0","r1","r2","r3","r4","r5","r6","r7", \
 	      "r9","r10","lr","memory" )
 
-#ifdef CONFIG_MMU
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
-#else
-static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
-#endif
-
-#ifdef CONFIG_STRICT_KERNEL_RWX
-void set_kernel_text_rw(void);
-void set_kernel_text_ro(void);
-#else
-static inline void set_kernel_text_rw(void) { }
-static inline void set_kernel_text_ro(void) { }
-#endif
-
 void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
 			     void *kaddr, unsigned long len);
 
diff -puN /dev/null arch/arm/include/asm/set_memory.h
--- /dev/null
+++ a/arch/arm/include/asm/set_memory.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 1999-2002 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASMARM_SET_MEMORY_H
+#define _ASMARM_SET_MEMORY_H
+
+#ifdef CONFIG_MMU
+int set_memory_ro(unsigned long addr, int numpages);
+int set_memory_rw(unsigned long addr, int numpages);
+int set_memory_x(unsigned long addr, int numpages);
+int set_memory_nx(unsigned long addr, int numpages);
+#else
+static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
+static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
+static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
+static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
+#endif
+
+#ifdef CONFIG_STRICT_KERNEL_RWX
+void set_kernel_text_rw(void);
+void set_kernel_text_ro(void);
+#else
+static inline void set_kernel_text_rw(void) { }
+static inline void set_kernel_text_ro(void) { }
+#endif
+
+#endif
diff -puN arch/arm64/include/asm/Kbuild~treewide-move-set_memory_-functions-away-from-cacheflushh arch/arm64/include/asm/Kbuild
--- a/arch/arm64/include/asm/Kbuild~treewide-move-set_memory_-functions-away-from-cacheflushh
+++ a/arch/arm64/include/asm/Kbuild
@@ -27,6 +27,7 @@ generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
 generic-y += segment.h
+generic-y += set_memory.h
 generic-y += sembuf.h
 generic-y += serial.h
 generic-y += shmbuf.h
diff -puN arch/arm64/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh arch/arm64/include/asm/cacheflush.h
--- a/arch/arm64/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -20,6 +20,7 @@
 #define __ASM_CACHEFLUSH_H
 
 #include <linux/mm.h>
+#include <asm/set_memory.h>
 
 /*
  * This flag is used to indicate that the page pointed to by a pte is clean
@@ -150,9 +151,4 @@ static inline void flush_cache_vunmap(un
 {
 }
 
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
-
 #endif
diff -puN arch/s390/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh arch/s390/include/asm/cacheflush.h
--- a/arch/s390/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh
+++ a/arch/s390/include/asm/cacheflush.h
@@ -3,32 +3,6 @@
 
 /* Caches aren't brain-dead on the s390. */
 #include <asm-generic/cacheflush.h>
-
-#define SET_MEMORY_RO	1UL
-#define SET_MEMORY_RW	2UL
-#define SET_MEMORY_NX	4UL
-#define SET_MEMORY_X	8UL
-
-int __set_memory(unsigned long addr, int numpages, unsigned long flags);
-
-static inline int set_memory_ro(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, SET_MEMORY_RO);
-}
-
-static inline int set_memory_rw(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, SET_MEMORY_RW);
-}
-
-static inline int set_memory_nx(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, SET_MEMORY_NX);
-}
-
-static inline int set_memory_x(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, SET_MEMORY_X);
-}
+#include <asm/set_memory.h>
 
 #endif /* _S390_CACHEFLUSH_H */
diff -puN /dev/null arch/s390/include/asm/set_memory.h
--- /dev/null
+++ a/arch/s390/include/asm/set_memory.h
@@ -0,0 +1,31 @@
+#ifndef _ASMS390_SET_MEMORY_H
+#define _ASMS390_SET_MEMORY_H
+
+#define SET_MEMORY_RO	1UL
+#define SET_MEMORY_RW	2UL
+#define SET_MEMORY_NX	4UL
+#define SET_MEMORY_X	8UL
+
+int __set_memory(unsigned long addr, int numpages, unsigned long flags);
+
+static inline int set_memory_ro(unsigned long addr, int numpages)
+{
+	return __set_memory(addr, numpages, SET_MEMORY_RO);
+}
+
+static inline int set_memory_rw(unsigned long addr, int numpages)
+{
+	return __set_memory(addr, numpages, SET_MEMORY_RW);
+}
+
+static inline int set_memory_nx(unsigned long addr, int numpages)
+{
+	return __set_memory(addr, numpages, SET_MEMORY_NX);
+}
+
+static inline int set_memory_x(unsigned long addr, int numpages)
+{
+	return __set_memory(addr, numpages, SET_MEMORY_X);
+}
+
+#endif
diff -puN arch/x86/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh arch/x86/include/asm/cacheflush.h
--- a/arch/x86/include/asm/cacheflush.h~treewide-move-set_memory_-functions-away-from-cacheflushh
+++ a/arch/x86/include/asm/cacheflush.h
@@ -4,94 +4,10 @@
 /* Caches aren't brain-dead on the intel. */
 #include <asm-generic/cacheflush.h>
 #include <asm/special_insns.h>
-
-/*
- * The set_memory_* API can be used to change various attributes of a virtual
- * address range. The attributes include:
- * Cachability   : UnCached, WriteCombining, WriteThrough, WriteBack
- * Executability : eXeutable, NoteXecutable
- * Read/Write    : ReadOnly, ReadWrite
- * Presence      : NotPresent
- *
- * Within a category, the attributes are mutually exclusive.
- *
- * The implementation of this API will take care of various aspects that
- * are associated with changing such attributes, such as:
- * - Flushing TLBs
- * - Flushing CPU caches
- * - Making sure aliases of the memory behind the mapping don't violate
- *   coherency rules as defined by the CPU in the system.
- *
- * What this API does not do:
- * - Provide exclusion between various callers - including callers that
- *   operation on other mappings of the same physical page
- * - Restore default attributes when a page is freed
- * - Guarantee that mappings other than the requested one are
- *   in any state, other than that these do not violate rules for
- *   the CPU you have. Do not depend on any effects on other mappings,
- *   CPUs other than the one you have may have more relaxed rules.
- * The caller is required to take care of these.
- */
-
-int _set_memory_uc(unsigned long addr, int numpages);
-int _set_memory_wc(unsigned long addr, int numpages);
-int _set_memory_wt(unsigned long addr, int numpages);
-int _set_memory_wb(unsigned long addr, int numpages);
-int set_memory_uc(unsigned long addr, int numpages);
-int set_memory_wc(unsigned long addr, int numpages);
-int set_memory_wt(unsigned long addr, int numpages);
-int set_memory_wb(unsigned long addr, int numpages);
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
-int set_memory_np(unsigned long addr, int numpages);
-int set_memory_4k(unsigned long addr, int numpages);
-
-int set_memory_array_uc(unsigned long *addr, int addrinarray);
-int set_memory_array_wc(unsigned long *addr, int addrinarray);
-int set_memory_array_wt(unsigned long *addr, int addrinarray);
-int set_memory_array_wb(unsigned long *addr, int addrinarray);
-
-int set_pages_array_uc(struct page **pages, int addrinarray);
-int set_pages_array_wc(struct page **pages, int addrinarray);
-int set_pages_array_wt(struct page **pages, int addrinarray);
-int set_pages_array_wb(struct page **pages, int addrinarray);
-
-/*
- * For legacy compatibility with the old APIs, a few functions
- * are provided that work on a "struct page".
- * These functions operate ONLY on the 1:1 kernel mapping of the
- * memory that the struct page represents, and internally just
- * call the set_memory_* function. See the description of the
- * set_memory_* function for more details on conventions.
- *
- * These APIs should be considered *deprecated* and are likely going to
- * be removed in the future.
- * The reason for this is the implicit operation on the 1:1 mapping only,
- * making this not a generally useful API.
- *
- * Specifically, many users of the old APIs had a virtual address,
- * called virt_to_page() or vmalloc_to_page() on that address to
- * get a struct page* that the old API required.
- * To convert these cases, use set_memory_*() on the original
- * virtual address, do not use these functions.
- */
-
-int set_pages_uc(struct page *page, int numpages);
-int set_pages_wb(struct page *page, int numpages);
-int set_pages_x(struct page *page, int numpages);
-int set_pages_nx(struct page *page, int numpages);
-int set_pages_ro(struct page *page, int numpages);
-int set_pages_rw(struct page *page, int numpages);
-
+#include <asm/set_memory.h>
 
 void clflush_cache_range(void *addr, unsigned int size);
 
 #define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
 
-extern int kernel_set_to_readonly;
-void set_kernel_text_rw(void);
-void set_kernel_text_ro(void);
-
 #endif /* _ASM_X86_CACHEFLUSH_H */
diff -puN /dev/null arch/x86/include/asm/set_memory.h
--- /dev/null
+++ a/arch/x86/include/asm/set_memory.h
@@ -0,0 +1,87 @@
+#ifndef _ASM_X86_SET_MEMORY_H
+#define _ASM_X86_SET_MEMORY_H
+
+#include <asm/page.h>
+#include <asm-generic/set_memory.h>
+
+/*
+ * The set_memory_* API can be used to change various attributes of a virtual
+ * address range. The attributes include:
+ * Cachability   : UnCached, WriteCombining, WriteThrough, WriteBack
+ * Executability : eXeutable, NoteXecutable
+ * Read/Write    : ReadOnly, ReadWrite
+ * Presence      : NotPresent
+ *
+ * Within a category, the attributes are mutually exclusive.
+ *
+ * The implementation of this API will take care of various aspects that
+ * are associated with changing such attributes, such as:
+ * - Flushing TLBs
+ * - Flushing CPU caches
+ * - Making sure aliases of the memory behind the mapping don't violate
+ *   coherency rules as defined by the CPU in the system.
+ *
+ * What this API does not do:
+ * - Provide exclusion between various callers - including callers that
+ *   operation on other mappings of the same physical page
+ * - Restore default attributes when a page is freed
+ * - Guarantee that mappings other than the requested one are
+ *   in any state, other than that these do not violate rules for
+ *   the CPU you have. Do not depend on any effects on other mappings,
+ *   CPUs other than the one you have may have more relaxed rules.
+ * The caller is required to take care of these.
+ */
+
+int _set_memory_uc(unsigned long addr, int numpages);
+int _set_memory_wc(unsigned long addr, int numpages);
+int _set_memory_wt(unsigned long addr, int numpages);
+int _set_memory_wb(unsigned long addr, int numpages);
+int set_memory_uc(unsigned long addr, int numpages);
+int set_memory_wc(unsigned long addr, int numpages);
+int set_memory_wt(unsigned long addr, int numpages);
+int set_memory_wb(unsigned long addr, int numpages);
+int set_memory_np(unsigned long addr, int numpages);
+int set_memory_4k(unsigned long addr, int numpages);
+
+int set_memory_array_uc(unsigned long *addr, int addrinarray);
+int set_memory_array_wc(unsigned long *addr, int addrinarray);
+int set_memory_array_wt(unsigned long *addr, int addrinarray);
+int set_memory_array_wb(unsigned long *addr, int addrinarray);
+
+int set_pages_array_uc(struct page **pages, int addrinarray);
+int set_pages_array_wc(struct page **pages, int addrinarray);
+int set_pages_array_wt(struct page **pages, int addrinarray);
+int set_pages_array_wb(struct page **pages, int addrinarray);
+
+/*
+ * For legacy compatibility with the old APIs, a few functions
+ * are provided that work on a "struct page".
+ * These functions operate ONLY on the 1:1 kernel mapping of the
+ * memory that the struct page represents, and internally just
+ * call the set_memory_* function. See the description of the
+ * set_memory_* function for more details on conventions.
+ *
+ * These APIs should be considered *deprecated* and are likely going to
+ * be removed in the future.
+ * The reason for this is the implicit operation on the 1:1 mapping only,
+ * making this not a generally useful API.
+ *
+ * Specifically, many users of the old APIs had a virtual address,
+ * called virt_to_page() or vmalloc_to_page() on that address to
+ * get a struct page* that the old API required.
+ * To convert these cases, use set_memory_*() on the original
+ * virtual address, do not use these functions.
+ */
+
+int set_pages_uc(struct page *page, int numpages);
+int set_pages_wb(struct page *page, int numpages);
+int set_pages_x(struct page *page, int numpages);
+int set_pages_nx(struct page *page, int numpages);
+int set_pages_ro(struct page *page, int numpages);
+int set_pages_rw(struct page *page, int numpages);
+
+extern int kernel_set_to_readonly;
+void set_kernel_text_rw(void);
+void set_kernel_text_ro(void);
+
+#endif /* _ASM_X86_SET_MEMORY_H */
diff -puN /dev/null include/asm-generic/set_memory.h
--- /dev/null
+++ a/include/asm-generic/set_memory.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_SET_MEMORY_H
+#define __ASM_SET_MEMORY_H
+
+/*
+ * Functions to change memory attributes.
+ */
+int set_memory_ro(unsigned long addr, int numpages);
+int set_memory_rw(unsigned long addr, int numpages);
+int set_memory_x(unsigned long addr, int numpages);
+int set_memory_nx(unsigned long addr, int numpages);
+
+#endif
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-hda-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

