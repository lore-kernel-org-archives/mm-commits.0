Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A218C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349998AbiDASXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350046AbiDASXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:23:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D0E63517
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECA19CE2612
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2BC340EE;
        Fri,  1 Apr 2022 18:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837297;
        bh=FxgTMCltgj8iR00ivm3JJTqJdRoqVdzMYU6tKfr4jU8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=0/5gxlbhFMlPQE3S5cwnZBzHU215LQvk4DofUHboZdj2dlBsxdmGFqLSvPUR3op1g
         L86lX8xmVhcw4Fe5I9TU8DFLjyQnilHe3M/KmKhs2nXDy7OMZxPTnN/HHUtu0KWpMt
         UFeijiD95Z+qS2SDf4FLOkuFkIMTxQnSgHODeXgU=
Date:   Fri, 01 Apr 2022 11:21:36 -0700
To:     sj@kernel.org, tome01@ajou.ac.kr, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 16/16] mm/damon: prevent activated scheme from sleeping by deactivated schemes
Message-Id: <20220401182137.4EF2BC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: mm/damon: prevent activated scheme from sleeping by deactivated schemes

In the DAMON, the minimum wait time of the schemes decides whether the
kernel wakes up 'kdamon_fn()'.  But since the minimum wait time is
initialized to zero, there are corner cases against the original
objective.

For example, if we have several schemes for one target, and if the wait
time of the first scheme is zero, the minimum wait time will set zero,
which means 'kdamond_fn()' should wake up to apply this scheme.  However,
in the following scheme, wait time can be set to non-zero.  Thus, the
mininum wait time will be set to non-zero, which can cause sleeping this
interval for 'kdamon_fn()' due to one deactivated last scheme.

This commit prevents making DAMON monitoring inactive state due to other
deactivated schemes.

Link: https://lkml.kernel.org/r/20220330105302.32114-1-tome01@ajou.ac.kr
Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes
+++ a/mm/damon/core.c
@@ -1019,12 +1019,15 @@ static int kdamond_wait_activation(struc
 	struct damos *s;
 	unsigned long wait_time;
 	unsigned long min_wait_time = 0;
+	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
-			if (!min_wait_time || wait_time < min_wait_time)
+			if (!init_wait_time || wait_time < min_wait_time) {
+				init_wait_time = true;
 				min_wait_time = wait_time;
+			}
 		}
 		if (!min_wait_time)
 			return 0;
_
