Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442D3C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 19:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJCTkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 15:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJCTkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 15:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C404F38A8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 12:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB4B611CF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 19:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36A6C433C1;
        Mon,  3 Oct 2022 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664826010;
        bh=kabLlfd5S7bouXRk/75HkfkZvqANlQOJmh71VkRPArI=;
        h=Date:To:From:Subject:From;
        b=XSQtXWPgOkQ2HeQTdEHIHE4m0G2trPXRytxMSwjD6lJ6l3G2NMMY2qP06iuttdBkx
         zoIW9q5sNnSna8uXsLfQmEu+KYVJWuJyv5cQZRzeXuX5PX9RIyrZGzC0BTzfcp4kt9
         TY6aMn975CSrTqS9Y4Hi9oRTlhe7qRRspSMo/qy8=
Date:   Mon, 03 Oct 2022 12:40:09 -0700
To:     mm-commits@vger.kernel.org, suleiman@google.com,
        senozhatsky@chromium.org, romlem@google.com, ngupta@vflare.org,
        minchan@kernel.org, bgeffon@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-always-expose-rw_page.patch added to mm-unstable branch
Message-Id: <20221003194010.B36A6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: always expose rw_page
has been added to the -mm mm-unstable branch.  Its filename is
     zram-always-expose-rw_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-always-expose-rw_page.patch

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
From: Brian Geffon <bgeffon@google.com>
Subject: zram: always expose rw_page
Date: Mon, 3 Oct 2022 10:48:32 -0400

Currently zram will adjust its fops to a version which does not contain
rw_page when a backing device has been assigned.  This is done to prevent
upper layers from assuming a synchronous operation when a page may have
been written back.  This forces every operation through bio which has
overhead associated with bio_alloc/frees.

The code can be simplified to always expose an rw_page method and only in
the rare event that a page is written back we instead will return
-EOPNOTSUPP forcing the upper layer to fallback to bio.

Link: https://lkml.kernel.org/r/20221003144832.2906610-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Rom Lemarchand <romlem@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-always-expose-rw_page
+++ a/drivers/block/zram/zram_drv.c
@@ -52,9 +52,6 @@ static unsigned int num_devices = 1;
 static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
-#ifdef CONFIG_ZRAM_WRITEBACK
-static const struct block_device_operations zram_wb_devops;
-#endif
 
 static void zram_free_page(struct zram *zram, size_t index);
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
@@ -546,17 +543,6 @@ static ssize_t backing_dev_store(struct
 	zram->backing_dev = backing_dev;
 	zram->bitmap = bitmap;
 	zram->nr_pages = nr_pages;
-	/*
-	 * With writeback feature, zram does asynchronous IO so it's no longer
-	 * synchronous device so let's remove synchronous io flag. Othewise,
-	 * upper layer(e.g., swap) could wait IO completion rather than
-	 * (submit and return), which will cause system sluggish.
-	 * Furthermore, when the IO function returns(e.g., swap_readpage),
-	 * upper layer expects IO was done so it could deallocate the page
-	 * freely but in fact, IO is going on so finally could cause
-	 * use-after-free when the IO is really done.
-	 */
-	zram->disk->fops = &zram_wb_devops;
 	up_write(&zram->init_lock);
 
 	pr_info("setup backing device %s\n", file_name);
@@ -1270,6 +1256,9 @@ static int __zram_bvec_read(struct zram
 		struct bio_vec bvec;
 
 		zram_slot_unlock(zram, index);
+		/* A null bio means rw_page was used, we must fallback to bio */
+		if (!bio)
+			return -EOPNOTSUPP;
 
 		bvec.bv_page = page;
 		bvec.bv_len = PAGE_SIZE;
@@ -1856,15 +1845,6 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
-#ifdef CONFIG_ZRAM_WRITEBACK
-static const struct block_device_operations zram_wb_devops = {
-	.open = zram_open,
-	.submit_bio = zram_submit_bio,
-	.swap_slot_free_notify = zram_slot_free_notify,
-	.owner = THIS_MODULE
-};
-#endif
-
 static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
_

Patches currently in -mm which might be from bgeffon@google.com are

zram-always-expose-rw_page.patch

