From: akpm@linux-foundation.org
Subject: [merged]
 mm-meminit-initialise-more-memory-for-inode-dentry-hash-tables-in-early-boot.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:15 -0700
Message-ID: <56f0400f.78hnjMNkuC7c8Al2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbcCUT4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhlcindy@linux.vnet.ibm.com, mgorman@techsingularity.net, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: meminit: initialise more memory for inode/dentry hash tables in early boot
has been removed from the -mm tree.  Its filename was
     mm-meminit-initialise-more-memory-for-inode-dentry-hash-tables-in-early-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Subject: mm: meminit: initialise more memory for inode/dentry hash tables in early boot

Upstream has supported page parallel initialisation for X86 and the boot
time is improved greately.  Some tests have been done for Power.

Here is the result I have done with different memory size.

* 4GB memory:
    boot time is as the following: 
    with patch vs without patch: 10.4s vs 24.5s
    boot time is improved 57%
* 200GB memory: 
    boot time looks the same with and without patches.
    boot time is about 38s
* 32TB memory: 
    boot time looks the same with and without patches 
    boot time is about 160s.
    The boot time is much shorter than X86 with 24TB memory.
    From community discussion, it costs about 694s for X86 24T system.

Parallel initialisation improves the performance by deferring memory
initilisation to kswap with N kthreads, it should improve the performance
therotically.  

In testing on X86, performance is improved greatly with huge memory.  But
on Power platform, it is improved greatly with less than 100GB memory. 
For huge memory, it is not improved greatly.  But it saves the time with
several threads at least, as the following information shows(32TB system
log):

[   22.648169] node 9 initialised, 16607461 pages in 280ms
[   22.783772] node 3 initialised, 23937243 pages in 410ms
[   22.858877] node 6 initialised, 29179347 pages in 490ms
[   22.863252] node 2 initialised, 29179347 pages in 490ms
[   22.907545] node 0 initialised, 32049614 pages in 540ms
[   22.920891] node 15 initialised, 32212280 pages in 550ms
[   22.923236] node 4 initialised, 32306127 pages in 550ms
[   22.923384] node 12 initialised, 32314319 pages in 550ms
[   22.924754] node 8 initialised, 32314319 pages in 550ms
[   22.940780] node 13 initialised, 33353677 pages in 570ms
[   22.940796] node 11 initialised, 33353677 pages in 570ms
[   22.941700] node 5 initialised, 33353677 pages in 570ms
[   22.941721] node 10 initialised, 33353677 pages in 570ms
[   22.941876] node 7 initialised, 33353677 pages in 570ms
[   22.944946] node 14 initialised, 33353677 pages in 570ms
[   22.946063] node 1 initialised, 33345485 pages in 580ms

It saves the time about 550*16 ms at least, although it can be ignore to
compare the boot time about 160 seconds.  What's more, the boot time is
much shorter on Power even without patches than x86 for huge memory
machine.  

So this patchset is still necessary to be enabled for Power. 



This patch (of 2):

This patch is based on Mel Gorman's old patch in the mailing list,
https://lkml.org/lkml/2015/5/5/280 which is discussed but it is fixed with
a completion to wait for all memory initialised in page_alloc_init_late().
It is to fix the OOM problem on X86 with 24TB memory which allocates
memory in late initialisation.  But for Power platform with 32TB memory,
it causes a call trace in vfs_caches_init->inode_init() and inode hash
table needs more memory.  So this patch allocates 1GB for 0.25TB/node for
large system as it is mentioned in https://lkml.org/lkml/2015/5/1/627

This call trace is found on Power with 32TB memory, 1024CPUs, 16nodes. 
Currently, it only allocates 2GB*16=32GB for early initialisation.  But
Dentry cache hash table needes 16GB and Inode cache hash table needs 16GB.
So the system have no enough memory for it.  The log from dmesg as the
following:

Dentry cache hash table entries: 2147483648 (order: 18,17179869184 bytes)
vmalloc: allocation failure, allocated 16021913600 of 17179934720 bytes
swapper/0: page allocation failure: order:0,mode:0x2080020
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-0-ppc64
Call Trace:
[c0000000012bfa00] [c0000000007c4a50].dump_stack+0xb4/0xb664 (unreliable)
[c0000000012bfa80] [c0000000001f93d4].warn_alloc_failed+0x114/0x160
[c0000000012bfb30] [c00000000023c204].__vmalloc_area_node+0x1a4/0x2b0
[c0000000012bfbf0] [c00000000023c3f4].__vmalloc_node_range+0xe4/0x110
[c0000000012bfc90] [c00000000023c460].__vmalloc_node+0x40/0x50
[c0000000012bfd10] [c000000000b67d60].alloc_large_system_hash+0x134/0x2a4
[c0000000012bfdd0] [c000000000b70924].inode_init+0xa4/0xf0
[c0000000012bfe60] [c000000000b706a0].vfs_caches_init+0x80/0x144
[c0000000012bfef0] [c000000000b35208].start_kernel+0x40c/0x4e0
[c0000000012bff90] [c000000000008cfc]start_here_common+0x20/0x4a4
Mem-Info:

Signed-off-by: Li Zhang <zhlcindy@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-initialise-more-memory-for-inode-dentry-hash-tables-in-early-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-initialise-more-memory-for-inode-dentry-hash-tables-in-early-boot
+++ a/mm/page_alloc.c
@@ -308,13 +308,20 @@ static inline bool update_defer_init(pg_
 				unsigned long pfn, unsigned long zone_end,
 				unsigned long *nr_initialised)
 {
+	unsigned long max_initialise;
+
 	/* Always populate low zones for address-contrained allocations */
 	if (zone_end < pgdat_end_pfn(pgdat))
 		return true;
+	/*
+	 * Initialise at least 2G of a node but also take into account that
+	 * two large system hashes that can take up 1GB for 0.25TB/node.
+	 */
+	max_initialise = max(2UL << (30 - PAGE_SHIFT),
+		(pgdat->node_spanned_pages >> 8));
 
-	/* Initialise at least 2G of the highest zone */
 	(*nr_initialised)++;
-	if (*nr_initialised > (2UL << (30 - PAGE_SHIFT)) &&
+	if ((*nr_initialised > max_initialise) &&
 	    (pfn & (PAGES_PER_SECTION - 1)) == 0) {
 		pgdat->first_deferred_pfn = pfn;
 		return false;
_

Patches currently in -mm which might be from zhlcindy@linux.vnet.ibm.com are


