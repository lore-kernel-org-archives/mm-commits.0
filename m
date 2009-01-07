From: akpm@linux-foundation.org
Subject: - bootmem-print-request-details-before-bug_onthem.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:57 -0800
Message-ID: <200901072214.n07MEvAD014776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761940AbZAGWPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     bootmem: print request details before BUG_ON(them)
has been removed from the -mm tree.  Its filename was
     bootmem-print-request-details-before-bug_onthem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -435,6 +435,10 @@ static void * __init alloc_bootmem_core(
 	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
+	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
+		align, goal, limit);
+
 	BUG_ON(!size);
 	BUG_ON(align & (align - 1));
 	BUG_ON(limit && goal + size > limit);
@@ -442,10 +446,6 @@ static void * __init alloc_bootmem_core(
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
-	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
-		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
-		align, goal, limit);
