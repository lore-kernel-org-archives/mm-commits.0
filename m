From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-slab-remove-duplicate-check.patch removed from -mm tree
Date: Mon, 20 Aug 2012 15:51:37 -0700
Message-ID: <20120820225138.44C6E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50968 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2HTWvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:51:39 -0400
Received: by obbwc20 with SMTP id wc20so4123487obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:51:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove duplicate check
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-duplicate-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/slab: remove duplicate check

While allocating pages using buddy allocator, the compound page is
probably split up to free pages.  Under these circumstances, the compound
page should be destroyed by destroy_compound_page().  However, there is a
duplicate check to judge if the page is compound.

Remove the duplicate check since the compound_order() returns 0 when the
page doesn't have PG_head set in destroy_compound_page().  That is to say,
destroy_compound_page() needn't check PageHead().

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-slab-remove-duplicate-check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-slab-remove-duplicate-check
+++ a/mm/page_alloc.c
@@ -368,8 +368,7 @@ static int destroy_compound_page(struct 
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


