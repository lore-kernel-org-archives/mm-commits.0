Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE77EC072A2
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346167AbjKQRg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346164AbjKQRg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:36:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FAD75
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:36:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE25C433C8;
        Fri, 17 Nov 2023 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242582;
        bh=QI5KAzCvGlq7k+6TGUVDBBu6GBYttOeZ22RrFpgU78A=;
        h=Date:To:From:Subject:From;
        b=WXLjL3b6I2MJ5TYZ4ckQWETEWk1Gn7rT2wAlxu+e1/RUhMn7rxrHX9x/qUQgH1TO7
         dUvVhTR/C+PbQH1j+2Y+n/BE4FfK45ZDxcVRWkKd52NbEA+4UEj+UscKuXZvzvhA3E
         W6hV0vpj2HS3Xz2bqZrrlSr6eQRMMMALozrGA43M=
Date:   Fri, 17 Nov 2023 09:36:22 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        dmaluka@chromium.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-split-memory-tracking-and-ac-time-tracking-v2.patch added to mm-unstable branch
Message-Id: <20231117173622.BEE25C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-split-memory-tracking-and-ac-time-tracking-v2
has been added to the -mm mm-unstable branch.  Its filename is
     zram-split-memory-tracking-and-ac-time-tracking-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-split-memory-tracking-and-ac-time-tracking-v2.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram-split-memory-tracking-and-ac-time-tracking-v2
Date: Fri, 17 Nov 2023 10:35:20 +0900

ifdef fixup, per Dmytro

Link: https://lkml.kernel.org/r/20231117013543.540280-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dmytro Maluka <dmaluka@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |    2 +-
 drivers/block/zram/zram_drv.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-split-memory-tracking-and-ac-time-tracking-v2
+++ a/drivers/block/zram/Kconfig
@@ -74,7 +74,7 @@ config ZRAM_TRACK_ENTRY_ACTIME
 	depends on ZRAM
 	help
 	  With this feature zram tracks access time of every stored
-	  entry (page), which can be used for a more fine-grained IDLE
+	  entry (page), which can be used for a more fine grained IDLE
 	  pages writeback.
 
 config ZRAM_MEMORY_TRACKING
--- a/drivers/block/zram/zram_drv.c~zram-split-memory-tracking-and-ac-time-tracking-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -301,7 +301,7 @@ static void mark_idle(struct zram *zram,
 		zram_slot_lock(zram, index);
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
-#ifdef ZRAM_TRACK_ENTRY_ACTIME
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 			is_idle = !cutoff || ktime_after(cutoff,
 							 zram->table[index].ac_time);
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-split-memory-tracking-and-ac-time-tracking-v2.patch
zram-tweak-writeback-config-help.patch
checkpatch-do-not-require-an-empty-line-before-error-injection.patch

