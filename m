From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-expose-total-reserved-memory.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:44:20 -0700
Message-ID: <57fc19c4.LGmF+IuXPOjVR/bw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbcJJWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srikar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dave.hansen@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mpe@ellerman.id.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: expose total reserved memory
has been removed from the -mm tree.  Its filename was
     mm-memblock-expose-total-reserved-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: mm/memblock.c: expose total reserved memory

The total reserved memory in a system is accounted but not available for
use use outside mm/memblock.c.  By exposing the total reserved memory,
systems can better calculate the size of large hashes.

Link: http://lkml.kernel.org/r/1472476010-4709-3-git-send-email-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN include/linux/memblock.h~mm-memblock-expose-total-reserved-memory include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-expose-total-reserved-memory
+++ a/include/linux/memblock.h
@@ -328,6 +328,7 @@ phys_addr_t memblock_alloc_base(phys_add
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				  phys_addr_t max_addr);
 phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_reserved_size(void);
 phys_addr_t memblock_mem_size(unsigned long limit_pfn);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
diff -puN mm/memblock.c~mm-memblock-expose-total-reserved-memory mm/memblock.c
--- a/mm/memblock.c~mm-memblock-expose-total-reserved-memory
+++ a/mm/memblock.c
@@ -1438,6 +1438,11 @@ phys_addr_t __init_memblock memblock_phy
 	return memblock.memory.total_size;
 }
 
+phys_addr_t __init_memblock memblock_reserved_size(void)
+{
+	return memblock.reserved.total_size;
+}
+
 phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
 {
 	unsigned long pages = 0;
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are


