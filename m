Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7F9C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiLBVl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiLBVl1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:41:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34029F1168
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC58B822BF
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E277C433D6;
        Fri,  2 Dec 2022 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670017283;
        bh=/NKHusqwi5qIvmBv/qhGi4+YXtGsz/ZcPFcXfMtlc3g=;
        h=Date:To:From:Subject:From;
        b=eg215KdVzqxxz6niS1XNmZ6UOq1phWuY5exuOCNN0I73C1uvCu9xaaXuOdy8W02Pw
         UqWLUDLnM5yLemx/4WMs7O0VNsPH6/QvHUXE9yraV/lzQRmcDP8WnZpfXCaS7KPS8m
         r/TED10PSmzBUnG1zSndZXBDZFooTVSqwlffpBX0=
Date:   Fri, 02 Dec 2022 13:41:22 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tim.c.chen@linux.intel.com,
        shakeelb@google.com, gthelen@google.com, almasrymina@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch added to mm-unstable branch
Message-Id: <20221202214123.8E277C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

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

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
kselftests-cgroup-update-kmem-test-precision-tolerance-fix.patch
mm-gup-remove-foll_migration-fix.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch
mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

