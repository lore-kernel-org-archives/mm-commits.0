From: akpm@linux-foundation.org
Subject: [folded-merged] kmemcheck-remove-annotations-fix.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 17:03:25 -0800
Message-ID: <5a0ce3dd.mzftquuh2cuid316%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBD1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.levin@verizon.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcheck: correctly remove kmemcheck call from dma_map_sg_attrs
has been removed from the -mm tree.  Its filename was
     kmemcheck-remove-annotations-fix.patch

This patch was dropped because it was folded into kmemcheck-remove-annotations.patch

------------------------------------------------------
From: "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>
Subject: kmemcheck: correctly remove kmemcheck call from dma_map_sg_attrs

We have missed removing some code as part of removing the kmemcheck
hooks.

Unfourtenatly this got missed during my review, and the code was
still building.

Link: http://lkml.kernel.org/r/20171012192151.26531-1-alexander.levin@verizon.com
Signed-off-by: Sasha Levin <alexander.levin@verizon.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/dma-mapping.h~kmemcheck-remove-annotations-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~kmemcheck-remove-annotations-fix
+++ a/include/linux/dma-mapping.h
@@ -261,10 +261,8 @@ static inline int dma_map_sg_attrs(struc
 				   unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-	int i, ents;
-	struct scatterlist *s;
+	int ents;
 
-	for_each_sg(sg, s, nents, i)
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	BUG_ON(ents < 0);
_

Patches currently in -mm which might be from alexander.levin@verizon.com are

kmemcheck-remove-annotations.patch
kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch
kmemcheck-remove-whats-left-of-notrack-flags.patch
kmemcheck-rip-it-out.patch

