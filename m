Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4835C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiGQAxi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiGQAxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCD91C912
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C59BB80D25
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED030C34114;
        Sun, 17 Jul 2022 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658019208;
        bh=R8LiAnutvgGl4GLcGUW/+tEjsyOu1gOJ6H3lHRmCbk0=;
        h=Date:To:From:Subject:From;
        b=jGPAwJfdWUucq8wI7TYhqUQe0+c0e0GTMgHZklrl38m/si0v7GcLnMWmg4pZmRLgR
         0BqwqdUwFfKvwviqbvRzKEHOiAE5XBNL1737Z2y9A823pVX7zPxQvKx6Ce7ZaR3XR+
         f7OzrPEZwYvp6llSbecliNiihLiwGeeN2rZvYSWQ=
Date:   Sat, 16 Jul 2022 17:53:27 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch added to mm-unstable branch
Message-Id: <20220717005327.ED030C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: set PG_hwpoison for busy hugetlb pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch

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
Subject: mm, hwpoison: set PG_hwpoison for busy hugetlb pages
Date: Thu, 14 Jul 2022 13:24:17 +0900

If memory_failure() fails to grab page refcount on a hugetlb page because
it's busy, it returns without setting PG_hwpoison on it.  This not only
loses a chance of error containment, but breaks the rule that
action_result() should be called only when memory_failure() do any of
handling work (even if that's just setting PG_hwpoison).  This
inconsistency could harm code maintainability.

So set PG_hwpoison and call hugetlb_set_page_hwpoison() for such a case.

Link: https://lkml.kernel.org/r/20220714042420.1847125-6-naoya.horiguchi@linux.dev
Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
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

 include/linux/mm.h  |    1 +
 mm/memory-failure.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages
+++ a/include/linux/mm.h
@@ -3188,6 +3188,7 @@ enum mf_flags {
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
 	MF_SW_SIMULATED = 1 << 5,
+	MF_NO_RETRY = 1 << 6,
 };
 int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 		      unsigned long count, int mf_flags);
--- a/mm/memory-failure.c~mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages
+++ a/mm/memory-failure.c
@@ -1802,7 +1802,8 @@ int __get_huge_page_for_hwpoison(unsigne
 			count_increased = true;
 	} else {
 		ret = -EBUSY;
-		goto out;
+		if (!(flags & MF_NO_RETRY))
+			goto out;
 	}
 
 	if (hugetlb_set_page_hwpoison(head, page)) {
@@ -1829,7 +1830,6 @@ static int try_memory_failure_hugetlb(un
 	struct page *p = pfn_to_page(pfn);
 	struct page *head;
 	unsigned long page_flags;
-	bool retry = true;
 
 	*hugetlb = 1;
 retry:
@@ -1845,8 +1845,8 @@ retry:
 		}
 		return res;
 	} else if (res == -EBUSY) {
-		if (retry) {
-			retry = false;
+		if (!(flags & MF_NO_RETRY)) {
+			flags |= MF_NO_RETRY;
 			goto retry;
 		}
 		action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

