Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9E81CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824836; cv=none; b=EGjDAr7j32xBqoRQ+d44tzB5fr++GkO3lnqN6lLE5YAcohbw5K6KjVS7l1cXJbujFfw7TPJSfeR7lapQB6fcZk2I4V8q6yToQ/2PxeCsZ83zIicblS/MRjv/GmrGT78CcGWfYu1U6pcD6VHQJs02aj2HWfSpFnkiere7ks6mrH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824836; c=relaxed/simple;
	bh=SsOP7pAPEv3jhH7lNXpJ3yoXt5cUnqVXjdc1GTrDuws=;
	h=Date:To:From:Subject:Message-Id; b=NE+s7K3h+hMp9rOsgMkGntz1wMW3VPGJfMsnfYOf5rgB4s/GjJtSj6GfbZr+9IgriMLzBpz7clHutSIn46e9VG7lvDNQI4gQG4e/dxjoHdRSqQTJGLbCj/IREgLwy7y935LX7Z3ze/wt1dFRvRF/ClIED7Dmk0Dnq380hA1UR9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2g9hU2Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2g9hU2Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE1EC32782;
	Fri, 12 Jul 2024 22:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824836;
	bh=SsOP7pAPEv3jhH7lNXpJ3yoXt5cUnqVXjdc1GTrDuws=;
	h=Date:To:From:Subject:From;
	b=2g9hU2OdJPyy3+/DuozW0e4nhUDPIhBl9O1UPZBIuStE6xVAVBHiKcLPyC8Ab85g+
	 fwaI2CcM3Fx/ekCMObb3aGrtwxxMVBpkcN3Bw4ToeiXX3ZSlsKNybTjn+94XQWTMyB
	 0ItBLSuUf/mL0HxYrPSPzBB1ktvgFIHGoEYzsew0=
Date: Fri, 12 Jul 2024 15:53:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch removed from -mm tree
Message-Id: <20240712225356.3EE1EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: introduce unpin_folio/unpin_folios helpers
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/gup: introduce unpin_folio/unpin_folios helpers
Date: Sun, 23 Jun 2024 23:36:09 -0700

Patch series "mm/gup: Introduce memfd_pin_folios() for pinning memfd
folios", v16.

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


This patch (of 9):

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

Link: https://lkml.kernel.org/r/20240624063952.1572359-1-vivek.kasireddy@intel.com
Link: https://lkml.kernel.org/r/20240624063952.1572359-2-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
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
@@ -1584,11 +1584,13 @@ static inline void put_page(struct page
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
@@ -189,6 +189,19 @@ void unpin_user_page(struct page *page)
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
@@ -400,6 +413,40 @@ void unpin_user_pages(struct page **page
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


