Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A7C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCCX3D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCCX3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:29:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D294F970
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 175486196E
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708DEC433EF;
        Fri,  3 Mar 2023 23:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677886140;
        bh=e524CAZsIdQZi4ccMNnOp1GQWQ3K3PoqveCaNtUI7vc=;
        h=Date:To:From:Subject:From;
        b=jCENOVmyCoh3SKqCv3ndOS9aa60aSA8MevaH82RGkcZUE4+tYQWnADly4ouoQ2d3M
         vr8Hk8UG3R1nOqOUGUJsmuPegdr5AXlA9dUcwe4TOOQbDhp4XK0ZqTDGJ0Fl4FteJW
         FwH/fWwr3wj5IWbfOJu5MJ1EixA2djSRsNtADuVQ=
Date:   Fri, 03 Mar 2023 15:28:59 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch added to mm-unstable branch
Message-Id: <20230303232900.708DEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch

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
Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
Date: Fri Mar  3 03:24:35 PM PST 2023

fix comment spello

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
+++ a/mm/zsmalloc.c
@@ -647,7 +647,7 @@ static int zs_stats_size_show(struct seq
 		spin_lock(&pool->lock);
 
 		/*
-		 * Replecate old behaviour for almost_full and almost_empty
+		 * Replicate old behaviour for almost_full and almost_empty
 		 * stats.
 		 */
 		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch

