Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C7EC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0444A21D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599938096;
	bh=J/AyfY3jDeavSnoqjuJ/mo+J3vu6U/veDoXZDZnVYlE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Tf8ACLj0vodYbydSfT8P0xTNRNwdOmpNVGqapFIfGtdg9tVMGIzzBMAc3lLTlhrFC
	 khX2qNSw0+If9844CCvGLOGxwIxoOz+CbQt5HkM6FO7zNxb7uMweYuLNUkBNi5TA/p
	 +EIBk6acSivjCXw/UZcCEovymvfsrpE3x1MfI1/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILTOz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:14:54 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04805207C3;
        Sat, 12 Sep 2020 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599938094;
        bh=J/AyfY3jDeavSnoqjuJ/mo+J3vu6U/veDoXZDZnVYlE=;
        h=Date:From:To:Subject:From;
        b=GLKeL8Vpc3HFkdKDJogO6pmjCw/ni5p1+QwNNz7ZIi56QsJbGoluY5zFGUr4TlEXE
         B0A8OVUdniSGqiI7rWlgt6KpkqfmnOU1Bps5ckIGP4YlXwhd1USMKHB/8s19F1l03/
         CA1HTV4k/NcNsEhhP7KTLH6kGpFiDS2D8U4X64sc=
Date:   Sat, 12 Sep 2020 12:14:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + xarray-add-xas_split-fix-2.patch added to -mm tree
Message-ID: <20200912191453.ZXat5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Sibject: xarray-add-xas_split-fix-2
has been added to the -mm tree.  Its filename is
     xarray-add-xas_split-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xarray-add-xas_split-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xarray-add-xas_split-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox (Oracle) <willy@infradead.org>
Sibject: xarray-add-xas_split-fix-2

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

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

