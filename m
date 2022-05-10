Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B074AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiEJEUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiEJESb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B72108A5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55CD36173F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1BEC385C7;
        Tue, 10 May 2022 04:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156060;
        bh=nIHGKNdXjhroBmgQcj2kUBKumB1ooTCO/GkmFYLJ+Y0=;
        h=Date:To:From:Subject:From;
        b=nkDHsbqhjsAIYK9RwfwF8p8VhWZGckCONRd/U6av9diwJ6SQCzHWsaLRkawoXancW
         SRvjEyKKo3venIedgw/k3TE/865FmKT4sIYLGiXZKMrquCCJIZf4eWpVmqXdL68PHg
         IYjUiuyUZYDsX0lYP/sFHSe+/sfgfHoq+Q4O0vvU=
Date:   Mon, 09 May 2022 21:14:20 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, bgeffon@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-a-huge_idle-writeback-mode.patch removed from -mm tree
Message-Id: <20220510041420.AE1BEC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: add a huge_idle writeback mode
has been removed from the -mm tree.  Its filename was
     zram-add-a-huge_idle-writeback-mode.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: zram: add a huge_idle writeback mode

Today it's only possible to write back as a page, idle, or huge.  A user
might want to writeback pages which are huge and idle first as these idle
pages do not require decompression and make a good first pass for
writeback.

Idle writeback specifically has the advantage that a refault is unlikely
given that the page has been swapped for some amount of time without being
refaulted.

Huge writeback has the advantage that you're guaranteed to get the maximum
benefit from a single page writeback, that is, you're reclaiming one full
page of memory.  Pages which are compressed in zram being written back
result in some benefit which is always less than a page size because of
the fact that it was compressed.

The primary use of this is for minimizing refaults in situations where the
device has to be sensitive to storage endurance.  On ChromeOS we have
devices with slow eMMC and repeated writes and refaults can negatively
affect performance and endurance.

Link: https://lkml.kernel.org/r/20220322215821.1196994-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    5 +++++
 drivers/block/zram/zram_drv.c               |   10 ++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-a-huge_idle-writeback-mode
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -343,6 +343,11 @@ Admin can request writeback of those idl
 
 With the command, zram will writeback idle pages from memory to the storage.
 
+Additionally, if a user choose to writeback only huge and idle pages
+this can be accomplished with::
+
+        echo huge_idle > /sys/block/zramX/writeback
+
 If an admin wants to write a specific page in zram device to the backing device,
 they could write a page index into the interface.
 
--- a/drivers/block/zram/zram_drv.c~zram-add-a-huge_idle-writeback-mode
+++ a/drivers/block/zram/zram_drv.c
@@ -639,8 +639,8 @@ static int read_from_bdev_async(struct z
 #define PAGE_WB_SIG "page_index="
 
 #define PAGE_WRITEBACK 0
-#define HUGE_WRITEBACK 1
-#define IDLE_WRITEBACK 2
+#define HUGE_WRITEBACK (1<<0)
+#define IDLE_WRITEBACK (1<<1)
 
 
 static ssize_t writeback_store(struct device *dev,
@@ -660,6 +660,8 @@ static ssize_t writeback_store(struct de
 		mode = IDLE_WRITEBACK;
 	else if (sysfs_streq(buf, "huge"))
 		mode = HUGE_WRITEBACK;
+	else if (sysfs_streq(buf, "huge_idle"))
+		mode = IDLE_WRITEBACK | HUGE_WRITEBACK;
 	else {
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
@@ -721,10 +723,10 @@ static ssize_t writeback_store(struct de
 				zram_test_flag(zram, index, ZRAM_UNDER_WB))
 			goto next;
 
-		if (mode == IDLE_WRITEBACK &&
+		if (mode & IDLE_WRITEBACK &&
 			  !zram_test_flag(zram, index, ZRAM_IDLE))
 			goto next;
-		if (mode == HUGE_WRITEBACK &&
+		if (mode & HUGE_WRITEBACK &&
 			  !zram_test_flag(zram, index, ZRAM_HUGE))
 			goto next;
 		/*
_

Patches currently in -mm which might be from bgeffon@google.com are


