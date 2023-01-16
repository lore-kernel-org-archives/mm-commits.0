Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C7BC54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjAPVjR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjAPVjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:39:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDC82BED5
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36F6F6112F
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830FCC433D2;
        Mon, 16 Jan 2023 21:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905154;
        bh=5BvnXYITYg4ZDlZLuJbk0FgdzfRUJQopwZGDbQnmysE=;
        h=Date:To:From:Subject:From;
        b=dmbf8VI1eGf/5EbFwGe6ztSAey4MC8Dn6JUbJNeu0S4A9B+GtepvLAgkiTORzp5a4
         C1t7SY2d6IG3IjErucwxJqv6NgXic1ljdBDV3vOY/+V6mWHXAgvc1cvRvwJLaY7cd3
         msRNJzPR1SENZHnOtj1yn8dRFPG7z9UsuxwYWCHQ=
Date:   Mon, 16 Jan 2023 13:39:13 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch removed from -mm tree
Message-Id: <20230116213914.830FCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
has been removed from the -mm tree.  Its filename was
     zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: skip chain size calculation for pow_of_2 classes
Date: Mon, 9 Jan 2023 12:38:36 +0900

If a class size is power of 2 then it wastes no memory and the best
configuration is 1 physical page per-zspage.

Link: https://lkml.kernel.org/r/20230109033838.2779902-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes
+++ a/mm/zsmalloc.c
@@ -2370,6 +2370,9 @@ static int calculate_zspage_chain_size(i
 	int i, min_waste = INT_MAX;
 	int chain_size = 1;
 
+	if (is_power_of_2(class_size))
+		return chain_size;
+
 	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int waste;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-make-zspage-chain-size-configurable-fix.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

