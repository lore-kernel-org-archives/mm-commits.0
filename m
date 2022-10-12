Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913EAC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJLBvr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiJLBvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D537549A
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04716133B
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501DCC433C1;
        Wed, 12 Oct 2022 01:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539501;
        bh=4S8qIBzEEI3c4d3u5S8XuWWXBNhma+EPpm0kNh4awA8=;
        h=Date:To:From:Subject:From;
        b=yb3JFIwtHIp5deQvg9FzbfBZS6nAjfI752L6SEtRLccSybrIFk5VPP0klCiwbZk9a
         BiyHQhZIQEv9T07v/F7SswlcUjBjeGZINH7RWcXleIeFKBBJhO6/biygwpcv+yDNBI
         qbnSMyae+Z7t9U/ZCY9/k8GGeBuQOBaRVRxqPn/0=
Date:   Tue, 11 Oct 2022 18:51:40 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-update-config-files.patch removed from -mm tree
Message-Id: <20221012015141.501DCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: update config files
has been removed from the -mm tree.  Its filename was
     ia64-update-config-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 arch/ia64/configs/bigsur_defconfig    |    2 --
 arch/ia64/configs/generic_defconfig   |    2 --
 arch/ia64/configs/gensparse_defconfig |    3 ---
 arch/ia64/configs/tiger_defconfig     |    2 --
 arch/ia64/configs/zx1_defconfig       |    1 -
 5 files changed, 10 deletions(-)

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


