Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBB8C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F466115B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhIHDCA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347443AbhIHDBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D3A61152;
        Wed,  8 Sep 2021 03:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070045;
        bh=GfByuxiZHw89tmlVPTM/bxEwB1XRfGvKa8FhM70a1+8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Daze4emJZAWjQ+7L5a4fb03THrlQMCal73RK9CulUlHZN9YPc4yYccZvSZE6BZyge
         XfxcRjqHy0u5KZaBX3scjJUAkLg0p/nWtXgaYvv4prOn25cCp/Bs1BCnO2SoXIOyXQ
         81EQHkKNOBbPP6BTcnQ6KzwbAl4/J3x/v9ZJgyoY=
Date:   Tue, 07 Sep 2021 20:00:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yuzenghui@huawei.com
Subject:  [patch 142/147] configs: remove the obsolete
 CONFIG_INPUT_POLLDEV
Message-ID: <20210908030044.5QYi8ELGo%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
