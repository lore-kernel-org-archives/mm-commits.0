From: akpm@linux-foundation.org
Subject: [merged] mm-adaptive-hash-table-scaling.patch removed from
 -mm tree
Date: Fri, 07 Jul 2017 12:10:12 -0700
Message-ID: <20170707191012.jgZmn163z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752572AbdGGTKY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, davem@davemloft.net, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: adaptive hash table scaling
has been removed from the -mm tree.  Its filename was
     mm-adaptive-hash-table-scaling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

The effect of this change on runtime is undetectable as filesystem
growth is not proportional to machine memory size as is currently
assumed.  The change effects only large memory machine.  Additional
tuning might be needed, but that can be done by the clients of the
kmem_cache_create interface, not the generic cache allocator itself.

The adaptive hashing is disabled on 32 bit systems to avoid confusion of
whether base should be different for smaller systems, and to avoid
overflows.

[mhocko@suse.com: drop HASH_ADAPT]
  Link: http://lkml.kernel.org/r/20170509094607.GG6481@dhcp22.suse.cz
[pasha.tatashin@oracle.com: UL -> ULL fix]
  Link: http://lkml.kernel.org/r/1495300013-653283-2-git-send-email-pasha.tatashin@oracle.com
[pasha.tatashin@oracle.com: disable adaptive hash on 32 bit systems]
  Link: http://lkml.kernel.org/r/1495469329-755807-2-git-send-email-pasha.tatashin@oracle.com
Link: http://lkml.kernel.org/r/1488432825-92126-5-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Babu Moger <babu.moger@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN mm/page_alloc.c~mm-adaptive-hash-table-scaling mm/page_alloc.c
--- a/mm/page_alloc.c~mm-adaptive-hash-table-scaling
+++ a/mm/page_alloc.c
@@ -7180,6 +7180,21 @@ static unsigned long __init arch_reserve
 #endif
 
 /*
+ * Adaptive scale is meant to reduce sizes of hash tables on large memory
+ * machines. As memory size is increased the scale is also increased but at
+ * slower pace.  Starting from ADAPT_SCALE_BASE (64G), every time memory
+ * quadruples the scale is increased by one, which means the size of hash table
+ * only doubles, instead of quadrupling as well.
+ * Because 32-bit systems cannot have large physical memory, where this scaling
+ * makes sense, it is disabled on such platforms.
+ */
+#if __BITS_PER_LONG > 32
+#define ADAPT_SCALE_BASE	(64ul << 30)
+#define ADAPT_SCALE_SHIFT	2
+#define ADAPT_SCALE_NPAGES	(ADAPT_SCALE_BASE >> PAGE_SHIFT)
+#endif
+
+/*
  * allocate a large system hash table from bootmem
  * - it is assumed that the hash table must contain an exact power-of-2
  *   quantity of entries
@@ -7210,6 +7225,16 @@ void *__init alloc_large_system_hash(con
 		if (PAGE_SHIFT < 20)
 			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
+#if __BITS_PER_LONG > 32
+		if (!high_limit) {
+			unsigned long adapt;
+
+			for (adapt = ADAPT_SCALE_NPAGES; adapt < numentries;
+			     adapt <<= ADAPT_SCALE_SHIFT)
+				scale++;
+		}
+#endif
+
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
 			numentries >>= (scale - PAGE_SHIFT);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch

