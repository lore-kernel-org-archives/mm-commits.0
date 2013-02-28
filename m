From: akpm@linux-foundation.org
Subject: [merged] lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:02 -0800
Message-ID: <20130228201102.D335F5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39247 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:04 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244481ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@intel.com, daniel.vetter@ffwll.ch, james.hogan@imgtec.com, maximlevitsky@gmail.com, swarren@wwwdotorg.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: use page iterator in the mapping iterator
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: James Hogan <james.hogan@imgtec.com> 
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/dw_mmc.c   |    4 +-
 include/linux/scatterlist.h |    6 ++--
 lib/scatterlist.c           |   50 ++++++++++++++++------------------
 3 files changed, 29 insertions(+), 31 deletions(-)

diff -puN drivers/mmc/host/dw_mmc.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator drivers/mmc/host/dw_mmc.c
--- a/drivers/mmc/host/dw_mmc.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator
+++ a/drivers/mmc/host/dw_mmc.c
@@ -1453,7 +1453,7 @@ static void dw_mci_read_data_pio(struct 
 		if (!sg_miter_next(sg_miter))
 			goto done;
 
-		host->sg = sg_miter->__sg;
+		host->sg = sg_miter->piter.sg;
 		buf = sg_miter->addr;
 		remain = sg_miter->length;
 		offset = 0;
@@ -1508,7 +1508,7 @@ static void dw_mci_write_data_pio(struct
 		if (!sg_miter_next(sg_miter))
 			goto done;
 
-		host->sg = sg_miter->__sg;
+		host->sg = sg_miter->piter.sg;
 		buf = sg_miter->addr;
 		remain = sg_miter->length;
 		offset = 0;
diff -puN include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator
+++ a/include/linux/scatterlist.h
@@ -293,11 +293,11 @@ struct sg_mapping_iter {
 	void			*addr;		/* pointer to the mapped area */
 	size_t			length;		/* length of the mapped area */
 	size_t			consumed;	/* number of consumed bytes */
+	struct sg_page_iter	piter;		/* page iterator */
 
 	/* these are internal states, keep away */
-	struct scatterlist	*__sg;		/* current entry */
-	unsigned int		__nents;	/* nr of remaining entries */
-	unsigned int		__offset;	/* offset within sg */
+	unsigned int		__offset;	/* offset within page */
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
+	__sg_page_iter_start(&miter->piter, sgl, nents, 0);
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
@@ -476,36 +474,35 @@ EXPORT_SYMBOL(sg_miter_start);
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
+		if (!__sg_page_iter_next(&miter->piter))
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
+		sg = miter->piter.sg;
+		pgoffset = miter->piter.sg_pgoffset;
+
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
+	}
+	miter->page = miter->piter.page;
+	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page) + off;
+		miter->addr = kmap_atomic(miter->page) + miter->__offset;
 	else
-		miter->addr = kmap(miter->page) + off;
+		miter->addr = kmap(miter->page) + miter->__offset;
 
 	return true;
 }
@@ -532,6 +529,7 @@ void sg_miter_stop(struct sg_mapping_ite
 	/* drop resources from the last iteration */
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
+		miter->__remaining -= miter->consumed;
 
 		if (miter->__flags & SG_MITER_TO_SG)
 			flush_kernel_dcache_page(miter->page);
_

Patches currently in -mm which might be from imre.deak@intel.com are

origin.patch

