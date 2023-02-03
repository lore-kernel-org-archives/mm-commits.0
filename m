Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D263C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjBCGmo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBCGl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0E426B9
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58DA8B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE559C433EF;
        Fri,  3 Feb 2023 06:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406278;
        bh=oGQhkd6Qi2RH43Lto+WHJ0kTZO6Ah5oTTzsj1/JDPtQ=;
        h=Date:To:From:Subject:From;
        b=2YmonZXnRXuXOR6gNmW4ghs7ygWOKbUtQi4zenZ53OSePGyFeUin4/2YzSNaHXDOh
         N4PCF8BnWweUMijXiEQ2eLyEMko2dOGuktDajcy6F3W5M17+vE6EIbPtWP4zFPDgUe
         LxXu8/M7abo7UftPDZf5MmbnH1CbSlPCPo+EDDgg=
Date:   Thu, 02 Feb 2023 22:37:57 -0800
To:     mm-commits@vger.kernel.org, m.szyprowski@samsung.com,
        minchan@kernel.org, laurent.pinchart@ideasonboard.com,
        iamjoonsoo.kim@lge.com, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch removed from -mm tree
Message-Id: <20230203063757.EE559C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/cma: fix potential memory loss on cma_declare_contiguous_nid
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Levi Yun <ppbuk5246@gmail.com>
Subject: mm/cma: fix potential memory loss on cma_declare_contiguous_nid
Date: Wed, 18 Jan 2023 17:05:23 +0900

Suppose memblock_alloc_range_nid() with highmem_start succeeds when
cma_declare_contiguous_nid is called with !fixed on a 32-bit system with
PHYS_ADDR_T_64BIT enabled with memblock.bottom_up == false.

But the next trial to memblock_alloc_range_nid() to allocate in [SIZE_4G,
limits) nullifies former successfully allocated addr and it retries
memblock_alloc_ragne_nid().

In this situation, the first successfully allocated address area is lost.

Change the order of allocation (SIZE_4G, high_memory and base) and check
whether the allocated succeeded to prevent potential memory loss.

Link: https://lkml.kernel.org/r/20230118080523.44522-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/cma.c~mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid
+++ a/mm/cma.c
@@ -322,18 +322,6 @@ int __init cma_declare_contiguous_nid(ph
 		phys_addr_t addr = 0;
 
 		/*
-		 * All pages in the reserved area must come from the same zone.
-		 * If the requested region crosses the low/high memory boundary,
-		 * try allocating from high memory first and fall back to low
-		 * memory in case of failure.
-		 */
-		if (base < highmem_start && limit > highmem_start) {
-			addr = memblock_alloc_range_nid(size, alignment,
-					highmem_start, limit, nid, true);
-			limit = highmem_start;
-		}
-
-		/*
 		 * If there is enough memory, try a bottom-up allocation first.
 		 * It will place the new cma area close to the start of the node
 		 * and guarantee that the compaction is moving pages out of the
@@ -350,6 +338,18 @@ int __init cma_declare_contiguous_nid(ph
 		}
 #endif
 
+		/*
+		 * All pages in the reserved area must come from the same zone.
+		 * If the requested region crosses the low/high memory boundary,
+		 * try allocating from high memory first and fall back to low
+		 * memory in case of failure.
+		 */
+		if (!addr && base < highmem_start && limit > highmem_start) {
+			addr = memblock_alloc_range_nid(size, alignment,
+					highmem_start, limit, nid, true);
+			limit = highmem_start;
+		}
+
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
 					limit, nid, true);
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are


