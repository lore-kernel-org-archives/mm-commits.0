Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1615C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822DC2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633390;
	bh=qpuZ/VkvJzifSxaBQhWMr9MSpJnVv6RDb3owHB3+UUQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1Tc1p6Cc43A23brKD34GOYM3ij+66LMvhvkXVD2p547JkKwkcxmVlPDqswjZ2LfPp
	 lHvLUEi5ChIqk2H0kTtSXhksM7C7CRxJu8q8uvDHJHzY9z10QaxhlBIznIeQcb7d9a
	 jRkHeiRkP6J+QEIzoi6JxjFCMoVwbZC/8pYvCG8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgJMX4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX42 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B7A82222E;
        Tue, 13 Oct 2020 23:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633387;
        bh=qpuZ/VkvJzifSxaBQhWMr9MSpJnVv6RDb3owHB3+UUQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZkcMkj4+otIaFP/rej3oi0hi18x0EvEFFtybMDnyAFCqrfiUGU2Y900JPqMD5mSN3
         f4jJylSN5fbhGIf3ycAwJfOFSND1c3K9RxIIKv4PBG9VVj47pHn2ISL/9jVDwus1HD
         Vjd4LXnfMs7/HFovaBGJWywsOLJWdxlia0WzvBV0=
Date:   Tue, 13 Oct 2020 16:56:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 146/181] mm/hugetlb: use list_splice to merge two
 list at once
Message-ID: <20201013235627.0rL2kGTLX%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: use list_splice to merge two list at once

Instead of add allocated file_region one by one to region_cache, we could
use list_splice to merge two list at once.

Also we know the number of entries in the list, increase the number
directly.

Link: https://lkml.kernel.org/r/20200831022351.20916-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-list_splice-to-merge-two-list-at-once
+++ a/mm/hugetlb.c
@@ -443,11 +443,8 @@ static int allocate_file_region_entries(
 
 		spin_lock(&resv->lock);
 
-		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
-			list_del(&rg->link);
-			list_add(&rg->link, &resv->region_cache);
-			resv->region_cache_count++;
-		}
+		list_splice(&allocated_regions, &resv->region_cache);
+		resv->region_cache_count += to_allocate;
 	}
 
 	return 0;
_
