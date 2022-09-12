Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9F6ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiILD3S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiILD2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1545275EF
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D4DAB80C6E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BACC433D7;
        Mon, 12 Sep 2022 03:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953317;
        bh=GUaoiI+C/tl+ztUphfycgShFLtj79jJ1NLfsGFbePqE=;
        h=Date:To:From:Subject:From;
        b=2P929sMeF8UHRm6vWjGh0JfvxspbUYdtC5A19ZVUVJ6yqm31R+NfDFPf6lXAfyVwU
         aor3I62pLSv4YTPyOgXoxH03fb4Y7uhz4FlR91n2Eot2wbrgZ1VZXBHx055Wzpnz1F
         WU7rLOsU4J4ELgpcKbNGztyTZLOCDxPK3j468Y7c=
Date:   Sun, 11 Sep 2022 20:28:36 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-remove-unnecessary-size_class-null-check.patch removed from -mm tree
Message-Id: <20220912032837.11BACC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: remove unnecessary size_class NULL check
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-unnecessary-size_class-null-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: remove unnecessary size_class NULL check
Date: Thu, 11 Aug 2022 18:37:55 +0300

pool->size_class array elements can't be NULL, so this check
is not needed.

In the whole code, we assign pool->size_class[i] values that are
not NULL. Releasing memory for these values occurs in the
zs_destroy_pool() function, which also releases and destroys the pool.

In addition, in the zs_stats_size_show() and async_free_zspage(),
with similar iterations over the array, we don't check it for NULL
pointer.

Link: https://lkml.kernel.org/r/20220811153755.16102-3-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-unnecessary-size_class-null-check
+++ a/mm/zsmalloc.c
@@ -2110,8 +2110,6 @@ unsigned long zs_compact(struct zs_pool
 
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
-		if (!class)
-			continue;
 		if (class->index != i)
 			continue;
 		pages_freed += __zs_compact(pool, class);
@@ -2156,8 +2154,6 @@ static unsigned long zs_shrinker_count(s
 
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
-		if (!class)
-			continue;
 		if (class->index != i)
 			continue;
 
@@ -2315,9 +2311,6 @@ void zs_destroy_pool(struct zs_pool *poo
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
-		if (!class)
-			continue;
-
 		if (class->index != i)
 			continue;
 
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

