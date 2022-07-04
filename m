Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B5CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiGDBJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGDBJZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596112DFF
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D70436130A
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36161C341CB;
        Mon,  4 Jul 2022 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896963;
        bh=uaLAPEFkjqaD8OwpMcEsT9QCeolaW3hpoVhvK9L/1u0=;
        h=Date:To:From:Subject:From;
        b=s/9ohCdk0Yzn/QU3m4TBF2B+22GtgmJb4gde//XqUZVBH9IKi8rCMTfckL9cB9lgn
         XT8ujzrIOztkTfxEnepBe+mUHr0GfKfUTzBEElm7GgKvm9UjJfp81RP/wJhcPuMxex
         ruHBvUi2weoImSE/q6NwrupYUZKAcDOtFQdV4Xck=
Date:   Sun, 03 Jul 2022 18:09:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch removed from -mm tree
Message-Id: <20220704010923.36161C341CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK

The parameter used by DEFINE_PAGE_VMA_WALK is _page not page, fix the
parameter name.  It didn't cause any build error, it is probably because
the only caller is write_protect_page() from ksm.c, which pass in page.

Link: https://lkml.kernel.org/r/20220512174551.81279-1-shy828301@gmail.com
Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk
+++ a/include/linux/rmap.h
@@ -325,8 +325,8 @@ struct page_vma_mapped_walk {
 #define DEFINE_PAGE_VMA_WALK(name, _page, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
 		.pfn = page_to_pfn(_page),				\
-		.nr_pages = compound_nr(page),				\
-		.pgoff = page_to_pgoff(page),				\
+		.nr_pages = compound_nr(_page),				\
+		.pgoff = page_to_pgoff(_page),				\
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

