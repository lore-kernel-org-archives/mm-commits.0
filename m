Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F5AD21
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628201; cv=none; b=WhkZ0S/QewApi7nXSSbJA6XgW6BvsUc0Q7ZOpiX40xeUZzgIxke+IVNZ/2oyN2/2RvNodX73AqqSi4uSx9kfdssmn+QelxyR/59m+So13hANLofR4H2x/oEODMyngW5QLpfHJ+mAQYixzTHVotmMAKyaAFx5msLmZet0lRb+H3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628201; c=relaxed/simple;
	bh=b+9AS39kc/47h4k3NXDnBRv223FgB3sj9OVjlTJILgE=;
	h=Date:To:From:Subject:Message-Id; b=LjG0+mkWMPXbt4KPdNIVFxm/BcYfWcf0jEfx4/dTULrE1anPlK/6WxRMvD/NQyWBk+a58I0JSM8/CAzWpq9pKfizkFozFvBjVK/qDOHPBiUeN9Y8oT3FasvBtB7A+31qxUmYD6jZSiQ66syPcSMizHwtrdZab4CYRD8JVRIBIcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q+HZxgdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q+HZxgdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D262C116B1;
	Sat, 29 Jun 2024 02:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628201;
	bh=b+9AS39kc/47h4k3NXDnBRv223FgB3sj9OVjlTJILgE=;
	h=Date:To:From:Subject:From;
	b=q+HZxgdxWflsDWFChfgviHcKHazLmRWBELRIFQdlmznVOVigHdFYfwGJ3DkNJ40mA
	 aQ+0+sPPMyqf9VXYlMDcnVMHzDa5UO3B1lc8mvkEluNLsS/wfmnfE6ryAlak4pPI3a
	 SrqlEM9B+S5rxvHTI6RUsIZFJLOlhaaiGYHgsNi8=
Date: Fri, 28 Jun 2024 19:30:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_maybe_dma_pinned.patch removed from -mm tree
Message-Id: <20240629023001.9D262C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_maybe_dma_pinned()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_maybe_dma_pinned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove page_maybe_dma_pinned()
Date: Tue, 4 Jun 2024 19:48:20 +0800

After the last user of page_maybe_dma_pinned() is converted to
folio_maybe_dma_pinned(), remove page_maybe_dma_pinned() and update the
document and comment.

[wangkefeng.wang@huawei.com: fix pin_user_pages.rst underlining]
  Link: https://lkml.kernel.org/r/61b256c7-4989-44ec-83db-f34a1bd4be2d@huawei.com
Link: https://lkml.kernel.org/r/20240604114822.2089819-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   12 ++++++------
 include/linux/mm.h                        |    9 ++-------
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_maybe_dma_pinned
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -196,20 +196,20 @@ INCORRECT (uses FOLL_GET calls):
     write to the data within the pages
     put_page()
 
-page_maybe_dma_pinned(): the whole point of pinning
-===================================================
+folio_maybe_dma_pinned(): the whole point of pinning
+====================================================
 
-The whole point of marking pages as "DMA-pinned" or "gup-pinned" is to be able
-to query, "is this page DMA-pinned?" That allows code such as page_mkclean()
+The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
+to query, "is this folio DMA-pinned?" That allows code such as page_mkclean()
 (and file system writeback code in general) to make informed decisions about
-what to do when a page cannot be unmapped due to such pins.
+what to do when a folio cannot be unmapped due to such pins.
 
 What to do in those cases is the subject of a years-long series of discussions
 and debates (see the References at the end of this document). It's a TODO item
 here: fill in the details once that's worked out. Meanwhile, it's safe to say
 that having this available: ::
 
-        static inline bool page_maybe_dma_pinned(struct page *page)
+        static inline bool folio_maybe_dma_pinned(struct folio *folio)
 
 ...is a prerequisite to solving the long-running gup+DMA problem.
 
--- a/include/linux/mm.h~mm-remove-page_maybe_dma_pinned
+++ a/include/linux/mm.h
@@ -1918,8 +1918,8 @@ static inline struct folio *pfn_folio(un
  *
  * For more information, please see Documentation/core-api/pin_user_pages.rst.
  *
- * Return: True, if it is likely that the page has been "dma-pinned".
- * False, if the page is definitely not dma-pinned.
+ * Return: True, if it is likely that the folio has been "dma-pinned".
+ * False, if the folio is definitely not dma-pinned.
  */
 static inline bool folio_maybe_dma_pinned(struct folio *folio)
 {
@@ -1938,11 +1938,6 @@ static inline bool folio_maybe_dma_pinne
 		GUP_PIN_COUNTING_BIAS;
 }
 
-static inline bool page_maybe_dma_pinned(struct page *page)
-{
-	return folio_maybe_dma_pinned(page_folio(page));
-}
-
 /*
  * This should most likely only be called during fork() to see whether we
  * should break the cow immediately for an anon page on the src mm.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

