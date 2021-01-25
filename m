Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F8EC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 823B420897
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbhAYWO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733216AbhAYWIY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE5522100A;
        Mon, 25 Jan 2021 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611612464;
        bh=cVHJLe66NpY1aLfvHNj6veEZ1pUI8IzfcUI86EKX62k=;
        h=Date:From:To:Subject:From;
        b=ZtH+srAVbtUrHX3heiKEyj7cVZxFuJPzWii4e3xvEqKaQcNVt/9qludA3Zp+iJVkv
         jL8n1Ke3SYUD/xR6CHYDjzFBB8pvhR+EoU41gOhMPagOK7XSTP1U99dJJkb5RNKcTn
         s2EfkS4k11fqRhZHA29vxy6nusFYliUMPewJDqe0=
Date:   Mon, 25 Jan 2021 14:07:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        khalid.aziz@oracle.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, ngupta@nitingupta.dev,
        vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-compaction-return-proper-state-in-should=5Fproactive=5Fco?=
 =?US-ASCII?Q?mpact=5Fnode-fix.patch?= removed from -mm tree
Message-ID: <20210125220743.CLPHCKZNt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-return-proper-state-in-should_proactive_compact_node-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch

This patch was dropped because it was folded into mm-compaction-return-proper-state-in-should_proactive_compact_node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-return-proper-state-in-should_proactive_compact_node-fix

s/max_t/max/

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nitin Gupta <ngupta@nitingupta.dev>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-return-proper-state-in-should_proactive_compact_node-fix
+++ a/mm/compaction.c
@@ -1975,7 +1975,7 @@ static unsigned int fragmentation_score_
 		struct zone *zone;
 
 		zone = &pgdat->node_zones[zoneid];
-		max = max_t(unsigned int, fragmentation_score_zone(zone), max);
+		max = max(fragmentation_score_zone(zone), max);
 	}
 
 	return max;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

