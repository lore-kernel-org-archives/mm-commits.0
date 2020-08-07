Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7981C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F50E22D00
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781546;
	bh=eaUg2ySwiBrrCh4WFQpxhVU7BnmKkv/9havG05Zn9Ig=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jZZAAMsWBiWa/3hMnsUyW+KNS9qd8cdWHBFxmaxGW+CPkgM2ySxYKWUDkgOBqrI80
	 84bZnz2MZ0Rdf9KIM//tdyPCrVAp2YSRM3ZZElcGDARxoJYfhfZlzDqaj22JT2GXsA
	 cGTFsFVlGIb944yGPPmQuQIGAKB+fbTZ5UXY4Hhw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgHGGZq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF8022CF6;
        Fri,  7 Aug 2020 06:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781545;
        bh=eaUg2ySwiBrrCh4WFQpxhVU7BnmKkv/9havG05Zn9Ig=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LqxYn5dAo4RQ+401RgaLAdneeLg1i2Alioea7KOuoVPAYA0DEEdVMSjnsNBXixg8T
         FlzAmErCs1Aa51CyjbGE2GZU2mgNwp7vAi/K6Is9g5py1zQ9tzWXFynBaM+OvVP3yv
         YCIcp3H7OoFRJkqUDWJUGNlUwh+kmrN7O0KAu9FA=
Date:   Thu, 06 Aug 2020 23:25:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 149/163] mm/page_alloc.c: extract the common part
 in pfn_to_bitidx()
Message-ID: <20200807062544.E0JWtD2Nu%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
