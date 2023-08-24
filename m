Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE6DC88CB2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjHXXVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbjHXXVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40868A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE0C663676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F8EC433C7;
        Thu, 24 Aug 2023 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919257;
        bh=ez+3uw4FJcAdQVOUKVGracKpyk3wqgV0CWKk/Ty665s=;
        h=Date:To:From:Subject:From;
        b=BdSZL9gUM48+D7/6nWWB+qWpB8yN+sr/9iGk/XJpuNb5GtpcgeQ4wJlzlnettQGeq
         ra1aj10VmA65PwG2cV5xOLp8e37p4fVpV1WTrgK38VFjDuqu20/4W8WcNcoHjKxPfT
         v1+rKav3MZv8TR8gCtWj1q+Yx6V1iZAjgf6BkI40=
Date:   Thu, 24 Aug 2023 16:20:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, axboe@kernel.dk,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch removed from -mm tree
Message-Id: <20230824232057.31F8EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: clear flags in tail pages that will be freed individually
has been removed from the -mm tree.  Its filename was
     hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: clear flags in tail pages that will be freed individually
Date: Tue, 22 Aug 2023 15:30:43 -0700

hugetlb manually creates and destroys compound pages.  As such it makes
assumptions about struct page layout.  Commit ebc1baf5c9b4 ("mm: free up a
word in the first tail page") breaks hugetlb.  The following will fix the
breakage.

Link: https://lkml.kernel.org/r/20230822231741.GC4509@monkey
Fixes: ebc1baf5c9b4 ("mm: free up a word in the first tail page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually
+++ a/mm/hugetlb.c
@@ -1484,6 +1484,7 @@ static void __destroy_compound_gigantic_
 
 	for (i = 1; i < nr_pages; i++) {
 		p = folio_page(folio, i);
+		p->flags &= ~PAGE_FLAGS_CHECK_AT_FREE;
 		p->mapping = NULL;
 		clear_compound_head(p);
 		if (!demote)
@@ -1702,8 +1703,6 @@ static void add_hugetlb_folio(struct hst
 static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
-	int i;
-	struct page *subpage;
 	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1745,14 +1744,6 @@ static void __update_and_free_hugetlb_fo
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		subpage = folio_page(folio, i);
-		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
-				1 << PG_referenced | 1 << PG_dirty |
-				1 << PG_active | 1 << PG_private |
-				1 << PG_writeback);
-	}
-
 	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
 	 * need to be given back to CMA in free_gigantic_folio.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


