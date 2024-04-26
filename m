Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1C47F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104129; cv=none; b=UuuSMyQrZnfPSPkMwa4OP6p8U1vAXxu4v3VIPTov1HbrBTFXfmKsZ+6LwxTI7O+obCirBPPIzckWLKuN9D8HBOjZpONbMm2P3ziRfnANJd+fpHAs+DEf3maL+N5xirOxAeazHpiaSsMcZ0xJ+Ei50SWOXeOXHdX4Lk8mgaHkWqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104129; c=relaxed/simple;
	bh=PH09xysiIWEAkMMZ2PG4dIKAFl05GTZX2ndmq8i9uVk=;
	h=Date:To:From:Subject:Message-Id; b=f6/sZPVaZOmZn5gZyq4pNB7W9Q0TkeiElBktFlDt50dSpXD+aZDocx/1cXkCweU/tQp6qwaRIOazCkYUFluJ46WC4HH9iUGcEv9Pg0sND1qcLpw4pA9FzPTHXAbji0tIBL5cZam45v9nxpWw6nu84G8cntbJBCanQJ2Uw1EMygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gKSxoHnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gKSxoHnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98B4C2BD11;
	Fri, 26 Apr 2024 04:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104128;
	bh=PH09xysiIWEAkMMZ2PG4dIKAFl05GTZX2ndmq8i9uVk=;
	h=Date:To:From:Subject:From;
	b=gKSxoHnRenwNOfMPKzONhCh/V6oopPXHVrrAHcPjj6vFAyvKhT9HyQn/+f1MJaihW
	 gk5lhsjqDI4Mdxq2g39qMvhCsz2d1F7+K/UF62dBW6+rWb7OA1WtV8m47EDjWG8HDY
	 y1RP7M3qZIM/PqRQ8yB5i9QXgKXgqkk0NApNzPUU=
Date: Thu, 25 Apr 2024 21:02:08 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_idle-and-page_young-wrappers.patch removed from -mm tree
Message-Id: <20240426040208.A98B4C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_idle and page_young wrappers
has been removed from the -mm tree.  Its filename was
     mm-remove-page_idle-and-page_young-wrappers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_idle and page_young wrappers
Date: Tue, 2 Apr 2024 21:12:50 +0100

All users have now been converted to the folio equivalents, so remove the
page wrappers.

Link: https://lkml.kernel.org/r/20240402201252.917342-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/include/linux/page_idle.h~mm-remove-page_idle-and-page_young-wrappers
+++ a/include/linux/page_idle.h
@@ -119,29 +119,4 @@ static inline void folio_clear_idle(stru
 }
 
 #endif /* CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool page_is_young(struct page *page)
-{
-	return folio_test_young(page_folio(page));
-}
-
-static inline void set_page_young(struct page *page)
-{
-	folio_set_young(page_folio(page));
-}
-
-static inline bool test_and_clear_page_young(struct page *page)
-{
-	return folio_test_clear_young(page_folio(page));
-}
-
-static inline bool page_is_idle(struct page *page)
-{
-	return folio_test_idle(page_folio(page));
-}
-
-static inline void set_page_idle(struct page *page)
-{
-	folio_set_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
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

