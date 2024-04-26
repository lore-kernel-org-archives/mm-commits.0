Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65DF80C16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104155; cv=none; b=L9G+5zSFqXEKxrZsOp9HMEHXn8y9aUUySn/s0WwBfXhgrZs1Rj9jdftlt0SIeBgUE9Mvu9+X1tl3nQXIIa71owimllfvF8fX9ES4TraLGxmxdq60xHAcXyBBPYZDB3SXmkkwmK7dPCdKx6YSj0yA4Gzm++XZjOXZcJo2BrdwkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104155; c=relaxed/simple;
	bh=k5vpokQNDbyKZqW349/CG57XkJCKS6bF5iFdGGcxhyo=;
	h=Date:To:From:Subject:Message-Id; b=WpNyG8xRhgQfbUTYdCrKgbZIHUmCxeMVzWsukwUgMFRCkvo+RY7RMzxOTB9vlCBa0YEXU6a/tuxHc0bQTg2w4zk50yRjW1fQ8C94P+/KIVLy3opaKpjPi5lhuCceD5fxpSf+DfPIYRzb34Nl172xoATuxiIzzOpKfpeXG/O5Zuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQAu1Mgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQAu1Mgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B252C116B1;
	Fri, 26 Apr 2024 04:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104155;
	bh=k5vpokQNDbyKZqW349/CG57XkJCKS6bF5iFdGGcxhyo=;
	h=Date:To:From:Subject:From;
	b=ZQAu1MghVJ1bdrxxcujeaOMmlxLxVcnMNbLkh/FeSOz6oWvZ3htMwwlbtoFAc4m0F
	 56W6XPuZhxZ5wHlzK2fpkUXBuXCRGarCjB0mBYYJlkmBs4XtTil0lBW+6q0JQoudwF
	 A9gBoTBDONSWlqbraajyqJi38sLXXF51WfwMzNT0=
Date: Thu, 25 Apr 2024 21:02:35 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-struct-page-from-get_shadow_from_swap_cache.patch removed from -mm tree
Message-Id: <20240426040235.8B252C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove struct page from get_shadow_from_swap_cache
has been removed from the -mm tree.  Its filename was
     mm-remove-struct-page-from-get_shadow_from_swap_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove struct page from get_shadow_from_swap_cache
Date: Tue, 2 Apr 2024 21:16:57 +0100

We don't actually use any parts of struct page; all we do is check the
value of the pointer.  So give the pointer the appropriate name & type.

Link: https://lkml.kernel.org/r/20240402201659.918308-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swap_state.c~mm-remove-struct-page-from-get_shadow_from_swap_cache
+++ a/mm/swap_state.c
@@ -73,11 +73,11 @@ void *get_shadow_from_swap_cache(swp_ent
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
-	struct page *page;
+	void *shadow;
 
-	page = xa_load(&address_space->i_pages, idx);
-	if (xa_is_value(page))
-		return page;
+	shadow = xa_load(&address_space->i_pages, idx);
+	if (xa_is_value(shadow))
+		return shadow;
 	return NULL;
 }
 
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

