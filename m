Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECCBC43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKIBle (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKIBkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55267F6E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EB95B81CD9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060B8C433C1;
        Wed,  9 Nov 2022 01:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957961;
        bh=Yid6pq4erB2x0xJ79/ebM738j0sab1JymEGbqeFaOxc=;
        h=Date:To:From:Subject:From;
        b=2vxqrlmt0G461QpYaUmCbqxA4eySZQXn5tuX8nC2T9wSwNKUpjnT5S4bhzatednX9
         SIhaLSjwJEutLBG/FtE33rCiwPGF3SykzBHBXVk/wkEQm3bLiT3aXVcNHs/CswlCOd
         7NWDNQ2VdMT9ZVN4xYfRAD6Ab1apUQ36+gcgcL5I=
Date:   Tue, 08 Nov 2022 17:39:20 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-make-put_ref_page-more-useful.patch removed from -mm tree
Message-Id: <20221109013921.060B8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: make put_ref_page() more useful
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-make-put_ref_page-more-useful.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: make put_ref_page() more useful
Date: Fri, 21 Oct 2022 16:46:09 +0800

Pass pfn/flags to put_ref_page(), then check MF_COUNT_INCREASED and drop
refcount to make the code look cleaner.

Link: https://lkml.kernel.org/r/20221021084611.53765-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-put_ref_page-more-useful
+++ a/mm/memory-failure.c
@@ -1910,17 +1910,25 @@ static inline unsigned long free_raw_hwp
 }
 #endif	/* CONFIG_HUGETLB_PAGE */
 
+/* Drop the extra refcount in case we come from madvise() */
+static void put_ref_page(unsigned long pfn, int flags)
+{
+	struct page *page;
+
+	if (!(flags & MF_COUNT_INCREASED))
+		return;
+
+	page = pfn_to_page(pfn);
+	if (page)
+		put_page(page);
+}
+
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
 	int rc = -ENXIO;
 
-	if (flags & MF_COUNT_INCREASED)
-		/*
-		 * Drop the extra refcount in case we come from madvise().
-		 */
-		put_page(page);
+	put_ref_page(pfn, flags);
 
 	/* device metadata space is not recoverable */
 	if (!pgmap_pfn_valid(pgmap, pfn))
@@ -2513,12 +2521,6 @@ static int soft_offline_in_use_page(stru
 	return ret;
 }
 
-static void put_ref_page(struct page *page)
-{
-	if (page)
-		put_page(page);
-}
-
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
@@ -2547,19 +2549,17 @@ int soft_offline_page(unsigned long pfn,
 {
 	int ret;
 	bool try_again = true;
-	struct page *page, *ref_page = NULL;
+	struct page *page;
 
 	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
-	if (flags & MF_COUNT_INCREASED)
-		ref_page = pfn_to_page(pfn);
 
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
 	if (!page) {
-		put_ref_page(ref_page);
+		put_ref_page(pfn, flags);
 		return -EIO;
 	}
 
@@ -2567,7 +2567,7 @@ int soft_offline_page(unsigned long pfn,
 
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
-		put_ref_page(ref_page);
+		put_ref_page(pfn, flags);
 		mutex_unlock(&mf_mutex);
 		return 0;
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


