From: akpm@linux-foundation.org
Subject: + pageattr-cache-flush-before-tlb-flush.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:02:27 -0700
Message-ID: <200808182302.m7IN2RFh017638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYHRXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com


The patch titled
     pageattr: cache flush before tlb flush
has been added to the -mm tree.  Its filename is
     pageattr-cache-flush-before-tlb-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
