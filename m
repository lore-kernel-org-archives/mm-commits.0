From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:59 -0700
Message-ID: <20120516184659.7C15AA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38970 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361Ab2EPSrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:00 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so125568yen.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, davem@davemloft.net, hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, stable@vger.kernel.org, steiner@sgi.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nobootmem: fix sign extend problem in __free_pages_memory()
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: mm: nobootmem: fix sign extend problem in __free_pages_memory()

Systems with 8 TBytes of memory or greater can hit a problem where only
the the first 8 TB of memory shows up.  This is due to "int i" being
smaller than "unsigned long start_aligned", causing the high bits to be
dropped.

The fix is to change `i' to unsigned long to match start_aligned
and end_aligned.

Thanks to Jack Steiner for assistance tracking this down.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory
+++ a/mm/nobootmem.c
@@ -82,8 +82,7 @@ void __init free_bootmem_late(unsigned l
 
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
-	int i;
-	unsigned long start_aligned, end_aligned;
+	unsigned long i, start_aligned, end_aligned;
 	int order = ilog2(BITS_PER_LONG);
 
 	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
_

Patches currently in -mm which might be from rja@sgi.com are


