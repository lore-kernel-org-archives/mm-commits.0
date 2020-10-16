Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE4AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E572087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814482;
	bh=tDOxT3/UVh8w4QfDMdRDon/VCQJ/7suC7VpaHH1KqNI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OIHtjB1HuwJg9PDXbJ/paDniqfWY+CM6uQjH6zp7KR7e9pG09Gb/dr8PjD/bBwVBV
	 k8Aa6EdrkRbyZkKKxM8x26OsLWC3rstNcBQyHBGjBZ45kynq+YJyF5Ypym64DeuXql
	 E0wj1F7cGicvkM9pcyWv2zNj1J+yH7eJZz1ucX8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404134AbgJPCOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404130AbgJPCOm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:14:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25EF02073A;
        Fri, 16 Oct 2020 02:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814481;
        bh=tDOxT3/UVh8w4QfDMdRDon/VCQJ/7suC7VpaHH1KqNI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M0A3PxqkMiG9LtK4A28+DtfC/DVsqiHMxTijgG2pQQqT93b/hEiFtoZBDYavmE3PG
         UFUI0/kOJdI2vdBVQiYq8JdzeTj23cFUO5wfYgLff+2okm3cG3TGoaAqTnxYaqXgWW
         Kf5Nfs/i3Jcph1nrMHBiSRQ85O3bjpVqBRv7TKJU=
Date:   Thu, 15 Oct 2020 19:14:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged] xarray-add-xas_split-fix-3patch.patch
 removed from -mm tree
Message-ID: <20201016021440.SfdE6Zslj%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix xarray
has been removed from the -mm tree.  Its filename was
     xarray-add-xas_split-fix-3patch.patch

This patch was dropped because it was folded into xarray-add-xas_split.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fix xarray

Testing today revealed a rather annoying bug where we can free an
initialised node back to the slab cache without zeroing it first.  That
ends up creating a corrupted XArray ...  whichever XArray happens to
allocate that node next.

Link: https://lkml.kernel.org/r/20201001233943.GW20115@casper.infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/xarray.c~xarray-add-xas_split-fix-3patch
+++ a/lib/xarray.c
@@ -271,8 +271,7 @@ static void xas_destroy(struct xa_state
 	while (node) {
 		XA_NODE_BUG_ON(node, !list_empty(&node->private_list));
 		next = rcu_dereference_raw(node->parent);
-		/* XXX: need to free children */
-		kmem_cache_free(radix_tree_node_cachep, node);
+		radix_tree_node_rcu_free(&node->rcu_head);
 		xas->xa_alloc = node = next;
 	}
 }
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
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

