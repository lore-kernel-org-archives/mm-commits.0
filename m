Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFC6C43462
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6689B6140E
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhEEBfL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD5E613FE;
        Wed,  5 May 2021 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178455;
        bh=I2Pw1HLYMIBSoXEhwIMYoUiKPouEB3WmAXbrTNTvUqo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BXoJ1PUDtANpR69fs77ppx7byLjDps4SAaKVc7gBqedaWq1UlRPtGRwCv/lPN0KcR
         Mkn1Rtyt6Msfh6lESgead2JvNdFgNLCYkL5p7sUJkldzTXQea8x+fgPtjH2ZX+SSBN
         LvaYAsz8zlCUTqmuvrzltTbIQvxVUdhjs7uqqQ4I=
Date:   Tue, 04 May 2021 18:34:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 029/143] khugepaged: use helper function
 range_in_vma() in collapse_pte_mapped_thp()
Message-ID: <20210505013415.jPC7DQK4u%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: use helper function range_in_vma() in collapse_pte_mapped_thp()

Patch series "Cleanup for khugepaged".

This series contains cleanups to remove unnecessary out label and
meaningless !pte_present() check.  Also use helper function to simplify
the code.  More details can be found in the respective changelogs.


This patch (of 3):

We could use helper function range_in_vma() to check whether the desired
range is inside the vma to simplify the code.

Link: https://lkml.kernel.org/r/20210325135647.64106-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210325135647.64106-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-use-helper-function-range_in_vma-in-collapse_pte_mapped_thp
+++ a/mm/khugepaged.c
@@ -1446,7 +1446,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	int i;
 
 	if (!vma || !vma->vm_file ||
-	    vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE)
+	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
 		return;
 
 	/*
_
