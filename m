Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5498142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291595; cv=none; b=T5btpMvu1qWR99mI86oq9EI9N7NTzzh3xNPn1KrwoNbr3bUDPQgf0UD3VTJXkYjGfhozrMucJsnfzkcwAFGhxAR4157BXEcJIo2kuk3K+P4veFO+cyV885gL4BlNoDyafwdAb7iZq5iGckDQbjFFn6PjL4msrnbGFosFjNQ1LyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291595; c=relaxed/simple;
	bh=ZcjK8sIW7OolUQFTqrDt2Gwi+qMKiXbS34OhgAIsxRE=;
	h=Date:To:From:Subject:Message-Id; b=MCsmVyTjwM04rjnbpPxUC2hSsOJpZIMYWfX3xibRiGSHMoQN1qRxw2r7hokgO4KXffVFKrg+SWkPlbgPKIwvleowAZBc4gy4L3lxY2D/ZS1F3F3wfPfjQQvy7FVdxn+uAsKXpeldVyFwqvsOiviPnIFNvHBYB4ZwIMVakYdGY6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jn0dNI27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jn0dNI27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8C5C32782;
	Tue, 25 Jun 2024 04:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291595;
	bh=ZcjK8sIW7OolUQFTqrDt2Gwi+qMKiXbS34OhgAIsxRE=;
	h=Date:To:From:Subject:From;
	b=jn0dNI27NRDvQHrlMI7a2+dOtLyif6PBQ+OrYzwTFE9oIJB1mHkYxLjEXqUo1yNkG
	 Nz/mL7OFbwG/W4pcCKfgdWKmuGEI0em3I0gPTSxFwnUHYBFmXGHJdiZvhu9crQhgrU
	 x6nZRJALP+WlNzhE38k7/h3tXdbjxzV2NPKerVes=
Date: Mon, 24 Jun 2024 21:59:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,alexs@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-remove-define_page_vma_walk.patch removed from -mm tree
Message-Id: <20240625045955.7B8C5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rmap: remove DEFINE_PAGE_VMA_WALK()
has been removed from the -mm tree.  Its filename was
     rmap-remove-define_page_vma_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: rmap: remove DEFINE_PAGE_VMA_WALK()
Date: Fri, 24 May 2024 13:36:18 +0800

This are no users since commit 40d707f33db5 ("mm/ksm: use folio in
write_protect_page"), so remove DEFINE_PAGE_VMA_WALK().

Link: https://lkml.kernel.org/r/20240524053618.208895-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/rmap.h~rmap-remove-define_page_vma_walk
+++ a/include/linux/rmap.h
@@ -684,16 +684,6 @@ struct page_vma_mapped_walk {
 	unsigned int flags;
 };
 
-#define DEFINE_PAGE_VMA_WALK(name, _page, _vma, _address, _flags)	\
-	struct page_vma_mapped_walk name = {				\
-		.pfn = page_to_pfn(_page),				\
-		.nr_pages = compound_nr(_page),				\
-		.pgoff = page_to_pgoff(_page),				\
-		.vma = _vma,						\
-		.address = _address,					\
-		.flags = _flags,					\
-	}
-
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
 		.pfn = folio_pfn(_folio),				\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

