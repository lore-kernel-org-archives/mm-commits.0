Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3E6C3F6B0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244801AbiHIBPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbiHIBOd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9B41DA7A
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 918FCB81125
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46949C433D6;
        Tue,  9 Aug 2022 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007670;
        bh=BjPLHLelc5KccJtKNwb7R4ePSnhvfD2hdY/2UrYD7vM=;
        h=Date:To:From:Subject:From;
        b=ycCyzO7p6QDNiyBzwUF7JQvFsiRq9fq4gMax4lab5zG5wtBOCYptAHrhg3R0JeBxE
         bqhT2S777MVr3HTwf6gUtuBQeTeODSKozOfO07Y06kM9IcOkf+3YyA5QjEU9v4d33z
         tXq3LmDiVv3GtKvHVUGZ1OrtN6xUcq7fUAF+VujU=
Date:   Mon, 08 Aug 2022 18:14:29 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-make-__page_handle_poison-returns-int.patch removed from -mm tree
Message-Id: <20220809011430.46949C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: make __page_handle_poison returns int
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-make-__page_handle_poison-returns-int.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: make __page_handle_poison returns int
Date: Thu, 14 Jul 2022 13:24:18 +0900

__page_handle_poison() returns bool that shows whether
take_page_off_buddy() has passed or not now.  But we will want to
distinguish another case of "dissolve has passed but taking off failed" by
its return value.  So change the type of the return value.  No functional
change.

Link: https://lkml.kernel.org/r/20220714042420.1847125-7-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-make-__page_handle_poison-returns-int
+++ a/mm/memory-failure.c
@@ -74,7 +74,13 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
-static bool __page_handle_poison(struct page *page)
+/*
+ * Return values:
+ *   1:   the page is dissolved (if needed) and taken off from buddy,
+ *   0:   the page is dissolved (if needed) and not taken off from buddy,
+ *   < 0: failed to dissolve.
+ */
+static int __page_handle_poison(struct page *page)
 {
 	int ret;
 
@@ -84,7 +90,7 @@ static bool __page_handle_poison(struct
 		ret = take_page_off_buddy(page);
 	zone_pcp_enable(page_zone(page));
 
-	return ret > 0;
+	return ret;
 }
 
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
@@ -94,7 +100,7 @@ static bool page_handle_poison(struct pa
 		 * Doing this check for free pages is also fine since dissolve_free_huge_page
 		 * returns 0 for non-hugetlb pages as well.
 		 */
-		if (!__page_handle_poison(page))
+		if (__page_handle_poison(page) <= 0)
 			/*
 			 * We could fail to take off the target page from buddy
 			 * for example due to racy page allocation, but that's
@@ -1086,7 +1092,7 @@ static int me_huge_page(struct page_stat
 		 * subpages.
 		 */
 		put_page(hpage);
-		if (__page_handle_poison(p)) {
+		if (__page_handle_poison(p) > 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
@@ -1867,7 +1873,7 @@ retry:
 	if (res == 0) {
 		unlock_page(head);
 		res = MF_FAILED;
-		if (__page_handle_poison(p)) {
+		if (__page_handle_poison(p) > 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


