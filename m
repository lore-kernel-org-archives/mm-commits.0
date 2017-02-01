From: akpm@linux-foundation.org
Subject: + scatterlist-dont-overflow-length-field.patch added to -mm tree
Date: Wed, 01 Feb 2017 14:09:33 -0800
Message-ID: <58925c9d.YCnDufahVCW1lTpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBAWJf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 17:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dillow@google.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: don't overflow length field
has been added to the -mm tree.  Its filename is
     scatterlist-dont-overflow-length-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scatterlist-dont-overflow-length-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scatterlist-dont-overflow-length-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Dillow <dillow@google.com>
Subject: scatterlist: don't overflow length field

When called with a region of contiguous pages totaling > 4 GB of memory,
sg_alloc_table_from_pages() will overflow the length field, leading to a
corrupt scatter list. Fix this by tracking the number of pages we've
merged and start a new chunk when we would overflow.

Tested by building various page lists with contiguous 8GB regions and
observing that they are correctly split without overflowing length.

Link: http://lkml.kernel.org/r/20170201212917.11278-1-dillow@google.com
Signed-off-by: David Dillow <dillow@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-dont-overflow-length-field lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-dont-overflow-length-field
+++ a/lib/scatterlist.c
@@ -394,17 +394,26 @@ int sg_alloc_table_from_pages(struct sg_
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask)
 {
+	unsigned int chunk_pages;
 	unsigned int chunks;
 	unsigned int i;
 	unsigned int cur_page;
 	int ret;
 	struct scatterlist *s;
 
+	BUILD_BUG_ON(!typecheck(typeof(s->length), unsigned int));
+
 	/* compute number of contiguous chunks */
 	chunks = 1;
-	for (i = 1; i < n_pages; ++i)
-		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
+	chunk_pages = 1;
+	for (i = 1; i < n_pages; ++i) {
+		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1 ||
+		    chunk_pages >= UINT_MAX >> PAGE_SHIFT) {
 			++chunks;
+			chunk_pages = 0;
+		}
+		++chunk_pages;
+	}
 
 	ret = sg_alloc_table(sgt, chunks, gfp_mask);
 	if (unlikely(ret))
@@ -417,10 +426,15 @@ int sg_alloc_table_from_pages(struct sg_
 		unsigned int j;
 
 		/* look for the end of the current chunk */
-		for (j = cur_page + 1; j < n_pages; ++j)
+		chunk_pages = 1;
+		for (j = cur_page + 1; j < n_pages; ++j) {
 			if (page_to_pfn(pages[j]) !=
-			    page_to_pfn(pages[j - 1]) + 1)
+			    page_to_pfn(pages[j - 1]) + 1 ||
+			    chunk_pages >= UINT_MAX >> PAGE_SHIFT) {
 				break;
+			}
+			++chunk_pages;
+		}
 
 		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
 		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
_

Patches currently in -mm which might be from dillow@google.com are

scatterlist-dont-overflow-length-field.patch

