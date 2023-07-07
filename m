Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBD4C001DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 20:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjGGUMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjGGUMC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 16:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD5F1FEB
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 13:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC95361A6A
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 20:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E3C433C8;
        Fri,  7 Jul 2023 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688760720;
        bh=U9ddmE5d152L7a5lldftBlwoLPUIm8ryUoemAV/Bzxk=;
        h=Date:To:From:Subject:From;
        b=CUv2jWO+FnvExU0hrcEeEDGS7xOSwaD/uY3vy3oLYStyBS/vBYQcI5VpYc9LpiBMh
         XeL/Yz6jxUPXGZf+UzxHOTAwiFMyV0rayJiBAeMO86Lz+XypJbNfU1kP7F+zhU/8S/
         idLQEdpIo8Z7t30JLx6SHV7Q2nPeKqPlxN/JCDdY=
Date:   Fri, 07 Jul 2023 13:11:59 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sourabhjain@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        geert@linux-m68k.org, agordeev@linux.ibm.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-kexec-refactor-for-kernel-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230707201200.4D0E3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch/kexec: refactor for kernel/Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     loongarch-kexec-refactor-for-kernel-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-kexec-refactor-for-kernel-kconfigkexec.patch

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
Subject: loongarch/kexec: refactor for kernel/Kconfig.kexec
Date: Thu, 6 Jul 2023 18:20:20 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec.  Utilize the common options and provide the
ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the equivalent set of
KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230706222027.189117-7-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- a/arch/loongarch/Kconfig~loongarch-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/loongarch/Kconfig
@@ -537,28 +537,16 @@ config CPU_HAS_PREFETCH
 	bool
 	default y
 
-config KEXEC
-	bool "Kexec system call"
-	select KEXEC_CORE
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
+config ARCH_SUPPORTS_KEXEC
+	def_bool y
 
-	  The name comes from the similarity to the exec system call.
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
 
-config CRASH_DUMP
-	bool "Build kdump crash kernel"
+config ARCH_SELECTS_CRASH_DUMP
+	def_bool y
+	depends on CRASH_DUMP
 	select RELOCATABLE
-	help
-	  Generate crash dump after being started by kexec. This should
-	  be normally only set in special crash dump kernels which are
-	  loaded in the main kernel with kexec-tools into a specially
-	  reserved region and then later executed after a crash by
-	  kdump/kexec.
-
-	  For more details see Documentation/admin-guide/kdump/kdump.rst
 
 config RELOCATABLE
 	bool "Relocatable kernel"
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

