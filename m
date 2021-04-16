Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6282FC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 17:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F936121F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 17:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhDPROS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239856AbhDPROQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 13:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AEB8611EF;
        Fri, 16 Apr 2021 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618593230;
        bh=Eh8wJp2Kagw3rxZqLYeZOWrFRXJzcquS4+wDHR2PyFc=;
        h=Date:From:To:Subject:From;
        b=ed9GHz3Gr24aR+UkYZUrVpOfsTtsu7SDu5DlXr9kBSpH4Ii1v5HNMGzFQQSnNC+4c
         yEYp+JdhVv/VdJ8vqOiZOyHsdCvVyTZyzaTiJih6fOmpDWbPvbsZoeUDE9VK2w8ZqK
         zDEDqiyQh+R8vP4OV+5U4G62uhPIBpYZFXzQ58YY=
Date:   Fri, 16 Apr 2021 10:13:49 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210416171349.gY_Z1XfuU%akpm@linux-foundation.org>
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

 drivers/gpu/drm/i915/display/vlv_dsi.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1004,26 +1004,14 @@ static void intel_dsi_post_disable(struc
 	intel_dsi_msleep(intel_dsi, intel_dsi->panel_off_delay);
 	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_POWER_OFF);
 
-<<<<<<< HEAD
-	/*
-	 * FIXME As we do with eDP, just make a note of the time here
-	 * and perform the wait before the next panel power on.
-	 */
-	msleep(intel_dsi->panel_pwr_cycle_delay);
-=======
 	intel_dsi->panel_power_off_time = ktime_get_boottime();
->>>>>>> linux-next/akpm-base
 }
 
 static void intel_dsi_shutdown(struct intel_encoder *encoder)
 {
 	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
 
-<<<<<<< HEAD
-	msleep(intel_dsi->panel_pwr_cycle_delay);
-=======
 	intel_dsi_wait_panel_power_cycle(intel_dsi);
->>>>>>> linux-next/akpm-base
 }
 
 static bool intel_dsi_get_hw_state(struct intel_encoder *encoder,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

