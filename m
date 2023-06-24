Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854C7EB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjFXAEg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjFXAEf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20E31715
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50E6161B45
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BFEC433C8;
        Sat, 24 Jun 2023 00:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687565073;
        bh=UU1TtSYKkawNh0Tx/SgyNRll4DRhT+WQwNB2EFIA3bA=;
        h=Date:To:From:Subject:From;
        b=o30LnNHaLslwUqJdueoBgagDPeOB59rmPYZQxt3ZVFgPsJFCblwFh8zb1iRZwM2JG
         7aBTw0M2OHC4Mfcwpi9RdH1/iDplDC0DC0z4N/8w32Uo4MtHR6MCE+YsH46opNxPkY
         TqpZM2rVN45NIjrG4e0f6//iR/pcg5IV32Mv9SZ8=
Date:   Fri, 23 Jun 2023 17:04:33 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        dianders@chromium.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch removed from -mm tree
Message-Id: <20230624000433.A5BFEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: fix typo in config HARDLOCKUP_DETECTOR_PREFER_BUDDY
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: watchdog/hardlockup: fix typo in config HARDLOCKUP_DETECTOR_PREFER_BUDDY
Date: Fri, 23 Jun 2023 06:07:17 +0200

Commit a5fcc2367e22 ("watchdog/hardlockup: make HAVE_NMI_WATCHDOG
sparc64-specific") accidentially introduces a typo in one of the config
dependencies of HARDLOCKUP_DETECTOR_PREFER_BUDDY.

Fix this accidental typo.

Link: https://lkml.kernel.org/r/20230623040717.8645-1-lukas.bulwahn@gmail.com
Fixes: a5fcc2367e22 ("watchdog/hardlockup: make HAVE_NMI_WATCHDOG sparc64-specific")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy
+++ a/lib/Kconfig.debug
@@ -1075,7 +1075,7 @@ config HARDLOCKUP_DETECTOR_PREFER_BUDDY
 	bool "Prefer the buddy CPU hardlockup detector"
 	depends on HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && HAVE_HARDLOCKUP_DETECTOR_BUDDY
-	depends on !HAVE_HARLOCKUP_DETECTOR_ARCH
+	depends on !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to prefer the buddy hardlockup detector over the perf one.
 
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


