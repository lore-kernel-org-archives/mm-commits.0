From: akpm@linux-foundation.org
Subject: + aoe-adjust-ref-of-head-for-compound-page-tails.patch added to
 -mm tree
Date: Wed, 07 Aug 2013 14:00:36 -0700
Message-ID: <5202b574.KT1T7jTnmhk1mvvd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGVAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-adjust-ref-of-head-for-compound-page-tails.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:00:36 -0700


The patch titled
     Subject: aoe: adjust ref of head for compound page tails
has been added to the -mm tree.  Its filename is
     aoe-adjust-ref-of-head-for-compound-page-tails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-adjust-ref-of-head-for-compound-page-tails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-adjust-ref-of-head-for-compound-page-tails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: adjust ref of head for compound page tails

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

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch
aoe-remove-custom-implementation-of-kbasename.patch
aoe-use-min-to-simplify-the-code.patch
aoe-adjust-ref-of-head-for-compound-page-tails.patch

