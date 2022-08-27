Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973D3ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiH0DWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiH0DWG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9C5BC81D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC3661DCB
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B12C433D6;
        Sat, 27 Aug 2022 03:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570524;
        bh=ZiMqqNBzmHz4Lpr0jXbch5kBsBn1+OmYRSUekYFKZBM=;
        h=Date:To:From:Subject:From;
        b=d/wsFp0b6fQnJvzniuZH6pI7sD1cggPsXLe3/SInFTYIe0UaSzQ2XXD9+X1Ig71YR
         V9dLrhm68HDiGaU7l1qwBWRFV5ZprlzEebfPdJMNWEXnLzrVfO1s821IgyrS+mdsFi
         nY5jOmGMIBnk6yoO6FUoqLzZj0Xr4Tbf/3s8uJ5c=
Date:   Fri, 26 Aug 2022 20:22:04 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, DDRokosov@sberdevices.ru,
        ddrokosov@sberdevices.ru, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-dont-retry-compress-incompressible-page.patch added to mm-unstable branch
Message-Id: <20220827032204.C0B12C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't retry compress incompressible page
has been added to the -mm mm-unstable branch.  Its filename is
     zram-dont-retry-compress-incompressible-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-dont-retry-compress-incompressible-page.patch

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
Subject: zram: don't retry compress incompressible page
Date: Wed, 24 Aug 2022 14:31:17 +0300

It doesn't make sense for us to retry to compress an uncompressible page
(comp_len == PAGE_SIZE) in zsmalloc slowpath, because we will be storing
it uncompressed anyway.  We can avoid wasting time on another compression
attempt.  It is enough to take lock (zcomp_stream_get) and execute the
code below.

Link: https://lkml.kernel.org/r/20220824113117.78849-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-retry-compress-incompressible-page
+++ a/drivers/block/zram/zram_drv.c
@@ -1410,9 +1410,19 @@ compress_again:
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
-		if (!IS_ERR((void *)handle))
+		if (IS_ERR((void *)handle))
+			return PTR_ERR((void *)handle);
+
+		if (comp_len != PAGE_SIZE)
 			goto compress_again;
-		return PTR_ERR((void *)handle);
+		/*
+		 * If the page is not compressible, you need to acquire the lock and
+		 * execute the code below. The zcomp_stream_get() call is needed to
+		 * disable the cpu hotplug and grab the zstrm buffer back.
+		 * It is necessary that the dereferencing of the zstrm variable below
+		 * occurs correctly.
+		 */
+		zstrm = zcomp_stream_get(zram->comp);
 	}
 
 	alloced_pages = zs_get_total_pages(zram->mem_pool);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zsmalloc-zs_object_copy-add-clarifying-comment.patch
zsmalloc-remove-unnecessary-size_class-null-check.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc.patch
zram-dont-retry-compress-incompressible-page.patch

