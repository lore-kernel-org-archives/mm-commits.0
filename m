From: akpm@linux-foundation.org
Subject: + mm-adaptive-hash-table-scaling.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:36:11 -0800
Message-ID: <58b9fdeb.mGhLgRNKYiKTSbTX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdCCXpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, babu.moger@oracle.com, davem@davemloft.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: adaptive hash table scaling
has been added to the -mm tree.  Its filename is
     mm-adaptive-hash-table-scaling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-adaptive-hash-table-scaling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-adaptive-hash-table-scaling.patch

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
Subject: mm: adaptive hash table scaling

Allow hash tables to scale with memory but at slower pace, when HASH_ADAPT
is provided every time memory quadruples the sizes of hash tables will
only double instead of quadrupling as well.  This algorithm starts working
only when memory size reaches a certain point, currently set to 64G.

This is example of dentry hash table size, before and after four various
memory configurations:

MEMORY	   SCALE	 HASH_SIZE
	old	new	old	new
    8G	 13	 13      8M      8M
   16G	 13	 13     16M     16M
   32G	 13	 13     32M     32M
   64G	 13	 13     64M     64M
  128G	 13	 14    128M     64M
  256G	 13	 14    256M    128M
  512G	 13	 15    512M    128M
 1024G	 13	 15   1024M    256M
 2048G	 13	 16   2048M    256M
 4096G	 13	 16   4096M    512M
 8192G	 13	 17   8192M    512M
16384G	 13	 17  16384M   1024M
32768G	 13	 18  32768M   1024M
65536G	 13	 18  65536M   2048M

Link: http://lkml.kernel.org/r/1488432825-92126-5-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Babu Moger <babu.moger@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c             |    2 +-
 fs/inode.c              |    2 +-
 include/linux/bootmem.h |    1 +
 mm/page_alloc.c         |   19 +++++++++++++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~mm-adaptive-hash-table-scaling fs/dcache.c
--- a/fs/dcache.c~mm-adaptive-hash-table-scaling
+++ a/fs/dcache.c
@@ -3585,7 +3585,7 @@ static void __init dcache_init(void)
 					sizeof(struct hlist_bl_head),
 					dhash_entries,
 					13,
-					HASH_ZERO,
+					HASH_ZERO | HASH_ADAPT,
 					&d_hash_shift,
 					&d_hash_mask,
 					0,
diff -puN fs/inode.c~mm-adaptive-hash-table-scaling fs/inode.c
--- a/fs/inode.c~mm-adaptive-hash-table-scaling
+++ a/fs/inode.c
@@ -1953,7 +1953,7 @@ void __init inode_init(void)
 					sizeof(struct hlist_head),
 					ihash_entries,
 					14,
-					HASH_ZERO,
+					HASH_ZERO | HASH_ADAPT,
 					&i_hash_shift,
 					&i_hash_mask,
 					0,
diff -puN include/linux/bootmem.h~mm-adaptive-hash-table-scaling include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-adaptive-hash-table-scaling
+++ a/include/linux/bootmem.h
@@ -359,6 +359,7 @@ extern void *alloc_large_system_hash(con
 #define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
 					 * shift passed via *_hash_shift */
 #define HASH_ZERO	0x00000004	/* Zero allocated hash table */
+#define	HASH_ADAPT	0x00000008	/* Adaptive scale for large memory */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
diff -puN mm/page_alloc.c~mm-adaptive-hash-table-scaling mm/page_alloc.c
--- a/mm/page_alloc.c~mm-adaptive-hash-table-scaling
+++ a/mm/page_alloc.c
@@ -7106,6 +7106,17 @@ static unsigned long __init arch_reserve
 #endif
 
 /*
+ * Adaptive scale is meant to reduce sizes of hash tables on large memory
+ * machines. As memory size is increased the scale is also increased but at
+ * slower pace.  Starting from ADAPT_SCALE_BASE (64G), every time memory
+ * quadruples the scale is increased by one, which means the size of hash table
+ * only doubles, instead of quadrupling as well.
+ */
+#define ADAPT_SCALE_BASE	(64ul << 30)
+#define ADAPT_SCALE_SHIFT	2
+#define ADAPT_SCALE_NPAGES	(ADAPT_SCALE_BASE >> PAGE_SHIFT)
+
+/*
  * allocate a large system hash table from bootmem
  * - it is assumed that the hash table must contain an exact power-of-2
  *   quantity of entries
@@ -7136,6 +7147,14 @@ void *__init alloc_large_system_hash(con
 		if (PAGE_SHIFT < 20)
 			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
+		if (flags & HASH_ADAPT) {
+			unsigned long adapt;
+
+			for (adapt = ADAPT_SCALE_NPAGES; adapt < numentries;
+			     adapt <<= ADAPT_SCALE_SHIFT)
+				scale++;
+		}
+
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
 			numentries >>= (scale - PAGE_SHIFT);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch
mm-zeroing-hash-tables-in-allocator.patch
mm-updated-callers-to-use-hash_zero-flag.patch
mm-adaptive-hash-table-scaling.patch

