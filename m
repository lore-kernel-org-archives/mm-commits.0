From: akpm@linux-foundation.org
Subject: + mm-zeroing-hash-tables-in-allocator.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:36:06 -0800
Message-ID: <58b9fde6.DlkhXs0n2Uh2JOZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdCCXpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, babu.moger@oracle.com, davem@davemloft.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zero hash tables in allocator
has been added to the -mm tree.  Its filename is
     mm-zeroing-hash-tables-in-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zeroing-hash-tables-in-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zeroing-hash-tables-in-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -7124,6 +7124,7 @@ void *__init alloc_large_system_hash(con
 	unsigned long long max = high_limit;
 	unsigned long log2qty, size;
 	void *table = NULL;
+	gfp_t gfp_flags;
 
 	/* allow the kernel cmdline to have a say */
 	if (!numentries) {
@@ -7168,12 +7169,17 @@ void *__init alloc_large_system_hash(con
 
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
@@ -7181,8 +7187,8 @@ void *__init alloc_large_system_hash(con
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

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch
mm-zeroing-hash-tables-in-allocator.patch
mm-updated-callers-to-use-hash_zero-flag.patch
mm-adaptive-hash-table-scaling.patch

