Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B1FC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiKWTdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiKWTdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:33:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65505A6F7
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E3C6B823D0
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1B2C433C1;
        Wed, 23 Nov 2022 19:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669232021;
        bh=uCnDlsd4d+LwlSnzJ3CSPPhJvzCR2OzIi2NrgEWM1So=;
        h=Date:To:From:Subject:From;
        b=KHXZcN/+trcigOLaCrlYETORfOvY5Re3ItU2LFLo4CKwSlG3zmFgczSL8fk242ozd
         nnSwvlqLf9SXWFSSLLfhsXMevj4m2MCElTqpCWfMjKHeTZI4MgaakTd5hYl+m5cZxa
         5EdIe3T7w8etWYaZ646YQ44QM+Jyuh4K+8Wl0bqk=
Date:   Wed, 23 Nov 2022 11:33:40 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch added to mm-unstable branch
Message-Id: <20221123193341.0B1B2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: implement writeback mechanism for zsmalloc (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch

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
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch

