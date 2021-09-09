Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9528EC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7827B611BD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346214AbhIIVHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346720AbhIIVGi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ED5D611C7;
        Thu,  9 Sep 2021 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221528;
        bh=tBF4tp4uxhIXJy7nKcBRP5FEtUN69LGsw8rtw1sczbo=;
        h=Date:From:To:Subject:From;
        b=MY7u4r88sw6lPMt23duaurHi3XraCefXy2Ia8fE3X4vfRqnKo5zOjZkM9xDZG72K6
         n1LxTbh66ITuR2Q5Q7pgX9AqFMlXvxcS65VE9yyhyLmH+4V24Ww9ezTSKLPK6LO9ZS
         y88aoAw2Oon8tchFz50GgJ4IjQCbS2MEO8in/dmY=
Date:   Thu, 09 Sep 2021 14:05:28 -0700
From:   akpm@linux-foundation.org
To:     dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org,
        yuzenghui@huawei.com
Subject:  [merged]
 configs-remove-the-obsolete-config_input_polldev.patch removed from -mm
 tree
Message-ID: <20210909210528.ybT-xCp8P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs: remove the obsolete CONFIG_INPUT_POLLDEV
has been removed from the -mm tree.  Its filename was
     configs-remove-the-obsolete-config_input_polldev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


