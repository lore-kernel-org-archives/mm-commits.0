Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076C615E7F4
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714670084; cv=none; b=EbpAG0/tJo/IP/I5geDOiTL0d1fx59hRKH31KrX8p1hKOgIul7hsIpbXzVpuIXekcuzJDvAuPtJBC9d4uS8CdY0Dy3MvkNRT4F0/Lnva3symyR9uglYitDEd5brXlvfnb61LRDcVDCJ4+N/Vi14v0jzzFG5rd8qOUx9TTVple3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714670084; c=relaxed/simple;
	bh=mzHG/FLzpR9NKuqh6EGKK5Df7zWgVz2qpdH7gEc5vOA=;
	h=Date:To:From:Subject:Message-Id; b=lcjDYSLFKDi1F4krbAiDvedS99mOFf5zxbI7m0X8e36pjk7JZFTTD42j5KMBPS898SEdCgz+p/fSIlxwxtFLXqlNCkdPCEPyQg0haaJaG4mMngxqrvt1s4szzQilHORhGHJM7MzE+YSwTVVlsO4AJiDNUISLVmy8vwDn5TXNsLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9lLhPfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9lLhPfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5F1C113CC;
	Thu,  2 May 2024 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714670083;
	bh=mzHG/FLzpR9NKuqh6EGKK5Df7zWgVz2qpdH7gEc5vOA=;
	h=Date:To:From:Subject:From;
	b=Z9lLhPfeHTf6rWaBtDYdoN5iFNnL47SM18QBuugh8JXEf/jgf4LYsYFrBN7p/26fi
	 pWdRpaUgjK1EWNewvkst6fJoCwMNXqP084A8iD9PJ0WhnLkUR/NGIsGrrWNJiZGRiN
	 /sFgtp+uEGs6SCnl4Ux18w6+7zlWNXKwY4dS5SXo=
Date: Thu, 02 May 2024 10:14:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + thp-remove-hpage_pmd_order-minimum-assertion.patch added to mm-unstable branch
Message-Id: <20240502171443.8A5F1C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: thp: remove HPAGE_PMD_ORDER minimum assertion
has been added to the -mm mm-unstable branch.  Its filename is
     thp-remove-hpage_pmd_order-minimum-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/thp-remove-hpage_pmd_order-minimum-assertion.patch

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
Subject: thp: remove HPAGE_PMD_ORDER minimum assertion
Date: Mon, 29 Apr 2024 20:00:55 +0100

We now handle order-1 folios correctly, so we don't need this assertion
any more.

Link: https://lkml.kernel.org/r/20240429190114.3126789-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/huge_memory.c~thp-remove-hpage_pmd_order-minimum-assertion
+++ a/mm/huge_memory.c
@@ -740,11 +740,6 @@ static int __init hugepage_init(void)
 	 * hugepages can't be allocated by the buddy allocator
 	 */
 	MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER);
-	/*
-	 * we use page->mapping and page->index in second tail page
-	 * as list_head: assuming THP order >= 2
-	 */
-	MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER < 2);
 
 	err = hugepage_init_sysfs(&hugepage_kobj);
 	if (err)
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
thp-remove-hpage_pmd_order-minimum-assertion.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

