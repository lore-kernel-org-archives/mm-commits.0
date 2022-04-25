Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869D4C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbiDZAC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiDZACY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D729120113
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF856B81BAD
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D090C385A9;
        Mon, 25 Apr 2022 23:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931156;
        bh=d7MyUIbuDCgxG/YCgOtzrG6ENKsemdrTdUHNYww3tbc=;
        h=Date:To:From:Subject:From;
        b=RUOaOEu6i/3RD+viowMHUwYAvFW435uA4pH2KG1sS8Psx45wLID3StWEM5gAVbLrS
         DRqcrI4XcUA7RM9aPpzGUPjv/hZS+ZeXnKrzFKq2OBcpyqxJVSet9WEMZ8XTLOO53p
         J2HGNqjKhT/rF628OVSxUU/1WFMNct9MsIv3BTwU=
Date:   Mon, 25 Apr 2022 16:59:15 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, linux@roeck-us.net,
        jdelvare@suse.com, daniel@ffwll.ch, christian.koenig@amd.com,
        alexander.deucher@amd.com, airlied@linux.ie, wangqing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235916.7D090C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gpu: drm: radeon: use time_is_before_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: gpu: drm: radeon: use time_is_before_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-4-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c~gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/drivers/gpu/drm/radeon/radeon_pm.c
@@ -25,6 +25,7 @@
 #include <linux/hwmon.h>
 #include <linux/pci.h>
 #include <linux/power_supply.h>
+#include <linux/jiffies.h>
 
 #include <drm/drm_vblank.h>
 
@@ -1899,7 +1900,7 @@ static void radeon_dynpm_idle_work_handl
 		 * to false since we want to wait for vbl to avoid flicker.
 		 */
 		if (rdev->pm.dynpm_planned_action != DYNPM_ACTION_NONE &&
-		    jiffies > rdev->pm.dynpm_action_timeout) {
+		    time_is_before_jiffies(rdev->pm.dynpm_action_timeout)) {
 			radeon_pm_get_dynpm_state(rdev);
 			radeon_pm_set_clocks(rdev);
 		}
_

Patches currently in -mm which might be from wangqing@vivo.com are

hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

