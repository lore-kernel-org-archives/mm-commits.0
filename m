Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE02C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6439221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709409;
	bh=c82qlOtsTcb+vRwVXwzt1D9JgSPtR8mL/8/mibKPhso=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cFSh5zaXM2JQEVC3sPrqt5EvRjY33u/IDUcfh5ZuHmw3tNJFGm6eN1H01X5+x5yyW
	 eOkcf5zVro4MsEKCtmDq4KdOw8ra1uxfaiWXa/Xk4jnNN2XtMCezcFcEM751/a4mFG
	 7zRxbM4LoyhihwMr+ZBhQFbzmdetb5hrSielb6oI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgJNVD3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVD3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7F0206B2;
        Wed, 14 Oct 2020 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709408;
        bh=c82qlOtsTcb+vRwVXwzt1D9JgSPtR8mL/8/mibKPhso=;
        h=Date:From:To:Subject:From;
        b=T/rPgoAgWDkmNtmIR3teNRE+qF9n0CT/5+L0zUPiH2bfxxXGBUq/1mqPL+WhNvkuK
         porU2leVWW5GV4B9SjowPaW5dAnWBsoWyotpanKV0hwxQHWRWuurTRTbvK4AVTJT3Q
         NnCMEbLm4uA5ggfbCFlS1jY5GfX3asRpHfqS/c2s=
Date:   Wed, 14 Oct 2020 14:03:28 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch removed from -mm tree
Message-ID: <20201014210328.IA0VWv09v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: a page from buddy is not on any list
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: a page from buddy is not on any list

The page allocated from buddy is not on any list, so just use list_add()
is enough.

Link: https://lkml.kernel.org/r/20200831022351.20916-6-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-a-page-from-buddy-is-not-on-any-list
+++ a/mm/hugetlb.c
@@ -2416,7 +2416,7 @@ struct page *alloc_huge_page(struct vm_a
 			h->resv_huge_pages--;
 		}
 		spin_lock(&hugetlb_lock);
-		list_move(&page->lru, &h->hugepage_activelist);
+		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

