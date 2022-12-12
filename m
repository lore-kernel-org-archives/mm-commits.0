Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF8DC2D0CB
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiLLCRR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiLLCQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AB2DFAD
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A373060EC9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069F1C433F2;
        Mon, 12 Dec 2022 02:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811295;
        bh=6XHwhXznO0/JNp+g5nLxLi54GaZdx5lRqJMF7SQVPYI=;
        h=Date:To:From:Subject:From;
        b=Xb5y9k3G6MQ1DLP4JcRTF7mBo4a5/Ft3FHd2ZtNUlVq0fDFLes0SZ5nHZsdUJg+zm
         RFL45JLYvAVLbsl3ibrBQv2Su3pL71rmLcaAPX68KPqp7NXKpi0uwjxY6Q9TI8igNl
         REYHEqkZnGGD4mlXR4k8fQeChcPQYr5XPqbG5ZCM=
Date:   Sun, 11 Dec 2022 18:14:54 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, weixugc@google.com,
        tim.c.chen@linux.intel.com, shy828301@gmail.com,
        shakeelb@google.com, gthelen@google.com, almasrymina@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch removed from -mm tree
Message-Id: <20221212021455.069F1C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: disable top-tier fallback to reclaim on proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm: disable top-tier fallback to reclaim on proactive reclaim
Date: Thu, 1 Dec 2022 15:33:17 -0800

Reclaiming directly from top tier nodes breaks the aging pipeline of
memory tiers.  If we have a RAM -> CXL -> storage hierarchy, we should
demote from RAM to CXL and from CXL to storage.  If we reclaim a page from
RAM, it means we 'demote' it directly from RAM to storage, bypassing
potentially a huge amount of pages colder than it in CXL.

However disabling reclaim from top tier nodes entirely would cause ooms in
edge scenarios where lower tier memory is unreclaimable for whatever
reason, e.g.  memory being mlocked() or too hot to reclaim.  In these
cases we would rather the job run with a performance regression rather
than it oom altogether.

However, we can disable reclaim from top tier nodes for proactive reclaim.
That reclaim is not real memory pressure, and we don't have any cause to
be breaking the aging pipeline.

[akpm@linux-foundation.org: restore comment layout, per Ying Huang]
Link: https://lkml.kernel.org/r/20221201233317.1394958-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim
+++ a/mm/vmscan.c
@@ -2088,10 +2088,29 @@ keep:
 	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
-		/* Folios which weren't demoted go back on @folio_list for retry: */
+		/* Folios which weren't demoted go back on @folio_list */
 		list_splice_init(&demote_folios, folio_list);
-		do_demote_pass = false;
-		goto retry;
+
+		/*
+		 * goto retry to reclaim the undemoted folios in folio_list if
+		 * desired.
+		 *
+		 * Reclaiming directly from top tier nodes is not often desired
+		 * due to it breaking the LRU ordering: in general memory
+		 * should be reclaimed from lower tier nodes and demoted from
+		 * top tier nodes.
+		 *
+		 * However, disabling reclaim from top tier nodes entirely
+		 * would cause ooms in edge scenarios where lower tier memory
+		 * is unreclaimable for whatever reason, eg memory being
+		 * mlocked or too hot to reclaim. We can disable reclaim
+		 * from top tier nodes in proactive reclaim though as that is
+		 * not real memory pressure.
+		 */
+		if (!sc->proactive) {
+			do_demote_pass = false;
+			goto retry;
+		}
 	}
 
 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
_

Patches currently in -mm which might be from almasrymina@google.com are


