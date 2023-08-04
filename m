Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B496EC001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjHDUEN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHDUEL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB9AE6E;
        Fri,  4 Aug 2023 13:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B55162120;
        Fri,  4 Aug 2023 20:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB753C433C7;
        Fri,  4 Aug 2023 20:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179449;
        bh=9XGsGZV3rrgGeFa3SCxVpO9YeLbHi3wThw0DeSRDRYE=;
        h=Date:To:From:Subject:From;
        b=f0RQlO1Wbawqk3enRVAlrtNL8eEEGAoQt4AYpsDNFd706qdDtFIlgn+HnIvMZ5FcB
         USZn7IrbzC97vPR91mmqx0J/+WrgYVdR7d52mju8y9F8Usi6aH/S2Ooh8bTdMK/8qR
         ybtxAAd+Cydr7KHNTfidOBoO7QycJ9c/zMJ0UoEs=
Date:   Fri, 04 Aug 2023 13:04:08 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        senozhatsky@chromium.org, minchan@kernel.org,
        matthias.bgg@gmail.com, bigeasy@linutronix.de,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch removed from -mm tree
Message-Id: <20230804200409.AB753C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: fix races between modifications of fullness and isolated
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-races-between-modifications-of-fullness-and-isolated.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Yang <andrew.yang@mediatek.com>
Subject: zsmalloc: fix races between modifications of fullness and isolated
Date: Fri, 21 Jul 2023 14:37:01 +0800

We encountered many kernel exceptions of VM_BUG_ON(zspage->isolated ==
0) in dec_zspage_isolation() and BUG_ON(!pages[1]) in zs_unmap_object()
lately.  This issue only occurs when migration and reclamation occur at
the same time.

With our memory stress test, we can reproduce this issue several times
a day.  We have no idea why no one else encountered this issue.  BTW,
we switched to the new kernel version with this defect a few months
ago.

Since fullness and isolated share the same unsigned int, modifications of
them should be protected by the same lock.

[andrew.yang@mediatek.com: move comment]
  Link: https://lkml.kernel.org/r/20230727062910.6337-1-andrew.yang@mediatek.com
Link: https://lkml.kernel.org/r/20230721063705.11455-1-andrew.yang@mediatek.com
Fixes: c4549b871102 ("zsmalloc: remove zspage isolation for migration")
Signed-off-by: Andrew Yang <andrew.yang@mediatek.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-fix-races-between-modifications-of-fullness-and-isolated
+++ a/mm/zsmalloc.c
@@ -1798,6 +1798,7 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
+	struct zs_pool *pool;
 	struct zspage *zspage;
 
 	/*
@@ -1807,9 +1808,10 @@ static bool zs_page_isolate(struct page
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
@@ -1875,12 +1877,12 @@ static int zs_page_migrate(struct page *
 	kunmap_atomic(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
+	dec_zspage_isolation(zspage);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
 	 */
 	spin_unlock(&pool->lock);
-	dec_zspage_isolation(zspage);
 	migrate_write_unlock(zspage);
 
 	get_page(newpage);
@@ -1897,14 +1899,16 @@ static int zs_page_migrate(struct page *
 
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

