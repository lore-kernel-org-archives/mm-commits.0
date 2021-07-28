Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65640C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 22:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F265603E9
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 22:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhG1W34 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 18:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232143AbhG1W34 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 18:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956D060FED;
        Wed, 28 Jul 2021 22:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627511393;
        bh=KQI6vwkcaILjpeq7hGvV7vJUBIu10tzY7NEUyMo4MhE=;
        h=Date:From:To:Subject:From;
        b=g6dSjGPHVGx+KaISyHCwKn+iBlg5AcGv3ACzB54I81fzu8yfLB8CfhhKu6KOSaRc4
         twGnrnX0s9LjimRKtKrPXgUSokmq2svYsVUTeR/gIj++CuGoxkSAYwZkrPZEcRHr2f
         mGF7n/OILaOseAwBpKiSNQKSW+Tf8Svk59BJuTsI=
Date:   Wed, 28 Jul 2021 15:29:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, dmitry.torokhov@gmail.com,
        yuzenghui@huawei.com
Subject:  + configs-remove-the-obsolete-config_input_polldev.patch
 added to -mm tree
Message-ID: <20210728222953.hteb_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs: remove the obsolete CONFIG_INPUT_POLLDEV
has been added to the -mm tree.  Its filename is
     configs-remove-the-obsolete-config_input_polldev.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/configs-remove-the-obsolete-config_input_polldev.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/configs-remove-the-obsolete-config_input_polldev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zenghui Yu <yuzenghui@huawei.com>
Subject: configs: remove the obsolete CONFIG_INPUT_POLLDEV

This CONFIG option was removed in commit 278b13ce3a89 ("Input: remove
input_polled_dev implementation") so there's no point to keep it in
defconfigs any longer.

Get rid of the leftover for all arches.

Link: https://lkml.kernel.org/r/20210726074741.1062-1-yuzenghui@huawei.com
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/dove_defconfig             |    1 -
 arch/arm/configs/pxa_defconfig              |    1 -
 arch/mips/configs/lemote2f_defconfig        |    1 -
 arch/mips/configs/pic32mzda_defconfig       |    1 -
 arch/mips/configs/rt305x_defconfig          |    1 -
 arch/mips/configs/xway_defconfig            |    1 -
 arch/parisc/configs/generic-32bit_defconfig |    1 -
 arch/x86/configs/i386_defconfig             |    1 -
 arch/x86/configs/x86_64_defconfig           |    1 -
 9 files changed, 9 deletions(-)

--- a/arch/arm/configs/dove_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/arm/configs/dove_defconfig
@@ -56,7 +56,6 @@ CONFIG_ATA=y
 CONFIG_SATA_MV=y
 CONFIG_NETDEVICES=y
 CONFIG_MV643XX_ETH=y
-CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV is not set
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
--- a/arch/arm/configs/pxa_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/arm/configs/pxa_defconfig
@@ -284,7 +284,6 @@ CONFIG_RT2800USB=m
 CONFIG_MWIFIEX=m
 CONFIG_MWIFIEX_SDIO=m
 CONFIG_INPUT_FF_MEMLESS=m
-CONFIG_INPUT_POLLDEV=y
 CONFIG_INPUT_MATRIXKMAP=y
 CONFIG_INPUT_MOUSEDEV=m
 CONFIG_INPUT_MOUSEDEV_SCREEN_X=640
--- a/arch/mips/configs/lemote2f_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/mips/configs/lemote2f_defconfig
@@ -116,7 +116,6 @@ CONFIG_8139TOO=y
 CONFIG_R8169=y
 CONFIG_USB_USBNET=m
 CONFIG_USB_NET_CDC_EEM=m
-CONFIG_INPUT_POLLDEV=m
 CONFIG_INPUT_EVDEV=y
 # CONFIG_MOUSE_PS2_ALPS is not set
 # CONFIG_MOUSE_PS2_LOGIPS2PP is not set
--- a/arch/mips/configs/pic32mzda_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/mips/configs/pic32mzda_defconfig
@@ -34,7 +34,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_INPUT_LEDS=m
-CONFIG_INPUT_POLLDEV=y
 CONFIG_INPUT_MOUSEDEV=m
 CONFIG_INPUT_EVDEV=y
 CONFIG_INPUT_EVBUG=m
--- a/arch/mips/configs/rt305x_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/mips/configs/rt305x_defconfig
@@ -90,7 +90,6 @@ CONFIG_PPPOE=m
 CONFIG_PPP_ASYNC=m
 CONFIG_ISDN=y
 CONFIG_INPUT=m
-CONFIG_INPUT_POLLDEV=m
 # CONFIG_KEYBOARD_ATKBD is not set
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_MISC=y
--- a/arch/mips/configs/xway_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/mips/configs/xway_defconfig
@@ -96,7 +96,6 @@ CONFIG_PPPOE=m
 CONFIG_PPP_ASYNC=m
 CONFIG_ISDN=y
 CONFIG_INPUT=m
-CONFIG_INPUT_POLLDEV=m
 # CONFIG_KEYBOARD_ATKBD is not set
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_MISC=y
--- a/arch/parisc/configs/generic-32bit_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/parisc/configs/generic-32bit_defconfig
@@ -111,7 +111,6 @@ CONFIG_PPP_BSDCOMP=m
 CONFIG_PPP_DEFLATE=m
 CONFIG_PPPOE=m
 # CONFIG_WLAN is not set
-CONFIG_INPUT_POLLDEV=y
 CONFIG_KEYBOARD_HIL_OLD=m
 CONFIG_KEYBOARD_HIL=m
 CONFIG_MOUSE_SERIAL=y
--- a/arch/x86/configs/i386_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/x86/configs/i386_defconfig
@@ -156,7 +156,6 @@ CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
 CONFIG_R8169=y
-CONFIG_INPUT_POLLDEV=y
 CONFIG_INPUT_EVDEV=y
 CONFIG_INPUT_JOYSTICK=y
 CONFIG_INPUT_TABLET=y
--- a/arch/x86/configs/x86_64_defconfig~configs-remove-the-obsolete-config_input_polldev
+++ a/arch/x86/configs/x86_64_defconfig
@@ -148,7 +148,6 @@ CONFIG_SKY2=y
 CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 CONFIG_R8169=y
-CONFIG_INPUT_POLLDEV=y
 CONFIG_INPUT_EVDEV=y
 CONFIG_INPUT_JOYSTICK=y
 CONFIG_INPUT_TABLET=y
_

Patches currently in -mm which might be from yuzenghui@huawei.com are

configs-remove-the-obsolete-config_input_polldev.patch

