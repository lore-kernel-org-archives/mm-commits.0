From: akpm@linux-foundation.org
Subject: + mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory.patch added to -mm tree
Date: Mon, 07 May 2012 14:32:24 -0700
Message-ID: <20120507213224.CDE2DA0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:61126 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab2EGVc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2012 17:32:27 -0400
Received: by werp12 with SMTP id p12so96296wer.1
        for <mm-commits@vger.kernel.org>; Mon, 07 May 2012 14:32:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rja@sgi.com, davem@davemloft.net, hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, stable@vger.kernel.org, steiner@sgi.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm: nobootmem: fix sign extend problem in __free_pages_memory()
has been added to the -mm tree.  Its filename is
     mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: mm: nobootmem: fix sign extend problem in __free_pages_memory()

Systems with 8 TBytes of memory or greater can hit a problem where only
the the first 8 TB of memory shows up.  This is due to "int i" being
smaller than "unsigned long start_aligned", causing the high bits to be
dropped.

The fix is to change `i' to unsigned long to match start_aligned
and end_aligned.

Thanks to Jack Steiner (steiner@sgi.com) for assistance tracking
this down.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
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
Subject: Subject: mm: nobootmem: fix sign extend problem in __free_pages_memory()

Patches currently in -mm which might be from rja@sgi.com are

mm-nobootmem-fix-sign-extend-problem-in-__free_pages_memory.patch

