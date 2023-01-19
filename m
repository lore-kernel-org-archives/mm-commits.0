Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7A1C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjATFxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjATFxr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:53:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377E930B24
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 503FEB82760
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB141C433F0;
        Thu, 19 Jan 2023 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168149;
        bh=TAksfAfxjZiKepRwDqK8F9TOaGOG2vdEtn4hV8+k8qo=;
        h=Date:To:From:Subject:From;
        b=U6hpiYO1k1EkkRV2WH6a+H2Ysj2W4XBmZEkSxYblzwe6VAiziWzHzZ7C8Vl7zj4Vi
         dhYWDtkJB3opBYRlaZQgXNIBEzdGJkrqooRi6O596L17tCz2VH2NHsNTarcFuOoSrz
         U7RwlC3cgIEeFjN6n9kB0LYWDVPa8gVKIs+aI0jY=
Date:   Thu, 19 Jan 2023 14:42:28 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        rppt@kernel.org, peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, vbabka@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot_early_init-for-kmemleak-fix.patch added to mm-unstable branch
Message-Id: <20230119224228.DB141C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-stack_depot_early_init-for-kmemleak-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot_early_init-for-kmemleak-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot_early_init-for-kmemleak-fix.patch

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
@@ -2094,7 +2094,6 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
-	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch
mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch
mm-use-stack_depot_early_init-for-kmemleak-fix.patch

