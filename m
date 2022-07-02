Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D66CC43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 04:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiGBEGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 00:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiGBEGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 00:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6FA2E699
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 21:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 094D0B83287
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 04:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BAEC34114;
        Sat,  2 Jul 2022 04:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656734786;
        bh=OXRwFqT1SwD0DA+zTsgqpdzDK+xbfoAhghfsq0+Fs+k=;
        h=Date:To:From:Subject:From;
        b=c3OUUJry0ybg/2Awm8Wci5mi0vR0KgGtgJdAoSZd9pN+ocHNUClHVdAuJbXiOc4C2
         UeOcruk2xu5E4yFZLq56uHMfWfHH+axPnjG4DtvbBHUL+9TaEiNUQ0gjv1pEWkfIw4
         PLPkL3SIJmRgO1ZanCW0Lrlz0c3QQ3mCOe5A5R5Y=
Date:   Fri, 01 Jul 2022 21:06:26 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-make-__page_handle_poison-returns-int.patch added to mm-unstable branch
Message-Id: <20220702040626.A0BAEC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: make __page_handle_poison returns int
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-make-__page_handle_poison-returns-int.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-make-__page_handle_poison-returns-int.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: make __page_handle_poison returns int
Date: Thu, 30 Jun 2022 11:27:53 +0900

__page_handle_poison() returns bool that shows whether
take_page_off_buddy() has passed or not now.  But we will want to
distinguish another case of "dissolve has passed but taking off failed" by
its return value.  So change the type of the return value.  No functional
change.

Link: https://lkml.kernel.org/r/20220630022755.3362349-8-naoya.horiguchi@linux.dev
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

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

