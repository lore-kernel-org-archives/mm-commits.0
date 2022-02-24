Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291A6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 03:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiBXDPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 22:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBXDPk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 22:15:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB12252938
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 19:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71765B81FCD
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 03:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017D2C340E7;
        Thu, 24 Feb 2022 03:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645672507;
        bh=wX6lMVnxPd/PqgVm2n+PvHvtwdwmg0s+GXTUV82Gc8I=;
        h=Date:To:From:Subject:From;
        b=p0v/vKxmf7RaM/kptHpqIjtA1J8tsb/5/eITdglO3Jwb83hYeHhLdzYltEsXrINHj
         6qJ+4W5wwkOE80DYOpuvHSTxR0ZYnPuOWthazCxqhGuRrP0nIjbOuRPvbKxK3w6/F5
         yqx9pQZ68Rr8LaeK7kygXJZvRDHFpXR5QKWA7atw=
Date:   Wed, 23 Feb 2022 19:15:06 -0800
To:     mm-commits@vger.kernel.org, keithp@keithp.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-gpu-drm-dp-drm_dpc-fix-build.patch added to -mm tree
Message-Id: <20220224031507.017D2C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/dp/drm_dp.c: "fix" build
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-dp-drm_dpc-fix-build.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-dp-drm_dpc-fix-build.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-dp-drm_dpc-fix-build.patch

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
@@ -56,7 +56,8 @@ struct dp_aux_backlight {
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

mm.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

