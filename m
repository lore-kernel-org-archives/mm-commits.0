Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA9CC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E3360F10
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhHGSaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGSaI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 14:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C1B6105A;
        Sat,  7 Aug 2021 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628360989;
        bh=k8hR7guTJQq9i6XuEC3VyYQEY3OGgrfa8CQoQk2JYZ0=;
        h=Date:From:To:Subject:From;
        b=E0Sz5gzIBBaPjoci0JgghjnUw7qnJjQ/XWg2R6Wrs8Eh2UrYKCzdyOrikaSJrok9X
         D9kzXjij70rpUZIHLzIky5GKTXOURW7yD1IyGcjiC+Xb5PD00sRpy6q44Miov5uWCh
         dHRoQ5K+DLtiEE90E/kt3PUz5RfB+KiAwhjc66K8=
Date:   Sat, 07 Aug 2021 11:29:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        npiggin@gmail.com, masahiroy@kernel.org, dzickus@redhat.com,
        babu.moger@oracle.com, lukas.bulwahn@gmail.com
Subject:  +
 kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch.patch added
 to -mm tree
Message-ID: <20210807182949.ZJ3ZD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH
has been added to the -mm tree.  Its filename is
     kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Commit 05a4a9527931 ("kernel/watchdog: split up config options") adds a
new config HARDLOCKUP_DETECTOR, which selects the non-existing config
HARDLOCKUP_DETECTOR_ARCH.

Hence, ./scripts/checkkconfigsymbols.py warns:

HARDLOCKUP_DETECTOR_ARCH Referencing files: lib/Kconfig.debug

Simply drop selecting the non-existing HARDLOCKUP_DETECTOR_ARCH.

Link: https://lkml.kernel.org/r/20210806115618.22088-1-lukas.bulwahn@gmail.com
Fixes: 05a4a9527931 ("kernel/watchdog: split up config options")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/Kconfig.debug~kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch
+++ a/lib/Kconfig.debug
@@ -1062,7 +1062,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch.patch

