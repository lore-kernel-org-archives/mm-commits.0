From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-use-pfn_phys.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:57:33 -0700
Message-ID: <534462bd.L5ncj+rmSKXJNCXt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbaDHU5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] mm-memblockc-use-pfn_phys.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:57:33 -0700


The patch titled
     Subject: mm/memblock.c: use PFN_PHYS()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-use-pfn_phys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/memblock.c: use PFN_PHYS()

Replace ((phys_addr_t)(x) << PAGE_SHIFT) by pfn macro.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-use-pfn_phys mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-use-pfn_phys
+++ a/mm/memblock.c
@@ -1253,7 +1253,7 @@ phys_addr_t __init memblock_mem_size(uns
 		pages += end_pfn - start_pfn;
 	}
 
-	return (phys_addr_t)pages << PAGE_SHIFT;
+	return PFN_PHYS(pages);
 }
 
 /* lowest address */
@@ -1324,7 +1324,7 @@ int __init_memblock memblock_search_pfn_
 			 unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	struct memblock_type *type = &memblock.memory;
-	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
+	int mid = memblock_search(type, PFN_PHYS(pfn));
 
 	if (mid == -1)
 		return -1;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

