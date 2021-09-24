Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D68DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F9261107
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346379AbhIXT4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344832AbhIXT4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 15:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DB861038;
        Fri, 24 Sep 2021 19:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632513275;
        bh=JBghuD/KRQb4kiZsTQ7n9OZ0dD2X1Y4eUeizcawujrA=;
        h=Date:From:To:Subject:From;
        b=sSXbJGib3mr12zLdqhVHQhJLOHL7ui9rzgh3YZ5LU+G/GKFNiBVb1cPXTgPx12LaW
         /DAUnr0CqQYAljVQUs4apLSt3PsGgWLIwhBt/GFMBkbP2UNi9KxzsK0rz6q1tlJHBM
         uoUmqZckdqNd9lDMfu2ZxTwyE+w5Wkb5FZGqurJI=
Date:   Fri, 24 Sep 2021 12:54:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bgeffon@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + zram-introduce-an-aged-idle-interface-v5-fix.patch
 added to -mm tree
Message-ID: <20210924195435.YmVQTg3Nh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-an-aged-idle-interface-v5-fix
has been added to the -mm tree.  Its filename is
     zram-introduce-an-aged-idle-interface-v5-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-an-aged-idle-interface-v5-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-an-aged-idle-interface-v5-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
zram-introduce-an-aged-idle-interface-v5-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

