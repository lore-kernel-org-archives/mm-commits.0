Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC79AC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3F720723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027205;
	bh=9CHqH3zCRh4G7zNc7BJ4LoGlDCZQvGtYekenl1PGRVI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Iw1UVT3SAuvunT8Jdw0VGXcGmAkiUqlE0Hx+L2lenG8XsNL1X6XxPlqyz2Es4Nbua
	 GDJScI02msjUIZOdEsGIbbpuydcZ+qt+BfIcufWlfTo6A36Qsu2m5MNCfraFrQIAJE
	 b6lEjxMmVvRK5tBQaLpvZAjquV+hnJSliH+mGh1s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCkF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCkE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762832065D;
        Mon, 10 Aug 2020 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027204;
        bh=9CHqH3zCRh4G7zNc7BJ4LoGlDCZQvGtYekenl1PGRVI=;
        h=Date:From:To:Subject:From;
        b=vskyMw1GOhEEJCsz2EWTLyfxGFqM8ZuqxJakJJYAu2ASt6t+Myi4f6vqc6RNsvuv7
         hM/X/jha6BNdWfL9EjOwSVuQzSe0pi6kT8PLOpCd9ArM57mdY1FRbpidfN5GP1qrpt
         8aPhLBeNJYQ8kN7wESF2elslX3f6wxbiGeF0TWV0=
Date:   Sun, 09 Aug 2020 19:40:04 -0700
From:   akpm@linux-foundation.org
To:     mgorman@suse.de, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch removed from
 -mm tree
Message-ID: <20200810024004.XGGtzD34M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: extract the common part in pfn_to_bitidx()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: extract the common part in pfn_to_bitidx()

The return value calculation is the same both for SPARSEMEM or not.

Just take it out.

Link: http://lkml.kernel.org/r/20200623124201.8199-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx
+++ a/mm/page_alloc.c
@@ -459,11 +459,10 @@ static inline int pfn_to_bitidx(struct p
 {
 #ifdef CONFIG_SPARSEMEM
 	pfn &= (PAGES_PER_SECTION-1);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
 	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
+	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
 
 /**
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


