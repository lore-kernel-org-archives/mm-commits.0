Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B09C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 03:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKXDoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiKXDoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 22:44:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D557C59
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:44:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B13B6B8269F
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 03:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602F0C433C1;
        Thu, 24 Nov 2022 03:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669261440;
        bh=FIxc+yG3WH2weNMnZVN7nxBsFmkgLuh1pIvRmwwzXdA=;
        h=Date:To:From:Subject:From;
        b=djKn0GlBPz/4h8Fg7kgRRRZI9lUCGdlpfsopxT+A5LZE/jBnwGSw3FsIpZose1Mjo
         BBWAM+Q/noHwAVR/r4mmoXyRjSCgZKzBZ/wGdLd521gfm8e8DqGUgMSfngX5/K3OQ2
         lBVB+bMJBGULiTdNn5dBtg9Xqla3rf+7WLmjqBFE=
Date:   Wed, 23 Nov 2022 19:43:59 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch removed from -mm tree
Message-Id: <20221124034400.602F0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: implement writeback mechanism for zsmalloc (fix)
has been removed from the -mm tree.  Its filename was
     zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch

This patch was dropped because it was folded into zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: implement writeback mechanism for zsmalloc (fix)
Date: Wed, 23 Nov 2022 11:17:03 -0800

Use get_first_page(), and add cond_resched() in retry loop.

Link: https://lkml.kernel.org/r/20221123191703.2902079-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix
+++ a/mm/zsmalloc.c
@@ -2509,12 +2509,13 @@ static int zs_reclaim_page(struct zs_poo
 		remove_zspage(class, zspage, fullness);
 
 		spin_unlock(&pool->lock);
+		cond_resched();
 
 		/* Lock backing pages into place */
 		lock_zspage(zspage);
 
 		obj_idx = 0;
-		page = zspage->first_page;
+		page = get_first_page(zspage);
 		while (1) {
 			handle = find_alloced_obj(class, page, &obj_idx);
 			if (!handle) {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

