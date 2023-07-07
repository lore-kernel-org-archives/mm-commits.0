Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A0FEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 20:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjGGUMN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjGGUMD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 16:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0713AE7
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 13:12:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D6561A70
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 20:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED22C433C7;
        Fri,  7 Jul 2023 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688760722;
        bh=ToczJdVtbNEe7quFqBTHyLXeA+54pvQJVgIm2ZQteMc=;
        h=Date:To:From:Subject:From;
        b=Vd71fc0WtQpdu6eVRICGtxK8esSLL1PLvfZgqa0LA09vahRns9pDmz7XJd2IyxL2A
         M822hPuuEQCPxBmkL4pkGth/dAwyVkPxUVCBGrC0NbYpTafYrCytE4wTSMoCSfiB3G
         8mKlORXb1MpYz948OROe/9g20oKv1pcTaEuY+k1g=
Date:   Fri, 07 Jul 2023 13:12:01 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sourabhjain@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        geert@linux-m68k.org, agordeev@linux.ibm.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-kexec-refactor-for-kernel-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230707201201.EED22C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/kexec: refactor for kernel/Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     m68k-kexec-refactor-for-kernel-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-kexec-refactor-for-kernel-kconfigkexec.patch

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
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: m68k/kexec: refactor for kernel/Kconfig.kexec
Date: Thu, 6 Jul 2023 18:20:21 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec.  Utilize the common options and provide the
ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the equivalent set of
KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230706222027.189117-8-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/arch/m68k/Kconfig~m68k-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/m68k/Kconfig
@@ -89,23 +89,8 @@ config MMU_SUN3
 	bool
 	depends on MMU && !MMU_MOTOROLA && !MMU_COLDFIRE
 
-config KEXEC
-	bool "kexec system call"
-	depends on M68KCLASSIC && MMU
-	select KEXEC_CORE
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  The name comes from the similarity to the exec system call.
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.  As of this writing the exact hardware
-	  interface is strongly in flux, so no good recommendation can be
-	  made.
+config ARCH_SUPPORTS_KEXEC
+	def_bool M68KCLASSIC && MMU
 
 config BOOTINFO_PROC
 	bool "Export bootinfo in procfs"
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
x86-kexec-refactor-for-kernel-kconfigkexec.patch
arm-kexec-refactor-for-kernel-kconfigkexec.patch
ia64-kexec-refactor-for-kernel-kconfigkexec.patch
arm64-kexec-refactor-for-kernel-kconfigkexec.patch
loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
m68k-kexec-refactor-for-kernel-kconfigkexec.patch
mips-kexec-refactor-for-kernel-kconfigkexec.patch
parisc-kexec-refactor-for-kernel-kconfigkexec.patch
powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
riscv-kexec-refactor-for-kernel-kconfigkexec.patch
s390-kexec-refactor-for-kernel-kconfigkexec.patch
sh-kexec-refactor-for-kernel-kconfigkexec.patch

