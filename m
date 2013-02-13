From: akpm@linux-foundation.org
Subject: + lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch added to -mm tree
Date: Wed, 13 Feb 2013 15:20:30 -0800
Message-ID: <20130213232031.4694D31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57645 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab3BMXUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 18:20:32 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so183078qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 15:20:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@intel.com, daniel.vetter@ffwll.ch, maximlevitsky@gmail.com, tj@kernel.org


The patch titled
     Subject: lib/scatterlist: use page iterator in the mapping iterator
has been added to the -mm tree.  Its filename is
     lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Imre Deak <imre.deak@intel.com>
Subject: lib/scatterlist: use page iterator in the mapping iterator

For better code reuse use the newly added page iterator to iterate through
the pages.  The offset, length within the page is still calculated by the
mapping iterator as well as the actual mapping.  Idea from Tejun Heo.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    6 ++--
 lib/scatterlist.c           |   48 +++++++++++++++-------------------
 2 files changed, 25 insertions(+), 29 deletions(-)

diff -puN include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator
+++ a/include/linux/scatterlist.h
@@ -295,9 +295,9 @@ struct sg_mapping_iter {
 	size_t			consumed;	/* number of consumed bytes */
 
 	/* these are internal states, keep away */
-	struct scatterlist	*__sg;		/* current entry */
-	unsigned int		__nents;	/* nr of remaining entries */
-	unsigned int		__offset;	/* offset within sg */
+	unsigned int		__offset;	/* offset within page */
+	struct sg_page_iter	__piter;	/* page iterator */
+	unsigned int		__remaining;	/* remaining bytes on page */
 	unsigned int		__flags;
 };
 
diff -puN lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator
+++ a/lib/scatterlist.c
@@ -449,9 +449,7 @@ void sg_miter_start(struct sg_mapping_it
 {
 	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
-	miter->__sg = sgl;
-	miter->__nents = nents;
-	miter->__offset = 0;
+	__sg_page_iter_start(&miter->__piter, sgl, nents, 0);
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
@@ -476,36 +474,33 @@ EXPORT_SYMBOL(sg_miter_start);
  */
 bool sg_miter_next(struct sg_mapping_iter *miter)
 {
-	unsigned int off, len;
-
-	/* check for end and drop resources from the last iteration */
-	if (!miter->__nents)
-		return false;
-
 	sg_miter_stop(miter);
 
-	/* get to the next sg if necessary.  __offset is adjusted by stop */
-	while (miter->__offset == miter->__sg->length) {
-		if (--miter->__nents) {
-			miter->__sg = sg_next(miter->__sg);
-			miter->__offset = 0;
-		} else
+	/*
+	 * Get to the next page if necessary.
+	 * __remaining, __offset is adjusted by sg_miter_stop
+	 */
+	if (!miter->__remaining) {
+		struct scatterlist *sg;
+		unsigned long pgoffset;
+
+		if (!__sg_page_iter_next(&miter->__piter))
 			return false;
-	}
 
-	/* map the next page */
-	off = miter->__sg->offset + miter->__offset;
-	len = miter->__sg->length - miter->__offset;
-
-	miter->page = nth_page(sg_page(miter->__sg), off >> PAGE_SHIFT);
-	off &= ~PAGE_MASK;
-	miter->length = min_t(unsigned int, len, PAGE_SIZE - off);
-	miter->consumed = miter->length;
+		sg = miter->__piter.sg;
+		pgoffset = miter->__piter.sg_pgoffset;
+
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+	}
+	miter->page = miter->__piter.page;
+	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page) + off;
+		miter->addr = kmap_atomic(miter->page) + miter->__offset;
 	else
-		miter->addr = kmap(miter->page) + off;
+		miter->addr = kmap(miter->page) + miter->__offset;
 
 	return true;
 }
@@ -532,6 +527,7 @@ void sg_miter_stop(struct sg_mapping_ite
 	/* drop resources from the last iteration */
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
+		miter->__remaining -= miter->consumed;
 
 		if (miter->__flags & SG_MITER_TO_SG)
 			flush_kernel_dcache_page(miter->page);
_

Patches currently in -mm which might be from imre.deak@intel.com are

linux-next.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

