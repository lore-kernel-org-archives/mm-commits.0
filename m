Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D14C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbiEJEPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiEJEO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1529729CBA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9505161726
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F7DC385C8;
        Tue, 10 May 2022 04:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155861;
        bh=Ai4nNioh7CiNBmjlcBfFiU6eHJoVqNGU/AMHE0lkoJ8=;
        h=Date:To:From:Subject:From;
        b=lkQ2NQ/YRMH5uGcIpFpUzkdKZgFQRyN5IRmYTOyt04zCE8M9jVrMkRqcdXdqNPk/2
         8S3Y/DEeJrP1Jd4b2wtyxXqu9lsGzcPjoU5XKlzE8mbnAA0O87mmAVrNpO3uZMmC7n
         B+zX9DLQQVOqefAatsSVXm1kH3vQOzoLSj6CaXlo=
Date:   Mon, 09 May 2022 21:11:00 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch removed from -mm tree
Message-Id: <20220510041100.E8F7DC385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hugetlb, hwpoison: separate branch for free and in-use hugepage
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch

This patch was dropped because it was merged into mm-stable

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
@@ -6776,7 +6776,9 @@ int get_hwpoison_huge_page(struct page *
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
@@ -1517,7 +1517,9 @@ int __get_huge_page_for_hwpoison(unsigne
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


