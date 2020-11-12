Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5CFC2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC886216C4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UspWQ4ZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKLXNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXNt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:13:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDFD320B80;
        Thu, 12 Nov 2020 23:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605222828;
        bh=3DV9QE44w7xA+udpc1rVuOSZPrOxO7wcB3+pCMLEsuQ=;
        h=Date:From:To:Subject:From;
        b=UspWQ4ZUESipjb44cCixPAdNab5EJHGt+xBqQ/SMHvLPtnW0AEbTN2d3FX3RaZ8E1
         Ik2GR0T3yYV6MDc4PKezCLhTIwoR3qugMqpIYp7xS1RoHCQt6aE0/hMNYb113+kTrU
         WdG5r6DTB0f8Efi2iSnKZCvQBOfFafXa3IIVfAPc=
Date:   Thu, 12 Nov 2020 15:13:47 -0800
From:   akpm@linux-foundation.org
To:     mcroce@linux.microsoft.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com
Subject:  + reboot-fix-variable-assignments-in-type_store.patch
 added to -mm tree
Message-ID: <20201112231347.xf2qc85p7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: fix variable assignments in type_store
has been added to the -mm tree.  Its filename is
     reboot-fix-variable-assignments-in-type_store.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/reboot-fix-variable-assignments-in-type_store.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/reboot-fix-variable-assignments-in-type_store.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Matteo Croce <mcroce@linux.microsoft.com>
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

reboot-fix-variable-assignments-in-type_store.patch
treewide-remove-stringification-from-__alias-macro-definition-fix.patch

