Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B0BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiI2OHe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiI2OHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:07:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63EE160E59
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37F7CCE21B9
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626AAC433B5;
        Thu, 29 Sep 2022 14:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460448;
        bh=C3LVGREy8+XMNhgskkHJdHpo2KhrdlR/FxMxtvA7iWI=;
        h=Date:To:From:Subject:From;
        b=B7JitfJJn2aUECUNB4IAx7Fy7/mO3iDr97ZRFmn0zFfCsfWbNNIYXSzrxWFHP1C3c
         tCnziFjxkrgScxL07apRLXJL5lDWqKhFZgFT0IUXnuAwPdOc3BqUFppMVGte9HVsX6
         m2m24rPlrDPlt/8efNiDCh/3loQFVRnwwfHdriTA=
Date:   Thu, 29 Sep 2022 07:07:27 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-update-config-files.patch added to mm-nonmm-unstable branch
Message-Id: <20220929140728.626AAC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: update config files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-update-config-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-update-config-files.patch

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
Subject: ia64: update config files
Date: Thu, 29 Sep 2022 12:14:41 +0200

Clean up config files by:
  - removing configs that were deleted in the past
  - removing configs not in tree and without recently pending patches
  - adding new configs that are replacements for old configs in the file

For some detailed information, see Link.

Link: https://lore.kernel.org/kernel-janitors/20220929090645.1389-1-lukas.bulwahn@gmail.com/

Link: https://lkml.kernel.org/r/20220929101441.32009-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/ia64/configs/bigsur_defconfig~ia64-update-config-files
+++ a/arch/ia64/configs/bigsur_defconfig
@@ -20,7 +20,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_ATA=m
@@ -91,7 +90,6 @@ CONFIG_NFS_V4=m
 CONFIG_NFSD=m
 CONFIG_NFSD_V4=y
 CONFIG_CIFS=m
-CONFIG_CIFS_STATS=y
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=y
--- a/arch/ia64/configs/generic_defconfig~ia64-update-config-files
+++ a/arch/ia64/configs/generic_defconfig
@@ -39,7 +39,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug
 CONFIG_CONNECTOR=y
 # CONFIG_PNP_DEBUG_MESSAGES is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SGI_XP=m
@@ -91,7 +90,6 @@ CONFIG_SERIAL_8250_SHARE_IRQ=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_EFI=y
-CONFIG_RAW_DRIVER=m
 CONFIG_HPET=y
 CONFIG_AGP=m
 CONFIG_AGP_I460=m
--- a/arch/ia64/configs/gensparse_defconfig~ia64-update-config-files
+++ a/arch/ia64/configs/gensparse_defconfig
@@ -31,11 +31,9 @@ CONFIG_IP_MULTICAST=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_ATA=y
-CONFIG_BLK_DEV_IDECD=y
 CONFIG_ATA_GENERIC=y
 CONFIG_PATA_CMD64X=y
 CONFIG_ATA_PIIX=y
@@ -81,7 +79,6 @@ CONFIG_SERIAL_8250_SHARE_IRQ=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_EFI=y
-CONFIG_RAW_DRIVER=m
 CONFIG_HPET=y
 CONFIG_AGP=m
 CONFIG_AGP_I460=m
--- a/arch/ia64/configs/tiger_defconfig~ia64-update-config-files
+++ a/arch/ia64/configs/tiger_defconfig
@@ -36,7 +36,6 @@ CONFIG_IP_MULTICAST=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_ATA=y
@@ -85,7 +84,6 @@ CONFIG_SERIAL_8250_SHARE_IRQ=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_EFI=y
-CONFIG_RAW_DRIVER=m
 CONFIG_HPET=y
 CONFIG_AGP=m
 CONFIG_AGP_I460=m
--- a/arch/ia64/configs/zx1_defconfig~ia64-update-config-files
+++ a/arch/ia64/configs/zx1_defconfig
@@ -30,7 +30,6 @@ CONFIG_PATA_CMD64X=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
-CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch
proc-make-config-proc_children-depend-on-proc_fs.patch
ia64-update-config-files.patch

