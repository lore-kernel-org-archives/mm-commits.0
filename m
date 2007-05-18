From: akpm@linux-foundation.org
Subject: + mm-alloc_large_system_hash-can-free-some-memory-for-non.patch added to -mm tree
Date: Fri, 18 May 2007 10:42:24 -0700
Message-ID: <200705181742.l4IHgOAH019939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:33859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbXERRqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, mel@csn.ul.ie


The patch titled
     MM: alloc_large_system_hash() can free some memory for non power-of-two bucketsize
has been added to the -mm tree.  Its filename is
     mm-alloc_large_system_hash-can-free-some-memory-for-non.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MM: alloc_large_system_hash() can free some memory for non power-of-two bucketsize
From: Eric Dumazet <dada1@cosmosbay.com>

alloc_large_system_hash() is called at boot time to allocate space for
several large hash tables.

Lately, TCP hash table was changed and its bucketsize is not a power-of-two
anymore.

On most setups, alloc_large_system_hash() allocates one big page (order >
0) with __get_free_pages(GFP_ATOMIC, order).  This single high_order page
has a power-of-two size, bigger than the needed size.

We can free all pages that wont be used by the hash table.

On a 1GB i386 machine, this patch saves 128 KB of LOWMEM memory.

TCP established hash table entries: 32768 (order: 6, 393216 bytes)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN mm/page_alloc.c~mm-alloc_large_system_hash-can-free-some-memory-for-non mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_large_system_hash-can-free-some-memory-for-non
+++ a/mm/page_alloc.c
@@ -3578,6 +3578,20 @@ void *__init alloc_large_system_hash(con
 			for (order = 0; ((1UL << order) << PAGE_SHIFT) < size; order++)
 				;
 			table = (void*) __get_free_pages(GFP_ATOMIC, order);
+			/*
+			 * If bucketsize is not a power-of-two, we may free
+			 * some pages at the end of hash table.
+			 */
+			if (table) {
+				unsigned long alloc_end = (unsigned long)table +
+						(PAGE_SIZE << order);
+				unsigned long used = (unsigned long)table +
+						PAGE_ALIGN(size);
+				while (used < alloc_end) {
+					free_page(used);
+					used += PAGE_SIZE;
+				}
+			}
 		}
 	} while (!table && size > PAGE_SIZE && --log2qty);
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

mm-alloc_large_system_hash-can-free-some-memory-for-non.patch
lguest-the-host-code.patch
