Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B6FC678DB
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 19:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCDTbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCDTbN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 14:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561181B564
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 11:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF54A60A50
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 19:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A11C433D2;
        Sat,  4 Mar 2023 19:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677958271;
        bh=WuBdHrjoqVOZqQRfWIeOpzWA0S1ztBJhGT11VJtTN6s=;
        h=Date:To:From:Subject:From;
        b=Uk80tXxkpeAVDkU8oX12muLESz3HyYLLb46G06G0op/2BcGYya4g8weOVUIKFR2So
         xl0B+GM5ZplY4PYPD11u7eXgN8Wog1JnAYxBV6ADucMQkGrTCvCEorLk/tKlvye8uY
         GiHyw+oLLBRchm5JuzyyoikD/j5AKYifDzZkW8sE=
Date:   Sat, 04 Mar 2023 11:31:10 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch removed from -mm tree
Message-Id: <20230304193111.42A11C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix.patch

This patch was dropped because it was folded into zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
Date: Sat Mar  4 11:29:08 AM PST 2023

initialize class_almost_full and class_almost_empty

Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix-fix
+++ a/mm/zsmalloc.c
@@ -625,7 +625,7 @@ static int zs_stats_size_show(struct seq
 	struct zs_pool *pool = s->private;
 	struct size_class *class;
 	int objs_per_zspage;
-	unsigned long class_almost_full, class_almost_empty;
+	unsigned long class_almost_full = 0, class_almost_empty = 0;
 	unsigned long obj_allocated, obj_used, pages_used, freeable;
 	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
 	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch

