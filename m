From: akpm@linux-foundation.org
Subject: [merged]
 mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:08:16 -0700
Message-ID: <20170707190816.rTYYnr6Lb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTIR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/nobootmem.c: return 0 when start_pfn equals end_pfn
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/nobootmem.c: return 0 when start_pfn equals end_pfn

When start_pfn equals end_pfn, __free_pages_memory() has no effect and
__free_memory_core() will finally return (end_pfn - start_pfn) = 0.

This patch returns 0 directly when start_pfn equals end_pfn.

Link: http://lkml.kernel.org/r/20170502131115.6650-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmem-return-0-when-start_pfn-equals-end_pfn mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-return-0-when-start_pfn-equals-end_pfn
+++ a/mm/nobootmem.c
@@ -118,7 +118,7 @@ static unsigned long __init __free_memor
 	unsigned long end_pfn = min_t(unsigned long,
 				      PFN_DOWN(end), max_low_pfn);
 
-	if (start_pfn > end_pfn)
+	if (start_pfn >= end_pfn)
 		return 0;
 
 	__free_pages_memory(start_pfn, end_pfn);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

