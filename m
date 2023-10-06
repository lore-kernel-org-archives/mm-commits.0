Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E326E94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjJFTSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjJFTST (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8217A95
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE49C433C8;
        Fri,  6 Oct 2023 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619897;
        bh=vOEZERHURwOvrwcPFzA1wHt59ZkD51mqGS6sTN0iw+8=;
        h=Date:To:From:Subject:From;
        b=xCxscPNR400T526LDbFvzyokA7ZwN7pM6bBDAu+dEPQfCF3ljJb76NCfzTRmvaE5Z
         n5S8Qw4Ismv103aOzZq7ekzziPz0vo9Utzvvja8LtI2okd0rbCzFbOZtlbE4UXroLu
         0wom4D1XztsUjAjnmtyGcUlQVau4bZvj7MU1zxhY=
Date:   Fri, 06 Oct 2023 12:18:14 -0700
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        mark-pk.tsai@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-use-copy_page-for-full-page-copy.patch added to mm-unstable branch
Message-Id: <20231006191816.BFE49C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use copy_page for full page copy
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-use-copy_page-for-full-page-copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-use-copy_page-for-full-page-copy.patch

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
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: zsmalloc: use copy_page for full page copy
Date: Fri, 6 Oct 2023 14:02:40 +0800

Some architectures have implemented optimized copy_page for full page
copying, such as arm.

On my arm platform, use the copy_page helper for single page copying is
about 10 percent faster than memcpy.

Link: https://lkml.kernel.org/r/20231006060245.7411-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-use-copy_page-for-full-page-copy
+++ a/mm/zsmalloc.c
@@ -1839,7 +1839,7 @@ static int zs_page_migrate(struct page *
 	 * Here, any user cannot access all objects in the zspage so let's move.
 	 */
 	d_addr = kmap_atomic(newpage);
-	memcpy(d_addr, s_addr, PAGE_SIZE);
+	copy_page(d_addr, s_addr);
 	kunmap_atomic(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are

zsmalloc-use-copy_page-for-full-page-copy.patch

