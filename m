Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FF7CDB486
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbjJRVhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbjJRVgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C02197
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C872C433AD;
        Wed, 18 Oct 2023 21:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664933;
        bh=rxb0rGPt+elROr6NiScBsAD/IIFK62I0PAutrlih1ic=;
        h=Date:To:From:Subject:From;
        b=jDGZ/3dTxR5kafhWKCbGtO+5mya2mOieYOBha6GF9qigJDXFW8k9s8JxrvJqNsynX
         NrZVRqueaQc5xHs13J/2BZ1wLcnTs1pRloJO0I3EhPaPMChud+9Wt9AnCF/mt+A9wm
         ojVwsVvShibkloeQlAf8P/5zJbscNX3CzIREb9Tk=
Date:   Wed, 18 Oct 2023 14:35:32 -0700
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        senozhatsky@chromium.org, minchan@kernel.org,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        mark-pk.tsai@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-use-copy_page-for-full-page-copy.patch removed from -mm tree
Message-Id: <20231018213533.2C872C433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: use copy_page for full page copy
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-copy_page-for-full-page-copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


