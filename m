From: akpm@linux-foundation.org
Subject: + bootmem-print-request-details-before-bug_onthem.patch added to -mm tree
Date: Mon, 05 Jan 2009 01:35:28 -0800
Message-ID: <200901050935.n059ZSnY015818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZAEJfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:35:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org


The patch titled
     bootmem: print request details before BUG_ON(them)
has been added to the -mm tree.  Its filename is
     bootmem-print-request-details-before-bug_onthem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: print request details before BUG_ON(them)
From: Johannes Weiner <hannes@cmpxchg.org>

Moving the request details print-out before the sanity checks that
might panic() enables us to analyse invalid requests without having
access to the line information of the stack dump.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~bootmem-print-request-details-before-bug_onthem mm/bootmem.c
--- a/mm/bootmem.c~bootmem-print-request-details-before-bug_onthem
+++ a/mm/bootmem.c
@@ -439,6 +439,10 @@ static void * __init alloc_bootmem_core(
 	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
+	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
+		align, goal, limit);
+
 	BUG_ON(!size);
 	BUG_ON(align & (align - 1));
 	BUG_ON(limit && goal + size > limit);
@@ -446,10 +450,6 @@ static void * __init alloc_bootmem_core(
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
-	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
-		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
-		align, goal, limit);
