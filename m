Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC0EC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbjHKW7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjHKW7J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1BD35A9
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A106676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D522C433C8;
        Fri, 11 Aug 2023 22:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794745;
        bh=/DPivhb3pUNNlRhchxwhP0QhV4Wh8e3lnvpVNGpmiCI=;
        h=Date:To:From:Subject:From;
        b=oGBsvMpMkoUNF4RW1ZIJbm41xnR/aEA5WaTcLjh+XqZ4iC09LiDXGKviW1edkugGs
         zRxRwBEsdyS4qR/zhMaJxOZps8OQPs4N1ORNGuIsAJoKR3rJn6QcRaXB3epK4MYiJ9
         dlXhvCU+L02IOGKKqaaYKmhuPfd91THb+lB0CFkM=
Date:   Fri, 11 Aug 2023 15:59:05 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-move-migration-destination-zspage-inuse-check.patch removed from -mm tree
Message-Id: <20230811225905.7D522C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: move migration destination zspage inuse check
has been removed from the -mm tree.  Its filename was
     zsmalloc-move-migration-destination-zspage-inuse-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: move migration destination zspage inuse check
Date: Sat, 24 Jun 2023 14:12:15 +0900

Destination zspage fullness check need to be done after zs_object_copy()
because that's where source and destination zspages fullness change. 
Checking destination zspage fullness before zs_object_copy() may cause
migration to loop through source zspage sub-pages scanning for allocate
objects just to find out at the end that the destination zspage is full.

Link: https://lkml.kernel.org/r/20230624053120.643409-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org> 
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-move-migration-destination-zspage-inuse-check
+++ a/mm/zsmalloc.c
@@ -1620,10 +1620,6 @@ static void migrate_zspage(struct zs_poo
 			continue;
 		}
 
-		/* Stop if there is no more space */
-		if (zspage_full(class, get_zspage(d_page)))
-			break;
-
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, get_zspage(d_page), handle);
 		zs_object_copy(class, free_obj, used_obj);
@@ -1631,6 +1627,10 @@ static void migrate_zspage(struct zs_poo
 		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj);
 
+		/* Stop if there is no more space */
+		if (zspage_full(class, get_zspage(d_page)))
+			break;
+
 		/* Stop if there are no more objects to migrate */
 		if (zspage_empty(get_zspage(s_page)))
 			break;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


