From: akpm@linux-foundation.org
Subject: + drivers-block-brdc-fix-brd_lookup_page-race.patch added to -mm
 tree
Date: Wed, 22 May 2013 14:48:33 -0700
Message-ID: <519d3d31.wZzfH4/59zC8BVO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3EVVse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, cw@f00f.org, axboe@kernel.dk, behlendorf1@llnl.gov

Subject: + drivers-block-brdc-fix-brd_lookup_page-race.patch added to -mm tree
To: behlendorf1@llnl.gov,axboe@kernel.dk,cw@f00f.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:48:33 -0700


The patch titled
     Subject: drivers/block/brd.c: fix brd_lookup_page() race
has been added to the -mm tree.  Its filename is
     drivers-block-brdc-fix-brd_lookup_page-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Behlendorf <behlendorf1@llnl.gov>
Subject: drivers/block/brd.c: fix brd_lookup_page() race

The index on the page must be set before it is inserted in the radix tree.
Otherwise there is a small race which can occur during lookup where the
page can be found with the incorrect index.  This will trigger the
BUG_ON() in brd_lookup_page().

Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>
Reported-by: Chris Wedgwood <cw@f00f.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/brd.c~drivers-block-brdc-fix-brd_lookup_page-race drivers/block/brd.c
--- a/drivers/block/brd.c~drivers-block-brdc-fix-brd_lookup_page-race
+++ a/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(stru
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
+	page->index = idx;
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
 		BUG_ON(!page);
 		BUG_ON(page->index != idx);
-	} else
-		page->index = idx;
+	}
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
_

Patches currently in -mm which might be from behlendorf1@llnl.gov are

drivers-block-brdc-fix-brd_lookup_page-race.patch

