Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BF0C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640F220738
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601677294;
	bh=80kDtD4yGzK2f7S3F8T/43MOLGv8jFOpfnF05gV+8rc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EWO3MY0C1U0FOAc0n9Mfc4hO9lvJ+cyeD2k1NXA7XCHEX+LIsooF/YI9PZLSsw6rR
	 KpXG6Raz8Cyk+dueK3URJjoXaXE09nhXv6pQxvsYJtFYIzu0u5nNZEsZoxtjPVcmJZ
	 kjVParAK6Z9OgcSMVZXrYee51BsNHJAXJ4Mn5Xto=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgJBWVe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBWVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 18:21:32 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCA7206CA;
        Fri,  2 Oct 2020 22:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601677291;
        bh=80kDtD4yGzK2f7S3F8T/43MOLGv8jFOpfnF05gV+8rc=;
        h=Date:From:To:Subject:From;
        b=kW7gcdqi3PqPTSvOXqyK8eIiey2yVSb76IiG+PNv0B+oglLh3UuTQKKyM+aJ5az8U
         3GPyyVt8HACpUNKmQv20yZtsCJ7jUy/J04IycaW1F+NotsFIy0C6xlv7UiFeonAF7v
         Gpu8PP1Vm4ccKBGzotqmgtN8o3WdTInQU0i8Gx00=
Date:   Fri, 02 Oct 2020 15:21:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch added
 to -mm tree
Message-ID: <20201002222131.pcG1Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix remove page fault assumption of compound page size
has been added to the -mm tree.  Its filename is
     mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: Fix remove page fault assumption of compound page size

page_order() and compound_order() are different things

Link: https://lkml.kernel.org/r/20201001152259.14932-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-remove-page-fault-assumption-of-compound-page-size-fix
+++ a/mm/memory.c
@@ -3751,7 +3751,7 @@ static vm_fault_t do_set_pmd(struct vm_f
 		return ret;
 
 	page = compound_head(page);
-	if (page_order(page) != HPAGE_PMD_ORDER)
+	if (compound_order(page) != HPAGE_PMD_ORDER)
 		return ret;
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
mm-optimise-madvise-willneed-fix.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-convert-find_get_entry-to-return-the-head-page-fix.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-shmem-return-head-page-from-find_lock_entry-fix.patch
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
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

