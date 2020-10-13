Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837B1C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50D742222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633401;
	bh=vraTFkAyU3iWIqq4aMcctztFK+Kn+g4VWSaDarwk7+E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SOPvtLw8cPSyNuUjO+8yndsOIm6B6Xrcy2b3kxFkksv/7npuGNczxV0fnKdhPNDSo
	 4D4LtWBp07qRgwqqpEWz04gkujiVag+c6bEsTvZqPberoZv+Lo1EGaaWpJ6kVwZtfP
	 kYIKrmwGV6COT3kgWfTcKNngSpXGApeLrr5ndeoI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgJMX4l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1612D2222E;
        Tue, 13 Oct 2020 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633400;
        bh=vraTFkAyU3iWIqq4aMcctztFK+Kn+g4VWSaDarwk7+E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yUJcoNVZZJUQGF2dOzPzmD/0HfIW74rmn9PbxFOUiNg7rJx5E3uWjgZ4qha8oGa2Z
         TqVKjyHxNXbN2MoFeDpt333fxT5G480+U/bN2Go00SzjNXrB/6rjsvtgr0vDUcQgbR
         9no3D0A3JrkwyKhJygoVec+6idiXs6vPofNSCmB8=
Date:   Tue, 13 Oct 2020 16:56:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 150/181] mm/hugetlb: take the free hpage during
 the iteration directly
Message-ID: <20201013235639.j6ScZKibf%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: take the free hpage during the iteration directly

Function dequeue_huge_page_node_exact() iterates the free list and return
the first valid free hpage.

Instead of break and check the loop variant, we could return in the loop
directly.  This could reduce some redundant check.

[mike.kravetz@oracle.com: points out a logic error]
[richard.weiyang@linux.alibaba.com: v4]
  Link: https://lkml.kernel.org/r/20200901014636.29737-8-richard.weiyang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20200831022351.20916-8-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-take-the-free-hpage-during-the-iteration-directly
+++ a/mm/hugetlb.c
@@ -1040,21 +1040,17 @@ static struct page *dequeue_huge_page_no
 		if (nocma && is_migrate_cma_page(page))
 			continue;
 
-		if (!PageHWPoison(page))
-			break;
+		if (PageHWPoison(page))
+			continue;
+
+		list_move(&page->lru, &h->hugepage_activelist);
+		set_page_refcounted(page);
+		h->free_huge_pages--;
+		h->free_huge_pages_node[nid]--;
+		return page;
 	}
 
-	/*
-	 * if 'non-isolated free hugepage' not found on the list,
-	 * the allocation fails.
-	 */
-	if (&h->hugepage_freelists[nid] == &page->lru)
-		return NULL;
-	list_move(&page->lru, &h->hugepage_activelist);
-	set_page_refcounted(page);
-	h->free_huge_pages--;
-	h->free_huge_pages_node[nid]--;
-	return page;
+	return NULL;
 }
 
 static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask, int nid,
_
