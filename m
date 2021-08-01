Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD37C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7144A60F9F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhHATLx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHATLx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2746360F9F;
        Sun,  1 Aug 2021 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627845104;
        bh=S/pSF+XXMlOEhj/IU2UMJS+F2vrdmPt057Qxlu0amtU=;
        h=Date:From:To:Subject:From;
        b=gIFTM+CYI22BcR5gFJHq2orF8Om4h4gpnr1b2r6Bk/xwK9ofPUxR749mbALvbh+JM
         Zp6WxMupLnOx21q4/Zg87xZ9+gFuAYZ85c4oyTU9ekepccwKBCZ16mc4BrNk9DKPvg
         zA+dG0eGrcQbXKWkVuZcFb0NJQEnT6cIBTaDo4wg=
Date:   Sun, 01 Aug 2021 12:11:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210801191143.CpaqbiMAz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                    |    8 --------
 block/genhd.c                  |    4 ----
 drivers/block/loop.c           |    7 -------
 drivers/hid/wacom_wac.c        |    8 --------
 drivers/nfc/s3fwrn5/firmware.c |    4 ----
 5 files changed, 31 deletions(-)

--- a/block/genhd.c~linux-next-git-rejects
+++ a/block/genhd.c
@@ -1100,11 +1100,7 @@ static void disk_release(struct device *
 	xa_destroy(&disk->part_tbl);
 	if (test_bit(GD_QUEUE_REF, &disk->state) && disk->queue)
 		blk_put_queue(disk->queue);
-<<<<<<< HEAD
-	bdput(disk->part0);	/* frees the disk */
-=======
 	iput(disk->part0->bd_inode);	/* frees the disk */
->>>>>>> linux-next/akpm-base
 }
 
 static int block_uevent(struct device *dev, struct kobj_uevent_env *env)
--- a/drivers/block/loop.c~linux-next-git-rejects
+++ a/drivers/block/loop.c
@@ -1306,13 +1306,6 @@ static int loop_configure(struct loop_de
 	if (partscan)
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
 
-<<<<<<< HEAD
-	/* Grab the block_device to prevent its destruction after we
-	 * put /dev/loopXX inode. Later in __loop_clr_fd() we bdput(bdev).
-	 */
-	bdgrab(bdev);
-=======
->>>>>>> linux-next/akpm-base
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
 		loop_reread_partitions(lo);
--- a/drivers/hid/wacom_wac.c~linux-next-git-rejects
+++ a/drivers/hid/wacom_wac.c
@@ -2554,10 +2554,6 @@ static void wacom_wac_finger_slot(struct
 		int slot;
 
 		slot = input_mt_get_slot_by_key(input, hid_data->id);
-<<<<<<< HEAD
-		if (slot < 0)
-			return;
-=======
 		if (slot < 0) {
 			return;
 		} else {
@@ -2569,7 +2565,6 @@ static void wacom_wac_finger_slot(struct
 				return;
 			}
 		}
->>>>>>> linux-next/akpm-base
 
 		input_mt_slot(input, slot);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER, prox);
@@ -3865,10 +3860,7 @@ int wacom_setup_touch_input_capabilities
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
 			wacom_wac->has_mute_touch_switch = true;
-<<<<<<< HEAD
-=======
 			wacom_wac->is_soft_touch_switch = true;
->>>>>>> linux-next/akpm-base
 		}
 		fallthrough;
 
--- a/drivers/nfc/s3fwrn5/firmware.c~linux-next-git-rejects
+++ a/drivers/nfc/s3fwrn5/firmware.c
@@ -423,11 +423,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_f
 	if (IS_ERR(tfm)) {
 		dev_err(&fw_info->ndev->nfc_dev->dev,
 			"Cannot allocate shash (code=%pe)\n", tfm);
-<<<<<<< HEAD
-		goto out;
-=======
 		return PTR_ERR(tfm);
->>>>>>> linux-next/akpm-base
 	}
 
 	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -11365,19 +11365,11 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-maxiradio*
 
-<<<<<<< HEAD
-MCAB MICROCHIP CAN BUS ANALYZER TOOL DRIVER
-R:	Yasushi SHOJI <yashi@spacecubics.com>
-L:	linux-can@vger.kernel.org
-S:	Maintained
-F:	drivers/net/can/usb/mcba_usb.c
-=======
 MAXLINEAR ETHERNET PHY DRIVER
 M:	Xu Liang <lxu@maxlinear.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/phy/mxl-gpy.c
->>>>>>> linux-next/akpm-base
 
 MCAN MMIO DEVICE DRIVER
 M:	Chandrasekar Ramakrishnan <rcsekar@samsung.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

