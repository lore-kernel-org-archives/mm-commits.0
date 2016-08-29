From: akpm@linux-foundation.org
Subject: +
 mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch added to -mm tree
Date: Mon, 29 Aug 2016 16:09:40 -0700
Message-ID: <57c4c0b4.mE7IDp43x3tMp4a8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbcH2XJu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nobootmem.c: remove duplicate macro ARCH_LOW_ADDRESS_LIMIT statements
has been added to the -mm tree.  Its filename is
     mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/nobootmem.c: remove duplicate macro ARCH_LOW_ADDRESS_LIMIT statements

Fix the following bugs:

 - the same ARCH_LOW_ADDRESS_LIMIT statements are duplicated between
   header and relevant source

 - don't ensure ARCH_LOW_ADDRESS_LIMIT perhaps defined by ARCH in
   asm/processor.h is preferred over default in linux/bootmem.h
   completely since the former header isn't included by the latter

Link: http://lkml.kernel.org/r/e046aeaa-e160-6d9e-dc1b-e084c2fd999f@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    9 +++++----
 mm/nobootmem.c          |   10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/bootmem.h~mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements
+++ a/include/linux/bootmem.h
@@ -7,6 +7,7 @@
 #include <linux/mmzone.h>
 #include <linux/mm_types.h>
 #include <asm/dma.h>
+#include <asm/processor.h>
 
 /*
  *  simple boot-time physical memory area allocator.
@@ -119,6 +120,10 @@ extern void *__alloc_bootmem_low_node(pg
 #define BOOTMEM_LOW_LIMIT __pa(MAX_DMA_ADDRESS)
 #endif
 
+#ifndef ARCH_LOW_ADDRESS_LIMIT
+#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
+#endif
+
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_align(x, align) \
@@ -180,10 +185,6 @@ static inline void * __init memblock_vir
 						    NUMA_NO_NODE);
 }
 
-#ifndef ARCH_LOW_ADDRESS_LIMIT
-#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
-#endif
-
 static inline void * __init memblock_virt_alloc_low(
 					phys_addr_t size, phys_addr_t align)
 {
diff -puN mm/nobootmem.c~mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements
+++ a/mm/nobootmem.c
@@ -11,18 +11,21 @@
 #include <linux/init.h>
 #include <linux/pfn.h>
 #include <linux/slab.h>
-#include <linux/bootmem.h>
 #include <linux/export.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
-#include <asm/processor.h>
 
 #include "internal.h"
 
+#ifndef CONFIG_HAVE_MEMBLOCK
+#error CONFIG_HAVE_MEMBLOCK not defined
+#endif
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 struct pglist_data __refdata contig_page_data;
 EXPORT_SYMBOL(contig_page_data);
@@ -395,9 +398,6 @@ void * __init __alloc_bootmem_node_high(
 	return __alloc_bootmem_node(pgdat, size, align, goal);
 }
 
-#ifndef ARCH_LOW_ADDRESS_LIMIT
-#define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
-#endif
 
 /**
  * __alloc_bootmem_low - allocate low boot memory
_

Patches currently in -mm which might be from zijun_hu@htc.com are

mm-vmalloc-fix-align-value-calculation-error.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch
mm-nobootmemc-remove-duplicate-macro-arch_low_address_limit-statements.patch

