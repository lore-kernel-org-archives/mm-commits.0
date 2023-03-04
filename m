Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A928C64EC4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 19:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCDTbM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCDTbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 14:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0D7D539
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 11:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB82460A55
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 19:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342B5C433EF;
        Sat,  4 Mar 2023 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677958270;
        bh=e+4eOf0PX8ic6R9/oYrV/muzSkMWYHmUOGQbg9di4vw=;
        h=Date:To:From:Subject:From;
        b=ZotcB5erTBgIjDpQjLAgt++HTjFwByOiHdOUV4wn1XK4WDbZxRohlnHgQdlGNVtMj
         aI5sPfGqy/TLYa7TcLYxaFGnDenaGE7YphxDw1UoSD0Ja52Hcng6uahp3DORAEL09n
         rh0ZCzFbgLOhUcbFj94hNVNdQtpugNHZwWqSd5+4=
Date:   Sat, 04 Mar 2023 11:31:09 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch removed from -mm tree
Message-Id: <20230304193110.342B5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch

This patch was dropped because it was folded into zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch

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
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

