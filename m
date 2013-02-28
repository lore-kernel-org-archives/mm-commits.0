From: akpm@linux-foundation.org
Subject: [folded-dropped] lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:38:39 -0800
Message-ID: <20130228003839.AC9A631C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:34012 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3B1Ail (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:38:41 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so138505vea.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:38:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@intel.com, daniel.vetter@ffwll.ch, james.hogan@imgtec.com, maximlevitsky@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: use page iterator in the mapping iterator
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix.patch

This patch was dropped because it was folded into lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

------------------------------------------------------
From: Imre Deak <imre.deak@intel.com>
Subject: lib/scatterlist: use page iterator in the mapping iterator

- The dw_mmc driver used sg_mapping_iter::__sg, which was marked as
  internal and moved by this patch to the new sg_page_iter struct.  This
  caused a compile time breakage for the driver.  Fix this by making
  sg_mapping_iter::piter a public interface and making the driver use
  sg_mapping_iter::piter.sg instead of sg_mapping_iter::__sg.  Thanks to
  James Hogan for pointing this out.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: James Hogan <james.hogan@imgtec.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/dw_mmc.c   |    4 ++--
 include/linux/scatterlist.h |    2 +-
 lib/scatterlist.c           |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/dw_mmc.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix drivers/mmc/host/dw_mmc.c
--- a/drivers/mmc/host/dw_mmc.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix
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
diff -puN include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix
+++ a/include/linux/scatterlist.h
@@ -293,10 +293,10 @@ struct sg_mapping_iter {
 	void			*addr;		/* pointer to the mapped area */
 	size_t			length;		/* length of the mapped area */
 	size_t			consumed;	/* number of consumed bytes */
+	struct sg_page_iter	piter;		/* page iterator */
 
 	/* these are internal states, keep away */
 	unsigned int		__offset;	/* offset within page */
-	struct sg_page_iter	__piter;	/* page iterator */
 	unsigned int		__remaining;	/* remaining bytes on page */
 	unsigned int		__flags;
 };
diff -puN lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix
+++ a/lib/scatterlist.c
@@ -449,7 +449,7 @@ void sg_miter_start(struct sg_mapping_it
 {
 	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
-	__sg_page_iter_start(&miter->__piter, sgl, nents, 0);
+	__sg_page_iter_start(&miter->piter, sgl, nents, 0);
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
@@ -484,17 +484,17 @@ bool sg_miter_next(struct sg_mapping_ite
 		struct scatterlist *sg;
 		unsigned long pgoffset;
 
-		if (!__sg_page_iter_next(&miter->__piter))
+		if (!__sg_page_iter_next(&miter->piter))
 			return false;
 
-		sg = miter->__piter.sg;
-		pgoffset = miter->__piter.sg_pgoffset;
+		sg = miter->piter.sg;
+		pgoffset = miter->piter.sg_pgoffset;
 
 		miter->__offset = pgoffset ? 0 : sg->offset;
 		miter->__remaining = sg->offset + sg->length -
 				(pgoffset << PAGE_SHIFT) - miter->__offset;
 	}
-	miter->page = miter->__piter.page;
+	miter->page = miter->piter.page;
 	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
_

Patches currently in -mm which might be from imre.deak@intel.com are

origin.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch

