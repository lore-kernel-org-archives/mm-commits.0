Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF5CECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiILDcU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiILDa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D9F6311
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C690C61178
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BFEC433D7;
        Mon, 12 Sep 2022 03:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953373;
        bh=cfMic3i4heQp5l08j9NK3Pc41j7clK3R+UlF/U11ay8=;
        h=Date:To:From:Subject:From;
        b=t6G85JPt6N/IoEFKVUowF0xZXnmSOkTwAmJOIYMpQ/FrDKHn4XuhDRnZJk/CriSC9
         ZiKBY+02W7rIyeGWNs/xxvkSURjqe6245KMYHejuBpZhRv0H5hWKgAdfZo7GlU0gy1
         u+ERBUFvuzmSw+6RX+R5j/DtmlaCXJCSI8kxFSL8=
Date:   Sun, 11 Sep 2022 20:29:32 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, anshuman.khandual@arm.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-kill-__soft_offline_page.patch removed from -mm tree
Message-Id: <20220912032933.26BFEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: kill __soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-kill-__soft_offline_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: kill __soft_offline_page()
Date: Fri, 19 Aug 2022 11:34:02 +0800

Squash the __soft_offline_page() into soft_offline_in_use_page() and kill
__soft_offline_page().

[wangkefeng.wang@huawei.com: update hpage when try_to_split_thp_page() succeeds]
  Link: https://lkml.kernel.org/r/20220830104654.28234-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20220819033402.156519-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-kill-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -2432,11 +2432,11 @@ static bool isolate_page(struct page *pa
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
@@ -2449,6 +2449,14 @@ static int __soft_offline_page(struct pa
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
+	if (!huge && PageTransHuge(hpage)) {
+		if (try_to_split_thp_page(page)) {
+			pr_info("soft offline: %#lx: thp split failed\n", pfn);
+			return -EBUSY;
+		}
+		hpage = page;
+	}
+
 	lock_page(page);
 	if (!PageHuge(page))
 		wait_on_page_writeback(page);
@@ -2498,19 +2506,6 @@ static int __soft_offline_page(struct pa
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

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

