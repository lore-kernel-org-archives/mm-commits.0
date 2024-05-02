Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5AD28FC
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669752; cv=none; b=JrSIwgynQPHb0XwLuHEN+a8PoVuPATB5gnyeze5X8hztqS7W3+vOI6l3PUcvcR9Wi1RmVeqv4IIXUbUOo8jG8A/FzCnh3lAntJtgfsYtu+0oB+2Zv8GFF9nil2zJl6hn9Sm5Cc+KfH/IHiodtocLmRBH85pVGwEkYuciHsZqfU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669752; c=relaxed/simple;
	bh=t+1z6wS0OUrvFtci3HoiydpfqHdcCdEV6/ELD8/jFok=;
	h=Date:To:From:Subject:Message-Id; b=ua54BHnsCVoIPGjqLLPN5jxLKV9JqDlQUfc/+TUaIMMDpQ3WsWOzYzHzZdjYdBEwobHoXgrTJa3Ve3J85ktSHaQ6PGj9dJ6oF3XKS6Avm2z8DljPYHF0Bzi+ycOsQcYMckk+iNRPvqt/eco1z8h+eRbcbi7ozaAAOCoHboFtTaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rtu9kLxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rtu9kLxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA10C113CC;
	Thu,  2 May 2024 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669751;
	bh=t+1z6wS0OUrvFtci3HoiydpfqHdcCdEV6/ELD8/jFok=;
	h=Date:To:From:Subject:From;
	b=Rtu9kLxfEdsRNef2CqEFiOzHVdwVaGuF1PeKAFNFWhV/TLyjFbcTvHa2TQI05V9MH
	 D23S4wkDnxlDIgd4L0fJPkVdcs9cyeQ0DbTWRYWnMf+SJ/8crou2BGqW4MvC0x65FW
	 i/l9F6TwTABMJH9CwP+w5ABKdx8m2UQ7Rfa8y1dg=
Date: Thu, 02 May 2024 10:09:10 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch added to mm-nonmm-unstable branch
Message-Id: <20240502170911.9DA10C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: Remove calls to folio_set_error() and folio_clear_error()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

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
Subject: nilfs2: Remove calls to folio_set_error() and folio_clear_error()
Date: Tue, 30 Apr 2024 14:09:01 +0900

Nobody checks this flag on nilfs2 folios, stop setting and clearing it. 
That lets us simplify nilfs_end_folio_io() slightly.

Link: https://lkml.kernel.org/r/20240420025029.2166544-17-willy@infradead.org
Link: https://lkml.kernel.org/r/20240430050901.3239-1-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c     |    1 -
 fs/nilfs2/segment.c |    8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error
+++ a/fs/nilfs2/dir.c
@@ -174,7 +174,6 @@ Eend:
 		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode));
 fail:
-	folio_set_error(folio);
 	return false;
 }
 
--- a/fs/nilfs2/segment.c~nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error
+++ a/fs/nilfs2/segment.c
@@ -1725,14 +1725,8 @@ static void nilfs_end_folio_io(struct fo
 		return;
 	}
 
-	if (!err) {
-		if (!nilfs_folio_buffers_clean(folio))
-			filemap_dirty_folio(folio->mapping, folio);
-		folio_clear_error(folio);
-	} else {
+	if (err || !nilfs_folio_buffers_clean(folio))
 		filemap_dirty_folio(folio->mapping, folio);
-		folio_set_error(folio);
-	}
 
 	folio_end_writeback(folio);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-set-the-marks-correctly-when-splitting-an-entry.patch
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
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

