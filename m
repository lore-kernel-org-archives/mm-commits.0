Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E2AC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 00:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjDLAao (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDLAan (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 20:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F301BE4
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 17:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADA362C7F
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 00:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C57AC433D2;
        Wed, 12 Apr 2023 00:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681259441;
        bh=LRGD1VwabuFAUtT1fgMf3E6GafgjgFboIIN+lsbpMMU=;
        h=Date:To:From:Subject:From;
        b=rVPoC5aBjYwXoLL94p7ljL+P7SzdMbDinXVLjgpG9pvSuRwkRAcprvVooTJZ1ieSP
         guOObidTNQxjwrtEM8hlp0x902UCOH2NWDL4qMtI5gp34E/aA+Rah+aCc6aQo8TpEw
         7sX6pcIMJUb2ojO9MUO0h8zNzfQbkWvrGolE9MRA=
Date:   Tue, 11 Apr 2023 17:30:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-simplify-shrink_node.patch added to mm-unstable branch
Message-Id: <20230412003041.1C57AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: simplify shrink_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-simplify-shrink_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-simplify-shrink_node.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/vmscan: simplify shrink_node()
Date: Tue, 11 Apr 2023 06:17:57 +0000

The difference between sc->nr_reclaimed and nr_reclaimed is computed three
times.  Introduce a new variable to record the value, so it only needs to
be computed once.

Link: https://lkml.kernel.org/r/20230411061757.12041-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-shrink_node
+++ a/mm/vmscan.c
@@ -6503,7 +6503,7 @@ static void shrink_node_memcgs(pg_data_t
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
-	unsigned long nr_reclaimed, nr_scanned;
+	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
@@ -6526,13 +6526,14 @@ again:
 
 	flush_reclaim_state(sc, reclaim_state);
 
+	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
+
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-			   sc->nr_scanned - nr_scanned,
-			   sc->nr_reclaimed - nr_reclaimed);
+			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
-	if (sc->nr_reclaimed - nr_reclaimed)
+	if (nr_node_reclaimed)
 		reclaimable = true;
 
 	if (current_is_kswapd()) {
@@ -6594,8 +6595,7 @@ again:
 	    test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_CONGESTED);
 
-	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
-				    sc))
+	if (should_continue_reclaim(pgdat, nr_node_reclaimed, sc))
 		goto again;
 
 	/*
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

cpuset-clean-up-cpuset_node_allowed.patch
memcg-oom-simplify-mem_cgroup_oom_synchronize.patch
mm-vmscan-simplify-shrink_node.patch

