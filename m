Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC33C5ACB2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 22:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjKOWlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 17:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbjKOWlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 17:41:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0507B195
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 14:41:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B6DC433C8;
        Wed, 15 Nov 2023 22:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700088107;
        bh=DdyoBsZ0sPD+T1klbWpLAdnmt+fGZkJTnLkTwOB+d6Q=;
        h=Date:To:From:Subject:From;
        b=FeFXfUHY+4Zok9x0RSjFVk07iM4Vhdr9jwdtF/bGNRPedd9522x3RUH+JZu5HPAnh
         1d9zdlK50/SOWvzcpM9QXUbUkMSZbF7XYwe4lNR/SWUNLcN67sm5nmMUb45YPkCxd3
         il+H/TgTWNXI7tUSNJeZykkaY2zdqIj3gPVucZN0=
Date:   Wed, 15 Nov 2023 14:41:47 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-tweak-writeback-config-help.patch added to mm-unstable branch
Message-Id: <20231115224147.92B6DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: tweak writeback config help
has been added to the -mm mm-unstable branch.  Its filename is
     zram-tweak-writeback-config-help.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-tweak-writeback-config-help.patch

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
Subject: zram: tweak writeback config help
Date: Wed, 15 Nov 2023 11:42:13 +0900

Writeback is for incompressible and idle zram pages.

Link: https://lkml.kernel.org/r/20231115024223.4133148-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-tweak-writeback-config-help
+++ a/drivers/block/zram/Kconfig
@@ -59,8 +59,8 @@ config ZRAM_WRITEBACK
        bool "Write back incompressible or idle page to backing device"
        depends on ZRAM
        help
-	 With incompressible page, there is no memory saving to keep it
-	 in memory. Instead, write it out to backing device.
+	 This lets zram entries (incompressible or idle pages) be written
+	 back to a backing device, helping save memory.
 	 For this feature, admin should set up backing device via
 	 /sys/block/zramX/backing_dev.
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-tweak-writeback-config-help.patch

