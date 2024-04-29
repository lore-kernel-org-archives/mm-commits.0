Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64885C42
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714409176; cv=none; b=q3YkF/nOwgUrn1qr7HhhAXsf9IabaCC2i9KkHQfT477+nQ7N2nPW2RPF78vZ+ZcrdDXmmv6emDVl1dJUqag/2N0BDnQB2OhjYDQOZDlHcZHojKHt2eb/SGdc3tGk3zHsd8/8KmIHyxNNZ32OC5BivBkzw95IHDUlyhINjK9yNAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714409176; c=relaxed/simple;
	bh=Mp2aEq/u14UlnsoyMJYcOp9IfIUB9Qk+KQXa59rntv8=;
	h=Date:To:From:Subject:Message-Id; b=piXnei2GmbTREgJNtJn61lCAuOraj061XNMp/nC40yeYWAbT6mdsyUwwaLe6RQsHVZ9LVnv0c6iXvyfZZWFexyljXFSjgB0a+GE+/654vBXhx8omdIrmsnjE+Y67TA8FqqHf7rFi1cPy4RqbkpOz8JOkpu9tMg0vDkMoHoijT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzS1pvB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzS1pvB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967DEC4AF14;
	Mon, 29 Apr 2024 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714409175;
	bh=Mp2aEq/u14UlnsoyMJYcOp9IfIUB9Qk+KQXa59rntv8=;
	h=Date:To:From:Subject:From;
	b=RzS1pvB+sx4UYwKDtN/DfBXPYX9t1/hK8vv1OyjfBPkKv7xTF+k2ulkFk012F15sg
	 bjHLyDoKH8/dkFtrHrxwSllp8nHHQ04Hd6u608vIe9pp0mS8AmjoToyv/SnqcIGYMy
	 LWk9vTAySVS6TFr6cEA+x9/ZqIaFG4zKPXfuxwBU=
Date: Mon, 29 Apr 2024 09:46:14 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-page_mapping.patch removed from -mm tree
Message-Id: <20240429164615.967DEC4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_mapping()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_mapping.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_mapping()
Date: Tue, 23 Apr 2024 23:55:37 +0100

All callers are now converted, delete this compatibility wrapper.

Link: https://lkml.kernel.org/r/20240423225552.4113447-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-page_mapping
+++ a/include/linux/pagemap.h
@@ -399,7 +399,6 @@ static inline void filemap_nr_thps_dec(s
 #endif
 }
 
-struct address_space *page_mapping(struct page *);
 struct address_space *folio_mapping(struct folio *);
 struct address_space *swapcache_mapping(struct folio *);
 
--- a/mm/folio-compat.c~mm-remove-page_mapping
+++ a/mm/folio-compat.c
@@ -10,12 +10,6 @@
 #include <linux/swap.h>
 #include "internal.h"
 
-struct address_space *page_mapping(struct page *page)
-{
-	return folio_mapping(page_folio(page));
-}
-EXPORT_SYMBOL(page_mapping);
-
 void unlock_page(struct page *page)
 {
 	return folio_unlock(page_folio(page));
_

Patches currently in -mm which might be from willy@infradead.org are

bounds-use-the-right-number-of-bits-for-power-of-two-config_nr_cpus.patch
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
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch

