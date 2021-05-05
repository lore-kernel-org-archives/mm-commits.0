Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD23DC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB51F613E4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhEEBe2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEEBe2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A83613E2;
        Wed,  5 May 2021 01:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178412;
        bh=emwOCu7E8jR3cRHzJgYk3sZBZy5Y1RCW8lrydNyaBZY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=04Hr9VVz5M5bK6DpeTxHPvrwit7LXnxA7h5bNqVsXz5F3oiW7vslImeM3NdVR64bk
         uNNL3sgcE1PE0y61qDycKCLvXceT5tkL1aHdh0in/BEW9ZMb8tQ9IkVTk1me8n8Iiu
         JIv414xbCEVkTc2jOEmAHv+b+BBpIV2YXE520mME=
Date:   Tue, 04 May 2021 18:33:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 015/143] mm/hugetlb: simplify the code when
 alloc_huge_page() failed in hugetlb_no_page()
Message-ID: <20210505013331.2DzwAOLrt%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
