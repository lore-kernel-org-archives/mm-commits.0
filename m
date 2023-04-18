Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A439C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjDRXdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDRXd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E9B76A0
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 031D462BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7A6C433D2;
        Tue, 18 Apr 2023 23:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860805;
        bh=exFKUHsropizxhyGPuRxvzkC5ww1MBspoRXXHmKzYR8=;
        h=Date:To:From:Subject:From;
        b=AUesxrVldEdWZgR64z/as+qC5FxJX73o0rLeq4jBo3Sq8PelDILCZ+Wvy/hPjfJZf
         /fLVl1Y9XYfEKGfyQOwQ5EsjZUo44XoGL3En6nhyGLwefaI4p1rrlEN3wstbxkF//u
         Qkel0ZCnvDJfooH6YKsvvEk1e+JYD7RtIkw56HG4=
Date:   Tue, 18 Apr 2023 16:33:24 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch removed from -mm tree
Message-Id: <20230418233325.5D7A6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: reset compaction source zspage pointer after putback_zspage()
has been removed from the -mm tree.  Its filename was
     zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: reset compaction source zspage pointer after putback_zspage()
Date: Mon, 17 Apr 2023 22:08:50 +0900

The current implementation of the compaction loop fails to set the source
zspage pointer to NULL in all cases, leading to a potential issue where
__zs_compact() could use a stale zspage pointer.  This pointer could even
point to a previously freed zspage, causing unexpected behavior in the
putback_zspage() and migrate_write_unlock() functions after returning from
the compaction loop.

Address the issue by ensuring that the source zspage pointer is always set
to NULL when it should be.

Link: https://lkml.kernel.org/r/20230417130850.1784777-1-senozhatsky@chromium.org
Fixes: 5a845e9f2d66 ("zsmalloc: rework compaction algorithm")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage
+++ a/mm/zsmalloc.c
@@ -2239,8 +2239,8 @@ static unsigned long __zs_compact(struct
 		if (fg == ZS_INUSE_RATIO_0) {
 			free_zspage(pool, class, src_zspage);
 			pages_freed += class->pages_per_zspage;
-			src_zspage = NULL;
 		}
+		src_zspage = NULL;
 
 		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
 		    || spin_is_contended(&pool->lock)) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-allow-only-one-active-pool-compaction-context.patch

