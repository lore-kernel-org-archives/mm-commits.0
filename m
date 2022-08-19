Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641A3C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiHSFEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244440AbiHSFEg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:04:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56805A2E1
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51267B825A9
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0BDC433C1;
        Fri, 19 Aug 2022 05:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660885473;
        bh=VMZ1umZwfcn43OdZIp+MPOfebQG1cgKnu6fbRsIwn9U=;
        h=Date:To:From:Subject:From;
        b=fUBoSiaX8cKrqkM3Tn3g47csgNyvKIVJGoW6hYsJysl3aVjk/Yf/pWQt/a0TRzSc+
         jBIh/IH1rVdFCd7qW3expiQnzssPVEOfDBRwRsJsn9/hBXiAdjGlkhTd0/a0XP4fG8
         Ayr6NkGTc3tGC0sRsEvx2tXjMUD5NjzPx6GvZet4=
Date:   Thu, 18 Aug 2022 22:04:32 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-kill-__soft_offline_page.patch added to mm-unstable branch
Message-Id: <20220819050432.EA0BDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: kill __soft_offline_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-kill-__soft_offline_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-kill-__soft_offline_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: kill __soft_offline_page()
Date: Fri, 19 Aug 2022 11:34:02 +0800

Squash the __soft_offline_page() into soft_offline_in_use_page() and kill
__soft_offline_page().

Link: https://lkml.kernel.org/r/20220819033402.156519-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-kill-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -2436,11 +2436,11 @@ static bool isolate_page(struct page *pa
 }
 
 /*
- * __soft_offline_page handles hugetlb-pages and non-hugetlb pages.
+ * soft_offline_in_use_page handles hugetlb-pages and non-hugetlb pages.
  * If the page is a non-dirty unmapped page-cache page, it simply invalidates.
  * If the page is mapped, it migrates the contents over.
  */
-static int __soft_offline_page(struct page *page)
+static int soft_offline_in_use_page(struct page *page)
 {
 	long ret = 0;
 	unsigned long pfn = page_to_pfn(page);
@@ -2453,6 +2453,13 @@ static int __soft_offline_page(struct pa
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
+	if (!huge && PageTransHuge(hpage)) {
+		if (try_to_split_thp_page(page)) {
+			pr_info("soft offline: %#lx: thp split failed\n", pfn);
+			return -EBUSY;
+		}
+	}
+
 	lock_page(page);
 	if (!PageHuge(page))
 		wait_on_page_writeback(page);
@@ -2502,19 +2509,6 @@ static int __soft_offline_page(struct pa
 	return ret;
 }
 
-static int soft_offline_in_use_page(struct page *page)
-{
-	struct page *hpage = compound_head(page);
-
-	if (!PageHuge(page) && PageTransHuge(hpage))
-		if (try_to_split_thp_page(page) < 0) {
-			pr_info("soft offline: %#lx: thp split failed\n",
-				page_to_pfn(page));
-			return -EBUSY;
-		}
-	return __soft_offline_page(page);
-}
-
 static void put_ref_page(struct page *page)
 {
 	if (page)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch

