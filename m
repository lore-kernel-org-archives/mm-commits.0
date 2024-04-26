Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2597F7F2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104047; cv=none; b=JAkEeIYrK59eGO2lkXT/DVer64t3y/vEc0WcaNZn/5j4UT82B/ct6fkjxI/Uyy9P7x/Ces040vm6JZbkSTCDMo8qK4t2ZVjP+MQjX0TxAIEyEFZoXaLFu4J1Q2zwV+9YAVwSETrgCvhMvxJCF9PjxVnzAvGuOYrUVG4eZAkxjdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104047; c=relaxed/simple;
	bh=HSctK7SJ15sQJA/01VthsMceKcSi3u7dbqP6eqh6bUY=;
	h=Date:To:From:Subject:Message-Id; b=ql0rU6zugSPupyCzcRk3sEpBbKPzdyPKyq10UsgNeCIi52FakUyBoZ7vwBP4UdwhKQtmoGqyyyGKkqQxw7TpSs+Uvp96J8hR8Lhip6ZhiSW29ZE3cEJKkjDByrDSWv1e9Y1z6wvC6m0sSFbpMaSBYMybgf9CiUAJo/gwKhUHuQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BqLGNMd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BqLGNMd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A34C113CD;
	Fri, 26 Apr 2024 04:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104047;
	bh=HSctK7SJ15sQJA/01VthsMceKcSi3u7dbqP6eqh6bUY=;
	h=Date:To:From:Subject:From;
	b=BqLGNMd0wKQGB4IB5+6Sz5MWX8swIKx0v3tKYGTB9GSeN4jbFjfTP4QHtMyz3+Yi9
	 mDVQk95dUuzYDHGOnvOTIFzh/3vmGTnN+ST/vPp8oHYO5mrhSVkaTxvZ9hDQdS2XCQ
	 oYucAlCd7/FHf4o/eMBEx7a2jfE3lD/Qve/93Qpw=
Date: Thu, 25 Apr 2024 21:00:46 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-use-huge_zero_folio.patch removed from -mm tree
Message-Id: <20240426040046.E6A34C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: use huge_zero_folio
has been removed from the -mm tree.  Its filename was
     dax-use-huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: dax: use huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:27 +0000

Convert from huge_zero_page to huge_zero_folio.

Link: https://lkml.kernel.org/r/20240326202833.523759-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                      |   14 +++++++-------
 include/trace/events/fs_dax.h |   16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/dax.c~dax-use-huge_zero_folio
+++ a/fs/dax.c
@@ -1207,17 +1207,17 @@ static vm_fault_t dax_pmd_load_hole(stru
 	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = mapping->host;
 	pgtable_t pgtable = NULL;
-	struct page *zero_page;
+	struct folio *zero_folio;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
 	pfn_t pfn;
 
-	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
+	zero_folio = mm_get_huge_zero_folio(vmf->vma->vm_mm);
 
-	if (unlikely(!zero_page))
+	if (unlikely(!zero_folio))
 		goto fallback;
 
-	pfn = page_to_pfn_t(zero_page);
+	pfn = page_to_pfn_t(&zero_folio->page);
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
 				  DAX_PMD | DAX_ZERO_PAGE);
 
@@ -1237,17 +1237,17 @@ static vm_fault_t dax_pmd_load_hole(stru
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
-	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
+	pmd_entry = mk_pmd(&zero_folio->page, vmf->vma->vm_page_prot);
 	pmd_entry = pmd_mkhuge(pmd_entry);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
-	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
+	trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
 	return VM_FAULT_NOPAGE;
 
 fallback:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, *entry);
+	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_folio, *entry);
 	return VM_FAULT_FALLBACK;
 }
 #else
--- a/include/trace/events/fs_dax.h~dax-use-huge_zero_folio
+++ a/include/trace/events/fs_dax.h
@@ -62,14 +62,14 @@ DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_don
 
 DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		struct page *zero_page,
+		struct folio *zero_folio,
 		void *radix_entry),
-	TP_ARGS(inode, vmf, zero_page, radix_entry),
+	TP_ARGS(inode, vmf, zero_folio, radix_entry),
 	TP_STRUCT__entry(
 		__field(unsigned long, ino)
 		__field(unsigned long, vm_flags)
 		__field(unsigned long, address)
-		__field(struct page *, zero_page)
+		__field(struct folio *, zero_folio)
 		__field(void *, radix_entry)
 		__field(dev_t, dev)
 	),
@@ -78,17 +78,17 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_cl
 		__entry->ino = inode->i_ino;
 		__entry->vm_flags = vmf->vma->vm_flags;
 		__entry->address = vmf->address;
-		__entry->zero_page = zero_page;
+		__entry->zero_folio = zero_folio;
 		__entry->radix_entry = radix_entry;
 	),
-	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_page %p "
+	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_folio %p "
 			"radix_entry %#lx",
 		MAJOR(__entry->dev),
 		MINOR(__entry->dev),
 		__entry->ino,
 		__entry->vm_flags & VM_SHARED ? "shared" : "private",
 		__entry->address,
-		__entry->zero_page,
+		__entry->zero_folio,
 		(unsigned long)__entry->radix_entry
 	)
 )
@@ -96,8 +96,8 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_cl
 #define DEFINE_PMD_LOAD_HOLE_EVENT(name) \
 DEFINE_EVENT(dax_pmd_load_hole_class, name, \
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		struct page *zero_page, void *radix_entry), \
-	TP_ARGS(inode, vmf, zero_page, radix_entry))
+		struct folio *zero_folio, void *radix_entry), \
+	TP_ARGS(inode, vmf, zero_folio, radix_entry))
 
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
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

