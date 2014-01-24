From: akpm@linux-foundation.org
Subject: [merged]
 mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:57 -0800
Message-ID: <52e2b7f1.6iom/5MRC1Y51xBY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaAXS66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, tj@kernel.org, tangchen@cn.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, phacht@linux.vnet.ibm.com

Subject: [merged] mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch removed from -mm tree
To: phacht@linux.vnet.ibm.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,tangchen@cn.fujitsu.com,tj@kernel.org,toshi.kani@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:57 -0800


The patch titled
     Subject: mm/nobootmem.c: add return value check in __alloc_memory_core_early()
has been removed from the -mm tree.  Its filename was
     mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm/nobootmem.c: add return value check in __alloc_memory_core_early()

When memblock_reserve() fails because memblock.reserved.regions cannot be
resized, the caller (e.g.  alloc_bootmem()) is not informed of the failed
allocation.  Therefore alloc_bootmem() silently returns the same pointer
again and again.

This patch adds a check for the return value of memblock_reserve() in
__alloc_memory_core().

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early
+++ a/mm/nobootmem.c
@@ -45,7 +45,9 @@ static void * __init __alloc_memory_core
 	if (!addr)
 		return NULL;
 
-	memblock_reserve(addr, size);
+	if (memblock_reserve(addr, size))
+		return NULL;
+
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
 	/*
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

origin.patch

