From: akpm@linux-foundation.org
Subject: [merged] lib-scatterlist-add-simple-page-iterator.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:59 -0800
Message-ID: <20130228201059.B6CC931C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49813 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:01 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246121yhr.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@intel.com, daniel.vetter@ffwll.ch, maximlevitsky@gmail.com, swarren@wwwdotorg.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: add simple page iterator
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-add-simple-page-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Imre Deak <imre.deak@intel.com>
Subject: lib/scatterlist: add simple page iterator

Add an iterator to walk through a scatter list a page at a time starting
at a specific page offset.  As opposed to the mapping iterator this is
meant to be small, performing well even in simple loops like collecting
all pages on the scatterlist into an array or setting up an iommu table
based on the pages' DMA address.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |   35 +++++++++++++++++++++++++++++++
 lib/scatterlist.c           |   38 ++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff -puN include/linux/scatterlist.h~lib-scatterlist-add-simple-page-iterator include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-add-simple-page-iterator
+++ a/include/linux/scatterlist.h
@@ -231,6 +231,41 @@ size_t sg_copy_to_buffer(struct scatterl
  */
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
+/*
+ * sg page iterator
+ *
+ * Iterates over sg entries page-by-page.  On each successful iteration,
+ * @piter->page points to the current page, @piter->sg to the sg holding this
+ * page and @piter->sg_pgoffset to the page's page offset within the sg. The
+ * iteration will stop either when a maximum number of sg entries was reached
+ * or a terminating sg (sg_last(sg) == true) was reached.
+ */
+struct sg_page_iter {
+	struct page		*page;		/* current page */
+	struct scatterlist	*sg;		/* sg holding the page */
+	unsigned int		sg_pgoffset;	/* page offset within the sg */
+
+	/* these are internal states, keep away */
+	unsigned int		__nents;	/* remaining sg entries */
+	int			__pg_advance;	/* nr pages to advance at the
+						 * next step */
+};
+
+bool __sg_page_iter_next(struct sg_page_iter *piter);
+void __sg_page_iter_start(struct sg_page_iter *piter,
+			  struct scatterlist *sglist, unsigned int nents,
+			  unsigned long pgoffset);
+
+/**
+ * for_each_sg_page - iterate over the pages of the given sg list
+ * @sglist:	sglist to iterate over
+ * @piter:	page iterator to hold current page, sg, sg_pgoffset
+ * @nents:	maximum number of sg entries to iterate over
+ * @pgoffset:	starting page offset
+ */
+#define for_each_sg_page(sglist, piter, nents, pgoffset)		   \
+	for (__sg_page_iter_start((piter), (sglist), (nents), (pgoffset)); \
+	     __sg_page_iter_next(piter);)
 
 /*
  * Mapping sg iterator
diff -puN lib/scatterlist.c~lib-scatterlist-add-simple-page-iterator lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-add-simple-page-iterator
+++ a/lib/scatterlist.c
@@ -394,6 +394,44 @@ int sg_alloc_table_from_pages(struct sg_
 }
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
+void __sg_page_iter_start(struct sg_page_iter *piter,
+			  struct scatterlist *sglist, unsigned int nents,
+			  unsigned long pgoffset)
+{
+	piter->__pg_advance = 0;
+	piter->__nents = nents;
+
+	piter->page = NULL;
+	piter->sg = sglist;
+	piter->sg_pgoffset = pgoffset;
+}
+EXPORT_SYMBOL(__sg_page_iter_start);
+
+static int sg_page_count(struct scatterlist *sg)
+{
+	return PAGE_ALIGN(sg->offset + sg->length) >> PAGE_SHIFT;
+}
+
+bool __sg_page_iter_next(struct sg_page_iter *piter)
+{
+	if (!piter->__nents || !piter->sg)
+		return false;
+
+	piter->sg_pgoffset += piter->__pg_advance;
+	piter->__pg_advance = 1;
+
+	while (piter->sg_pgoffset >= sg_page_count(piter->sg)) {
+		piter->sg_pgoffset -= sg_page_count(piter->sg);
+		piter->sg = sg_next(piter->sg);
+		if (!--piter->__nents || !piter->sg)
+			return false;
+	}
+	piter->page = nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+
+	return true;
+}
+EXPORT_SYMBOL(__sg_page_iter_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
_

Patches currently in -mm which might be from imre.deak@intel.com are

origin.patch

