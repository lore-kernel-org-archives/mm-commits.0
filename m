Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC69C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D0D22D02
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLPER0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPER0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:17:26 -0500
Date:   Tue, 15 Dec 2020 20:16:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092205;
        bh=cjxSqZjceCW1zyRy3Vncb2gr9yqKxh90Pirl8n4S5G8=;
        h=From:To:Subject:From;
        b=1r3Jnv+VMx0kcI7yAdmJBom1wQ5xKmlsUtpFMXCW32m+f6Fr2sukFQ35RIv+lotpg
         J+LqlFL3I+PH4Htf63lWmNaEXZv/W6DT8+PflUuT6NhdAJjHh/BSJkjPBym5Qms69j
         2i0L6EeorAXMJec0psEiqWNAj3V+SUlFYQW2er+E=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, keescook@chromium.org, linux@roeck-us.net,
        mcroce@microsoft.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, pasha.tatashin@soleen.com,
        pmladek@suse.com, rppt@kernel.org, tyhicks@linux.microsoft.com
Subject:  [folded-merged]
 reboot-fix-variable-assignments-in-type_store.patch removed from -mm tree
Message-ID: <20201216041644.3aR4_l7Iz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: fix variable assignments in type_store
has been removed from the -mm tree.  Its filename was
     reboot-fix-variable-assignments-in-type_store.patch

This patch was dropped because it was folded into reboot-allow-to-specify-reboot-mode-via-sysfs.patch

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: reboot: fix variable assignments in type_store

Clang warns:

kernel/reboot.c:707:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_TRIPLE;
                            ~ ^~~~~~~~~~~
kernel/reboot.c:709:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_KBD;
                            ~ ^~~~~~~~
kernel/reboot.c:711:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_BIOS;
                            ~ ^~~~~~~~~
kernel/reboot.c:713:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_ACPI;
                            ~ ^~~~~~~~~
kernel/reboot.c:715:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_EFI;
                            ~ ^~~~~~~~
kernel/reboot.c:717:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_CF9_FORCE;
                            ~ ^~~~~~~~~~~~~~
kernel/reboot.c:719:17: warning: implicit conversion from enumeration
type 'enum reboot_type' to different enumeration type 'enum reboot_mode'
[-Wenum-conversion]
                reboot_mode = BOOT_CF9_SAFE;
                            ~ ^~~~~~~~~~~~~
7 warnings generated.

It seems that these assignment should be to reboot_type, not
reboot_mode. Fix it so there are no more warnings and the code works
properly.

Link: https://lkml.kernel.org/r/20201112035023.974748-1-natechancellor@gmail.com
Fixes: eab8da48579d ("reboot: allow to specify reboot mode via sysfs")
Link: https://github.com/ClangBuiltLinux/linux/issues/1197
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Matteo Croce <mcroce@microsoft.com>
Tested-by: Matteo Croce <mcroce@microsoft.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/reboot.c~reboot-fix-variable-assignments-in-type_store
+++ a/kernel/reboot.c
@@ -704,19 +704,19 @@ static ssize_t type_store(struct kobject
 		return -EPERM;
 
 	if (!strncmp(buf, BOOT_TRIPLE_STR, strlen(BOOT_TRIPLE_STR)))
-		reboot_mode = BOOT_TRIPLE;
+		reboot_type = BOOT_TRIPLE;
 	else if (!strncmp(buf, BOOT_KBD_STR, strlen(BOOT_KBD_STR)))
-		reboot_mode = BOOT_KBD;
+		reboot_type = BOOT_KBD;
 	else if (!strncmp(buf, BOOT_BIOS_STR, strlen(BOOT_BIOS_STR)))
-		reboot_mode = BOOT_BIOS;
+		reboot_type = BOOT_BIOS;
 	else if (!strncmp(buf, BOOT_ACPI_STR, strlen(BOOT_ACPI_STR)))
-		reboot_mode = BOOT_ACPI;
+		reboot_type = BOOT_ACPI;
 	else if (!strncmp(buf, BOOT_EFI_STR, strlen(BOOT_EFI_STR)))
-		reboot_mode = BOOT_EFI;
+		reboot_type = BOOT_EFI;
 	else if (!strncmp(buf, BOOT_CF9_FORCE_STR, strlen(BOOT_CF9_FORCE_STR)))
-		reboot_mode = BOOT_CF9_FORCE;
+		reboot_type = BOOT_CF9_FORCE;
 	else if (!strncmp(buf, BOOT_CF9_SAFE_STR, strlen(BOOT_CF9_SAFE_STR)))
-		reboot_mode = BOOT_CF9_SAFE;
+		reboot_type = BOOT_CF9_SAFE;
 	else
 		return -EINVAL;
 
_

Patches currently in -mm which might be from natechancellor@gmail.com are

reboot-allow-to-specify-reboot-mode-via-sysfs.patch

