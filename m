Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0AACCA47B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbiFBSff (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238190AbiFBSf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C282236A6
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD6261729
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D47C385A5;
        Thu,  2 Jun 2022 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654194928;
        bh=dx5VfC0KJJEmjKFa8DMIcRhOG5CmHOJh+M9ylaUABiE=;
        h=Date:To:From:Subject:From;
        b=VxeNGho0JRnGvmIQ/zumAYEodlUtHddoDKrENPo+3BOGAJHG80LUx8u8A8fXz5Dae
         5IJraQKTp5v0Wjg7v6H5E9JO2fsfO3C3r0HSGX4+Hpcyi6siCX6ci+BbqgCFfqBJmV
         w3/kUTySEK0IH1MAu0TDJjdqZ6s8Vm5rhbcX7YhY=
Date:   Thu, 02 Jun 2022 11:35:27 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch added to mm-unstable branch
Message-Id: <20220602183527.F2D47C385A5@smtp.kernel.org>
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
Date: Thu, 2 Jun 2022 14:06:30 +0900

Currently if memory_failure() (modified to remove blocking code) is called
on a page in some 1GB hugepage, memory error handling returns failure and
the raw error page gets into undesirable state.  The impact is small in
production systems (just leaked single 4kB page), but this limits the test
efficiency because unpoison doesn't work for it.  So we can no longer
create 1GB hugepage on the 1GB physical address range with such hwpoison
pages, that could be an issue in testing on small systems.

When a hwpoison page in a 1GB hugepage is handled, it's caught by the
PageHWPoison check in free_pages_prepare() because the hugepage is broken
down into raw error page and order is 0:

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
incremented and now unpoison works.

Link: https://lkml.kernel.org/r/20220602050631.771414-5-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -1044,7 +1044,6 @@ static int me_huge_page(struct page_stat
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
 		unlock_page(hpage);
 	} else {
-		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error hugepage,
@@ -1052,9 +1051,11 @@ static int me_huge_page(struct page_stat
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
 
@@ -1602,9 +1603,11 @@ retry:
 	 */
 	if (res == 0) {
 		unlock_page(head);
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

mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch
mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

