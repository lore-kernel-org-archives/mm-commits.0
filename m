Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B11AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Mar 2022 21:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiCCV6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 16:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiCCV6D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 16:58:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6C056C25
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 13:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9D361D64
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 21:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C488C004E1;
        Thu,  3 Mar 2022 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646344636;
        bh=M34w4LScOTY6jYcF3XWDtDgZxFBZeTFykyDoLCRjikY=;
        h=Date:To:From:Subject:From;
        b=ygrl9FRWoDzexoKTmUebujs0OZ3kleMig5Da8Li/FAszG5ctBIoCKzVkuao4pa5yk
         UUN41h1caQzuX/rG72mW541qOwNx+B+//8/QXEH0zM7gR5MFSINPDAEvTK/hq1UZ96
         XIzaBAwl8DrVEsxxxLwvFxlbm/7HeQMaJ2nxELuA=
Date:   Thu, 03 Mar 2022 13:57:15 -0800
To:     mm-commits@vger.kernel.org, keithp@keithp.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] drivers-gpu-drm-dp-drm_dpc-fix-build.patch removed from -mm tree
Message-Id: <20220303215716.9C488C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/dp/drm_dp.c: "fix" build
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-dp-drm_dpc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpu/drm/dp/drm_dp.c: "fix" build

drivers/gpu/drm/dp/drm_dp.c: In function 'drm_dp_get_adjust_request_post_cursor':
drivers/gpu/drm/dp/drm_dp.c:59:27: error: array subscript 10 is outside array bounds of 'const u8[6]' {aka 'const unsigned char[6]'} [-Werror=array-bounds]
   59 |         return link_status[r - DP_LANE0_1_STATUS];
      |                ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/dp/drm_dp.c:210:51: note: while referencing 'link_status'
  210 | u8 drm_dp_get_adjust_request_post_cursor(const u8 link_status[DP_LINK_STATUS_SIZE],
      |                                          ~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[4]: *** [scripts/Makefile.build:288: drivers/gpu/drm/dp/drm_dp.o] Error 1
make[3]: *** [scripts/Makefile.build:614: drivers/gpu/drm/dp] Error 2
make[2]: *** [scripts/Makefile.build:614: drivers/gpu/drm] Error 2
make[1]: *** [scripts/Makefile.build:614: drivers/gpu] Error 2
make: *** [Makefile:1971: drivers] Error 2

Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/dp/drm_dp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/dp/drm_dp.c~drivers-gpu-drm-dp-drm_dpc-fix-build
+++ a/drivers/gpu/drm/dp/drm_dp.c
@@ -57,7 +57,8 @@ struct dp_aux_backlight {
 /* Helpers for DP link training */
 static u8 dp_link_status(const u8 link_status[DP_LINK_STATUS_SIZE], int r)
 {
-	return link_status[r - DP_LANE0_1_STATUS];
+//	return link_status[r - DP_LANE0_1_STATUS];
+	return 0;
 }
 
 static u8 dp_get_lane_status(const u8 link_status[DP_LINK_STATUS_SIZE],
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

