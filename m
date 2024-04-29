Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165BB84D0D
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404315; cv=none; b=jaMBP17Crf249uOO5jYloSbxvKRuPoNSO6WhpeWlyC3xe42SM8vLCrPyEv7RrS0aN/vdAMz4Oh2B1yAW844TooIcLov3RIghbbqgobW8wyIwm33JJ0yvsKU0t4bdSJq9A4kVhWHQnrPsO8x9+Ri2Kt4dFRJcM+v7GmXF8pDytKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404315; c=relaxed/simple;
	bh=DMPIpplOtvlhopMOk+jx6tMMcBMaE5kxiq4w5rFsfEw=;
	h=Date:To:From:Subject:Message-Id; b=Db3rUgf4HdWheXOigiUtHDPQkDWeEGXDAYENu7CiQaKE2iNnvHyFMT5V0YI3PFsriUGvSQyrWQQ5P1v0XtaIw7fRlu4ibq8Rpp3oDFy7n/cm3w5EccC3sDw5zxHEN2uKIJfKyUW4YTJfEYjnVKirGidpC44tunbls27TscTRCkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsEZQmdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsEZQmdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA7CC113CD;
	Mon, 29 Apr 2024 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714404314;
	bh=DMPIpplOtvlhopMOk+jx6tMMcBMaE5kxiq4w5rFsfEw=;
	h=Date:To:From:Subject:From;
	b=rsEZQmdnSecbOZ7sJgM6Y64E+dUF+9VXKytMy0OScKx0h5bxf4enWpOCKKjYKfhl+
	 7e47d8rgpuvhMk5VmqiyoHH4F/fwc+ETX3GMriowqfeP7iG/atx7uItcFNLIesdtJN
	 feJ0ocrF+PXLg0NPF2bIcAIrxG1psoOnhAbK9rLs=
Date: Mon, 29 Apr 2024 08:25:13 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-remove-calls-to-set-the-folio-error-flag.patch added to mm-nonmm-unstable branch
Message-Id: <20240429152514.7BA7CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: remove calls to set the folio error flag
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-remove-calls-to-set-the-folio-error-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-remove-calls-to-set-the-folio-error-flag.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: squashfs: remove calls to set the folio error flag
Date: Sat, 20 Apr 2024 03:50:18 +0100

Nobody checks the error flag on squashfs folios, so stop setting it.

Link: https://lkml.kernel.org/r/20240420025029.2166544-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    6 +-----
 fs/squashfs/file_direct.c |    3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/fs/squashfs/file.c~squashfs-remove-calls-to-set-the-folio-error-flag
+++ a/fs/squashfs/file.c
@@ -375,8 +375,6 @@ void squashfs_fill_page(struct page *pag
 	flush_dcache_page(page);
 	if (copied == avail)
 		SetPageUptodate(page);
-	else
-		SetPageError(page);
 }
 
 /* Copy data into page cache  */
@@ -471,7 +469,7 @@ static int squashfs_read_folio(struct fi
 
 		res = read_blocklist(inode, index, &block);
 		if (res < 0)
-			goto error_out;
+			goto out;
 
 		if (res == 0)
 			res = squashfs_readpage_sparse(page, expected);
@@ -483,8 +481,6 @@ static int squashfs_read_folio(struct fi
 	if (!res)
 		return 0;
 
-error_out:
-	SetPageError(page);
 out:
 	pageaddr = kmap_atomic(page);
 	memset(pageaddr, 0, PAGE_SIZE);
--- a/fs/squashfs/file_direct.c~squashfs-remove-calls-to-set-the-folio-error-flag
+++ a/fs/squashfs/file_direct.c
@@ -106,14 +106,13 @@ int squashfs_readpage_block(struct page
 	return 0;
 
 mark_errored:
-	/* Decompression failed, mark pages as errored.  Target_page is
+	/* Decompression failed.  Target_page is
 	 * dealt with by the caller
 	 */
 	for (i = 0; i < pages; i++) {
 		if (page[i] == NULL || page[i] == target_page)
 			continue;
 		flush_dcache_page(page[i]);
-		SetPageError(page[i]);
 		unlock_page(page[i]);
 		put_page(page[i]);
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
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch

