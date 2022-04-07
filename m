Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89D4C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 22:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiDGWyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 18:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiDGWyq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 18:54:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0CA16C098
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 15:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6845E60AEB
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 22:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3B2C385A4;
        Thu,  7 Apr 2022 22:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649371963;
        bh=G2igHkg+n73GIIA47s3GlUc1QiSBYNNxaBoTOwH3HDE=;
        h=Date:To:From:Subject:From;
        b=Pb3QyzKS5mMSnI+KCzPjCl3Yl6MURQtnsttffLpmHmQTrWxzwuYO7EFiZQyPSxbOq
         zCYiB3y9rnkBY97sfCBpYieYu66X3tdMqECpd+ezEgHVJ7nEH+1gx04Y8K+k5504wu
         hO8psXZ0kOmuwHG17bq1xGg/9jqheXlDCmzKtf+M=
Date:   Thu, 07 Apr 2022 15:52:43 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7.patch added to -mm tree
Message-Id: <20220407225243.BE3B2C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7.patch

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
Subject: mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7

- Move lock_page() to try_memory_failure_hugetlb()
  (based on bug report from Dan Carpenter)
- Add Fixes: tag and CC to stable.

Link: https://lkml.kernel.org/r/20220407112929.1344748-1-naoya.horiguchi@linux.dev
Fixes: 761ad8d7c7b5 ("mm: hwpoison: introduce memory_failure_hugetlb()")
Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7
+++ a/mm/memory-failure.c
@@ -1500,8 +1500,6 @@ static int try_to_split_thp_page(struct
 
 /*
  * Called from hugetlb code with hugetlb_lock held.
- * If a hugepage is successfully grabbed (so it's determined to handle
- * the error as a hugepage error), returns with holding the page lock.
  *
  * Return values:
  *   0             - free hugepage
@@ -1533,25 +1531,20 @@ int __get_huge_page_for_hwpoison(unsigne
 		goto out;
 	}
 
-	lock_page(head);
-
 	if (hwpoison_filter(page)) {
 		ret = -EOPNOTSUPP;
-		goto unlock;
+		goto out;
 	}
 
 	if (TestSetPageHWPoison(head)) {
 		ret = -EHWPOISON;
-		goto unlock;
+		goto out;
 	}
 
-	/* keep locking page. */
 	return ret;
-unlock:
-	unlock_page(head);
+out:
 	if (count_increased)
 		put_page(head);
-out:
 	return ret;
 }
 
@@ -1596,14 +1589,11 @@ retry:
 
 	num_poisoned_pages_inc();
 
-	head = compound_head(p);
-
 	/*
 	 * Handling free hugepage.  The possible race with hugepage allocation
 	 * or demotion can be prevented by PageHWPoison flag.
 	 */
 	if (res == 0) {
-		unlock_page(head);
 		res = MF_FAILED;
 		if (__page_handle_poison(p)) {
 			page_ref_inc(p);
@@ -1613,6 +1603,9 @@ retry:
 		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
+	head = compound_head(p);
+	lock_page(head);
+
 	/*
 	 * The page could have changed compound pages due to race window.
 	 * If this happens just bail out.
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb.patch
mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb-v7.patch

