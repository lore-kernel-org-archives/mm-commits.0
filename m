Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A382EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjGBXe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjGBXe1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A421E40
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD2F960CF7
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C602C433C9;
        Sun,  2 Jul 2023 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688340865;
        bh=sZTY9b80yYIwIWRHolAb1y/9/DUKC43di/zfTDHsRxY=;
        h=Date:To:From:Subject:From;
        b=LRGaqldu1FuZOkRBwasT8NTXyxE3zvtN5UVG4vdjKjAYlDeXKyOGmfe7L+yyc0Bfu
         HPZE6fI9sGRiJNmsuenG0qWKwqTbUbVLcOnoUMZoeEuk1IfVoekEQ68gOWV78EhN2Z
         WKvrvj8/O4ik9h1orwte2GBgsEmKyJXiUmzCpT/Q=
Date:   Sun, 02 Jul 2023 16:34:24 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-move-migration-destination-zspage-inuse-check.patch added to mm-unstable branch
Message-Id: <20230702233425.1C602C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: move migration destination zspage inuse check
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-move-migration-destination-zspage-inuse-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-move-migration-destination-zspage-inuse-check.patch

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

zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch
zsmalloc-move-migration-destination-zspage-inuse-check.patch

