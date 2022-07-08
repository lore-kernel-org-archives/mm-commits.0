Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B22C43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiGHAyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiGHAya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:54:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BB070E6C
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195B7B824B5
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC8EC3411E;
        Fri,  8 Jul 2022 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657241666;
        bh=3kOnn/Aw61c+3FmugCdUzauV9B3tyxwrhHHHF5TjVU4=;
        h=Date:To:From:Subject:From;
        b=1fgpIkgK9wzVLZ5AXcMOP4RAfmOZvh9VDB7Ny1WSnPP1oWOUF6+rpvPVTFZ/e3yej
         P4IKZVsO2ePkT1InnCUZFiQaxMeoveyCtonCWPe8U23cMTvO+BdRXJ95wLcOB3nnBF
         JJvRyYcCSWVq/7ZPWxi3TCrpBvu4nATQCbTeDNQE=
Date:   Thu, 07 Jul 2022 17:54:26 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-make-__page_handle_poison-returns-int.patch removed from -mm tree
Message-Id: <20220708005426.AEC8EC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: make __page_handle_poison returns int
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-make-__page_handle_poison-returns-int.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: make __page_handle_poison returns int
Date: Mon, 4 Jul 2022 10:33:10 +0900

__page_handle_poison() returns bool that shows whether
take_page_off_buddy() has passed or not now.  But we will want to
distinguish another case of "dissolve has passed but taking off failed" by
its return value.  So change the type of the return value.  No functional
change.

Link: https://lkml.kernel.org/r/20220704013312.2415700-8-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
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
@@ -71,7 +71,13 @@ atomic_long_t num_poisoned_pages __read_
 
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
 
@@ -81,7 +87,7 @@ static bool __page_handle_poison(struct
 		ret = take_page_off_buddy(page);
 	zone_pcp_enable(page_zone(page));
 
-	return ret > 0;
+	return ret;
 }
 
 static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
@@ -91,7 +97,7 @@ static bool page_handle_poison(struct pa
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
@@ -1850,7 +1856,7 @@ retry:
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

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

