Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BABC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 21:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiCPVL3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 17:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239762AbiCPVL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 17:11:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3A62BEF
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 14:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007C6B81D45
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 21:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39A4C340EC;
        Wed, 16 Mar 2022 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647465011;
        bh=ZtfaSm9WOUEid0ecdbiH6VrPrd2//LCutSLFbTlLkeI=;
        h=Date:To:From:Subject:From;
        b=MZKEeVR2joPghaJcIiyrX8+viup5fEYGmiLprTOgBXiEu6tI2BrGq3TtRaSzZsDW3
         BZvlIrVZ0TwgJMyoX9J9bekaoClSYCGORdqhCpKgUUCFGmg8EpSyRKuctsq790taqP
         nVFrsjpg/BIXtozx7OLXdeXge4zjcYFS4/kOMjrI=
Date:   Wed, 16 Mar 2022 14:10:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, luofei@unicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages.patch added to -mm tree
Message-Id: <20220316211011.B39A4C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix comments about avoiding atomic allocation of vmemmap pages
has been added to the -mm tree.  Its filename is
     hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: luofei <luofei@unicloud.com>
Subject: hugetlb: fix comments about avoiding atomic allocation of vmemmap pages

Since there is no longer an atomic allocation of vmemmap pages, but a
fixed flag(GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE) is used.  The
description of atomicity here is some what inappropriate.

And the atomic parameter naming of update_and_free_page() may be
misleading, add a comment here.

Link: https://lkml.kernel.org/r/20220316031602.377452-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages
+++ a/mm/hugetlb.c
@@ -1567,10 +1567,12 @@ static void __update_and_free_page(struc
 }
 
 /*
- * As update_and_free_page() can be called under any context, so we cannot
- * use GFP_KERNEL to allocate vmemmap pages. However, we can defer the
- * actual freeing in a workqueue to prevent from using GFP_ATOMIC to allocate
- * the vmemmap pages.
+ * Freeing hugetlb pages in done in update_and_free_page(). When freeing
+ * a hugetlb page, vmemmap pages may need to be allocated. The routine
+ * alloc_huge_page_vmemmap() can possibly sleep as it uses GFP_KERNEL.
+ * However, update_and_free_page() can be called under any context. To
+ * avoid the possibility of sleeping in a context where sleeping is not
+ * allowed, defer the actual freeing in a workqueue where sleeping is allowed.
  *
  * free_hpage_workfn() locklessly retrieves the linked list of pages to be
  * freed and frees them one-by-one. As the page->mapping pointer is going
@@ -1614,6 +1616,10 @@ static inline void flush_free_hpage_work
 		flush_work(&free_hpage_work);
 }
 
+/*
+ * atomic == true indicates called from a context where sleeping is
+ * not allowed.
+ */
 static void update_and_free_page(struct hstate *h, struct page *page,
 				 bool atomic)
 {
@@ -1623,7 +1629,8 @@ static void update_and_free_page(struct
 	}
 
 	/*
-	 * Defer freeing to avoid using GFP_ATOMIC to allocate vmemmap pages.
+	 * Defer freeing to avoid possible sleeping when allocating
+	 * vmemmap pages.
 	 *
 	 * Only call schedule_work() if hpage_freelist is previously
 	 * empty. Otherwise, schedule_work() had been called but the workfn
_

Patches currently in -mm which might be from luofei@unicloud.com are

mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch
hugetlb-fix-comments-about-avoiding-atomic-allocation-of-vmemmap-pages.patch

