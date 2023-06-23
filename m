Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB688EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 04:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjFWEkD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 00:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjFWEkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 00:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D72126
        for <mm-commits@vger.kernel.org>; Thu, 22 Jun 2023 21:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F17761910
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 04:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712C3C433C0;
        Fri, 23 Jun 2023 04:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687495200;
        bh=6Myx8KntI/ZUGIyqn0V7oIWWoASG7LP6EZvGcmgR5EI=;
        h=Date:To:From:Subject:From;
        b=ctX/9c4HNnIs1elIk2NQ7tuw+nxjuk8p7A19OZdwj7lnqkpmtp8YwGOvzqIj5ApgY
         qo+QOg7GetXHmlLMJtz/mTN6ll0Teyn3pt2fo7zjpyLZew+qsboWt9x5uPdEbL8qKa
         LVr3OeXkHrtcamQRWPYqRGh2QH5p8kO7VRVX8g6c=
Date:   Thu, 22 Jun 2023 21:39:59 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        dianders@chromium.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch added to mm-nonmm-unstable branch
Message-Id: <20230623044000.712C3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog/hardlockup: fix typo in config HARDLOCKUP_DETECTOR_PREFER_BUDDY
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Cc: Petr Mladek <pmladek@suse.com>
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

watchdog-hardlockup-fix-typo-in-config-hardlockup_detector_prefer_buddy.patch

