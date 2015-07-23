From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch added to
 -mm tree
Date: Thu, 23 Jul 2015 12:36:16 -0700
Message-ID: <55b14230.irGkBA31VBPAJBGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbbGWTgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, bhe@redhat.com, fabf@skynet.be, isimatu.yasuaki@jp.fujitsu.com, kuleshovmail@gmail.com, lcapitulino@redhat.com, qiuxishi@huawei.com, tglx@linutronix.de, tj@kernel.org, vladimir.murzin@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: handle node hole when initializing numa_meminfo.
has been added to the -mm tree.  Its filename is
     mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mem-hotplug: handle node hole when initializing numa_meminfo.

When parsing SRAT, all memory ranges are added into numa_meminfo.  In
numa_init(), before entering numa_cleanup_meminfo(), all possible memory
ranges are in numa_meminfo.  And numa_cleanup_meminfo() removes all ranges
over max_pfn or empty.

But, this only works if the nodes are continuous.  Let's have a look at
the following example:

We have an SRAT like this:
SRAT: Node 0 PXM 0 [mem 0x00000000-0x5fffffff]
SRAT: Node 0 PXM 0 [mem 0x100000000-0x1ffffffffff]
SRAT: Node 1 PXM 1 [mem 0x20000000000-0x3ffffffffff]
SRAT: Node 4 PXM 2 [mem 0x40000000000-0x5ffffffffff] hotplug
SRAT: Node 5 PXM 3 [mem 0x60000000000-0x7ffffffffff] hotplug
SRAT: Node 2 PXM 4 [mem 0x80000000000-0x9ffffffffff] hotplug
SRAT: Node 3 PXM 5 [mem 0xa0000000000-0xbffffffffff] hotplug
SRAT: Node 6 PXM 6 [mem 0xc0000000000-0xdffffffffff] hotplug
SRAT: Node 7 PXM 7 [mem 0xe0000000000-0xfffffffffff] hotplug

On boot, only node 0,1,2,3 exist.

And the numa_meminfo will look like this:
numa_meminfo.nr_blks = 9
1. on node 0: [0, 60000000]
2. on node 0: [100000000, 20000000000]
3. on node 1: [20000000000, 40000000000]
4. on node 4: [40000000000, 60000000000]
5. on node 5: [60000000000, 80000000000]
6. on node 2: [80000000000, a0000000000]
7. on node 3: [a0000000000, a0800000000]
8. on node 6: [c0000000000, a0800000000]
9. on node 7: [e0000000000, a0800000000]

And numa_cleanup_meminfo() will merge 1 and 2, and remove 8,9 because the
end address is over max_pfn, which is a0800000000.  But 4 and 5 are not
removed because their end addresses are less then max_pfn.  But in fact,
node 4 and 5 don't exist.

In a word, numa_cleanup_meminfo() is not able to handle holes between nodes.

Since memory ranges in node 4 and 5 are in numa_meminfo, in
numa_register_memblks(), node 4 and 5 will be mistakenly set to online.

If you run lscpu, it will show:
NUMA node0 CPU(s):     0-14,128-142
NUMA node1 CPU(s):     15-29,143-157
NUMA node2 CPU(s):
NUMA node3 CPU(s):
NUMA node4 CPU(s):     62-76,190-204
NUMA node5 CPU(s):     78-92,206-220

In this patch, we use memblock_overlaps_region() to check if ranges in
numa_meminfo overlap with ranges in memory_block.  Since memory_block
contains all available memory at boot time, if they overlap, it means the
ranges exist.  If not, then remove them from numa_meminfo.

After this patch, lscpu will show:
NUMA node0 CPU(s):     0-14,128-142
NUMA node1 CPU(s):     15-29,143-157
NUMA node4 CPU(s):     62-76,190-204
NUMA node5 CPU(s):     78-92,206-220

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c       |    6 ++++--
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/numa.c~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo
+++ a/arch/x86/mm/numa.c
@@ -246,8 +246,10 @@ int __init numa_cleanup_meminfo(struct n
 		bi->start = max(bi->start, low);
 		bi->end = min(bi->end, high);
 
-		/* and there's no empty block */
-		if (bi->start >= bi->end)
+		/* and there's no empty or non-exist block */
+		if (bi->start >= bi->end ||
+		    !memblock_overlaps_region(&memblock.memory,
+			bi->start, bi->end - bi->start))
 			numa_remove_memblk_from(i--, mi);
 	}
 
diff -puN include/linux/memblock.h~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo include/linux/memblock.h
--- a/include/linux/memblock.h~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo
+++ a/include/linux/memblock.h
@@ -77,6 +77,8 @@ int memblock_remove(phys_addr_t base, ph
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
+bool memblock_overlaps_region(struct memblock_type *type,
+			      phys_addr_t base, phys_addr_t size);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
diff -puN mm/memblock.c~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo mm/memblock.c
--- a/mm/memblock.c~mem-hotplug-handle-node-hole-when-initializing-numa_meminfo
+++ a/mm/memblock.c
@@ -91,7 +91,7 @@ static unsigned long __init_memblock mem
 	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
 
-static bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
+bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
 					phys_addr_t base, phys_addr_t size)
 {
 	unsigned long i;
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

