Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB666C5ACB2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjKOXa7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbjKOXaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054831A5;
        Wed, 15 Nov 2023 15:30:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15DC433C7;
        Wed, 15 Nov 2023 23:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091051;
        bh=EBzxAG8wS91F6XaN/s9CY4TirJKQ+lF5YFqAWB033Vs=;
        h=Date:To:From:Subject:From;
        b=0a62pmiywB2kPGQrKDl1uO6G5RatLFBBgSsdDHq/FnOQsD/Wu7rlh9kgMQMz2eR4X
         fpdjLyOQUpb2LXEvsUmFHdbNnQ4Idoqg/JctQ5gLuHo3JEAPmBiIyo22SHjk2gFAi/
         cmtw7+KrK/8lJWGySnxGRflRdlgjcNssHTXZfeTI=
Date:   Wed, 15 Nov 2023 15:30:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, shakeelb@google.com, cl@linux.com,
        roman.gushchin@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] cgroups-warning-for-metadata-allocation-with-gfp_nofail-was-re-folio_alloc_buffers-doing-allocations-order-1-with-gfp_nofail.patch removed from -mm tree
Message-Id: <20231115233051.8E15DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmem: drop __GFP_NOFAIL when allocating objcg vectors
has been removed from the -mm tree.  Its filename was
     cgroups-warning-for-metadata-allocation-with-gfp_nofail-was-re-folio_alloc_buffers-doing-allocations-order-1-with-gfp_nofail.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: drop __GFP_NOFAIL when allocating objcg vectors
Date: Tue, 7 Nov 2023 09:18:02 -0800

Objcg vectors attached to slab pages to store slab object ownership
information are allocated using gfp flags for the original slab
allocation.  Depending on slab page order and the size of slab objects,
objcg vector can take several pages.

If the original allocation was done with the __GFP_NOFAIL flag, it
triggered a warning in the page allocation code.  Indeed, order > 1 pages
should not been allocated with the __GFP_NOFAIL flag.

Fix this by simply dropping the __GFP_NOFAIL flag when allocating the
objcg vector.  It effectively allows to skip the accounting of a single
slab object under a heavy memory pressure.

An alternative would be to implement the mechanism to fallback to order-0
allocations for accounting metadata, which is also not perfect because it
will increase performance penalty and memory footprint of the kernel
memory accounting under memory pressure.

Link: https://lkml.kernel.org/r/ZUp8ZFGxwmCx4ZFr@P9FQF9L96D.corp.robot.car
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Christoph Lameter <cl@linux.com>
Closes: https://lkml.kernel.org/r/6b42243e-f197-600a-5d22-56bd728a5ad8@gentwo.org
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~cgroups-warning-for-metadata-allocation-with-gfp_nofail-was-re-folio_alloc_buffers-doing-allocations-order-1-with-gfp_nofail
+++ a/mm/memcontrol.c
@@ -2936,7 +2936,8 @@ void mem_cgroup_commit_charge(struct fol
  * Moreover, it should not come from DMA buffer and is not readily
  * reclaimable. So those GFP bits should be masked off.
  */
-#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
+				 __GFP_ACCOUNT | __GFP_NOFAIL)
 
 /*
  * mod_objcg_mlstate() may be called with irq enabled, so
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


