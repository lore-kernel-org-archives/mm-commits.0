Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCBBC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBD26140F
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhEEBfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3493C61408;
        Wed,  5 May 2021 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178461;
        bh=8LNiOTA5Iidin3MezmCMtibo8dcIExpNhF8u1nLR9pY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K3YUjkfbwXSDnTd0OmVYNMgbwdb8J3q85aw6ahV/kLwOcyCGwLPoSvWWHySAZKYx1
         hR9BiwW2fxLFu4mpJ5on9AXWzMfQ4sYpU1n/HpO6CDJ4OGsT9o1VB7qLXxFg9Xkszb
         L/7pmS4TgVxAdCnLW0RWPLhMRzApE/7vwhCmqfTw=
Date:   Tue, 04 May 2021 18:34:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 031/143] khugepaged: remove meaningless
 !pte_present() check in khugepaged_scan_pmd()
Message-ID: <20210505013420.mH76M2jFg%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: remove meaningless !pte_present() check in khugepaged_scan_pmd()

We know it must meet the !is_swap_pte() and !pte_none() condition if we
reach here. Since !is_swap_pte() indicates pte_none() or pte_present()
is met, it's guaranteed that pte must be present here.

Link: https://lkml.kernel.org/r/20210325135647.64106-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-meaningless-pte_present-check-in-khugepaged_scan_pmd
+++ a/mm/khugepaged.c
@@ -1271,10 +1271,6 @@ static int khugepaged_scan_pmd(struct mm
 				goto out_unmap;
 			}
 		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out_unmap;
-		}
 		if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
_
