Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5066CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCCX3P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCCX3E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:29:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2475AF970
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F1561961
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD39C433A0;
        Fri,  3 Mar 2023 23:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677886142;
        bh=2aLV0kjY2dpIIeYlAMwrByJ+y6XQpV+NWs/Y/PzEqSg=;
        h=Date:To:From:Subject:From;
        b=r8qAGgROwqXU0mR7gaT+NauT7way7Dx6yewIFgoVHcDwZZUoC1LbP6/n9zIUFb1KI
         nZIgYu/aySCljnnk3HFz797sqs3BtfWZnHBKw+krPBCu7akbZlBZXVsJkbfD1l19Yf
         WNeWG6mlbVWVHQ4ilbvZ0c2LSeOeY643CfXf8WKM=
Date:   Fri, 03 Mar 2023 15:29:01 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch added to mm-unstable branch
Message-Id: <20230303232902.1CD39C433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch

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
Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
Date: Fri Mar  3 03:25:23 PM PST 2023

fix zs_stats_size_show() accumulation, per Yosry

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
+++ a/mm/zsmalloc.c
@@ -651,9 +651,9 @@ static int zs_stats_size_show(struct seq
 		 * stats.
 		 */
 		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
-			class_almost_full = zs_stat_get(class, fg);
+			class_almost_full += zs_stat_get(class, fg);
 		for (fg = ZS_INUSE_RATIO_10; fg < ZS_INUSE_RATIO_70; fg++)
-			class_almost_empty = zs_stat_get(class, fg);
+			class_almost_empty += zs_stat_get(class, fg);
 
 		obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
 		obj_used = zs_stat_get(class, ZS_OBJS_INUSE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch

