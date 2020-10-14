Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4368FC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4C47221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709416;
	bh=FekOk6qS5w2P00HH4nYhANtSqv1bvKEijNfPiX4riHA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Um5uG84KntoMwpU2QONOzj0eGJsoG+tC1s/ve3AfzdGjT84tiYqFaaccxj2m5tW+Y
	 C/FiWGR3vFSzBVgkv1DCwCJw9IY3uz4gFxLQc0/ILdNNphOMQCQIIAlPKhdfSv5Q5x
	 rpaT2de+xk/KQqmWTrTj6GbYAYxDsIBkoSXto/fs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgJNVDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB707214D8;
        Wed, 14 Oct 2020 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709415;
        bh=FekOk6qS5w2P00HH4nYhANtSqv1bvKEijNfPiX4riHA=;
        h=Date:From:To:Subject:From;
        b=A2WwF20UbWe7ORNRajYSyd+qB0roNv+chSChoV3wwl5B4xDdpBt+oWvW+hjnmmiWm
         JYJMIC8VK18zhM0rpAONTH9pYZGICKsQ75z6/BFbz0b5xi4MEPBl+G+/itCsM4WWfW
         sOwbBzC3P1gnLBQykIXKzUOmhydrvi4ZjfV0q7ok=
Date:   Wed, 14 Oct 2020 14:03:34 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch removed
 from -mm tree
Message-ID: <20201014210334.QZrM8GaXC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: take the free hpage during the iteration directly
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

