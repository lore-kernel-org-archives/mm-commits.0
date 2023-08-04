Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EA3C001DB
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 19:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHDTrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjHDTrR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 15:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162D6E7
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 12:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA4D62119
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 19:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15BAC433CB;
        Fri,  4 Aug 2023 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691178436;
        bh=o4jRAnqw1QK9PUPbWDDtpSuGJpZ0tuHSIrOAx4CWA70=;
        h=Date:To:From:Subject:From;
        b=LbUdot9Fl3u57SjtZIMWIVVUeZNq9823liWTMVwYplV++KnBStsZjT0qY7Kr1C+aY
         ZMtzCWnoLDyjRRGMjOuuwcYk8Q1yBYxf4wiKLTAh03umgEZEXT8h5YEZ2qalHqOTaq
         VllRhOXgirVwIIqDXfm2M2rC+WvUb5ZdQGspv7sE=
Date:   Fri, 04 Aug 2023 12:47:15 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, matthias.bgg@gmail.com, bigeasy@linutronix.de,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch removed from -mm tree
Message-Id: <20230804194715.F15BAC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch

This patch was dropped because it was folded into zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch

------------------------------------------------------
From: Andrew Yang <andrew.yang@mediatek.com>
Subject: zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2
Date: Thu, 27 Jul 2023 14:29:07 +0800

move comment

Link: https://lkml.kernel.org/r/20230727062910.6337-1-andrew.yang@mediatek.com
Signed-off-by: Andrew Yang <andrew.yang@mediatek.com>
Fixes: c4549b871102 ("zsmalloc: remove zspage isolation for migration")
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2
+++ a/mm/zsmalloc.c
@@ -1877,11 +1877,11 @@ static int zs_page_migrate(struct page *
 	kunmap_atomic(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
+	dec_zspage_isolation(zspage);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
 	 */
-	dec_zspage_isolation(zspage);
 	spin_unlock(&pool->lock);
 	migrate_write_unlock(zspage);
 
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are

zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch
fs-drop_caches-draining-pages-before-dropping-caches.patch

