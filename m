Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54B0C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiANWIw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWIu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AEBC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECCC8CE19A9
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAEAC36AE5;
        Fri, 14 Jan 2022 22:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198127;
        bh=TlrU+C6l/nFj2pbC+AT6rgSDEJdIHWVMfCtIE6Kos9Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ww52qYlA7cW/9rI40sXBdKJA0CkmXJeX9Q2AzImHUDLBG/V52VtK9+Iul3ExYO2xn
         blNMiG48z50CoeZGpMnKCAlDv692ZvqvI8S7zqE/tylclZSR/gvi7gEAsrKJAJAUU6
         d81sRt0rjxXG5i14+K10X/R/3orSV1bhjMNc90gk=
Date:   Fri, 14 Jan 2022 14:08:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        dave.hansen@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, xlpang@linux.alibaba.com,
        ying.huang@intel.com, zhongjiang-ali@linux.alibaba.com,
        ziy@nvidia.com
Subject:  [patch 106/146] mm: migrate: add more comments for
 selecting target node randomly
Message-ID: <20220114220846.k9XhK_39D%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
