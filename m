From: akpm@linux-foundation.org
Subject: + kmemcheck-remove-annotations-fix.patch added to -mm tree
Date: Thu, 12 Oct 2017 13:30:30 -0700
Message-ID: <59dfd0e6.DPQQS+F7wgE2H3Bv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755455AbdJLUab (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Oct 2017 16:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.levin@verizon.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcheck: correctly remove kmemcheck call from dma_map_sg_attrs
has been added to the -mm tree.  Its filename is
     kmemcheck-remove-annotations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemcheck-remove-annotations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemcheck-remove-annotations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -260,10 +260,8 @@ static inline int dma_map_sg_attrs(struc
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
kmemcheck-remove-annotations-fix.patch
kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch
kmemcheck-remove-whats-left-of-notrack-flags.patch
kmemcheck-rip-it-out.patch

