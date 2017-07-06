From: akpm@linux-foundation.org
Subject: [patch 030/108] mm/nobootmem.c: return 0 when start_pfn
 equals end_pfn
Date: Thu, 06 Jul 2017 15:36:53 -0700
Message-ID: <20170706223653.TELrDBQ-2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdGFWgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
