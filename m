Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E90D7D3FA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104014; cv=none; b=CMMdzcoP8hQTohRX9nZ4RoEOlTAKF/Jz51ggRBIEQjMyP/ClqMfiPalDoh7br2sOa7ateOx2RNBimjyGwHcENNMzQm2ZE9BX6YGcl4qCMVusITDxLIpJRTkde3wva1coR66H/PGMtdDqj0kRW2FQZ2gaczuFOgxe+XLe7aDuUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104014; c=relaxed/simple;
	bh=vmNwDb1N/ttYpG3IzrOI+ukRQrKMG/EMByOjm7MInEk=;
	h=Date:To:From:Subject:Message-Id; b=UdW4g3Jwriv3I8ohKwo4TK7uWkbT/PqApKYO3aeUrP6Tsg4nn6cugy9GYvZkK4jj9sJqAo5xkNLldJVnZqNI9p/2+fTZsDNV8aHnmc+1IxbzWzV+YDH65RW77HT6Z6wPc+fA3micvUazJYWkDsWBClPvGA51jGJ2C3svNMVrkbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwDimg/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwDimg/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C56C116B1;
	Fri, 26 Apr 2024 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104014;
	bh=vmNwDb1N/ttYpG3IzrOI+ukRQrKMG/EMByOjm7MInEk=;
	h=Date:To:From:Subject:From;
	b=KwDimg/6M2BYOZbfcmfcMw37JFTfuwiVOiJtzKosEaK7rqwSMG+HiaSCCswu6UWFe
	 OhGiXHN5HNGUScZ/7CKqGiSqixTlM6Oisd+T864Iq8N6kAwzY0JM3MbUlxp79vr7Vq
	 x3/cV+bRv3qiPMRS3lnAbHeEWGthocdLqm8CkcPc=
Date: Thu, 25 Apr 2024 21:00:13 -0700
To: mm-commits@vger.kernel.org,svetly.todorov@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch removed from -mm tree
Message-Id: <20240426040014.44C56C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xtensa: remove uses of PG_arch_1 on individual pages
has been removed from the -mm tree.  Its filename was
     xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: xtensa: remove uses of PG_arch_1 on individual pages
Date: Tue, 26 Mar 2024 17:10:24 +0000

Since switching to the new page table range API, we disregard the
PG_arch_1 (aka dcache dirty) flag on tail pages, and only pay attention to
it on the folio.  Fix these two missed spots where we were setting it on
arbitrary pages.

Link: https://lkml.kernel.org/r/20240326171045.410737-3-willy@infradead.org
Reported-by: Svetly Todorov <svetly.todorov@memverge.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Svetly Todorov <svetly.todorov@memverge.com>	[xtensa]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/cache.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/xtensa/mm/cache.c~xtensa-remove-uses-of-pg_arch_1-on-individual-pages
+++ a/arch/xtensa/mm/cache.c
@@ -87,12 +87,13 @@ static inline void *coherent_kvaddr(stru
 
 void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
+	struct folio *folio = page_folio(page);
 	unsigned long paddr;
 	void *kvaddr = coherent_kvaddr(page, TLBTEMP_BASE_1, vaddr, &paddr);
 
 	preempt_disable();
 	kmap_invalidate_coherent(page, vaddr);
-	set_bit(PG_arch_1, &page->flags);
+	set_bit(PG_arch_1, folio_flags(folio, 0));
 	clear_page_alias(kvaddr, paddr);
 	preempt_enable();
 }
@@ -101,6 +102,7 @@ EXPORT_SYMBOL(clear_user_highpage);
 void copy_user_highpage(struct page *dst, struct page *src,
 			unsigned long vaddr, struct vm_area_struct *vma)
 {
+	struct folio *folio = page_folio(dst);
 	unsigned long dst_paddr, src_paddr;
 	void *dst_vaddr = coherent_kvaddr(dst, TLBTEMP_BASE_1, vaddr,
 					  &dst_paddr);
@@ -109,7 +111,7 @@ void copy_user_highpage(struct page *dst
 
 	preempt_disable();
 	kmap_invalidate_coherent(dst, vaddr);
-	set_bit(PG_arch_1, &dst->flags);
+	set_bit(PG_arch_1, folio_flags(folio, 0));
 	copy_page_alias(dst_vaddr, src_vaddr, dst_paddr, src_paddr);
 	preempt_enable();
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

