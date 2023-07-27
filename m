Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39D3C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjG0RDg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjG0RDd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF613595
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C9C261EEC
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5F9C433C7;
        Thu, 27 Jul 2023 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477409;
        bh=SB349gRxqO1ngeV8uy/7cS6UtGnI7Csqw3aIh0gBjCE=;
        h=Date:To:From:Subject:From;
        b=cvLVMgi+I0iSqZ4Y7bZWPgn2fbhbrtTPSJjSTF51Nl9wr51FxtXuK1WIqLLbkx4Pd
         cawKMvXWG2kLzmm+XvTwmuwaK2S8XTVLaslu+4YDmq8sAAmmXzNJ6rQBXYZndoiXXZ
         JoUHEwI9ixvuQLIV3U1yO7s0TZfwzruXIPkA4gzo=
Date:   Thu, 27 Jul 2023 10:03:28 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, matthias.bgg@gmail.com, bigeasy@linutronix.de,
        angelogioacchino.delregno@collabora.com, andrew.yang@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20230727170329.8E5F9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
zsmalloc-fix-races-between-modifications-of-fullness-and-isolated-v2.patch
fs-drop_caches-draining-pages-before-dropping-caches.patch

