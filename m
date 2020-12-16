Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFFBC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4F523407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgLPRMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:32994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:03 -0500
Date:   Wed, 16 Dec 2020 09:11:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138708;
        bh=8kpFvJpLkVRhY4iqkILYtynHnfhe/NoybjzWwYcKriA=;
        h=From:To:Subject:From;
        b=tCldVbC4qdIcbjDmooiLZgAzuu/LR/QnNrYXvyjtigw0QXuzfWtzNElrcMSmt5G9H
         xBmNkasr9rQLMMd044mGEiFSU+EzVsFunfqeqtnCGu9VxtcAUMNspK2uD5U+tjQaZ2
         ssLMAm9+HGD10sew+9Yp0MD4WbpFFa2RZ/OiTDHE=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, keescook@chromium.org, linux@roeck-us.net,
        mcroce@microsoft.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, pasha.tatashin@soleen.com,
        pmladek@suse.com, rppt@kernel.org, tyhicks@linux.microsoft.com
Subject:  [merged]
 reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch
 removed from -mm tree
Message-ID: <20201216171147.N-d7BgQwf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: remove cf9_safe from allowed types and rename cf9_force
has been removed from the -mm tree.  Its filename was
     reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: reboot: remove cf9_safe from allowed types and rename cf9_force

BOOT_CF9_SAFE_STR is an internal value used only by the x86 code and it's
not possible to set it from userspace.

Remove it, and rename 'cf9_force' to 'pci', so to make it coherent with
the kernel command line reboot= option.

Tested with this script:

	cd /sys/kernel/reboot/

	for i in cold warm hard soft gpio; do
		echo $i >mode
		read j <mode
		[ $i = $j ] || echo "mode $i != $j"
	done

	for i in bios acpi kbd triple efi pci; do
		echo $i >type
		read j <type
		[ $i = $j ] || echo "type $i != $j"
	done

	for i in $(seq 0 $(nproc --ignore=1)); do
		echo $i >cpu
		read j <cpu
		[ $i = $j ] || echo "cpu $i != $j"
	done

	for i in 0 1; do
		echo $i >force
		read j <force
		[ $i = $j ] || echo "force $i != $j"
	done

Link: https://lkml.kernel.org/r/20201113015900.543923-1-mcroce@linux.microsoft.com
Fixes: eab8da48579d ("reboot: allow to specify reboot mode via sysfs")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/kernel/reboot.c~reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force
+++ a/kernel/reboot.c
@@ -615,8 +615,7 @@ __setup("reboot=", reboot_setup);
 #define BOOT_BIOS_STR		"bios"
 #define BOOT_ACPI_STR		"acpi"
 #define BOOT_EFI_STR		"efi"
-#define BOOT_CF9_FORCE_STR	"cf9_force"
-#define BOOT_CF9_SAFE_STR	"cf9_safe"
+#define BOOT_PCI_STR		"pci"
 
 static ssize_t mode_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
@@ -688,10 +687,7 @@ static ssize_t type_show(struct kobject
 		val = BOOT_EFI_STR;
 		break;
 	case BOOT_CF9_FORCE:
-		val = BOOT_CF9_FORCE_STR;
-		break;
-	case BOOT_CF9_SAFE:
-		val = BOOT_CF9_SAFE_STR;
+		val = BOOT_PCI_STR;
 		break;
 	default:
 		val = REBOOT_UNDEFINED_STR;
@@ -715,10 +711,8 @@ static ssize_t type_store(struct kobject
 		reboot_type = BOOT_ACPI;
 	else if (!strncmp(buf, BOOT_EFI_STR, strlen(BOOT_EFI_STR)))
 		reboot_type = BOOT_EFI;
-	else if (!strncmp(buf, BOOT_CF9_FORCE_STR, strlen(BOOT_CF9_FORCE_STR)))
+	else if (!strncmp(buf, BOOT_PCI_STR, strlen(BOOT_PCI_STR)))
 		reboot_type = BOOT_CF9_FORCE;
-	else if (!strncmp(buf, BOOT_CF9_SAFE_STR, strlen(BOOT_CF9_SAFE_STR)))
-		reboot_type = BOOT_CF9_SAFE;
 	else
 		return -EINVAL;
 
_

Patches currently in -mm which might be from mcroce@microsoft.com are


