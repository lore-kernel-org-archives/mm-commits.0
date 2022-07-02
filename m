Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5AFCCA481
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 04:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiGBEGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 00:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiGBEGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 00:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5283531201
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 21:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2236B82CF1
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 04:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98211C34114;
        Sat,  2 Jul 2022 04:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656734788;
        bh=ZOoO0M+hygz2k9vVYdRoCVD29IW6dwQJ4OX9EBJC2dc=;
        h=Date:To:From:Subject:From;
        b=m8B2sXO5oOICMxZ/H1YC3UHx8rQkJGyyPhtYAp77ywb75TqK6zRo6J1sbBBweEFTZ
         LmKRJua1k3Pm/pqrUzJNrhsTJp4xOQNYyNmLgP3TmKjntrhphNpZ48XyitAHS2E7C7
         q73bF9ppiI7rZbmEMdcZdLmNwd5JuTIzH7ib4GWM=
Date:   Fri, 01 Jul 2022 21:06:28 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch added to mm-unstable branch
Message-Id: <20220702040628.98211C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch

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
Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
Date: Thu, 30 Jun 2022 11:27:54 +0900

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

Link: https://lkml.kernel.org/r/20220630022755.3362349-9-naoya.horiguchi@linux.dev
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
 
@@ -1855,10 +1856,11 @@ retry:
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

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

