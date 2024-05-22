Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36CA3F
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716415662; cv=none; b=sJkWJV4kmPiI2MWVnelQvT9LhGI/iwIBwoErHtZGIbJtqUSX+fVV6RGsFNl4FDE9CEVxvfVrx9W5rf6WmFHLVT0X3/dXKAU2oW84d1CigZn+iI9+rNxypeYUuH6/KbCucgsBOSX3jMVlT6KHQYfyjiag55GWkBwqLSMGJdKAC2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716415662; c=relaxed/simple;
	bh=x9xHsAexKxQS0BJlc5C8MxeO+cQy6ZQroNedR9XUxYQ=;
	h=Date:To:From:Subject:Message-Id; b=gBAytLcJtHUGOaghCfbytFPOIRiCg5euN4EYNRd/U/jqlgKvMWM7P4LKpTf+w+aieG5X7BXTi+8jMp8yxbxR6NlxURTaB2YbusPBpkviJ2Gkq2PWdWMTcFY6OI/PpT8/IG996E6KwsGFZmPXhbAEdLagpytpG5sK34ZK1dmoyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvAnO5Dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvAnO5Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C75CC2BBFC;
	Wed, 22 May 2024 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716415661;
	bh=x9xHsAexKxQS0BJlc5C8MxeO+cQy6ZQroNedR9XUxYQ=;
	h=Date:To:From:Subject:From;
	b=zvAnO5DggE+bDoEftdYE2psAxRPWtY6I8K2LZchIlxIf/rlGLpwsHr/iDyFeEnCLO
	 U40h4ui2FVhQ4b9JfNaxtsdgAtyqiY7a0JJO9ym8wcF+y+ApF6rD0DAtmnr/ZSo099
	 hqMGFbNkZVhqJqJ5+DAncbywuIhj8X0kNM2GeT6Q=
Date: Wed, 22 May 2024 15:07:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch added to mm-unstable branch
Message-Id: <20240522220741.5C75CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: introduce unpin_folio/unpin_folios helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/gup: introduce unpin_folio/unpin_folios helpers
Date: Wed, 10 Apr 2024 23:59:37 -0700

Patch series "mm/gup: Introduce memfd_pin_folios() for pinning memfd
folios", v14.

Currently, some drivers (e.g, Udmabuf) that want to longterm-pin the
pages/folios associated with a memfd, do so by simply taking a reference
on them.  This is not desirable because the pages/folios may reside in
Movable zone or CMA block.

Therefore, having drivers use memfd_pin_folios() API ensures that the
folios are appropriately pinned via FOLL_PIN for longterm DMA.

This patchset also introduces a few helpers and converts the Udmabuf
driver to use folios and memfd_pin_folios() API to longterm-pin the folios
for DMA.  Two new Udmabuf selftests are also included to test the driver
and the new API.


This patch (of 8):

These helpers are the folio versions of unpin_user_page/unpin_user_pages. 
They are currently only useful for unpinning folios pinned by
memfd_pin_folios() or other associated routines.  However, they could find
new uses in the future, when more and more folio-only helpers are added to
GUP.

We should probably sanity check the folio as part of unpin similar to how
it is done in unpin_user_page/unpin_user_pages but we cannot cleanly do
that at the moment without also checking the subpage.  Therefore, sanity
checking needs to be added to these routines once we have a way to
determine if any given folio is anon-exclusive (via a per folio
AnonExclusive flag).

Link: https://lkml.kernel.org/r/20240411070157.3318425-1-vivek.kasireddy@intel.com
Link: https://lkml.kernel.org/r/20240411070157.3318425-2-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/gup.c           |   47 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-unpin_folio-unpin_folios-helpers
+++ a/include/linux/mm.h
@@ -1613,11 +1613,13 @@ static inline void put_page(struct page
 #define GUP_PIN_COUNTING_BIAS (1U << 10)
 
 void unpin_user_page(struct page *page);
+void unpin_folio(struct folio *folio);
 void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
 				 bool make_dirty);
 void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 				      bool make_dirty);
 void unpin_user_pages(struct page **pages, unsigned long npages);
+void unpin_folios(struct folio **folios, unsigned long nfolios);
 
 static inline bool is_cow_mapping(vm_flags_t flags)
 {
--- a/mm/gup.c~mm-gup-introduce-unpin_folio-unpin_folios-helpers
+++ a/mm/gup.c
@@ -277,6 +277,19 @@ void unpin_user_page(struct page *page)
 EXPORT_SYMBOL(unpin_user_page);
 
 /**
+ * unpin_folio() - release a dma-pinned folio
+ * @folio:         pointer to folio to be released
+ *
+ * Folios that were pinned via memfd_pin_folios() or other similar routines
+ * must be released either using unpin_folio() or unpin_folios().
+ */
+void unpin_folio(struct folio *folio)
+{
+	gup_put_folio(folio, 1, FOLL_PIN);
+}
+EXPORT_SYMBOL_GPL(unpin_folio);
+
+/**
  * folio_add_pin - Try to get an additional pin on a pinned folio
  * @folio: The folio to be pinned
  *
@@ -488,6 +501,40 @@ void unpin_user_pages(struct page **page
 }
 EXPORT_SYMBOL(unpin_user_pages);
 
+/**
+ * unpin_folios() - release an array of gup-pinned folios.
+ * @folios:  array of folios to be marked dirty and released.
+ * @nfolios: number of folios in the @folios array.
+ *
+ * For each folio in the @folios array, release the folio using gup_put_folio.
+ *
+ * Please see the unpin_folio() documentation for details.
+ */
+void unpin_folios(struct folio **folios, unsigned long nfolios)
+{
+	unsigned long i = 0, j;
+
+	/*
+	 * If this WARN_ON() fires, then the system *might* be leaking folios
+	 * (by leaving them pinned), but probably not. More likely, gup/pup
+	 * returned a hard -ERRNO error to the caller, who erroneously passed
+	 * it here.
+	 */
+	if (WARN_ON(IS_ERR_VALUE(nfolios)))
+		return;
+
+	while (i < nfolios) {
+		for (j = i + 1; j < nfolios; j++)
+			if (folios[i] != folios[j])
+				break;
+
+		if (folios[i])
+			gup_put_folio(folios[i], j - i, FOLL_PIN);
+		i = j;
+	}
+}
+EXPORT_SYMBOL_GPL(unpin_folios);
+
 /*
  * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
  * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch
mm-gup-introduce-check_and_migrate_movable_folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

