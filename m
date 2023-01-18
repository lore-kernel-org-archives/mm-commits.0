Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA100C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjARVk0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjARVkY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2663C24
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A46B61A53
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65831C433F0;
        Wed, 18 Jan 2023 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674078022;
        bh=4BSkVUpJfgOB5c2fAmUXm2lpAVHDxXNy7DmXp2S+vpo=;
        h=Date:To:From:Subject:From;
        b=QBQHddB7EZvuXawn3IT7W6BkiBuGrq57NlVLtDXyKzdv3rJOG1S5qCq41dNogIygf
         Z/9s22KUyW1Rlocv3dgEE26qQZPcZoBzA+FdA7QYtfERgGQ79oj3OaPCZ6UFMeDx4i
         B75tcgwgDc2K6gnAF6tsYGbpgVLwc2AebwapKZGM=
Date:   Wed, 18 Jan 2023 13:40:21 -0800
To:     mm-commits@vger.kernel.org, m.szyprowski@samsung.com,
        minchan@kernel.org, laurent.pinchart@ideasonboard.com,
        iamjoonsoo.kim@lge.com, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch added to mm-unstable branch
Message-Id: <20230118214022.65831C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: fix potential memory loss on cma_declare_contiguous_nid
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/cma.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/cma.c~mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid
+++ a/mm/cma.c
@@ -331,18 +331,6 @@ int __init cma_declare_contiguous_nid(ph
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
@@ -359,6 +347,18 @@ int __init cma_declare_contiguous_nid(ph
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

mm-cma-fix-potential-memory-loss-on-cma_declare_contiguous_nid.patch

