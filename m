Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9963EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjHUUkI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjHUUkA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683FA19B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C1F6462E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49591C433C8;
        Mon, 21 Aug 2023 20:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650371;
        bh=QpBgsKTWzEj09UCu2HjP9tnX4ll2Rl0ukCjRN9RyV4s=;
        h=Date:To:From:Subject:From;
        b=fl+K3971mIN2FMC73jx5rkhsOQLgoD5AeRS7OSIgxskh3lF2AVFST9Uw9XWD2XSLP
         o0ZmeqJUC+UkoBdHS7/ZsKfRephbOtylgDDPJ4w3QMcdqo3rHcLCzZysfmrZ6JXxAz
         WrxcILX+D3Y0lsBs/PtgGEZUUTVkrPAZ+UKgxhNs=
Date:   Mon, 21 Aug 2023 13:39:30 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        yangyifei03@kuaishou.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch removed from -mm tree
Message-Id: <20230821203931.49591C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm:vmscan: fix inaccurate reclaim during proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Efly Young <yangyifei03@kuaishou.com>
Subject: mm:vmscan: fix inaccurate reclaim during proactive reclaim
Date: Fri, 21 Jul 2023 09:41:16 +0800

Before commit f53af4285d77 ("mm: vmscan: fix extreme overreclaim and swap
floods"), proactive reclaim will extreme overreclaim sometimes.  But
proactive reclaim still inaccurate and some extent overreclaim.

Problematic case is easy to construct.  Allocate lots of anonymous memory
(e.g., 20G) in a memcg, then swapping by writing memory.recalim and there
is a certain probability of overreclaim.  For example, request 1G by
writing memory.reclaim will eventually reclaim 1.7G or other values more
than 1G.

The reason is that reclaimer may have already reclaimed part of requested
memory in one loop, but before adjust sc->nr_to_reclaim in outer loop,
call shrink_lruvec() again will still follow the current sc->nr_to_reclaim
to work.  It will eventually lead to overreclaim.  In theory, the amount
of reclaimed would be in [request, 2 * request).

Reclaimer usually tends to reclaim more than request.  But either direct
or kswapd reclaim have much smaller nr_to_reclaim targets, so it is less
noticeable and not have much impact.

Proactive reclaim can usually come in with a larger value, so the error is
difficult to ignore.  Considering proactive reclaim is usually low
frequency, handle the batching into smaller chunks is a better approach.

Link: https://lkml.kernel.org/r/20230721014116.3388-1-yangyifei03@kuaishou.com
Signed-off-by: Efly Young <yangyifei03@kuaishou.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim
+++ a/mm/memcontrol.c
@@ -6686,8 +6686,8 @@ static ssize_t memory_reclaim(struct ker
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options);
+					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
+					GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
_

Patches currently in -mm which might be from yangyifei03@kuaishou.com are


