Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C88C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBCGfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjBCGfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39724ED1E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F29961DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3847C433EF;
        Fri,  3 Feb 2023 06:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406131;
        bh=DgF4f0qw6A674SvIL7ZHc4dZM6UhNeQG5qocg7puLBY=;
        h=Date:To:From:Subject:From;
        b=XVYsJtEzMSxmTR1GMFzGjaA+4p5U47IvoBVIvC66oGL2545JpLG/e0PfspJ/gby66
         Kqw7kf69xxx9EkdPW4Clq62Z4TulpYiMteJpZepVjReFMmGK77IuPkXU9TPKa9zZWK
         W2BVqs/bgHMYH8CG1AaKQDrUnbLCo+VU8fftYdyY=
Date:   Thu, 02 Feb 2023 22:35:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch removed from -mm tree
Message-Id: <20230203063530.E3847C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: avoid fragmentation score calculation for empty zones
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: avoid fragmentation score calculation for empty zones
Date: Tue, 10 Jan 2023 21:36:22 +0800

There is no need to calculate the fragmentation score for empty zones.

Link: https://lkml.kernel.org/r/100331ad9d274a9725e687b00d85d75d7e4a17c7.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-avoid-fragmentation-score-calculation-for-empty-zones
+++ a/mm/compaction.c
@@ -2025,6 +2025,8 @@ static unsigned int fragmentation_score_
 		struct zone *zone;
 
 		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
 		score += fragmentation_score_zone_weighted(zone);
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


