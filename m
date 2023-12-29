Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B40512E57
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bd8EtKcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA6C433C7;
	Fri, 29 Dec 2023 19:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879264;
	bh=2pb/0Q4/ORZK7RA+AqIuowZAKgNXtST7wA7YhT4lAnI=;
	h=Date:To:From:Subject:From;
	b=Bd8EtKcDmkF8e4PzPFm7tssYWamaRFDGY7DsNUq1vi2hr6SWOfbs3m1IowDfIe9lj
	 /rZuIgAAr0a0CRsaRubZSr7QzwrHOaUlG0emPJu7MnJVSlObrTWzYpwQAhy6BFxyYV
	 ciYJKas+LhhlaDe7bAOmPS1GBJdvOr0CAJ9ceNU4=
Date: Fri, 29 Dec 2023 11:47:44 -0800
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch removed from -mm tree
Message-Id: <20231229194744.AEDA6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch

This patch was dropped because it was folded into mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix
Date: Wed, 13 Dec 2023 15:37:25 +0000

The patch 6faef19bdfcc: "mm: convert ksm_might_need_to_copy() to work
on folios" from Dec 11, 2023 (linux-next), leads to the following
Smatch static checker warning:

 	mm/memory.c:4118 do_swap_page()
 	error: 'folio' dereferencing possible ERR_PTR()

Link: https://lkml.kernel.org/r/ZXnPtblC6A1IkyAB@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by:  Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lkml.kernel.org/r/a07e5aad-2b09-4966-b486-4791619dceae@moroto.mountain
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix
+++ a/mm/memory.c
@@ -3945,9 +3945,11 @@ vm_fault_t do_swap_page(struct vm_fault
 		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
 		if (unlikely(!folio)) {
 			ret = VM_FAULT_OOM;
+			folio = swapcache;
 			goto out_page;
 		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
 			ret = VM_FAULT_HWPOISON;
+			folio = swapcache;
 			goto out_page;
 		}
 		page = folio_page(folio, 0);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch
mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

