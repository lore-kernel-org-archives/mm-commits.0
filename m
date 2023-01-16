Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5FEC67871
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjAPVjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjAPVjU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A8F2BEE4
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:39:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C406AB810EA
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C973C433D2;
        Mon, 16 Jan 2023 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905157;
        bh=+6QJ2DUgYekeBJBiyKZldeh7viWNRUTfQ80Sfv3owiA=;
        h=Date:To:From:Subject:From;
        b=Ac8CHLvZPiD+bo+5VKr+l3eK/18Put1gVgGrRyI/9AKLQArie3POc3kK1zDxwL+On
         TNGI1XH96h4G6QFApYSc0jZpb5loaOxDPTCHgifkPw8nQ3gKc3xOEjFzx42ZuU9GHx
         vr5DcK2197Ituzo9Vk7bWjArcw2IC4Z6ibkF/1oM=
Date:   Mon, 16 Jan 2023 13:39:16 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-set-default-zspage-chain-size-to-8.patch removed from -mm tree
Message-Id: <20230116213917.6C973C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: set default zspage chain size to 8
has been removed from the -mm tree.  Its filename was
     zsmalloc-set-default-zspage-chain-size-to-8.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: set default zspage chain size to 8
Date: Mon, 9 Jan 2023 12:38:38 +0900

This changes key characteristics (pages per-zspage and objects per-zspage)
of a number of size classes which in results in different pool
configuration.  With zspage chain size of 8 we have more size clases
clusters (123) and higher huge size class watermark (3632 bytes).

Please read zsmalloc documentation for more details.

Link: https://lkml.kernel.org/r/20230109033838.2779902-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/Kconfig~zsmalloc-set-default-zspage-chain-size-to-8
+++ a/mm/Kconfig
@@ -193,7 +193,7 @@ config ZSMALLOC_STAT
 
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
-	default 4
+	default 8
 	range 1 16
 	depends on ZSMALLOC
 	help
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch

