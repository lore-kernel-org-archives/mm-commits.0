Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6379EC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 16:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjK3Q0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 11:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjK3Q0R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 11:26:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5579F198
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 08:26:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC04CC433C9;
        Thu, 30 Nov 2023 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701361583;
        bh=j006kdzFKYHevfbhCLbx5FKFwrzYaTZpyPgMi4CJtTo=;
        h=Date:To:From:Subject:From;
        b=v0kc1mZwOSlsbs3jjwzzEwovcE5Eg8RpCdApQRZb1wEOZP06Pt4y9KvGdGN05E34T
         rHePoTCBsD7pRLAkzMtm+sex/MJkpII15lYByisL52YLRqhEtO0x/pZ33NnQBzzINO
         0+8CImRA7YGeXwwYSmYZRrn6JW/fKeu7xk87Isx8=
Date:   Thu, 30 Nov 2023 08:26:22 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sfr@rothwell.id.au, davem@davemloft.net, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-turn-off-werror-for-architectures-with-known-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20231130162622.EC04CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: turn off -Werror for architectures with known warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-turn-off-werror-for-architectures-with-known-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-turn-off-werror-for-architectures-with-known-warnings.patch

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
From: "Arnd Bergmann" <arnd@arndb.de>
Subject: arch: turn off -Werror for architectures with known warnings
Date: Thu, 30 Nov 2023 09:07:38 +0100

A couple of architectures enable -Werror for their own files regardless of
CONFIG_WERROR but also have known warnings that fail the build with
-Wmissing-prototypes enabled by default:

arch/alpha/lib/memcpy.c:153:8: error: no previous prototype for 'memcpy' [-Werror=missing-prototypes]
arch/alpha/kernel/irq.c:96:1: error: no previous prototype for 'handle_irq' [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:673:17: error: no previous prototype for ‘sys_rt_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:636:17: error: no previous prototype for ‘sys_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/syscall.c:51:16: error: no previous prototype for ‘sysm_pipe’ [-Werror=missing-prototypes]
arch/mips/mm/fault.c:323:17: error: no previous prototype for ‘do_page_fault’ [-Werror=missing-prototypes]
arch/sparc/vdso/vma.c:246:12: warning: no previous prototype for ‘init_vdso_image’ [-Wmissing-prototypes]v
arch/sparc/vdso/vdso32/../vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/vdso/vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/prom/p1275.c:52:6: warning: no previous prototype for ‘prom_cif_init’ [-Wmissing-prototypes]
arch/sparc/prom/misc_64.c:165:5: warning: no previous prototype for ‘prom_get_mmu_ihandle’ [-Wmissing-prototypes]

This appears to be an artifact from the times when this architecture code
was better maintained that most device drivers and before CONFIG_WERROR
was added.  Now it just gets in the way, so remove all of these.

Powerpc and x86 both still have their own Kconfig options to enable
-Werror for some of their files.  These architectures are better
maintained than most and the options are easy to disable, so leave those
untouched.

Link: https://lkml.kernel.org/r/4be73872-c1f5-4c31-8201-712c19290a22@app.fastmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Stephen Rothwell <sfr@rothwell.id.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/Makefile    |    1 -
 arch/alpha/mm/Makefile     |    2 --
 arch/mips/Kbuild           |    6 ------
 arch/sparc/kernel/Makefile |    1 -
 arch/sparc/lib/Makefile    |    1 -
 arch/sparc/mm/Makefile     |    1 -
 arch/sparc/prom/Makefile   |    1 -
 7 files changed, 13 deletions(-)

--- a/arch/alpha/lib/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/alpha/lib/Makefile
@@ -4,7 +4,6 @@
 #
 
 asflags-y := $(KBUILD_CFLAGS)
-ccflags-y := -Werror
 
 # Many of these routines have implementations tuned for ev6.
 # Choose them iff we're targeting ev6 specifically.
--- a/arch/alpha/mm/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/alpha/mm/Makefile
@@ -3,6 +3,4 @@
 # Makefile for the linux alpha-specific parts of the memory manager.
 #
 
-ccflags-y := -Werror
-
 obj-y	:= init.o fault.o
--- a/arch/mips/Kbuild~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/mips/Kbuild
@@ -1,10 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# Fail on warnings - also for files referenced in subdirs
-# -Werror can be disabled for specific files using:
-# CFLAGS_<file.o> := -Wno-error
-ifeq ($(W),)
-subdir-ccflags-y := -Werror
-endif
 
 # platform specific definitions
 include $(srctree)/arch/mips/Kbuild.platforms
--- a/arch/sparc/kernel/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/sparc/kernel/Makefile
@@ -5,7 +5,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
--- a/arch/sparc/lib/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/sparc/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi -DST_DIV0=0x02
-ccflags-y := -Werror
 
 lib-$(CONFIG_SPARC32) += ashrdi3.o
 lib-$(CONFIG_SPARC32) += memcpy.o memset.o
--- a/arch/sparc/mm/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/sparc/mm/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 obj-$(CONFIG_SPARC64)   += ultra.o tlb.o tsb.o
 obj-y                   += fault_$(BITS).o
--- a/arch/sparc/prom/Makefile~arch-turn-off-werror-for-architectures-with-known-warnings
+++ a/arch/sparc/prom/Makefile
@@ -3,7 +3,6 @@
 # Linux.
 #
 asflags := -ansi
-ccflags := -Werror
 
 lib-y                 := bootstr_$(BITS).o
 lib-y                 += init_$(BITS).o
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch
arch-turn-off-werror-for-architectures-with-known-warnings.patch
ida-make-ida_dump-static.patch
jffs2-mark-__jffs2_dbg_superblock_counts-static.patch
sched-fair-move-unused-stub-functions-to-header.patch
x86-sta2x11-include-header-for-sta2x11_get_instance-prototype.patch
usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

