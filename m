Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27D9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJUEew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiJUEeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AC1DE9F
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2DF361263
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3C0C433D6;
        Fri, 21 Oct 2022 04:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326883;
        bh=QZhrVoVaFXHIjl6sOzHOin10VENM8WEniBv4fLnIMB8=;
        h=Date:To:From:Subject:From;
        b=xOIF6XGdiqZrSML5vn24P4uOwy0PbyACpQmnfTA84PUsAzJZK7D2KIv9+Ur46mVdP
         RCVX3BJOhaqwWb5h6vgV86YNtYQxR5VytOMghv/ZfEbp53dUfD27D1hsAb+rM7LR6A
         HAgcopTIeB3qpHCnGpgAT6Xg1c3Yy6wE393/RqTU=
Date:   Thu, 20 Oct 2022 21:34:42 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zsmalloc-zs_destroy_pool-add-size_class-null-check.patch removed from -mm tree
Message-Id: <20221021043443.1B3C0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: zs_destroy_pool: add size_class NULL check
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_destroy_pool-add-size_class-null-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


