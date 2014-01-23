From: akpm@linux-foundation.org
Subject: [folded-merged] mm-nobootmem-free_all_bootmem-again-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:20:19 -0800
Message-ID: <52e1a3b3.eyrlimoLpJs8TXvh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWXUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:20:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robinmholt@gmail.com, rientjes@google.com, phacht@linux.vnet.ibm.com

Subject: [folded-merged] mm-nobootmem-free_all_bootmem-again-fix.patch removed from -mm tree
To: phacht@linux.vnet.ibm.com,rientjes@google.com,robinmholt@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:20:19 -0800


The patch titled
     Subject: mm-nobootmem-free_all_bootmem-again-fix
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-free_all_bootmem-again-fix.patch

This patch was dropped because it was folded into mm-nobootmem-free_all_bootmem-again.patch

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm-nobootmem-free_all_bootmem-again-fix

This fixes an unused variable warning in nobootmem.c

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-free_all_bootmem-again-fix
+++ a/mm/nobootmem.c
@@ -116,9 +116,13 @@ static unsigned long __init __free_memor
 static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
-	phys_addr_t start, end, size;
+	phys_addr_t start, end;
 	u64 i;
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+	phys_addr_t size;
+#endif
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch

