Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5063C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D3761421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEHWri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWrh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5916101D;
        Sat,  8 May 2021 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513994;
        bh=YzeYUhyJ/U+sb7AX4Ky1pmx4nrmnOshV218DQikC2ts=;
        h=Date:From:To:Subject:From;
        b=xvs4ILzCxZ/U1v1BCv36UyUx4Fq2mrvH8kIqVLzI7ADcgRiQUI3/HuCZOqWJHKx0e
         BDNyOURV4Xyd7zw382wPiFNjYSFM+9L3P9G5iBxjU269HCyQl8QADnZxJ+1JT7s6/D
         GtA3iOC9cEami6jvUq82tD6Jjf5OkenURXyIeYWQ=
Date:   Sat, 08 May 2021 15:46:34 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-simplify-the-code-when-alloc=5Fhuge=5Fpage-fai?=
 =?US-ASCII?Q?led-in-hugetlb=5Fno=5Fpage.patch?= removed from -mm tree
Message-ID: <20210508224634.M7FAFrUXB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify the code when alloc_huge_page() failed in hugetlb_no_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: simplify the code when alloc_huge_page() failed in hugetlb_no_page()

Rework the error handling code when alloc_huge_page() failed to remove
some duplicated code and simplify the code slightly.

Link: https://lkml.kernel.org/r/20210308112809.26107-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page
+++ a/mm/hugetlb.c
@@ -4395,13 +4395,10 @@ retry:
 			 * sure there really is no pte entry.
 			 */
 			ptl = huge_pte_lock(h, mm, ptep);
-			if (!huge_pte_none(huge_ptep_get(ptep))) {
-				ret = 0;
-				spin_unlock(ptl);
-				goto out;
-			}
+			ret = 0;
+			if (huge_pte_none(huge_ptep_get(ptep)))
+				ret = vmf_error(PTR_ERR(page));
 			spin_unlock(ptl);
-			ret = vmf_error(PTR_ERR(page));
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


