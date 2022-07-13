Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF6DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 17:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbiGMRgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiGMRgg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 13:36:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780322CCB5
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 10:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0114361D06
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 17:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC2BC34114;
        Wed, 13 Jul 2022 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657733793;
        bh=Tz9BjYYzWDUEivRfJFuVSyauj0cwwBKCEdlJnyox2J0=;
        h=Date:To:From:Subject:From;
        b=WImMWzdtsVVzMIcDNN9RzhA4upS0gYuI399UP0oFk5OqA3OEtZawtKFSUVurEtEv/
         BaructzsW3GbjUJGYvi8UYNgY3D2TFwV+h0RWH/30s7CvIE9pkNATbn5xpzmHoxUrL
         GPTqJFil/3j0pKHa2p6chYWXWz5++Q1Qakj5VoGI=
Date:   Wed, 13 Jul 2022 10:36:32 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch removed from -mm tree
Message-Id: <20220713173633.4FC2BC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: set PG_hwpoison for busy hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: set PG_hwpoison for busy hugetlb pages
Date: Fri, 8 Jul 2022 14:36:50 +0900

If memory_failure() fails to grab page refcount on a hugetlb page because
it's busy, it returns without setting PG_hwpoison on it.  This not only
loses a chance of error containment, but breaks the rule that
action_result() should be called only when memory_failure() do any of
handling work (even if that's just setting PG_hwpoison).  This
inconsistency could harm code maintainability.

So set PG_hwpoison and call hugetlb_set_page_hwpoison() for such a case.

Link: https://lkml.kernel.org/r/20220708053653.964464-6-naoya.horiguchi@linux.dev
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
@@ -1788,7 +1788,8 @@ int __get_huge_page_for_hwpoison(unsigne
 			count_increased = true;
 	} else {
 		ret = -EBUSY;
-		goto out;
+		if (!(flags & MF_NO_RETRY))
+			goto out;
 	}
 
 	if (hugetlb_set_page_hwpoison(head, page)) {
@@ -1815,7 +1816,6 @@ static int try_memory_failure_hugetlb(un
 	struct page *p = pfn_to_page(pfn);
 	struct page *head;
 	unsigned long page_flags;
-	bool retry = true;
 
 	*hugetlb = 1;
 retry:
@@ -1831,8 +1831,8 @@ retry:
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
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

