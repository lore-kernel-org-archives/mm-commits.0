Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54DFC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58A4B2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814479;
	bh=bfa5zUPpZQl7tXchcF32QUatL89PT6aKF4UD8mQLi3A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cObflwlDOy0H7EiBCMzcvOHsKwgtawVV8+S6uAPOGUUdZLJvG1vCxATnPDNEGsaLZ
	 Hu94PkF2W/4Dr0Ltq3fZdgciD1yISrOuF4DCB4deRU1y7tL0ZyURUtqMMFSGlsAed1
	 lrreUeaUL0Hh0VPES4MZ96aqqMNsTga58N4PjQbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404133AbgJPCOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404130AbgJPCOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:14:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBDF22073A;
        Fri, 16 Oct 2020 02:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814478;
        bh=bfa5zUPpZQl7tXchcF32QUatL89PT6aKF4UD8mQLi3A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZzMGSocoG4TyLpd85AcBUWgUdXnt8UUFBspT8bwqVCCbhqH9aW9vt18fwEBxxWt8f
         HCDKUxrqTsUqrEkhaJ3v/OixipAGQ34Hz8+3+DiJDVXF+MqhmpdH9UB8kt6nr4z38p
         9jIfDAKufHcilLHvxdKBZztX/LxmZE2yBB35EI9A=
Date:   Thu, 15 Oct 2020 19:14:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged] xarray-add-xas_split-fix-2.patch removed
 from -mm tree
Message-ID: <20201016021437.8qwdYiubY%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xarray-add-xas_split-fix-2
has been removed from the -mm tree.  Its filename was
     xarray-add-xas_split-fix-2.patch

This patch was dropped because it was folded into xarray-add-xas_split.patch

------------------------------------------------------
From: Matthew Wilcox (Oracle) <willy@infradead.org>
Subject: xarray-add-xas_split-fix-2

    fix xarray split

Link: https://lkml.kernel.org/r/20200910175450.GV6583@casper.infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    3 +++
 lib/xarray.c      |   21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/lib/test_xarray.c~xarray-add-xas_split-fix-2
+++ a/lib/test_xarray.c
@@ -1524,6 +1524,9 @@ static void check_split_1(struct xarray
 	}
 	XA_BUG_ON(xa, i != 1 << order);
 
+	xa_set_mark(xa, index, XA_MARK_0);
+	XA_BUG_ON(xa, !xa_get_mark(xa, index, XA_MARK_0));
+
 	xa_destroy(xa);
 }
 
--- a/lib/xarray.c~xarray-add-xas_split-fix-2
+++ a/lib/xarray.c
@@ -973,10 +973,11 @@ static void node_set_marks(struct xa_nod
 	xa_mark_t mark = XA_MARK_0;
 
 	for (;;) {
-		if (marks & (1 << (__force unsigned int)mark))
+		if (marks & (1 << (__force unsigned int)mark)) {
 			node_set_mark(node, offset, mark);
-		if (child)
-			node_mark_all(child, mark);
+			if (child)
+				node_mark_all(child, mark);
+		}
 		if (mark == XA_MARK_MAX)
 			break;
 		mark_inc(mark);
@@ -984,8 +985,18 @@ static void node_set_marks(struct xa_nod
 }
 
 /**
- * Allocate memory for splitting an entry of @order size into the order
- * stored in the @xas.
+ * xas_split_alloc() - Allocate memory for splitting an entry.
+ * @xas: XArray operation state.
+ * @entry: New entry which will be stored in the array.
+ * @order: New entry order.
+ * @gfp: Memory allocation flags.
+ *
+ * This function should be called before calling xas_split().
+ * If necessary, it will allocate new nodes (and fill them with @entry)
+ * to prepare for the upcoming split of an entry of @order size into
+ * entries of the order stored in the @xas.
+ *
+ * Context: May sleep if @gfp flags permit.
  */
 void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 		gfp_t gfp)
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
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

