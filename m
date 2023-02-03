Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF29C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjBCGm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjBCGkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11348FB60
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2DEDFCE2EC5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E20C433D2;
        Fri,  3 Feb 2023 06:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406267;
        bh=HDSEgz6FtjBqStj0F7gSRrH9nVijmtPD7h5gFIA9fts=;
        h=Date:To:From:Subject:From;
        b=ltMss/52MNcwkexy4q5orq1/Zz3k9lnV57RgBB0K86FVjM1NLvTxA47IZJM7MCOiL
         Ye0K0eQ74+3PfWI1JIDHwbz57RaeG4tzHd9+Cpc91I5Fcl/fmz/+PVbjivvbmkI77m
         jSgT876yaqSvy+CthbGC9izlKKFbozWrHExUzWfY=
Date:   Thu, 02 Feb 2023 22:37:47 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, huaisheng.ye@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-skip-apply-schemes-if-empty.patch removed from -mm tree
Message-Id: <20230203063747.90E20C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: skip apply schemes if empty
has been removed from the -mm tree.  Its filename was
     mm-damon-core-skip-apply-schemes-if-empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


