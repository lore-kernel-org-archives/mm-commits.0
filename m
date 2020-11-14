Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0254FC4742C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9657C2225D
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bo/z3lPE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKNBeY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:34:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKNBeX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:34:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF512225D;
        Sat, 14 Nov 2020 01:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605317663;
        bh=pfj1g8R403nfYRA3Rb7JTMiPGQE36eDHcshgrpu9kuA=;
        h=Date:From:To:Subject:From;
        b=Bo/z3lPEeNl8SYHR/V7PEYwV0o0cXY3QvyRFuB8kVbsSmgIbxWTbAVpKFUMuxnjp/
         7o5xdctyH5XwOKJoG8aXBO02p3IpgrAknVAU6bcpbGs1uQp87y//i48ssUU+Jn18vT
         iLzpyq0VQqId9c/JG8R4zV85xq8Q+ru5NY+mVpvk=
Date:   Fri, 13 Nov 2020 17:34:22 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, keescook@chromium.org, linux@roeck-us.net,
        mcroce@microsoft.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, pasha.tatashin@soleen.com,
        pmladek@suse.com, rppt@kernel.org, tyhicks@linux.microsoft.com
Subject:  +
 reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch added
 to -mm tree
Message-ID: <20201114013422.IPqLa2FtZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: remove cf9_safe from allowed types and rename cf9_force
has been added to the -mm tree.  Its filename is
     reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -613,8 +613,7 @@ __setup("reboot=", reboot_setup);
 #define BOOT_BIOS_STR		"bios"
 #define BOOT_ACPI_STR		"acpi"
 #define BOOT_EFI_STR		"efi"
-#define BOOT_CF9_FORCE_STR	"cf9_force"
-#define BOOT_CF9_SAFE_STR	"cf9_safe"
+#define BOOT_PCI_STR		"pci"
 
 static ssize_t mode_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
@@ -686,10 +685,7 @@ static ssize_t type_show(struct kobject
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
@@ -713,10 +709,8 @@ static ssize_t type_store(struct kobject
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

revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
reboot-fix-overflow-parsing-reboot-cpu-number.patch
reboot-refactor-and-comment-the-cpu-selection-code.patch
reboot-allow-to-specify-reboot-mode-via-sysfs.patch
reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch

