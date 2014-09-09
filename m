From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch added to -mm tree
Date: Tue, 09 Sep 2014 14:47:49 -0700
Message-ID: <540f7585.Za1rw3w8bMBDAsqO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaIIVru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2014 17:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, hpa@zytor.com, rjw@sisk.pl, tangchen@cn.fujitsu.com, tj@kernel.org, wency@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: let memblock skip the hotpluggable memory regions in __next_mem_range()
has been added to the -mm tree.  Its filename is
     mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: let memblock skip the hotpluggable memory regions in __next_mem_range()

Let memblock skip the hotpluggable memory regions in __next_mem_range(),
it is used to to prevent memblock from allocating hotpluggable memory for
the kernel at early time.  The code is the same as __next_mem_range_rev().

Clear hotpluggable flag before releasing free pages to the buddy
allocator.  If we don't clear hotpluggable flag in
free_low_memory_core_early(), the memory which marked hotpluggable flag
will not free to buddy allocator.  Because __next_mem_range() will skip
them.

free_low_memory_core_early
	for_each_free_mem_range
		for_each_mem_range
			__next_mem_range

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |    4 ++++
 mm/nobootmem.c |    2 ++
 2 files changed, 6 insertions(+)

diff -puN mm/memblock.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range mm/memblock.c
--- a/mm/memblock.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range
+++ a/mm/memblock.c
@@ -816,6 +816,10 @@ void __init_memblock __next_mem_range(u6
 		if (nid != NUMA_NO_NODE && nid != m_nid)
 			continue;
 
+		/* skip hotpluggable memory regions if needed */
+		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+			continue;
+
 		if (!type_b) {
 			if (out_start)
 				*out_start = m_start;
diff -puN mm/nobootmem.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range mm/nobootmem.c
--- a/mm/nobootmem.c~mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range
+++ a/mm/nobootmem.c
@@ -119,6 +119,8 @@ static unsigned long __init free_low_mem
 	phys_addr_t start, end;
 	u64 i;
 
+	memblock_clear_hotplug(0, ULLONG_MAX);
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch

