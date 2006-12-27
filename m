From: akpm@osdl.org
Subject: + mm-set-hashdist_default-to-1-for-x86_64-numa.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:12:58 -0800
Message-ID: <200612270912.kBR9CwTS006505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbWL0JNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:13:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, ak@suse.de, clameter@engr.sgi.com, pravin.shelar@calsoftinc.com, shai@scalex86.org


The patch titled
     mm: Set HASHDIST_DEFAULT to 1 for x86_64 NUMA
has been added to the -mm tree.  Its filename is
     mm-set-hashdist_default-to-1-for-x86_64-numa.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: Set HASHDIST_DEFAULT to 1 for x86_64 NUMA
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Enable system hashtable memory to be distributed among nodes on x86_64 NUMA

Forcing the kernel to use node interleaved vmalloc instead of bootmem for
the system hashtable memory (alloc_large_system_hash) reduces the memory
imbalance on node 0 by around 40MB on a 8 node x86_64 NUMA box:

Before the following patch, on bootup of a 8 node box:

Node 0 MemTotal:      3407488 kB
Node 0 MemFree:       3206296 kB
Node 0 MemUsed:        201192 kB
Node 0 Active:           7012 kB
Node 0 Inactive:          512 kB
Node 0 Dirty:               0 kB
Node 0 Writeback:           0 kB
Node 0 FilePages:        1912 kB
Node 0 Mapped:            420 kB
Node 0 AnonPages:        5612 kB
Node 0 PageTables:        468 kB
Node 0 NFS_Unstable:        0 kB
Node 0 Bounce:              0 kB
Node 0 Slab:             5408 kB
Node 0 SReclaimable:      644 kB
Node 0 SUnreclaim:       4764 kB

After the patch (or using hashdist=1 on the kernel command line):

Node 0 MemTotal:      3407488 kB
Node 0 MemFree:       3247608 kB
Node 0 MemUsed:        159880 kB
Node 0 Active:           3012 kB
Node 0 Inactive:          616 kB
Node 0 Dirty:               0 kB
Node 0 Writeback:           0 kB
Node 0 FilePages:        2424 kB
Node 0 Mapped:            380 kB
Node 0 AnonPages:        1200 kB
Node 0 PageTables:        396 kB
Node 0 NFS_Unstable:        0 kB
Node 0 Bounce:              0 kB
Node 0 Slab:             6304 kB
Node 0 SReclaimable:     1596 kB
Node 0 SUnreclaim:       4708 kB

I guess it is a good idea to keep HASHDIST_DEFAULT "on" for x86_64 NUMA
since x86_64 has no dearth of vmalloc space?  Or maybe enable hash
distribution for all 64bit NUMA arches?  The following patch does it only
for x86_64.

Signed-off-by: Pravin B. Shelar <pravin.shelar@calsoftinc.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/bootmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bootmem.h~mm-set-hashdist_default-to-1-for-x86_64-numa include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-set-hashdist_default-to-1-for-x86_64-numa
+++ a/include/linux/bootmem.h
@@ -122,9 +122,9 @@ extern void *alloc_large_system_hash(con
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
 
 /* Only NUMA needs hash distribution.
- * IA64 is known to have sufficient vmalloc space.
+ * IA64 and x86_64 have sufficient vmalloc space.
  */
-#if defined(CONFIG_NUMA) && defined(CONFIG_IA64)
+#if defined(CONFIG_NUMA) && (defined(CONFIG_IA64) || defined(CONFIG_X86_64))
 #define HASHDIST_DEFAULT 1
 #else
 #define HASHDIST_DEFAULT 0
_

Patches currently in -mm which might be from kiran@scalex86.org are

mm-set-hashdist_default-to-1-for-x86_64-numa.patch
slab-leaks3-default-y.patch

