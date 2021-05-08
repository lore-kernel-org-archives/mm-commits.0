Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63382C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 453B561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWsO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7219B613C5;
        Sat,  8 May 2021 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514032;
        bh=Y2x2a7YLPMcqT/7B2nyWyf6RvFJ/xz48/4sVGEl1WqM=;
        h=Date:From:To:Subject:From;
        b=gTATD6MC58dGkWc06q8QBIKHlheLGA2mJCkG4HYIM3bxOFw2eodGTjVgxbM6CAFgP
         XX2R6lnVv+Ap3/AkFq1boxGiX7i4/xTf8UqKIvvUAvSiS1Gx59jUez3okxPGs4XAHx
         wxBIZ+re1Oh9XN2HehA3yGrBGgzGgB1ZFbX89XpA=
Date:   Sat, 08 May 2021 15:47:12 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  [merged]
 khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch removed
 from -mm tree
Message-ID: <20210508224712.q7KwhW_gx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: remove unnecessary out label in collapse_huge_page()
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-unnecessary-out-label-in-collapse_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: remove unnecessary out label in collapse_huge_page()

The out label here is unneeded because it just goes to out_up_write label.
Remove it to make code more concise.

Link: https://lkml.kernel.org/r/20210325135647.64106-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-unnecessary-out-label-in-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1128,10 +1128,10 @@ static void collapse_huge_page(struct mm
 	mmap_write_lock(mm);
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
-		goto out;
+		goto out_up_write;
 	/* check if the pmd is still valid */
 	if (mm_find_pmd(mm, address) != pmd)
-		goto out;
+		goto out_up_write;
 
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -1171,7 +1171,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(pmd_ptl);
 		anon_vma_unlock_write(vma->anon_vma);
 		result = SCAN_FAIL;
-		goto out;
+		goto out_up_write;
 	}
 
 	/*
@@ -1215,8 +1215,6 @@ out_nolock:
 		mem_cgroup_uncharge(*hpage);
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
-out:
-	goto out_up_write;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


