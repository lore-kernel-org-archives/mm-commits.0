Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC631C41513
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjGXRek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjGXRej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506021700
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B85EA61290
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16570C433C7;
        Mon, 24 Jul 2023 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690220074;
        bh=kLaiZU4p/2X4PSb+Z2HFlZ+uSPfvU97KFo39R2b0dVs=;
        h=Date:To:From:Subject:From;
        b=zCbkj3xK4e4O8ax3z+JB0hLXd4TaQSLx7G2YYRfSXJCuuTXP6ifGwlF1SKOZ63mHn
         96KJ1wAl+PLliHTMTibe7PKIRuRU5mIqJlQDVUgadeCiZzomI6SFBySz/W0Tjr3b4C
         +zyWrVTl89+a11q2pRBw0elRzZbLTh+bGCtOd9ew=
Date:   Mon, 24 Jul 2023 10:34:33 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, matthias.bgg@gmail.com, bigeasy@linutronix.de,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch added to mm-unstable branch
Message-Id: <20230724173434.16570C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix races between modifications of fullness and isolated
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch

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
From: Andrew Yang <andrew.yang@mediatek.com>
Subject: zsmalloc: fix races between modifications of fullness and isolated
Date: Fri, 21 Jul 2023 14:37:01 +0800

Since fullness and isolated share the same unsigned int, modifications of
them should be protected by the same lock.

Link: https://lkml.kernel.org/r/20230721063705.11455-1-andrew.yang@mediatek.com
Fixes: c4549b871102 ("zsmalloc: remove zspage isolation for migration")
Signed-off-by: Andrew Yang <andrew.yang@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-fix-races-between-modifications-of-fullness-and-isolated
+++ a/mm/zsmalloc.c
@@ -1777,6 +1777,7 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
+	struct zs_pool *pool;
 	struct zspage *zspage;
 
 	/*
@@ -1786,9 +1787,10 @@ static bool zs_page_isolate(struct page
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	migrate_write_lock(zspage);
+	pool = zspage->pool;
+	spin_lock(&pool->lock);
 	inc_zspage_isolation(zspage);
-	migrate_write_unlock(zspage);
+	spin_unlock(&pool->lock);
 
 	return true;
 }
@@ -1858,8 +1860,8 @@ static int zs_page_migrate(struct page *
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
 	 */
-	spin_unlock(&pool->lock);
 	dec_zspage_isolation(zspage);
+	spin_unlock(&pool->lock);
 	migrate_write_unlock(zspage);
 
 	get_page(newpage);
@@ -1876,14 +1878,16 @@ static int zs_page_migrate(struct page *
 
 static void zs_page_putback(struct page *page)
 {
+	struct zs_pool *pool;
 	struct zspage *zspage;
 
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	migrate_write_lock(zspage);
+	pool = zspage->pool;
+	spin_lock(&pool->lock);
 	dec_zspage_isolation(zspage);
-	migrate_write_unlock(zspage);
+	spin_unlock(&pool->lock);
 }
 
 static const struct movable_operations zsmalloc_mops = {
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are

fs-drop_caches-draining-pages-before-dropping-caches.patch
zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch

