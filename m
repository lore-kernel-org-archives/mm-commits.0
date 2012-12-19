From: akpm@linux-foundation.org
Subject: [merged] mm-slab-remove-duplicate-check.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:46 -0800
Message-ID: <20121219203947.2A389200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:64695 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2LSUjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:49 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so133944wgb.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove duplicate check
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-duplicate-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: remove duplicate check

While allocating pages using buddy allocator, the compound page is
probably split up to free pages.  Under these circumstances, the compound
page should be destroyed by destroy_compound_page().  However, there is a
duplicate check to judge if the page is compound.

Remove the duplicate check since the compound_order() returns 0 when the
page doesn't have PG_head set in destroy_compound_page().  That is to say,
destroy_compound_page() needn't check PageHead().

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-slab-remove-duplicate-check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-slab-remove-duplicate-check
+++ a/mm/page_alloc.c
@@ -371,8 +371,7 @@ static int destroy_compound_page(struct 
 	int nr_pages = 1 << order;
 	int bad = 0;
 
-	if (unlikely(compound_order(page) != order) ||
-	    unlikely(!PageHead(page))) {
+	if (unlikely(compound_order(page) != order)) {
 		bad_page(page);
 		bad++;
 	}
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch

