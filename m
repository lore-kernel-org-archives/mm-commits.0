Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E879C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347843AbiATV2H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC26C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A148B81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA00C340E0;
        Thu, 20 Jan 2022 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714083;
        bh=7EjOYmLlVu++TTV4M3mHwPFW5cGP2qW9nOyk6vHgwic=;
        h=Date:From:To:Subject:From;
        b=TDRMITsipXqKWoAm9MKobDB+GZAWIPSTfPwJbsz42ts8jIEs/55dfwmIG1t180LN/
         u3Rj1r/RdaIx4jMd4ACcTVh2N6WtFX03BxwPyryDIVoQyISW2gTkD61v3PI/rL6+jX
         2ghkYSL+kxb+egy+Im+pnoboXc+9H89iYK1vcUCU=
Date:   Thu, 20 Jan 2022 13:28:03 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, bvanassche@acm.org, mcgrof@kernel.org,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  [merged] zram-use-attribute_groups.patch removed from -mm
 tree
Message-ID: <20220120212803.ZxRddmptJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use ATTRIBUTE_GROUPS
has been removed from the -mm tree.  Its filename was
     zram-use-attribute_groups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: zram: use ATTRIBUTE_GROUPS

Embrace ATTRIBUTE_GROUPS to avoid boiler plate code.  This should not
introduce any functional changes.

Link: https://lkml.kernel.org/r/20211028203600.2157356-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-attribute_groups
+++ a/drivers/block/zram/zram_drv.c
@@ -1903,14 +1903,7 @@ static struct attribute *zram_disk_attrs
 	NULL,
 };
 
-static const struct attribute_group zram_disk_attr_group = {
-	.attrs = zram_disk_attrs,
-};
-
-static const struct attribute_group *zram_disk_attr_groups[] = {
-	&zram_disk_attr_group,
-	NULL,
-};
+ATTRIBUTE_GROUPS(zram_disk);
 
 /*
  * Allocate and initialize new zram device. the function returns
@@ -1982,7 +1975,7 @@ static int zram_add(void)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
-	ret = device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
sysctl-add-helper-to-register-a-sysctl-mount-point.patch
fs-move-binfmt_misc-sysctl-to-its-own-file.patch
sysctl-share-unsigned-long-const-values.patch
fs-move-inode-sysctls-to-its-own-file.patch
fs-move-fs-stat-sysctls-to-file_tablec.patch
fs-move-dcache-sysctls-to-its-own-file.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
fs-move-shared-sysctls-to-fs-sysctlsc.patch
fs-move-locking-sysctls-where-they-are-used.patch
fs-move-namei-sysctls-to-its-own-file.patch
fs-move-fs-execc-sysctls-into-its-own-file.patch
fs-move-pipe-sysctls-to-is-own-file.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper-fix.patch
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

