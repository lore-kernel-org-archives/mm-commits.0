Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3E0C43219
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiKJAbk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiKJAbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3E42A260
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 695E361D25
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4F2C433C1;
        Thu, 10 Nov 2022 00:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040272;
        bh=ztCA3n7dzKNb66NyBBln+yhyT0KgZOf7ZJ1hcOPec3w=;
        h=Date:To:From:Subject:From;
        b=Uc5nVjPHoNagT7HywKJGU9KKlqcfmpf+Ud2OiaFYhlY9hjL0dJBpTFwIyrzHMkuBd
         2g+ghTwOsn0mF1KCMp3X8aSna7HxpX/4PuEeD3TTBX11ta23gLdx7i2uiHN4Cn/UXz
         nHHysippPy5fM92Brugis8ENQ3XpvMjcaDCHUy1M=
Date:   Wed, 09 Nov 2022 16:31:12 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-incompressible-writeback.patch added to mm-unstable branch
Message-Id: <20221110003112.BE4F2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add incompressible writeback
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-incompressible-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-incompressible-writeback.patch

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
Subject: zram: add incompressible writeback
Date: Wed, 9 Nov 2022 20:50:46 +0900

Add support for incompressible pages writeback:

  echo incompressible > /sys/block/zramX/writeback

Link: https://lkml.kernel.org/r/20221109115047.2921851-13-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    7 ++++++-
 drivers/block/zram/zram_drv.c               |   18 ++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-incompressible-writeback
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -348,8 +348,13 @@ this can be accomplished with::
 
         echo huge_idle > /sys/block/zramX/writeback
 
+If a user chooses to writeback only incompressible pages (pages that none of
+algorithms can compress) this can be accomplished with::
+
+	echo incompressible > /sys/block/zramX/writeback
+
 If an admin wants to write a specific page in zram device to the backing device,
-they could write a page index into the interface.
+they could write a page index into the interface::
 
 	echo "page_index=1251" > /sys/block/zramX/writeback
 
--- a/drivers/block/zram/zram_drv.c~zram-add-incompressible-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -645,10 +645,10 @@ static int read_from_bdev_async(struct z
 
 #define PAGE_WB_SIG "page_index="
 
-#define PAGE_WRITEBACK 0
-#define HUGE_WRITEBACK (1<<0)
-#define IDLE_WRITEBACK (1<<1)
-
+#define PAGE_WRITEBACK			0
+#define HUGE_WRITEBACK			(1<<0)
+#define IDLE_WRITEBACK			(1<<1)
+#define INCOMPRESSIBLE_WRITEBACK	(1<<2)
 
 static ssize_t writeback_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
@@ -669,6 +669,8 @@ static ssize_t writeback_store(struct de
 		mode = HUGE_WRITEBACK;
 	else if (sysfs_streq(buf, "huge_idle"))
 		mode = IDLE_WRITEBACK | HUGE_WRITEBACK;
+	else if (sysfs_streq(buf, "incompressible"))
+		mode = INCOMPRESSIBLE_WRITEBACK;
 	else {
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
@@ -731,11 +733,15 @@ static ssize_t writeback_store(struct de
 			goto next;
 
 		if (mode & IDLE_WRITEBACK &&
-			  !zram_test_flag(zram, index, ZRAM_IDLE))
+		    !zram_test_flag(zram, index, ZRAM_IDLE))
 			goto next;
 		if (mode & HUGE_WRITEBACK &&
-			  !zram_test_flag(zram, index, ZRAM_HUGE))
+		    !zram_test_flag(zram, index, ZRAM_HUGE))
+			goto next;
+		if (mode & INCOMPRESSIBLE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
+
 		/*
 		 * Clearing ZRAM_UNDER_WB is duty of caller.
 		 * IOW, zram_free_page never clear it.
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

