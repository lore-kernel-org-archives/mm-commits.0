From: akpm@linux-foundation.org
Subject: - mm-set-hashdist_default-to-1-for-x86_64-numa.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:56 -0700
Message-ID: <200703292337.l2TNbuiq015169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945932AbXC2XiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, ak@suse.de, clameter@engr.sgi.com, pravin.shelar@calsoftinc.com, shai@scalex86.org, mm-commits@vger.kernel.org


The patch titled
     mm: Set HASHDIST_DEFAULT to 1 for x86_64 NUMA
has been removed from the -mm tree.  Its filename was
     mm-set-hashdist_default-to-1-for-x86_64-numa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


I ran a HPC MPI benchmark -- 'Ansys wingsolid', which takes up quite a bit of
memory and uses up tlb entries.  This was on a 4 way, 2 socket
Tyan AMD box (non vsmp), with 8G total memory (4G pernode).

The results with and without hash distribution are:

1. Vanilla - runtime of 1188.000s
2. With hashdist=1 runtime of 1154.000s

Oprofile output for the duration of run is:

1. Vanilla:
PU: AMD64 processors, speed 2411.16 MHz (estimated)
Counted L1_AND_L2_DTLB_MISSES events (L1 and L2 DTLB misses) with a unit
mask of 0x00 (No unit mask) count 500
samples  %        app name                 symbol name
163054    6.5513  libansys1.so             MultiFront::decompose(int, int,
Elemset *, int *, int, int, int)
162061    6.5114  libansys3.so             blockSaxpy6L_fd
162042    6.5107  libansys3.so             blockInnerProduct6L_fd
156286    6.2794  libansys3.so             maxb33_
87879     3.5309  libansys1.so             elmatrixmultpcg_
84857     3.4095  libansys4.so             saxpy_pcg
58637     2.3560  libansys4.so             .st4560
46612     1.8728  libansys4.so             .st4282
43043     1.7294  vmlinux-t                copy_user_generic_string
41326     1.6604  libansys3.so             blockSaxpyBackSolve6L_fd
41288     1.6589  libansys3.so             blockInnerProductBackSolve6L_fd

2. With hashdist=1
CPU: AMD64 processors, speed 2411.13 MHz (estimated)
Counted L1_AND_L2_DTLB_MISSES events (L1 and L2 DTLB misses) with a unit
mask of 0x00 (No unit mask) count 500
samples  %        app name                 symbol name
162993    6.9814  libansys1.so             MultiFront::decompose(int, int,
Elemset *, int *, int, int, int)
160799    6.8874  libansys3.so             blockInnerProduct6L_fd
160459    6.8729  libansys3.so             blockSaxpy6L_fd
156018    6.6826  libansys3.so             maxb33_
84700     3.6279  libansys4.so             saxpy_pcg
83434     3.5737  libansys1.so             elmatrixmultpcg_
58074     2.4875  libansys4.so             .st4560
46000     1.9703  libansys4.so             .st4282
41166     1.7632  libansys3.so             blockSaxpyBackSolve6L_fd
41033     1.7575  libansys3.so             blockInnerProductBackSolve6L_fd
35762     1.5318  libansys1.so             inner_product_sub
35591     1.5245  libansys1.so             inner_product_sub2
28259     1.2104  libansys4.so             addVectors



Signed-off-by: Pravin B. Shelar <pravin.shelar@calsoftinc.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Acked-by: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

git-pciseg.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
slab-leaks3-default-y.patch
