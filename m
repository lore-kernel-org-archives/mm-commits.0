Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCA9C04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 19:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHATiR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjHATiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 15:38:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6937C2102
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 12:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F58616C3
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 19:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B18C433C7;
        Tue,  1 Aug 2023 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690918693;
        bh=V21tVuXlpnqCCZVDG2F+DsnsD7Oign2YIPED591Fw9Y=;
        h=Date:To:From:Subject:From;
        b=YF3JRNZbVqbauSmvQ0y4nAwUGsBnxft4vobV1ru1SzEQGDPVGimLKyH2leIykYYU0
         9NqPsMsfAonVGPP13KTrF7mmE2hyCMfRAv9Zhf6GuL3xdgi1eBIuukzHb3/muNiiWu
         3qUcWuPrHkt3WKfvJd9z/aOIe2TZKtMBEysMPQgY=
Date:   Tue, 01 Aug 2023 12:38:12 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        yangyifei03@kuaishou.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch added to mm-unstable branch
Message-Id: <20230801193813.57B18C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm:vmscan: fix inaccurate reclaim during proactive reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

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
@@ -6695,8 +6695,8 @@ static ssize_t memory_reclaim(struct ker
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

mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

