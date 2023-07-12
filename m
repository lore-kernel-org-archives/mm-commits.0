Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70C3EB64DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjGLTP5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbjGLTPu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA012F
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB5BC618C1
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1287CC433C8;
        Wed, 12 Jul 2023 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189348;
        bh=sQvT4L3LQTY6Y7rcxB4PYkWSqUqHSivGijBY8ptbZGA=;
        h=Date:To:From:Subject:From;
        b=R1p9r9xLJBjoEw009RDqrnc/EuFj515Kg2YzWi3iYgevBAj3Fy2VCHBdgGQaWh98j
         Uf9JZCo8IWGXYEAloL9aWlxuXTC/KihW94/O9I9d4CU3mBd7RTj44tc97IbnoOJBoO
         fnZn8kJLLrH+1DoDXg9jzjsb61dRET5Gb6rgL+dY=
Date:   Wed, 12 Jul 2023 12:15:47 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-kexec-refactor-for-kernel-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230712191548.1287CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips/kexec: refactor for kernel/Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-kexec-refactor-for-kernel-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-kexec-refactor-for-kernel-kconfigkexec.patch

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
Subject: mips/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:39 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-9-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

--- a/arch/mips/Kconfig~mips-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/mips/Kconfig
@@ -2878,33 +2878,11 @@ config HZ
 config SCHED_HRTICK
 	def_bool HIGH_RES_TIMERS
 
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
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.  As of this writing the exact hardware
-	  interface is strongly in flux, so no good recommendation can be
-	  made.
-
-config CRASH_DUMP
-	bool "Kernel crash dumps"
-	help
-	  Generate crash dump after being started by kexec.
-	  This should be normally only set in special crash dump kernels
-	  which are loaded in the main kernel with kexec-tools into
-	  a specially reserved region and then later executed after
-	  a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or firmware using
-	  PHYSICAL_START.
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded"
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
kexec-rename-arch_has_kexec_purgatory.patch

