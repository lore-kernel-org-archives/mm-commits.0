Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38874C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B9C21531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937911;
	bh=A+VJ1jwmYP3oZSXo8N87h9KzyatUfV+JfEJowxVnBQg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=05ph6vbC6hkSt1/BwwFXW5tNJdrk6MRdHKdZ3Fxv0S9CdW/TxoMlrxIwdSiB0Ap7c
	 cefRjI4oafiy4e+8Bj6qy4YksZzVpQ7zXyV3RxyO+yJ+ert3hPBFGGgzgjNleOWjF7
	 s4mwYJtaAQC7aStPZiQT0ay8tj93910zBnfxkCKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgILTLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgILTLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:49 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2880207C3;
        Sat, 12 Sep 2020 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937908;
        bh=A+VJ1jwmYP3oZSXo8N87h9KzyatUfV+JfEJowxVnBQg=;
        h=Date:From:To:Subject:From;
        b=uSBIxomp0Kzwy8bTk7myf6hAhe6Ux+M5DO4EDd/7rIleZyqSOGY/+Ik/19Swu03p2
         G8bBn79UbntBLV9l1tTxB/0l3uAqFwSbcxCxVNWOSUUgk8vI9sbiU0DhQNl6fzlucx
         oZ1BgebZIC82HzT5gzYbVirxq/Leso0OrkF0rYjs=
Date:   Sat, 12 Sep 2020 12:11:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch added to
 -mm tree
Message-ID: <20200912191148.5LTLS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: support tail pages in wait_for_stable_page
has been added to the -mm tree.  Its filename is
     mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch

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
Subject: mm/page-writeback: support tail pages in wait_for_stable_page

page->mapping is undefined for tail pages, so operate exclusively on the
head page.

Link: https://lkml.kernel.org/r/20200908195539.25896-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~mm-page-writeback-support-tail-pages-in-wait_for_stable_page
+++ a/mm/page-writeback.c
@@ -2849,6 +2849,7 @@ EXPORT_SYMBOL_GPL(wait_on_page_writeback
  */
 void wait_for_stable_page(struct page *page)
 {
+	page = thp_head(page);
 	if (bdi_cap_stable_pages_required(inode_to_bdi(page->mapping->host)))
 		wait_on_page_writeback(page);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
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

