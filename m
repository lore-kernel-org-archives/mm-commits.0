Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DFACA47
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 01:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsXuZBC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918FFC433C8;
	Wed, 20 Dec 2023 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703034072;
	bh=YNWIKO7Nvexi9+TUypbMn3rXDrsuhdlPvQmK+jG0X3g=;
	h=Date:To:From:Subject:From;
	b=wsXuZBC/8Lq/X7KQTViUFZZGG1Vyd+6nY+q+wlJol2pPzUOyrX6Q4bpLhcYM7pD2L
	 J14/iPGCfUM+6XaCiwvKzSbYtwYXHf6iW8U1KXzRz8UM3tCJoghKuYKzS9P4nph9JF
	 va+gegFdU4HVDyHYJsLecx59qBZk15QbV8YJ7/cg=
Date: Tue, 19 Dec 2023 17:01:12 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20231220010112.918FFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix
Date: Wed, 20 Dec 2023 00:54:17 +0000

avoid NULL pointer deref

Link: https://lkml.kernel.org/r/ZYI7OcVlM1voKfBl@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swap_state.c~mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix
+++ a/mm/swap_state.c
@@ -885,6 +885,9 @@ struct page *swapin_readahead(swp_entry_
 		swap_vma_readahead(entry, gfp_mask, mpol, ilx, vmf) :
 		swap_cluster_readahead(entry, gfp_mask, mpol, ilx);
 	mpol_cond_put(mpol);
+
+	if (!folio)
+		return NULL;
 	return folio_file_page(folio, swp_offset(entry));
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch
mm-memory-failure-check-the-mapcount-of-the-precise-page.patch
mm-memory-failure-cast-index-to-loff_t-before-shifting-it.patch
mailmap-add-an-old-address-for-naoya-horiguchi.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
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

