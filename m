Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3031F7DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854762; cv=none; b=dhxTKApF5L94RBXaHnliI5YeQEU48fxtd5wB20/oZqNG2YEc57nIbaFftNUK/i43KVqy9vFibLfkYKB626ZdwW570XTSV38HeEZ51cLdReej5sv9u63dSRg83hrmdY8yxl2tGd1syHnSFnnNq7AewfNRU7CNUXZW/QbF9xGmLoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854762; c=relaxed/simple;
	bh=vSn/aBMn1jwq76exoqY7ykznqaVlZgspe+MhVB1Zw1s=;
	h=Date:To:From:Subject:Message-Id; b=IyC9TBtuUtsBAMGZnIj2Mselbsw4WMnVpxh2FAo6VMQm007EYByCH15MEcI5ga/3hqm5qrvMacHxcyMiBzjNeN9sBEiPtJWgzO24pcvtqGc5tL8T4+2eSi1NjHxL+WKAvngHWG1ABjj/JD7K1Vn3F8CTSF9enCrMQ1L5HKc5g1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=st1fvhc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="st1fvhc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA77C4CECF;
	Wed,  6 Nov 2024 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854761;
	bh=vSn/aBMn1jwq76exoqY7ykznqaVlZgspe+MhVB1Zw1s=;
	h=Date:To:From:Subject:From;
	b=st1fvhc9gmA+P/oWK1gg/gUMcE+NwNUUVoNpQISOH2D+xBE0ZBRw3stYpTTTHdqe7
	 J7JThFc1VgGf1EehBXEaSK822Wz+9G10z7hLrI6C0hJWOFFRYD5EynBiAGrqF4U8kG
	 fd6LSSnY5stMryQsAm2+KeOKbESU5JSUGWyafyQU=
Date: Tue, 05 Nov 2024 16:59:21 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageksm.patch removed from -mm tree
Message-Id: <20241106005921.9DA77C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageKsm()
has been removed from the -mm tree.  Its filename was
     mm-remove-pageksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageKsm()
Date: Wed, 2 Oct 2024 16:25:31 +0100

All callers have been converted to use folio_test_ksm() or
PageAnonNotKsm(), so we can remove this wrapper.

Link: https://lkml.kernel.org/r/20241002152533.1350629-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +------
 mm/internal.h              |    2 +-
 mm/ksm.c                   |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageksm
+++ a/include/linux/page-flags.h
@@ -725,13 +725,8 @@ static __always_inline bool folio_test_k
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_KSM;
 }
-
-static __always_inline bool PageKsm(const struct page *page)
-{
-	return folio_test_ksm(page_folio(page));
-}
 #else
-TESTPAGEFLAG_FALSE(Ksm, ksm)
+FOLIO_TEST_FLAG_FALSE(ksm)
 #endif
 
 u64 stable_page_flags(const struct page *page);
--- a/mm/internal.h~mm-remove-pageksm
+++ a/mm/internal.h
@@ -1356,7 +1356,7 @@ static inline bool gup_must_unshare(stru
 		smp_rmb();
 
 	/*
-	 * Note that PageKsm() pages cannot be exclusive, and consequently,
+	 * Note that KSM pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
 	return !PageAnonExclusive(page);
--- a/mm/ksm.c~mm-remove-pageksm
+++ a/mm/ksm.c
@@ -656,7 +656,7 @@ static int break_ksm(struct vm_area_stru
 	 *
 	 * VM_FAULT_SIGBUS could occur if we race with truncation of the
 	 * backing file, which also invalidates anonymous pages: that's
-	 * okay, that truncation will have unmapped the PageKsm for us.
+	 * okay, that truncation will have unmapped the KSM page for us.
 	 *
 	 * VM_FAULT_OOM: at the time of writing (late July 2009), setting
 	 * aside mem_cgroup limits, VM_FAULT_OOM would only be set if the
@@ -1434,7 +1434,7 @@ out:
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
  * @page: the PageAnon page that we want to replace with kpage
- * @kpage: the PageKsm page that we want to map instead of page,
+ * @kpage: the KSM page that we want to map instead of page,
  *         or NULL the first time when we want to use page as kpage.
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

