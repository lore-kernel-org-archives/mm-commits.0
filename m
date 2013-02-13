From: akpm@linux-foundation.org
Subject: + lib-scatterlist-add-simple-page-iterator.patch added to -mm tree
Date: Wed, 13 Feb 2013 15:20:27 -0800
Message-ID: <20130213232028.501CD31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:43417 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab3BMXU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 18:20:29 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so183603vch.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 15:20:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@intel.com, daniel.vetter@ffwll.ch, maximlevitsky@gmail.com, tj@kernel.org


The patch titled
     Subject: lib/scatterlist: add simple page iterator
has been added to the -mm tree.  Its filename is
     lib-scatterlist-add-simple-page-iterator.patch

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

linux-next.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

