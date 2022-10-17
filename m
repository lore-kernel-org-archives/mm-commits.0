Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF7EC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJQABh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJQABg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:01:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DC62CE17
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22C61B80D2B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F18C433C1;
        Mon, 17 Oct 2022 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665964892;
        bh=PRZ1DSrGBz5SCrOs+ahxJ+FlPu6BpcVvraDHf2NOzxU=;
        h=Date:To:From:Subject:From;
        b=RPVHjONby8VUlFPw6KFBshMes4q83YV6DMyGb40atLfPYse7jidiDrZCncusBNeAJ
         RR+55eOxubh+eGsLhzywMzgNjSknMw86a4zO7NpZhbT5B33obJvEu+o7DBvDafC2E+
         H8PM+6Shh4sWUSCdGffRNG0f3fab5pRo1ndasJwo=
Date:   Sun, 16 Oct 2022 17:01:32 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_destroy_pool-add-size_class-null-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20221017000132.C8F18C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zs_destroy_pool: add size_class NULL check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zsmalloc-zs_destroy_pool-add-size_class-null-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_destroy_pool-add-size_class-null-check.patch

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
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: zs_destroy_pool: add size_class NULL check
Date: Thu, 13 Oct 2022 14:28:25 +0300

Inside the zs_destroy_pool() function, there can still be NULL size_class
pointers: if when the next size_class is allocated, inside
zs_create_pool() function, kzalloc will return NULL and handling the error
condition, zs_create_pool() will call zs_destroy_pool().

Link: https://lkml.kernel.org/r/20221013112825.61869-1-avromanov@sberdevices.ru
Fixes: f24263a5a076 ("zsmalloc: remove unnecessary size_class NULL check")
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-zs_destroy_pool-add-size_class-null-check
+++ a/mm/zsmalloc.c
@@ -2311,6 +2311,9 @@ void zs_destroy_pool(struct zs_pool *poo
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
+		if (!class)
+			continue;
+
 		if (class->index != i)
 			continue;
 
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-zs_destroy_pool-add-size_class-null-check.patch

