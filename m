Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BE9C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1293061A6F
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJAXXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhJAXXx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:23:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D1C361242;
        Fri,  1 Oct 2021 23:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130528;
        bh=JzvD9zUGfVF6S8Qt3K4dnW4Y8cOggloWjicKboxDOrk=;
        h=Date:From:To:Subject:From;
        b=ZXVGvL5YpHrWDf18AbsjWge5u2HQpoXVYXWmu6K4C09RT9K8Oe+7n0mgjdQp3ORs+
         3L4h/rwLVyFKtM0ZXPPgOy/eYTY+6v6p4uaRIv68mqZuR0PcoUWXwan5vsaG+iPQKT
         6Pix6sKcjGhdkPTLHtfU3Wd54Nv2vWrcdlwJx22A=
Date:   Fri, 01 Oct 2021 16:22:08 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, corbet@lwn.net, jsbarnes@google.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org, suleiman@google.com
Subject:  +
 zram-allow-backing-device-to-be-assigned-after-init.patch added to -mm tree
Message-ID: <20211001232208.U-I36vLyD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: allow backing device to be assigned after init
has been added to the -mm tree.  Its filename is
     zram-allow-backing-device-to-be-assigned-after-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-allow-backing-device-to-be-assigned-after-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-allow-backing-device-to-be-assigned-after-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: zram: allow backing device to be assigned after init

There does not appear to be a technical reason to not allow the zram
backing device to be assigned after the zram device is initialized.

This change will allow for the backing device to be assigned as long as no
backing device is already assigned.  In that event backing_dev would
return -EEXIST.

Link: https://lkml.kernel.org/r/20211001181627.394921-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-allow-backing-device-to-be-assigned-after-init
+++ a/drivers/block/zram/zram_drv.c
@@ -492,9 +492,9 @@ static ssize_t backing_dev_store(struct
 		return -ENOMEM;
 
 	down_write(&zram->init_lock);
-	if (init_done(zram)) {
-		pr_info("Can't setup backing device for initialized device\n");
-		err = -EBUSY;
+	if (zram->backing_dev) {
+		pr_info("Backing device is already assigned\n");
+		err = -EEXIST;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from bgeffon@google.com are

zram-introduce-an-aged-idle-interface.patch
zram-introduce-an-aged-idle-interface-v5.patch
zram-introduce-an-aged-idle-interface-v6.patch
zram-allow-backing-device-to-be-assigned-after-init.patch

