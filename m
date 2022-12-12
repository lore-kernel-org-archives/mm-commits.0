Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09569C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 01:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLLBSs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBSs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 20:18:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998556157
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 17:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3046960DE3
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 01:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531FC433EF;
        Mon, 12 Dec 2022 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670807922;
        bh=W1E088ZpOruBd5wNePc9462KlFwjwMPN03q5D2QyeJ4=;
        h=Date:To:From:Subject:From;
        b=Z3NgNtJpokoozMWBw7qLn0e5G8r2AVW7Q64wFrm+5qmgBTEWoA/2RnHYt2iB9pQ93
         poJR3HkhAMEiYttMmu2XgQtXZmFZuq2fJo+Riuv0wQGJueYkAgzZtpVmdvKCOokZqH
         UMhhdzIa0AQzSHxLzXYEWlnt8MFoe9+BWjL+Ctiw=
Date:   Sun, 11 Dec 2022 17:18:41 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tim.c.chen@linux.intel.com,
        shakeelb@google.com, gthelen@google.com, almasrymina@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch removed from -mm tree
Message-Id: <20221212011842.8531FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

This patch was dropped because it was folded into mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix
Date: Fri Dec  2 01:40:18 PM PST 2022

restore comment layout, per Ying Huang

Cc: Greg Thelen <gthelen@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix
+++ a/mm/vmscan.c
@@ -2088,9 +2088,7 @@ keep:
 	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
-		/*
-		 * Folios which weren't demoted go back on @folio_list.
-		 */
+		/* Folios which weren't demoted go back on @folio_list */
 		list_splice_init(&demote_folios, folio_list);
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

