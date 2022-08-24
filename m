Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACCCC00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbiHXSBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240735AbiHXSAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:00:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96670767F
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A5461749
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5489C433C1;
        Wed, 24 Aug 2022 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661363988;
        bh=izYJ+dH9BoQVwdb9vKfBZKBZb4K5u2vflA2eJ3H0ifo=;
        h=Date:To:From:Subject:From;
        b=TjBGTpfGNmEzLV9jByaeYPdfuiHY4dXroLF5Nne5pOWZdzeo9DdRET2mc2ioE6yus
         t0nito7yOHDpDzsJyYHOylKe0Wol2a/1uJmjen4lyFqWw7DYFsBSl3hs6CMiuMkUMS
         mIl+efcDEnZZrt+9UTUeaZpmxW4d8bjR9tSWe2h0=
Date:   Wed, 24 Aug 2022 10:59:47 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch added to mm-unstable branch
Message-Id: <20220824175948.A5489C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
has been added to the -mm mm-unstable branch.  Its filename is
     block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch

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
Subject: drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Wed, 24 Aug 2022 12:51:00 +0900

We do all reset operations under write lock, so we don't need to save
->disksize and ->comp to stack variables.  Another thing is that ->comp is
freed during zram reset, but comp pointer is not NULL-ed, so zram keeps
the freed pointer value.

Link: https://lkml.kernel.org/r/20220824035100.971816-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset
+++ a/drivers/block/zram/zram_drv.c
@@ -1689,9 +1689,6 @@ out:
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1701,17 +1698,15 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	comp = zram->comp;
-	disksize = zram->disksize;
-	zram->disksize = 0;
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(zram, disksize);
+	zram_meta_free(zram, zram->disksize);
+	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(comp);
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
 	reset_bdev(zram);
 
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch
block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch

