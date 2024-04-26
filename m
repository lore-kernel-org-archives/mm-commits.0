Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329397F464
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104074; cv=none; b=CAHCCBoLZydXmclmPryzt+UH1QmAqjYUW1tsj9CWbvFqcE6/PZn2tX7BjG9127qxQ0l/pQlUof4Ls7WSv4DOK9f2oDA/7tfu0lAkS2jAGkZNRmULM8nrYOgjGcUpO4q/IAqNzLynkaa71qQPSy8cKkgH4wDCKRvrBJowgBU2YPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104074; c=relaxed/simple;
	bh=8VHWEfLOtba4iLumPXIkppYn0ZTRqCY9V7xfBWk5fLc=;
	h=Date:To:From:Subject:Message-Id; b=oMPtkjnSzk1Qc11H50yI5RswpHEg/ew7Sr7BF7hNaL3yj/WIj2co5hn9ijfdFpnyYtnlffRePaNs2+FAbXUI5od/x460WkHgY5mOFV+BB82hNhcOIyEd/kYFA43gJ1lqHVIGyjK0TkqZhKmXEVfEQWO2pYn9dGI7hVfzdSHlrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nXMvJ4WA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nXMvJ4WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0883CC116B1;
	Fri, 26 Apr 2024 04:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104074;
	bh=8VHWEfLOtba4iLumPXIkppYn0ZTRqCY9V7xfBWk5fLc=;
	h=Date:To:From:Subject:From;
	b=nXMvJ4WAR6uBbHhh8XRHcOKHj/nC2q8PLGFuwMDU2lSIOjVptmbrv4rz48xV4esgx
	 cCrRLmY8j6lGhOChC9tyAbLS4nTZ3YwAML+LV5MWdQrlt24ZxV3xFdPeV/evBc0kLF
	 x8B42PlPM8BHn2xmZfh+kKaSbOLHH6kFSsDUApa0=
Date: Thu, 25 Apr 2024 21:01:13 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-__set_page_dirty.patch removed from -mm tree
Message-Id: <20240426040114.0883CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove __set_page_dirty()
has been removed from the -mm tree.  Its filename was
     filemap-remove-__set_page_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove __set_page_dirty()
Date: Wed, 27 Mar 2024 18:54:29 +0000

All callers have been converted to use folios; remove this wrapper.

Link: https://lkml.kernel.org/r/20240327185447.1076689-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-__set_page_dirty
+++ a/include/linux/pagemap.h
@@ -1147,11 +1147,6 @@ void folio_end_writeback(struct folio *f
 void wait_for_stable_page(struct page *page);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
-static inline void __set_page_dirty(struct page *page,
-		struct address_space *mapping, int warn)
-{
-	__folio_mark_dirty(page_folio(page), mapping, warn);
-}
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

