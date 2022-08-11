Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AF3C25B06
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiHKVWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiHKVWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4609C22C
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 236E261466
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ECFC433D6;
        Thu, 11 Aug 2022 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252921;
        bh=n25XAODKkrvAZMsowQmJ20RPucNvflRdZjllFd9aH30=;
        h=Date:To:From:Subject:From;
        b=Zv/yncpWA9QLpaM4idJm1poJwWOIRFNBr+BP5Z8Mx3nviU2WqtomiSzyPSTRggZFe
         p2xvNXW7hTdq/IciXP1duyy21Z2Z4evGqVZ7p8O3kF1pX13a4qJMz98/h4XY1SK0g5
         9RdmIdvxccxMda/HO68ZdTePHE/WSQehNB1QOvsw=
Date:   Thu, 11 Aug 2022 14:22:00 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-unnecessary-size_class-null-check.patch added to mm-unstable branch
Message-Id: <20220811212201.71ECFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove unnecessary size_class NULL check
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-remove-unnecessary-size_class-null-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-remove-unnecessary-size_class-null-check.patch

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
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

zsmalloc-zs_object_copy-add-clarifying-comment.patch
zsmalloc-remove-unnecessary-size_class-null-check.patch

