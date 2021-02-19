Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88210C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 23:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5398B64EB3
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 23:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSXUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Feb 2021 18:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhBSXUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Feb 2021 18:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECED664EB3;
        Fri, 19 Feb 2021 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613776764;
        bh=cUswPstBuFWG0x1QfZyVYHIHKbwq7sgutyJzNCOft9E=;
        h=Date:From:To:Subject:From;
        b=V2tc5E7xl/AJ5o2tX1QDWitY0Jx2pIWqMZWGj9iKISzakhUCLGnlnXWe3RSlo7v2R
         pfwXdINeInwEzF3pxTOUAxGE5KR9pdWSnsVkp7T1rFvOFvxFjjaZrDigzjb9A0rYnF
         LgZ4EfGA5u4BvxQVhMwiM+K7s2dBNkac3mwC0bjg=
Date:   Fri, 19 Feb 2021 15:19:23 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com, guro@fb.com,
        chenwandun@huawei.com
Subject:  +
 mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch added
 to -mm tree
Message-ID: <20210219231923.81_M1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: suppress wrong warning info when alloc gigantic page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-suppress-wrong-warning-info-when-alloc-gigantic-page.patch

