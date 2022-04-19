Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6AAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 04:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiDSFAj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 01:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiDSFAi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 01:00:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2903113D
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 21:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D83ADB8119F
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 04:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C46CC385A5;
        Tue, 19 Apr 2022 04:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650344274;
        bh=O8QHVYo8e471D2TXc71BfQ1DOW7kQDuxsWAsW577tg4=;
        h=Date:To:From:Subject:From;
        b=NiC7gWzvFhHC0CGjKJlRmfyjPGirQkVs22ODhAPVgtJctMESkfEHiIn4Prka0qNm+
         iMcc/T9r2Z9sOaYgp8zpQ0I9IffTTZJgr6UzYC4CnAkIR5hUQf6vmN5hVkc8YA045r
         KF/lSZKWB/tbfMzZe1MBO2isrr/7acODB6lQ6EAc=
Date:   Mon, 18 Apr 2022 21:57:53 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch added to -mm tree
Message-Id: <20220419045754.6C46CC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb, hwpoison: separate branch for free and in-use hugepage
has been added to the -mm tree.  Its filename is
     mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hugetlb, hwpoison: separate branch for free and in-use hugepage

We know that HPageFreed pages should have page refcount 0, so
get_page_unless_zero() always fails and returns 0.  So explicitly separate
the branch based on page state for minor optimization and better
readability.

Link: https://lkml.kernel.org/r/20220415041848.GA3034499@ik1-406-35019.vs.sakura.ne.jp
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    4 +++-
 mm/memory-failure.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage
+++ a/mm/hugetlb.c
@@ -6831,7 +6831,9 @@ int get_hwpoison_huge_page(struct page *
 	spin_lock_irq(&hugetlb_lock);
 	if (PageHeadHuge(page)) {
 		*hugetlb = true;
-		if (HPageFreed(page) || HPageMigratable(page))
+		if (HPageFreed(page))
+			ret = 0;
+		else if (HPageMigratable(page))
 			ret = get_page_unless_zero(page);
 		else
 			ret = -EBUSY;
--- a/mm/memory-failure.c~mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage
+++ a/mm/memory-failure.c
@@ -1518,7 +1518,9 @@ int __get_huge_page_for_hwpoison(unsigne
 	if (flags & MF_COUNT_INCREASED) {
 		ret = 1;
 		count_increased = true;
-	} else if (HPageFreed(head) || HPageMigratable(head)) {
+	} else if (HPageFreed(head)) {
+		ret = 0;
+	} else if (HPageMigratable(head)) {
 		ret = get_page_unless_zero(head);
 		if (ret)
 			count_increased = true;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb.patch
mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch
revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch

