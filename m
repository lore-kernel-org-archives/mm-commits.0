Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B99CC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED24422203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630472;
	bh=Qs+5xBqudFf/JwMKkiPYtnNczdDuH5Bgnv51TcVArLY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XoLevj7SGUW3xLoYmIFNUGegLDM25Tz2jGTU/U1K/+ys1pT/cqIQMMxG5olDnDnI8
	 ZeT4IIzwzMZ6zQLEuBSIq0BUPe2JgJVdbBHhBH61HtBFoiZGWJfe0Y7ktcHMKXMpBT
	 NVarz65yRWvsnpQr2Sspripx6ibp/HfgnhCuuy4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgJMXHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXHv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:07:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F92421D40;
        Tue, 13 Oct 2020 23:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630470;
        bh=Qs+5xBqudFf/JwMKkiPYtnNczdDuH5Bgnv51TcVArLY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Bt4WP3b2XR47S8koPzuElp8eoBbFYt0fj6KipAu4jwDLZIM41bocTTes3q8zECXbP
         fVaEjughegxQAbd8H7z8kZf7MAALhOPNaBAI8LBtBGdr6vHQbEaN/bpbb5BTmxhiw0
         fbL5ARma0gDxyPmzjmey5pq59mX/IQWzaerO8fLg=
Date:   Tue, 13 Oct 2020 16:07:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-shmem-return-head-page-from-find_lock_entry-fix.patch removed from -mm
 tree
Message-ID: <20201013230749.u4X1BCBCf%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-return-head-page-from-find_lock_entry-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-return-head-page-from-find_lock_entry-fix.patch

This patch was dropped because it was folded into mm-shmem-return-head-page-from-find_lock_entry.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-shmem-return-head-page-from-find_lock_entry-fix

fix BUG()s


[1] https://lore.kernel.org/linux-mm/20200912032042.GA6583@casper.infradead.org/

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-return-head-page-from-find_lock_entry-fix
+++ a/mm/shmem.c
@@ -1795,7 +1795,7 @@ static int shmem_getpage_gfp(struct inod
 	struct mm_struct *charge_mm;
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
-	pgoff_t hindex;
+	pgoff_t hindex = index;
 	int error;
 	int once = 0;
 	int alloced = 0;
@@ -1824,6 +1824,8 @@ repeat:
 		return error;
 	}
 
+	if (page)
+		hindex = page->index;
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
@@ -1834,6 +1836,7 @@ repeat:
 		unlock_page(page);
 		put_page(page);
 		page = NULL;
+		hindex = index;
 	}
 	if (page || sgp == SGP_READ)
 		goto out;
@@ -1984,7 +1987,7 @@ clear:
 		goto unlock;
 	}
 out:
-	*pagep = page + index - page->index;
+	*pagep = page + index - hindex;
 	return 0;
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
page_alloc-fix-freeing-non-compound-pages.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
xarray-add-xas_split-fix-3patch.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

