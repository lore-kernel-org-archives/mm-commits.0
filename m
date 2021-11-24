Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE334C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352106AbhKXVmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352023AbhKXVk4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:40:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42AB6102A;
        Wed, 24 Nov 2021 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637789866;
        bh=2oZRTzmKOFnt6tcwbDk5D0xbrh+CVNJ+EeJ4Ktl3Xyc=;
        h=Date:From:To:Subject:From;
        b=ko/Uc0wBkHRoSthVejln2xkW0ylloTUEdIgAGAFuHyEmD7Z+AS46B/En5uwECXKmH
         87Tl/o+4zTqieyT4lVHQGEEAZ6vW7CnmlR2BlyPU0t2mmEwhduhUg4lKaf10I/2cvJ
         TZlEFqCGemxdBppa82DmTPyQr0ZelgY2Ct1E0yyY=
Date:   Wed, 24 Nov 2021 13:37:45 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, dave.hansen@linux.intel.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        xlpang@linux.alibaba.com, ying.huang@intel.com,
        zhongjiang-ali@linux.alibaba.com, ziy@nvidia.com
Subject:  +
 mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch added
 to -mm tree
Message-ID: <20211124213745.I5ztMI1uR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: add more comments for selecting target node randomly
has been added to the -mm tree.  Its filename is
     mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: add more comments for selecting target node randomly

As Yang Shi suggested [1], it will be helpful to explain why we should
select target node randomly now if there are multiple target nodes.

[1] https://lore.kernel.org/all/CAHbLzkqSqCL+g7dfzeOw8fPyeEC0BBv13Ny1UVGHDkadnQdR=g@mail.gmail.com/

Link: https://lkml.kernel.org/r/c31d36bd097c6e9e69fc0f409c43b78e53e64fc2.1637766801.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c~mm-migrate-add-more-comments-for-selecting-target-node-randomly
+++ a/mm/migrate.c
@@ -1196,6 +1196,14 @@ int next_demotion_node(int node)
 		/*
 		 * If there are multiple target nodes, just select one
 		 * target node randomly.
+		 *
+		 * In addition, we can also use round-robin to select
+		 * target node, but we should introduce another variable
+		 * for node_demotion[] to record last selected target node,
+		 * that may cause cache ping-pong due to the changing of
+		 * last target node. Or introducing per-cpu data to avoid
+		 * caching issue, which seems more complicated. So selecting
+		 * target node randomly seems better until now.
 		 */
 		index = get_random_int() % target_nr;
 		break;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch
mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch

