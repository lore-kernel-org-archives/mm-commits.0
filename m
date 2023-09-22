Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A39E7D0BB
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjIVBkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjIVBkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:40:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F0E8
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:40:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373FCC433C7;
        Fri, 22 Sep 2023 01:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346803;
        bh=Q4Cw2l1iLhdjDSH30CJHkY/gLe72yddyz7IBFbHLsjk=;
        h=Date:To:From:Subject:From;
        b=VDUO7QY94IrrU7u/+zYulMy2VBSoydKG2k2WsuBjJuDr6Djm8aeS1rpvNA59DspJH
         XRVJ70wgwadJvx2YSxZRndH01tXS/FWUt9NXBN26798xmBXsvmgZBlovKcxztmekkv
         DTNrrdhUBlHsGfT9h6JwkxEaY7ZTjXtCb4udqMcc=
Date:   Thu, 21 Sep 2023 18:40:02 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, link@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch added to mm-unstable branch
Message-Id: <20230922014003.373FCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: remove unnecessary si_meminfo invoke.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch

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
From: Huan Yang <link@vivo.com>
Subject: mm/damon/core: remove unnecessary si_meminfo invoke.
Date: Wed, 20 Sep 2023 09:57:27 +0800

si_meminfo() will read and assign more info not just free/ram pages.  For
just DAMOS_WMARK_FREE_MEM_RATE use, only get free and ram pages is ok to
save cpu.

Link: https://lkml.kernel.org/r/20230920015727.4482-1-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-unnecessary-si_meminfo-invoke
+++ a/mm/damon/core.c
@@ -1326,12 +1326,10 @@ static bool kdamond_need_stop(struct dam
 
 static unsigned long damos_wmark_metric_value(enum damos_wmark_metric metric)
 {
-	struct sysinfo i;
-
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
-		si_meminfo(&i);
-		return i.freeram * 1000 / i.totalram;
+		return global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		       totalram_pages();
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from link@vivo.com are

mm-damon-core-remove-unnecessary-si_meminfo-invoke.patch

