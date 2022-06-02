Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65382C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiFBSf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiFBSfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7A71277D
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A5861723
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AE9C385A5;
        Thu,  2 Jun 2022 18:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654194923;
        bh=rNWyi/FrCHyiK5JIVe7W0cl/8Ft0drXW1HcWVW0k/Xs=;
        h=Date:To:From:Subject:From;
        b=jF2Mc6iuL4LxwEs7WN370xzh4e/VULBZf3mDdRfhCoNEOLF7TYUszTDbWwAqIhTcV
         Nsiq+yIzbtvcXsbCPSd2wAGCePuZ5yEcX1exDG2HfNtC3KtfYAXe9QKJXAkgTC9UIO
         X7TfTts/jDCkZTCnw/+vcrp2GczinT/J0pE0BLq0=
Date:   Thu, 02 Jun 2022 11:35:23 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch added to mm-unstable branch
Message-Id: <20220602183523.C5AE9C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: set PG_hwpoison for busy hugetlb pages
has been added to the -mm mm-unstable branch.  Its filename is
     mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch

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
Subject: mm,hwpoison: set PG_hwpoison for busy hugetlb pages
Date: Thu, 2 Jun 2022 14:06:28 +0900

If memory_failure() fails to grab page refcount on a hugetlb page because
it's busy, it returns without setting PG_hwpoison on it.  This not only
loses a chance of error containment, but breaks the rule that
action_result() should be called only when memory_failure() do any of
handling work (even if that's just setting PG_hwpoison).  This
inconsistency could harm code maintainability.

So set PG_hwpoison and call hugetlb_set_page_hwpoison() for such a case.

Link: https://lkml.kernel.org/r/20220602050631.771414-3-naoya.horiguchi@linux.dev
Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
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

 include/linux/mm.h  |    1 +
 mm/memory-failure.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages
+++ a/include/linux/mm.h
@@ -3248,6 +3248,7 @@ enum mf_flags {
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
+	MF_NO_RETRY = 1 << 5,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/mm/memory-failure.c~mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages
+++ a/mm/memory-failure.c
@@ -1527,7 +1527,8 @@ int __get_huge_page_for_hwpoison(unsigne
 			count_increased = true;
 	} else {
 		ret = -EBUSY;
-		goto out;
+		if (!(flags & MF_NO_RETRY))
+			goto out;
 	}
 
 	if (TestSetPageHWPoison(head)) {
@@ -1557,7 +1558,6 @@ static int try_memory_failure_hugetlb(un
 	struct page *p = pfn_to_page(pfn);
 	struct page *head;
 	unsigned long page_flags;
-	bool retry = true;
 
 	*hugetlb = 1;
 retry:
@@ -1573,8 +1573,8 @@ retry:
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

mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch
mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

