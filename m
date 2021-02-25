Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C89C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BBC64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhBYTck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234438AbhBYTaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A814064F39;
        Thu, 25 Feb 2021 19:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280650;
        bh=LdCW6dmUWJYzRfXCdyTY3Akth2EagGc60/LpP5M6kfc=;
        h=Date:From:To:Subject:From;
        b=ChFkPuq+T6V6JB7lTnk2+Tq3IKGmG/ZOBj59G0JjwS9uFJFBs4ObpAQ55li0c/Biw
         qJUTN/jOuECva0l9wGp0kSV6cY5+vRLE+eyVW6euuad1THVUPX42/ugviNW9lH86c9
         7Q9GAddf6sB/UOeiyLQ0njggrTZmi1ee9Wf+/dls=
Date:   Thu, 25 Feb 2021 11:17:30 -0800
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, guro@fb.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
 removed from -mm tree
Message-ID: <20210225191730.vo2Y4iZxl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page

If hugetlb_cma is enabled, it will skip boot time allocation when
allocating gigantic page, that doesn't means allocation failure, so
suppress this warning info.

Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page
+++ a/mm/hugetlb.c
@@ -2529,7 +2529,7 @@ static void __init hugetlb_hstate_alloc_
 		if (hstate_is_gigantic(h)) {
 			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
-				break;
+				goto free;
 			}
 			if (!alloc_bootmem_huge_page(h))
 				break;
@@ -2547,7 +2547,7 @@ static void __init hugetlb_hstate_alloc_
 			h->max_huge_pages, buf, i);
 		h->max_huge_pages = i;
 	}
-
+free:
 	kfree(node_alloc_noretry);
 }
 
_

Patches currently in -mm which might be from chenwandun@huawei.com are


