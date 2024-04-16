Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBA1CF8A
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297622; cv=none; b=CMANVuXDjIq7xIcJekuiFTm2yH+P6el5WhfO1XGdbpE0hj0OwNrKUDkX8Q7oUef1YIVAaiaGqCsTUd8MGqkk9XB99ZMqh8hhiDqQhANeqkubX8p6b3gv7vP2dKDOq8UVhkljO5QrV0/34StgPckfrfMEjzs6CK52fbHrtTg+j6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297622; c=relaxed/simple;
	bh=gAD2sE0U7K/adjjAKGKUaoKqSny/tDBC2jZK5+9XEnk=;
	h=Date:To:From:Subject:Message-Id; b=r4/3BPhO4esNHnSehZciH6ESejyjuU43eWXxqt7s5fJP4SbLHlOz+ZF6NpUa9dWV7v2i4QcyY1VwlldnvtOS57Bi9JEMuUe3NBDG4q9hz7vwMvnlueAJLH8e9fwXxmKbEIk34xTOjZOM8AFvDI9/9dyo1VkXLCtIpVQf9nNtNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ApckshxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ApckshxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03831C113CE;
	Tue, 16 Apr 2024 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297622;
	bh=gAD2sE0U7K/adjjAKGKUaoKqSny/tDBC2jZK5+9XEnk=;
	h=Date:To:From:Subject:From;
	b=ApckshxXg1BAXXTJB7AT7GUmHUIJUrn4Ct8g7hTQRscHdVsSOFbzb9C1e4hANM5fm
	 In+E9MW5NbYDTgAXCg5/miRKaOHSWct2CoXKkznj9XCcr7JOviGKBRVewsbCDLtGTe
	 Z8VjoEBa6hTOVq4g2drKL72wYBTmlCFikL0lwz/g=
Date: Tue, 16 Apr 2024 13:00:21 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-add-kernel-doc-for-try_to_free_buffers.patch added to mm-unstable branch
Message-Id: <20240416200022.03831C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buffer: add kernel-doc for try_to_free_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-add-kernel-doc-for-try_to_free_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-add-kernel-doc-for-try_to_free_buffers.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add kernel-doc for try_to_free_buffers()
Date: Tue, 16 Apr 2024 04:17:47 +0100

The documentation for this function has become separated from it over
time; move it to the right place and turn it into kernel-doc.  Mild
editing of the content to make it more about what the function does, and
less about how it does it.

Link: https://lkml.kernel.org/r/20240416031754.4076917-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-try_to_free_buffers
+++ a/fs/buffer.c
@@ -2868,26 +2868,6 @@ int sync_dirty_buffer(struct buffer_head
 }
 EXPORT_SYMBOL(sync_dirty_buffer);
 
-/*
- * try_to_free_buffers() checks if all the buffers on this particular folio
- * are unused, and releases them if so.
- *
- * Exclusion against try_to_free_buffers may be obtained by either
- * locking the folio or by holding its mapping's i_private_lock.
- *
- * If the folio is dirty but all the buffers are clean then we need to
- * be sure to mark the folio clean as well.  This is because the folio
- * may be against a block device, and a later reattachment of buffers
- * to a dirty folio will set *all* buffers dirty.  Which would corrupt
- * filesystem data on the same device.
- *
- * The same applies to regular filesystem folios: if all the buffers are
- * clean then we set the folio clean and proceed.  To do that, we require
- * total exclusion from block_dirty_folio().  That is obtained with
- * i_private_lock.
- *
- * try_to_free_buffers() is non-blocking.
- */
 static inline int buffer_busy(struct buffer_head *bh)
 {
 	return atomic_read(&bh->b_count) |
@@ -2921,6 +2901,30 @@ failed:
 	return false;
 }
 
+/**
+ * try_to_free_buffers - Release buffers attached to this folio.
+ * @folio: The folio.
+ *
+ * If any buffers are in use (dirty, under writeback, elevated refcount),
+ * no buffers will be freed.
+ *
+ * If the folio is dirty but all the buffers are clean then we need to
+ * be sure to mark the folio clean as well.  This is because the folio
+ * may be against a block device, and a later reattachment of buffers
+ * to a dirty folio will set *all* buffers dirty.  Which would corrupt
+ * filesystem data on the same device.
+ *
+ * The same applies to regular filesystem folios: if all the buffers are
+ * clean then we set the folio clean and proceed.  To do that, we require
+ * total exclusion from block_dirty_folio().  That is obtained with
+ * i_private_lock.
+ *
+ * Exclusion against try_to_free_buffers may be obtained by either
+ * locking the folio or by holding its mapping's i_private_lock.
+ *
+ * Context: Process context.  @folio must be locked.  Will not sleep.
+ * Return: true if all buffers attached to this folio were freed.
+ */
 bool try_to_free_buffers(struct folio *folio)
 {
 	struct address_space * const mapping = folio->mapping;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch

