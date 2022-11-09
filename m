Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C360FC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKIBij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKIBic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A04B7E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5E7B81CD6
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F9AC433D6;
        Wed,  9 Nov 2022 01:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957901;
        bh=XWaFqwEx+kGQwpLRpJAwjo/iFTguKe+5Jsf/Xry4kZY=;
        h=Date:To:From:Subject:From;
        b=bI5yS5rjiKsa/xxbZTcnJqKoJiKVL6l6a0VrJ6v9bUjqXPBVN2V3Dqtg0OmZn4/M2
         hun1Ex3iV1Jp1D9R6fsml9Slk8IyoFy0upUA6lxUA8WbNROVCVUHqkHvmCqtaFe/cD
         4TKmTFntdGTDcxv/JglL0JQ/biuFMtIm9VPXoSMQ=
Date:   Tue, 08 Nov 2022 17:38:20 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-try_cmpxchg-in-update_used_max.patch removed from -mm tree
Message-Id: <20221109013821.13F9AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: use try_cmpxchg in update_used_max
has been removed from the -mm tree.  Its filename was
     zram-use-try_cmpxchg-in-update_used_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-try_cmpxchg-in-update_used_max
+++ a/drivers/block/zram/zram_drv.c
@@ -188,16 +188,13 @@ static void update_position(u32 *index,
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

llist-avoid-extra-memory-read-in-llist_add_batch.patch
sched-fair-use-try_cmpxchg-in-task_numa_work.patch

