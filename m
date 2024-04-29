Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3584D09
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404312; cv=none; b=QM5VhjrFNsFsAjqRLgi1D0GPY49sYTWGQsXeeq8h39D44bnHtDRQk7BVfZucI+FcGv2hJktoKEdIB4R+tyBMyLD1lFyYm5AP/3m1M8ZBp5LIL+ZALrfzds0JUozpaLpViRw5+HIp1GMOGgGcHXA3SMDj9FxfzsJ17N8+sYx+blQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404312; c=relaxed/simple;
	bh=vROQibo+P2Z66g5RGEgTsTeZtXSv51YzksgaIPhvs9g=;
	h=Date:To:From:Subject:Message-Id; b=PKoQ9IkTaTjd/3BSFn1UZB2VUP94tViU5OeBERPHfYgya11Vo3yUz8zJ4i76RTBqtztfHw8xO7b5gUAmEGTQimBqyNrkmuBP3ebVkpWS/pZ9dO/Wv7q+t7uyeB3Nxe6F/vUjiyr+TjcnGi6OvF9TRyjW1NSo3c6n38wfRIKEKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ROA7RgId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ROA7RgId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7965C116B1;
	Mon, 29 Apr 2024 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714404311;
	bh=vROQibo+P2Z66g5RGEgTsTeZtXSv51YzksgaIPhvs9g=;
	h=Date:To:From:Subject:From;
	b=ROA7RgIdUeV+yeovYoZHsJoViJfBOJeDeaogcagEsRffSmetb+C1sOjDMYEvw3z1R
	 h1JAeENaNIloQEqEOmj5Mq4Clmsado2LbOXHXArJMydKjqnyeSPTJ8J8FDJyzUlSdf
	 Z4SkRr+6Z5/U4KWYPiYH0pDojEfCWtg9VMdTS+3Q=
Date: Mon, 29 Apr 2024 08:25:10 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch added to mm-nonmm-unstable branch
Message-Id: <20240429152511.A7965C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: convert squashfs_symlink_read_folio to use folio APIs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch

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
Subject: squashfs: convert squashfs_symlink_read_folio to use folio APIs
Date: Sat, 20 Apr 2024 03:50:17 +0100

Remove use of page APIs, return the errno instead of 0, switch from
kmap_atomic to kmap_local and use folio_end_read() to unify the two exit
paths.

Link: https://lkml.kernel.org/r/20240420025029.2166544-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/symlink.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/fs/squashfs/symlink.c~squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis
+++ a/fs/squashfs/symlink.c
@@ -32,20 +32,19 @@
 
 static int squashfs_symlink_read_folio(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int index = page->index << PAGE_SHIFT;
+	int index = folio_pos(folio);
 	u64 block = squashfs_i(inode)->start;
 	int offset = squashfs_i(inode)->offset;
 	int length = min_t(int, i_size_read(inode) - index, PAGE_SIZE);
-	int bytes, copied;
+	int bytes, copied, error;
 	void *pageaddr;
 	struct squashfs_cache_entry *entry;
 
 	TRACE("Entered squashfs_symlink_readpage, page index %ld, start block "
-			"%llx, offset %x\n", page->index, block, offset);
+			"%llx, offset %x\n", folio->index, block, offset);
 
 	/*
 	 * Skip index bytes into symlink metadata.
@@ -57,14 +56,15 @@ static int squashfs_symlink_read_folio(s
 			ERROR("Unable to read symlink [%llx:%x]\n",
 				squashfs_i(inode)->start,
 				squashfs_i(inode)->offset);
-			goto error_out;
+			error = bytes;
+			goto out;
 		}
 	}
 
 	/*
 	 * Read length bytes from symlink metadata.  Squashfs_read_metadata
 	 * is not used here because it can sleep and we want to use
-	 * kmap_atomic to map the page.  Instead call the underlying
+	 * kmap_local to map the folio.  Instead call the underlying
 	 * squashfs_cache_get routine.  As length bytes may overlap metadata
 	 * blocks, we may need to call squashfs_cache_get multiple times.
 	 */
@@ -75,29 +75,26 @@ static int squashfs_symlink_read_folio(s
 				squashfs_i(inode)->start,
 				squashfs_i(inode)->offset);
 			squashfs_cache_put(entry);
-			goto error_out;
+			error = entry->error;
+			goto out;
 		}
 
-		pageaddr = kmap_atomic(page);
+		pageaddr = kmap_local_folio(folio, 0);
 		copied = squashfs_copy_data(pageaddr + bytes, entry, offset,
 								length - bytes);
 		if (copied == length - bytes)
 			memset(pageaddr + length, 0, PAGE_SIZE - length);
 		else
 			block = entry->next_index;
-		kunmap_atomic(pageaddr);
+		kunmap_local(pageaddr);
 		squashfs_cache_put(entry);
 	}
 
-	flush_dcache_page(page);
-	SetPageUptodate(page);
-	unlock_page(page);
-	return 0;
-
-error_out:
-	SetPageError(page);
-	unlock_page(page);
-	return 0;
+	flush_dcache_folio(folio);
+	error = 0;
+out:
+	folio_end_read(folio, error == 0);
+	return error;
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

