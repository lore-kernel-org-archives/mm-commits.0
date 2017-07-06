From: akpm@linux-foundation.org
Subject: [patch 071/108] mm: zero hash tables in allocator
Date: Thu, 06 Jul 2017 15:39:08 -0700
Message-ID: <20170706223908.UuuUs78K3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdGFWjJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, babu.moger@oracle.com, davem@davemloft.net, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: zero hash tables in allocator

Add a new flag HASH_ZERO which when provided grantees that the hash table
that is returned by alloc_large_system_hash() is zeroed.  In most cases
that is what is needed by the caller.  Use page level allocator's
__GFP_ZERO flags to zero the memory.  It is using memset() which is
efficient method to zero memory and is optimized for most platforms.

Link: http://lkml.kernel.org/r/1488432825-92126-3-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    1 +
 mm/page_alloc.c         |   12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-zeroing-hash-tables-in-allocator include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-zeroing-hash-tables-in-allocator
+++ a/include/linux/bootmem.h
@@ -358,6 +358,7 @@ extern void *alloc_large_system_hash(con
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
 #define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
 					 * shift passed via *_hash_shift */
+#define HASH_ZERO	0x00000004	/* Zero allocated hash table */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
diff -puN mm/page_alloc.c~mm-zeroing-hash-tables-in-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-zeroing-hash-tables-in-allocator
+++ a/mm/page_alloc.c
@@ -7198,6 +7198,7 @@ void *__init alloc_large_system_hash(con
 	unsigned long long max = high_limit;
 	unsigned long log2qty, size;
 	void *table = NULL;
+	gfp_t gfp_flags;
 
 	/* allow the kernel cmdline to have a say */
 	if (!numentries) {
@@ -7242,12 +7243,17 @@ void *__init alloc_large_system_hash(con
 
 	log2qty = ilog2(numentries);
 
+	/*
+	 * memblock allocator returns zeroed memory already, so HASH_ZERO is
+	 * currently not used when HASH_EARLY is specified.
+	 */
+	gfp_flags = (flags & HASH_ZERO) ? GFP_ATOMIC | __GFP_ZERO : GFP_ATOMIC;
 	do {
 		size = bucketsize << log2qty;
 		if (flags & HASH_EARLY)
 			table = memblock_virt_alloc_nopanic(size, 0);
 		else if (hashdist)
-			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
+			table = __vmalloc(size, gfp_flags, PAGE_KERNEL);
 		else {
 			/*
 			 * If bucketsize is not a power-of-two, we may free
@@ -7255,8 +7261,8 @@ void *__init alloc_large_system_hash(con
 			 * alloc_pages_exact() automatically does
 			 */
 			if (get_order(size) < MAX_ORDER) {
-				table = alloc_pages_exact(size, GFP_ATOMIC);
-				kmemleak_alloc(table, size, 1, GFP_ATOMIC);
+				table = alloc_pages_exact(size, gfp_flags);
+				kmemleak_alloc(table, size, 1, gfp_flags);
 			}
 		}
 	} while (!table && size > PAGE_SIZE && --log2qty);
_
