Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944ADC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E4F61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FBC4613E8;
        Sat,  8 May 2021 22:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514030;
        bh=vkKtpdsx+2kakMeuAuOxzORqahfUI/1Bu/NdaSrvhu4=;
        h=Date:From:To:Subject:From;
        b=LUq0Nxn6fvkJxvnjKz82aRMfnSkxRxT6C4FShKbbSC5QX+KUkJE5KM+dnYOWLe9e+
         B6tU63VQXX67oONgwfk+Vb8LEIXRimTO22+60xoux571iF/9Hki3EgHgUQd1k9V3OS
         gQXpKZme0ePSd1tvN8WXFJPXEYIpd3wk18rK0afk=
Date:   Sat, 08 May 2021 15:47:10 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?khugepaged-use-helper-function-range=5Fin=5Fvma-in-colla?=
 =?US-ASCII?Q?pse=5Fpte=5Fmapped=5Fthp.patch?= removed from -mm tree
Message-ID: <20210508224710.dnPIrtBwX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: use helper function range_in_vma() in collapse_pte_mapped_thp()
has been removed from the -mm tree.  Its filename was
     khugepaged-use-helper-function-range_in_vma-in-collapse_pte_mapped_thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


