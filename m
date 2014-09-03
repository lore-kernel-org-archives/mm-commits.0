From: akpm@linux-foundation.org
Subject: [merged]
 memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:21 -0700
Message-ID: <54075681.YZTCzqhpUZOMrBak%akpm__23706.047391943$1409767071$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaICR5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, qiuxishi@huawei.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock, memhotplug: fix wrong type in memblock_find_in_range_node().
has been removed from the -mm tree.  Its filename was
     memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock, memhotplug: fix wrong type in memblock_find_in_range_node().

In memblock_find_in_range_node(), we defined ret as int.  But it should be
phys_addr_t because it is used to store the return value from
__memblock_find_range_bottom_up().

The bug has not been triggered because when allocating low memory near the
kernel end, the "int ret" won't turn out to be negative.  When we started
to allocate memory on other nodes, and the "int ret" could be minus.  Then
the kernel will panic.

A simple way to reproduce this: comment out the following code in numa_init(),

        memblock_set_bottom_up(false);

and the kernel won't boot.

Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: <stable@vger.kernel.org>	[3.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memblock.c~memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node mm/memblock.c
--- a/mm/memblock.c~memblock-memhotplug-fix-wrong-type-in-memblock_find_in_range_node
+++ a/mm/memblock.c
@@ -192,8 +192,7 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid)
 {
-	int ret;
-	phys_addr_t kernel_end;
+	phys_addr_t kernel_end, ret;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch

