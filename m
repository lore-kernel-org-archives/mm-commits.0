From: akpm@linux-foundation.org
Subject: - pageattr-cache-flush-before-tlb-flush.patch removed from -mm tree
Date: Mon, 18 Aug 2008 22:26:17 -0700
Message-ID: <200808190526.m7J5QI7X032637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbYHSF0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 01:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     pageattr: cache flush before tlb flush
has been removed from the -mm tree.  Its filename was
     pageattr-cache-flush-before-tlb-flush.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageattr: cache flush before tlb flush
From: Shaohua Li <shaohua.li@intel.com>

clflush uses a virtual address but cache line is physical indexed in x86. 
In my understanding, clflush will do some pagetable walk, so doing cache
flush first should reduce some pagetable walk.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/pageattr.c~pageattr-cache-flush-before-tlb-flush arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~pageattr-cache-flush-before-tlb-flush
+++ a/arch/x86/mm/pageattr.c
@@ -168,10 +168,8 @@ static void cpa_flush_range(unsigned lon
 	BUG_ON(irqs_disabled());
 	WARN_ON(PAGE_ALIGN(start) != start);
 
-	on_each_cpu(__cpa_flush_range, NULL, 1);
