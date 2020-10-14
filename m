Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08F5C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A64B322253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709273;
	bh=MOY7B2uMQU7c9ueGHjLtIb4gvdbGbj8WV77L18oJ5sg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SCBtgfzHKz7+eRLs2ghghuFQwbhEO2c3ubMNl73Hy5DPAZAM3dXrb6ZVoUjpd8vKa
	 2bgpgWU56IEDF5137YwVxWcUsdla1KG3v8qCKw7PKwOJSdqdtv35t5rbqx/k76Vyz8
	 fRhgAECEXWg+xqEPdRCvyn7nIlV3u73JIBzsDgfE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgJNVBK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgJNVBK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928842224E;
        Wed, 14 Oct 2020 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709268;
        bh=MOY7B2uMQU7c9ueGHjLtIb4gvdbGbj8WV77L18oJ5sg=;
        h=Date:From:To:Subject:From;
        b=MrqvF4r6FA+Bih1T1MijtFQB9W3C8lPzCdcjM7GeKdt/70J9XINWpPNRLCvsHa02a
         76pXG8OFsu+6jD1y5m7OlPuP3zosRpfu0wdNZwKKITib0EKZFPvJGmOngDQFSZLH80
         qwcSEylNkhhOFxSXah7sdB4byncJhUWK/PUDDKr8=
Date:   Wed, 14 Oct 2020 14:01:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-move-pagedoublemap-bit.patch removed from -mm
 tree
Message-ID: <20201014210108.3f-tQ6I3f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move PageDoubleMap bit
has been removed from the -mm tree.  Its filename was
     mm-move-pagedoublemap-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move PageDoubleMap bit

Patch series "Fix PageDoubleMap".

This is a purely theoretical problem for now as none of the filesystems
which use PG_private_2 (ie PG_fscache) are being converted at this time,
but it's confusing to leave it like this.


This patch (of 2):

PG_private_2 is defined as being PF_ANY (applicable to tail pages as well
as regular & head pages).  That means that the first tail page of a
double-map page will appear to have Private2 set.  Use the Workingset bit
instead which is defined as PF_HEAD so any attempt to access the
Workingset bit on a tail page will redirect to the head page's Workingset
bit.

Link: https://lkml.kernel.org/r/20200629151933.15671-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200629151933.15671-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-move-pagedoublemap-bit
+++ a/include/linux/page-flags.h
@@ -167,7 +167,7 @@ enum pageflags {
 	PG_slob_free = PG_private,
 
 	/* Compound pages. Stored in first tail page's flags */
-	PG_double_map = PG_private_2,
+	PG_double_map = PG_workingset,
 
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
_

Patches currently in -mm which might be from willy@infradead.org are

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

