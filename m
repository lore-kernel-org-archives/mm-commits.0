Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4408EC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 17:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbiGMRgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiGMRgp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 13:36:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2982CCBA
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 10:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D95BB82113
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 17:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB579C3411E;
        Wed, 13 Jul 2022 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657733795;
        bh=4osfcf4cDw+x/Df3Udsmf9qMKuG/4E5aXMKqbLCgjT0=;
        h=Date:To:From:Subject:From;
        b=D6bgr715R8raMnYCAUo4X3IHWFN1y4k+Uj5eJR9yCiVpUXjHHMcLcIRD0lIDjWvsd
         Dcu52dP4C7KHXsOCK9Oz/YEiDFCpvZNaWGbv8LXV/KUOvGUmSGnqq0PjApnG78blAR
         HxIOpJQWSJEb2/Azr8lFiAlMCqc+x64VcQB6CdLo=
Date:   Wed, 13 Jul 2022 10:36:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch removed from -mm tree
Message-Id: <20220713173635.BB579C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
Date: Fri, 8 Jul 2022 14:36:52 +0900

Currently if memory_failure() (modified to remove blocking code with
subsequent patch) is called on a page in some 1GB hugepage, memory error
handling fails and the raw error page gets into leaked state.  The impact
is small in production systems (just leaked single 4kB page), but this
limits the testability because unpoison doesn't work for it.  We can no
longer create 1GB hugepage on the 1GB physical address range with such
leaked pages, that's not useful when testing on small systems.

When a hwpoison page in a 1GB hugepage is handled, it's caught by the
PageHWPoison check in free_pages_prepare() because the 1GB hugepage is
broken down into raw error pages before coming to this point:

        if (unlikely(PageHWPoison(page)) && !order) {
                ...
                return false;
        }

Then, the page is not sent to buddy and the page refcount is left 0.

Originally this check is supposed to work when the error page is freed
from page_handle_poison() (that is called from soft-offline), but now we
are opening another path to call it, so the callers of
__page_handle_poison() need to handle the case by considering the return
value 0 as success.  Then page refcount for hwpoison is properly
incremented so unpoison works.

Link: https://lkml.kernel.org/r/20220708053653.964464-8-naoya.horiguchi@linux.dev
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

 mm/memory-failure.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -1084,7 +1084,6 @@ static int me_huge_page(struct page_stat
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
 		unlock_page(hpage);
 	} else {
-		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error hugepage,
@@ -1092,9 +1091,11 @@ static int me_huge_page(struct page_stat
 		 * subpages.
 		 */
 		put_page(hpage);
-		if (__page_handle_poison(p) > 0) {
+		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
+		} else {
+			res = MF_FAILED;
 		}
 	}
 
@@ -1860,10 +1861,11 @@ retry:
 	 */
 	if (res == 0) {
 		unlock_page(head);
-		res = MF_FAILED;
-		if (__page_handle_poison(p) > 0) {
+		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
+		} else {
+			res = MF_FAILED;
 		}
 		action_result(pfn, MF_MSG_FREE_HUGE, res);
 		return res == MF_RECOVERED ? 0 : -EBUSY;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

