Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194D0C32772
	for <mm-commits@archiver.kernel.org>; Tue, 23 Aug 2022 22:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiHWWtI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Aug 2022 18:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiHWWtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Aug 2022 18:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF00688DFA
        for <mm-commits@vger.kernel.org>; Tue, 23 Aug 2022 15:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C021616BE
        for <mm-commits@vger.kernel.org>; Tue, 23 Aug 2022 22:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9315BC433D6;
        Tue, 23 Aug 2022 22:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661294946;
        bh=lpbiXGV0I200qder0N87nJYUqGweGagqPX8Pbn1MEQQ=;
        h=Date:To:From:Subject:From;
        b=vTHEMZULo+I+STElOhfmfhLbbvQQgPL7MdRk5OXTlECHT/kxhi69QYg5625xfemtv
         XpGVxP/4tVgzsDnrMLuOTpZfesJZMyLEX1YiQ1xBOmDr4V7Z2Pl3odCX2K1QUng+05
         fbWYUomtG0W6nopYkjNB77Isa5a4ZigVZIESsnaI=
Date:   Tue, 23 Aug 2022 15:49:05 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ddrokosov@sberdevices.ru,
        avromanov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [wrecked] zram-dont-retry-compress-incompressible-page.patch removed from -mm tree
Message-Id: <20220823224906.9315BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: don't retry compress incompressible page
has been removed from the -mm tree.  Its filename was
     zram-dont-retry-compress-incompressible-page.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zram: don't retry compress incompressible page
Date: Wed, 10 Aug 2022 14:28:57 +0300

It doesn't make sense for us to retry to compress an uncompressible page
(comp_len == PAGE_SIZE) in zsmalloc slowpath, because we will be storing
it uncompressed anyway.  We can avoid wasting time on another compression
attempt.  It is enough to take lock (zcomp_stream_get) and execute the
code below.

Link: https://lkml.kernel.org/r/20220810112857.90278-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-retry-compress-incompressible-page
+++ a/drivers/block/zram/zram_drv.c
@@ -1410,9 +1410,20 @@ compress_again:
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
+
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

