Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E37D469D
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627527; cv=none; b=Iar+g6yKSm3GWMp8+qixT7TaD7ed/rel7gpX4w4m9tXE5Jc/kXcv03id0Cpg0RQF66gAK0Ecg0ovkV8qQ4ksaH0VFJVon+ZDU34+qLo2kb57IZCyLKYBkomWD4M0KzshXScdeCri1k48BDh1ZwxJF5Tuv+BI+KsWyuHk1dL9/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627527; c=relaxed/simple;
	bh=tFVeumlkcbopH7PAMqm6oUxJXDJCBnS1nNGtzdZTDtI=;
	h=Date:To:From:Subject:Message-Id; b=UgOWZs8EflKILtYTmGS8bWq9D9Cux3MKJgX61OtONoGDLFSwz3T8r9wZyYnQbgJHZVGYNmxMRK8SmF5HPtKFIgyYf/aa7WmyPOQDRC3dlyW93JBm39qCXUG5yRJY+yf90lfBauLv8/noMtlX8jkMA9lAH5rJ+LTuskVq0PI7Vso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYGO7uPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYGO7uPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECEDC116B1;
	Sat, 29 Jun 2024 02:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627526;
	bh=tFVeumlkcbopH7PAMqm6oUxJXDJCBnS1nNGtzdZTDtI=;
	h=Date:To:From:Subject:From;
	b=oYGO7uPE5V7Slf8qSRzLgKTOMuoZAbBomEi5HIxHJ+NQQRgV9BTRFWdWdPNT03wsG
	 mgXAoPbo2AjRnJlQ9YfJ5D4AKHffUwbLZbFOSJ1Js2SvcPApON9f9Ru5JhiiAZfMfs
	 soAjdMZbnnzSsPvXlwyN28xgg0OBmATIlYiuljAc=
Date: Fri, 28 Jun 2024 19:18:46 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-page_maybe_dma_pinned-fix.patch removed from -mm tree
Message-Id: <20240629021846.CECEDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-remove-page_maybe_dma_pinned-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-page_maybe_dma_pinned-fix.patch

This patch was dropped because it was folded into mm-remove-page_maybe_dma_pinned.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-remove-page_maybe_dma_pinned-fix
Date: Thu, 6 Jun 2024 11:36:29 +0800

fix pin_user_pages.rst underlining

Link: https://lkml.kernel.org/r/61b256c7-4989-44ec-83db-f34a1bd4be2d@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_maybe_dma_pinned-fix
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -197,7 +197,7 @@ INCORRECT (uses FOLL_GET calls):
     put_page()
 
 folio_maybe_dma_pinned(): the whole point of pinning
-===================================================
+====================================================
 
 The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
 to query, "is this folio DMA-pinned?" That allows code such as page_mkclean()
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

