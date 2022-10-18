Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7771BC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 20:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJRUuQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJRUuN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 16:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEE539BB5
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 13:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00593616F1
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 20:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F6CC433C1;
        Tue, 18 Oct 2022 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666126205;
        bh=0JtWsc3oSV6j+nAEMWxIX+hEcA5B+8ds7h6plbh1hQ8=;
        h=Date:To:From:Subject:From;
        b=i7MfycE1kI/uDeRF6PTZ6PxIem+ek368+5gKWQp7y1p1uqKkHI9j49Hd1Z8TX9d4k
         GMdiOKPweUM3NOom85a6xzgESWi4A/49b4Xs2ZPIpNPZCHcs7tzg3St4smw8THj5ny
         wvvTPXf4atMMxi8HyvPINz0rfe7waCTL1VCuBygA=
Date:   Tue, 18 Oct 2022 13:50:04 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-try_cmpxchg-in-update_used_max.patch added to mm-unstable branch
Message-Id: <20221018205005.52F6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use try_cmpxchg in update_used_max
has been added to the -mm mm-unstable branch.  Its filename is
     zram-use-try_cmpxchg-in-update_used_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-try_cmpxchg-in-update_used_max.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: zram: use try_cmpxchg in update_used_max
Date: Tue, 18 Oct 2022 16:51:54 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
update_used_max.  x86 CMPXCHG instruction returns success in ZF flag, so
this change saves a compare after cmpxchg (and related move instruction in
front of cmpxchg).

Also, reorder code a bit to remove additional compare and conditional jump
from the assembly code.  Together, hese two changes save 15 bytes from the
function when compiled for x86_64.

No functional change intended.

Link: https://lkml.kernel.org/r/20221018145154.3699-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-try_cmpxchg-in-update_used_max
+++ a/drivers/block/zram/zram_drv.c
@@ -193,16 +193,13 @@ static void update_position(u32 *index,
 static inline void update_used_max(struct zram *zram,
 					const unsigned long pages)
 {
-	unsigned long old_max, cur_max;
-
-	old_max = atomic_long_read(&zram->stats.max_used_pages);
+	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
 
 	do {
-		cur_max = old_max;
-		if (pages > cur_max)
-			old_max = atomic_long_cmpxchg(
-				&zram->stats.max_used_pages, cur_max, pages);
-	} while (old_max != cur_max);
+		if (cur_max >= pages)
+			return;
+	} while (!atomic_long_try_cmpxchg(&zram->stats.max_used_pages,
+					  &cur_max, pages));
 }
 
 static inline void zram_fill_page(void *ptr, unsigned long len,
_

Patches currently in -mm which might be from ubizjak@gmail.com are

zram-use-try_cmpxchg-in-update_used_max.patch
llist-avoid-extra-memory-read-in-llist_add_batch.patch

