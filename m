From: akpm@linux-foundation.org
Subject: + mm-slab-remove-duplicate-check.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:56:02 -0700
Message-ID: <20120820225603.1155B200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61014 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:56:06 -0400
Received: by faem1 with SMTP id m1so225227fae.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:56:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, penberg@cs.helsinki.fi


The patch titled
     Subject: mm/page_alloc.c: remove duplicate check
has been added to the -mm tree.  Its filename is
     mm-slab-remove-duplicate-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab-remove-duplicate-check.patch

