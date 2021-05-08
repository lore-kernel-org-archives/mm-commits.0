Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA0EC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F140613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWsR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C7A86100C;
        Sat,  8 May 2021 22:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514034;
        bh=1HFF0xAgYLolOvVdxLudOeI++PpBOODBvcyMaZuU9oM=;
        h=Date:From:To:Subject:From;
        b=POEq3ZI88gZgND29anIWeu/XJvYcrUI8gCo7wGP7YQvtSpnNy7MKMQhlqox+QA7ie
         go71UdigC0Uj2juDFS4uzfLe1xYhF3jj6nbKkpwFTwh8hhVXJ8qxBTkM9XZ5YNckhq
         gQLW+NOjrWR7r9vRFdiaQ2MmR4Whd8IKWD23VLwI=
Date:   Sat, 08 May 2021 15:47:14 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?khugepaged-remove-meaningless-pte=5Fpresent-check-in-khuge?=
 =?US-ASCII?Q?paged=5Fscan=5Fpmd.patch?= removed from -mm tree
Message-ID: <20210508224714.bnSB3XtEy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: remove meaningless !pte_present() check in khugepaged_scan_pmd()
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-meaningless-pte_present-check-in-khugepaged_scan_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


