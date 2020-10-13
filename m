Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB60C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D92522227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630358;
	bh=Hbebu2UmpX2FdA8CPMJ5WtrwbeI7IN0kpHzPiWmJEnI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=f3JAZHgpKFspNy+kgQqZ3kVHvCbo/ET2rsZvANM7VbyDzMlraiA69ZqLb48lH6soX
	 PON12QbES/5MO3hcfuuVVfb9isdNZJpqvbmXz/WyPwkvrU7RAO1ELjqO9s7Q98sOiQ
	 9fNm7euS1e0dKQz02nMhtTcHY0ANe+O3Qrsshyb0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgJMXF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXF5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:05:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B9922202;
        Tue, 13 Oct 2020 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630356;
        bh=Hbebu2UmpX2FdA8CPMJ5WtrwbeI7IN0kpHzPiWmJEnI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rJEB1lqbD4Rb9OB++E8XNkyi1TyP9xGlGIYh7G7Kef5pDN9Pv2JNIcQFHf2Hvhlga
         79wI1mbnS9xIMxO+3xqhPvJewcA8XRzEGNoAFXAF8s0jo5IXIXGdFNIkE1FQv0F5Qh
         wxea7Z3HVTngsdGSiQ2uSrnb+k3g7tYLe7+XWGCI=
Date:   Tue, 13 Oct 2020 16:05:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cai@redhat.com, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged] mm-optimise-madvise-willneed-fix.patch
 removed from -mm tree
Message-ID: <20201013230556.vmLPzszP1%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-optimise-madvise-willneed-fix
has been removed from the -mm tree.  Its filename was
     mm-optimise-madvise-willneed-fix.patch

This patch was dropped because it was folded into mm-optimise-madvise-willneed.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-optimise-madvise-willneed-fix

On Mon, Sep 14, 2020 at 12:17:07PM -0400, Qian Cai wrote:
> Reverting the "Return head pages from find_*_entry" patchset [1] up to this
> patch fixed the issue that LTP madvise06 test [2] would trigger endless soft-
> lockups below. It does not help after applied patches fixed other separate
> issues in the patchset [3][4].

Link: https://lkml.kernel.org/r/20200914165032.GS6583@casper.infradead.org
Reported-by: Qian Cai <cai@redhat.com>
Tested-by: Qian Cai <cai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-optimise-madvise-willneed-fix
+++ a/mm/madvise.c
@@ -234,6 +234,7 @@ static void force_shm_swapin_readahead(s
 
 		if (!xa_is_value(page))
 			continue;
+		xas_pause(&xas);
 		rcu_read_unlock();
 
 		swap = radix_to_swp_entry(page);
@@ -243,7 +244,6 @@ static void force_shm_swapin_readahead(s
 			put_page(page);
 
 		rcu_read_lock();
-		xas_reset(&xas);
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
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
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

