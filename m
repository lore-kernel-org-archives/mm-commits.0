Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C89C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DBD22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630405;
	bh=7eyUtldlMp1VslsS0D7pFn+Lre0TNm5Sn6jpVdSp0Tw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qkENFUn+a5Or2z0zSHvQ77tYwAZYdEPhGQNSgzTnFCecD/6tsNew5DephQVK8gnuJ
	 HASE0kR3anADETlTxhglktyNJ4JIjqxtrTdbbqh67M9HV6M0bz+okzyM3ytUEHsfyQ
	 qVNVcJVR/8AvBEVms+8CG4Mfg1lb7TTn6SCpsUws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbgJMXGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:06:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57DB822202;
        Tue, 13 Oct 2020 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630404;
        bh=7eyUtldlMp1VslsS0D7pFn+Lre0TNm5Sn6jpVdSp0Tw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dzrodfrr9mPg24gT+6QsSgyw4d61/bCo2od4JgS1jsWsf7EIQd+WUUgyQWvnpvri7
         7we84clj9FaW3YaXd/JayNtOUaKciFk7kelLP3HVLrB0YgZmnSeeSV06frV6gkwZUU
         f2bifDqpqfyIlqRsY3sdk8hQQuW0Du6E/1NVlXJM=
Date:   Tue, 13 Oct 2020 16:06:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     lkp@intel.com, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 mm-convert-find_get_entry-to-return-the-head-page-fix.patch removed from
 -mm tree
Message-ID: <20201013230643.0y7pOnHC0%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-find_get_entry-to-return-the-head-page-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-find_get_entry-to-return-the-head-page-fix.patch

This patch was dropped because it was folded into mm-convert-find_get_entry-to-return-the-head-page.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-convert-find_get_entry-to-return-the-head-page-fix

Link: https://lkml.kernel.org/r/20200914112738.GM6583@casper.infradead.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_state.c~mm-convert-find_get_entry-to-return-the-head-page-fix
+++ a/mm/swap_state.c
@@ -431,6 +431,8 @@ struct page *find_get_incore_page(struct
 	struct swap_info_struct *si;
 	struct page *page = find_get_entry(mapping, index);
 
+	if (!page)
+		return page;
 	if (!xa_is_value(page))
 		return find_subpage(page, index);
 	if (!shmem_mapping(mapping))
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
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

