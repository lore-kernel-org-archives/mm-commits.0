Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97C6C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 01:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiL3BAA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 20:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiL3A77 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 19:59:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC1613F91
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 16:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5983361983
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 00:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11D2C433EF;
        Fri, 30 Dec 2022 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672361997;
        bh=zalDJTrmGhEJkag3JCOK5y9xYzu/ILXHw1eIc4aizmo=;
        h=Date:To:From:Subject:From;
        b=YtOgzQ8Gv5FZinC5fFDB+EySKP6bLY0en3PBJL2Zdkjl9l0TRkh0xPoxcNVFYI77G
         rqQUS/lhX3o1572R/wsLzG/xuaYfwFvtTJco4ashcAa1O/SQqPdLXo8YIhzfGhLaHK
         oey7AqcRN31UdTDXrIX8+SCgbUrBTgzsdPeIIbiY=
Date:   Thu, 29 Dec 2022 16:59:56 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        jhs2.lee@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-typos-in-comments.patch added to mm-unstable branch
Message-Id: <20221230005957.B11D2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix typos in comments
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-typos-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-typos-in-comments.patch

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
From: JeongHyeon Lee <jhs2.lee@samsung.com>
Subject: zram: fix typos in comments
Date: Fri, 23 Dec 2022 13:03:31 +0900

- The double `range` is duplicated in comment, remove one.
 - change `syfs` to `sysfs`

Link: https://lkml.kernel.org/r/20221223040331.4194-1-jhs2.lee@samsung.com
Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zram-fix-typos-in-comments
+++ a/drivers/block/zram/zram_drv.c
@@ -190,7 +190,7 @@ static inline bool valid_io_request(stru
 
 	end = start + (size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
-	/* out of range range */
+	/* out of range */
 	if (unlikely(start >= bound || end > bound || start > end))
 		return false;
 
@@ -2385,7 +2385,7 @@ static int zram_add(void)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
+	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
_

Patches currently in -mm which might be from jhs2.lee@samsung.com are

zram-fix-typos-in-comments.patch

