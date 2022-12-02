Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02655C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiLBVlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiLBVlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:41:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AA8F1436
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 230CF623FC
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BE1C433D6;
        Fri,  2 Dec 2022 21:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670017281;
        bh=mbgKy7UwlW/xHa1gOvjuVlmAEQEnIlTO7+akAFhhtmQ=;
        h=Date:To:From:Subject:From;
        b=dOCpYxrFwY/exlTz+siZv1VbOzHtfY1zVCEflNBPHMNSym/7vyh2Fe2/Tr1YKCqTu
         wimQQ8hNLUkAcxeRmptI6ZlI7Eg863RkXlVTF9Kaq89SWEtmxsapdB/waX7aZpPuIi
         vWpIsqcTZuvWZmRPS1Tl2s1aQrzdCpnVFQRzsvcg=
Date:   Fri, 02 Dec 2022 13:41:20 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tim.c.chen@linux.intel.com,
        shakeelb@google.com, gthelen@google.com, almasrymina@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch added to mm-unstable branch
Message-Id: <20221202214121.71BE1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable top-tier fallback to reclaim on proactive reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

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

Link: https://lkml.kernel.org/r/20221201233317.1394958-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim
+++ a/mm/vmscan.c
@@ -2088,10 +2088,31 @@ keep:
 	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
-		/* Folios which weren't demoted go back on @folio_list for retry: */
+		/*
+		 * Folios which weren't demoted go back on @folio_list.
+		 */
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

mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim.patch

