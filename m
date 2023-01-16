Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE556C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjAPVhW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbjAPVhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:37:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C034F2BEDB
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D5A86114C
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2745C433D2;
        Mon, 16 Jan 2023 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905037;
        bh=XTfj12IpBzMtGdvmbvbG9oK14t56Sk/XaQSuyNfhi7U=;
        h=Date:To:From:Subject:From;
        b=oNFTZCumTuN+hxwTAwaDmanUS10KD8posUZCjpl948vUMyPZEoCPh6QUNKG0KG3bD
         YtQTe315a2PEshXtBC5ikQYynNqH1nT7TFh6ghoRQLeAvAGFmgO6zfbBvsYRK2sUFP
         hIR8YyTOEtu7P1hYcp+ZfpKDV8asYi4+YCO87uL4=
Date:   Mon, 16 Jan 2023 13:37:16 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, huaisheng.ye@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-skip-apply-schemes-if-empty.patch added to mm-unstable branch
Message-Id: <20230116213717.B2745C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: skip apply schemes if empty
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-skip-apply-schemes-if-empty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-apply-schemes-if-empty.patch

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
From: Huaisheng Ye <huaisheng.ye@intel.com>
Subject: mm/damon/core: skip apply schemes if empty
Date: Mon, 16 Jan 2023 14:23:47 +0800

Sometimes there is no scheme in damon's context, for example just use damo
record to monitor workload's data access pattern.

If current damon context doesn't have any scheme in the list, kdamond has
no need to iterate over list of all targets and regions but do nothing.

So, skip apply schemes when ctx->schemes is empty.

Link: https://lkml.kernel.org/r/20230116062347.1148553-1-huaisheng.ye@intel.com
Signed-off-by: Huaisheng Ye <huaisheng.ye@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/core.c~mm-damon-core-skip-apply-schemes-if-empty
+++ a/mm/damon/core.c
@@ -1269,7 +1269,8 @@ static int kdamond_fn(void *data)
 			if (ctx->callback.after_aggregation &&
 					ctx->callback.after_aggregation(ctx))
 				break;
-			kdamond_apply_schemes(ctx);
+			if (!list_empty(&ctx->schemes))
+				kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
 			if (ctx->ops.reset_aggregated)
_

Patches currently in -mm which might be from huaisheng.ye@intel.com are

mm-damon-core-skip-apply-schemes-if-empty.patch

