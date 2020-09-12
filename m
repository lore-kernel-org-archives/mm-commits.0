Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F3EC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DDB7207C3
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937891;
	bh=vj+2JNbJ+S1YeycXl2MRO982EoMHAN4/bnEu9LJsj0E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u2ynvCpSEy6V44zqo0wO6ESNKs/Srqrj+NFkmpKNPfUuIooJiLSHXEZDZ22rpcnO1
	 WdUtaUrgOCiY5+kvTtTXEPtJpKPfyGq22DNq9R5ocGpLKoh+83gliZBr/0lAZsOoGb
	 UIWUVhyA4LSMuc/UKrX130n0TY3TMoBhl318tQS0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILTLb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:30 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCCEF21D40;
        Sat, 12 Sep 2020 19:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937889;
        bh=vj+2JNbJ+S1YeycXl2MRO982EoMHAN4/bnEu9LJsj0E=;
        h=Date:From:To:Subject:From;
        b=deQJ4IBJYM6nCqxUBhe3ImU2APm2qPiuoJaw8b3PQuQklKQKQDmvvrxU2A3+XODrt
         mLKo6FpkMetWBxU/uqKhKWZmm/Luccuu3fwzWYxdgKYxy2Ae8/Qgslv5BIqQh7bxfv
         vlI4SIJ/b5WYGxzsBkVccGckwSmUx72PIohnz3sk=
Date:   Sat, 12 Sep 2020 12:11:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch added to -mm
 tree
Message-ID: <20200912191129.UFkFM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix page cache removal for arbitrary sized THPs
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch

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
Subject: mm/filemap: fix page cache removal for arbitrary sized THPs

Patch series "Remove assumptions of THP size".

There are a number of places in the VM which assume that a THP is a PMD in
size.  That's true today, and remains true after this patch series, but
this is a prerequisite for switching to arbitrary-sized THPs. 
thp_nr_pages() still returns either HPAGE_PMD_NR or 1, but will be changed
later.


This patch (of 11):

page_cache_free_page() assumes THPs are PMD_SIZE; fix that assumption.

Link: https://lkml.kernel.org/r/20200908195539.25896-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200908195539.25896-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps
+++ a/mm/filemap.c
@@ -249,7 +249,7 @@ static void page_cache_free_page(struct
 		freepage(page);
 
 	if (PageTransHuge(page) && !PageHuge(page)) {
-		page_ref_sub(page, HPAGE_PMD_NR);
+		page_ref_sub(page, thp_nr_pages(page));
 		VM_BUG_ON_PAGE(page_count(page) <= 0, page);
 	} else {
 		put_page(page);
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

