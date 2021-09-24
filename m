Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C00C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF53611C8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbhIXUdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343775AbhIXUdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:33:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 566636108B;
        Fri, 24 Sep 2021 20:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632515539;
        bh=OXIpBrpFZMGjALKYxqRxr8PMOuTeBMeWJcgjT/9pEvs=;
        h=Date:From:To:Subject:From;
        b=Ke4lHU1/igZUM6wNwtRLFQvj69Iz+a+4wbsxYmxL7C5tgs7VeEV3UiQsRgQDV0ypW
         /lS5U+5FpUqVrL4J9asmWpuxk+SO7P5jvtgG83zMHtVl6lAOU/UaJLAnc89ldcfJ08
         ycxQOi+HgbFC1mikNfymiCOWlNx0s4PkKLllNlL0=
Date:   Fri, 24 Sep 2021 13:32:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bgeffon@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [withdrawn]
 zram-introduce-an-aged-idle-interface-v5-fix.patch removed from -mm tree
Message-ID: <20210924203218.ppcV7EiGg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-an-aged-idle-interface-v5-fix
has been removed from the -mm tree.  Its filename was
     zram-introduce-an-aged-idle-interface-v5-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-introduce-an-aged-idle-interface-v5-fix

use IS_ENABLED some more

Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-an-aged-idle-interface-v5-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -309,9 +309,8 @@ static void mark_idle(struct zram *zram,
 		zram_slot_lock(zram, index);
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
-#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+			if (IS_ENABLED(CONFIG_ZRAM_MEMORY_TRACKING))
 				is_idle = (!cutoff || ktime_after(cutoff, zram->table[index].ac_time));
-#endif
 			if (is_idle)
 				zram_set_flag(zram, index, ZRAM_IDLE);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

