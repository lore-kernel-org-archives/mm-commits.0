From: akpm@linux-foundation.org
Subject: [merged] aoe-adjust-ref-of-head-for-compound-page-tails.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:34 -0700
Message-ID: <520bdc06.UaWRzCQdIpsmdy04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab3HNTff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: [merged] aoe-adjust-ref-of-head-for-compound-page-tails.patch removed from -mm tree
To: ecashin@coraid.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:34 -0700


The patch titled
     Subject: aoe: adjust ref of head for compound page tails
has been removed from the -mm tree.  Its filename was
     aoe-adjust-ref-of-head-for-compound-page-tails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: adjust ref of head for compound page tails

Fix a BUG which can trigger when direct-IO is used with AOE.

As discussed previously, the fact that some users of the block layer
provide bios that point to pages with a zero _count means that it is not
OK for the network layer to do a put_page on the skb frags during an
skb_linearize, so the aoe driver gets a reference to pages in bios and
puts the reference before ending the bio.  And because it cannot use
get_page on a page with a zero _count, it manipulates the value directly.

It is not OK to increment the _count of a compound page tail, though,
since the VM layer will VM_BUG_ON a non-zero _count.  Block users that do
direct I/O can result in the aoe driver seeing compound page tails in
bios.  In that case, the same logic works as long as the head of the
compound page is used instead of the tails.  This patch handles compound
pages and does not BUG.

It relies on the block layer user leaving the relationship between the
page tail and its head alone for the duration between the submission of
the bio and its completion, whether successful or not.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-adjust-ref-of-head-for-compound-page-tails drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-adjust-ref-of-head-for-compound-page-tails
+++ a/drivers/block/aoe/aoecmd.c
@@ -906,16 +906,10 @@ bio_pageinc(struct bio *bio)
 	int i;
 
 	bio_for_each_segment(bv, bio, i) {
-		page = bv->bv_page;
 		/* Non-zero page count for non-head members of
-		 * compound pages is no longer allowed by the kernel,
-		 * but this has never been seen here.
+		 * compound pages is no longer allowed by the kernel.
 		 */
-		if (unlikely(PageCompound(page)))
-			if (compound_trans_head(page) != page) {
-				pr_crit("page tail used for block I/O\n");
-				BUG();
-			}
+		page = compound_trans_head(bv->bv_page);
 		atomic_inc(&page->_count);
 	}
 }
@@ -924,10 +918,13 @@ static void
 bio_pagedec(struct bio *bio)
 {
 	struct bio_vec *bv;
+	struct page *page;
 	int i;
 
-	bio_for_each_segment(bv, bio, i)
-		atomic_dec(&bv->bv_page->_count);
+	bio_for_each_segment(bv, bio, i) {
+		page = compound_trans_head(bv->bv_page);
+		atomic_dec(&page->_count);
+	}
 }
 
 static void
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

