From: akpm@linux-foundation.org
Subject: + page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:35:28 -0700
Message-ID: <200808052035.m75KZSSX022202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762563AbYHEUgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, dhowells@redhat.com


The patch titled
     page allocator: use no-panic variant of alloc_bootmem() in alloc_large_system_hash()
has been added to the -mm tree.  Its filename is
     page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash.patch

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
Subject: page allocator: use no-panic variant of alloc_bootmem() in alloc_large_system_hash()
From: Jan Beulich <jbeulich@novell.com>

..  since a failed allocation is being (initially) handled gracefully, and
panic()-ed upon failure explicitly in the function if retries with smaller
sizes failed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++++
 mm/page_alloc.c         |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/bootmem.h~page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash include/linux/bootmem.h
--- a/include/linux/bootmem.h~page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash
+++ a/include/linux/bootmem.h
@@ -97,10 +97,14 @@ extern void *__alloc_bootmem_low_node(pg
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_nopanic(x) \
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
 	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_pages_nopanic(x) \
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x) \
diff -puN mm/page_alloc.c~page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash
+++ a/mm/page_alloc.c
@@ -4437,7 +4437,7 @@ void *__init alloc_large_system_hash(con
 	do {
 		size = bucketsize << log2qty;
 		if (flags & HASH_EARLY)
-			table = alloc_bootmem(size);
+			table = alloc_bootmem_nopanic(size);
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch
page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash.patch
x86-64-fix-overlap-of-modules-and-fixmap-areas.patch

