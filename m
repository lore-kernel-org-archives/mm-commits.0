Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36A7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377876AbiATV1h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377877AbiATV1g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6B7C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C46B81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D4CC340E0;
        Thu, 20 Jan 2022 21:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714053;
        bh=1hAzvIJQbU50uiy+lLFobA3Fj8TsNgjTq4zBnVr41y0=;
        h=Date:From:To:Subject:From;
        b=gxwRQw2PzLS5axc8ikYVYcG2crZxWRQRDKyGS7aqH1Eg8qdu7xtqbsizxxDct4YQ/
         /+sXT5Wy81dlQq8E858AnYp+S43587SbWy5Ox6BhFMeNozV+BmAXQAIrwQGZhy0fVE
         fTJ5cEKILnFhwZsW+PyQTbU7HaEIYS+lSL3r3Mrs=
Date:   Thu, 20 Jan 2022 13:27:32 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, dave.hansen@linux.intel.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        xlpang@linux.alibaba.com, ying.huang@intel.com,
        zhongjiang-ali@linux.alibaba.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch
 removed from -mm tree
Message-ID: <20220120212732.PRbKmdK36%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: add more comments for selecting target node randomly
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-more-comments-for-selecting-target-node-randomly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1206,6 +1206,14 @@ int next_demotion_node(int node)
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


