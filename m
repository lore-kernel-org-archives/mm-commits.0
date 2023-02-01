Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66409C636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjBAAjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBAAjX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:39:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E70525E
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B834561745
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21095C433D2;
        Wed,  1 Feb 2023 00:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675211961;
        bh=vRg9AYd1VLDt7+i60vpqNt6uSemU631A5041Wb6MDbM=;
        h=Date:To:From:Subject:From;
        b=KaNhVidAPr2yLV+AaG16SZnQF6+DN4Pc8FI2m2dQUVKnXIAvCD6golXVSk3FXHozt
         tF5jX8KLifCrRUfOBFDEs3M0CAxcFZbz3AlmJBjkiRzxstlFG7MXMU5DkdFab3Q3qR
         lyPxZpNEGo5QegXv/KtvAFbTIWjMx61LAA6B2qhU=
Date:   Tue, 31 Jan 2023 16:39:20 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        rppt@kernel.org, peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-stack_depot_early_init-for-kmemleak-fix.patch removed from -mm tree
Message-Id: <20230201003921.21095C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-use-stack_depot_early_init-for-kmemleak-fix
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot_early_init-for-kmemleak-fix.patch

This patch was dropped because it was folded into mm-use-stack_depot_early_init-for-kmemleak.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-use-stack_depot_early_init-for-kmemleak-fix
Date: Thu, 19 Jan 2023 11:32:36 +0100

The call to stack_depot_init() becomes no-op after this patch so it's not
a bug to leave it there, but it's just misleading now.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak-fix
+++ a/mm/kmemleak.c
@@ -2095,7 +2095,6 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
-	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch
mm-use-stack_depot_early_init-for-kmemleak.patch
revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

