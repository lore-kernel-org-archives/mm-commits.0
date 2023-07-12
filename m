Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5689EB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjGLTPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjGLTPe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8CD1FC0
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67713618C1
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC47C433C7;
        Wed, 12 Jul 2023 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189331;
        bh=kWfqm/ExAunBnYc7bC8647IezPv8pfrAlHgFGiSN+v4=;
        h=Date:To:From:Subject:From;
        b=rdG+oZFB5r/DVXXvvrvpnbKKnLRA5wDthmT9UVn1+HoBiMsNH5BspIgJh6djyCOAb
         OuUMyLFC7F6NC1koYOMGDwnRE7RexXM4C9UdVLVlGVR7RzlHuEo2HkPxMAHe14JUtq
         63Z2vhIqc4HgZdnovH6foF4RvtRTM+yTUPV+tAmY=
Date:   Wed, 12 Jul 2023 12:15:31 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-refactor-for-kernel-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230712191531.BFC47C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/kexec: refactor for kernel/Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-refactor-for-kernel-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-refactor-for-kernel-kconfigkexec.patch

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
Subject: x86/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:33 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-3-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |   98 ++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 76 deletions(-)

--- a/arch/x86/Kconfig~x86-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/x86/Kconfig
@@ -2040,88 +2040,34 @@ config EFI_RUNTIME_MAP
 
 source "kernel/Kconfig.hz"
 
-config KEXEC
-	bool "kexec system call"
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
-
-config KEXEC_FILE
-	bool "kexec file based system call"
-	select KEXEC_CORE
+config ARCH_SUPPORTS_KEXEC
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_FILE
+	def_bool X86_64 && CRYPTO && CRYPTO_SHA256
+
+config ARCH_SELECTS_KEXEC_FILE
+	def_bool y
+	depends on KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
-	depends on X86_64
-	depends on CRYPTO=y
-	depends on CRYPTO_SHA256=y
-	help
-	  This is new version of kexec system call. This system call is
-	  file based and takes file descriptors as system call argument
-	  for kernel and initramfs as opposed to list of segments as
-	  accepted by previous system call.
 
 config ARCH_HAS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
-config KEXEC_SIG
-	bool "Verify kernel signature during kexec_file_load() syscall"
-	depends on KEXEC_FILE
-	help
+config ARCH_SUPPORTS_KEXEC_SIG
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_SIG_FORCE
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_JUMP
+	def_bool y
 
-	  This option makes the kexec_file_load() syscall check for a valid
-	  signature of the kernel image.  The image can still be loaded without
-	  a valid signature unless you also enable KEXEC_SIG_FORCE, though if
-	  there's a signature that we can check, then it must be valid.
-
-	  In addition to this option, you need to enable signature
-	  verification for the corresponding kernel image type being
-	  loaded in order for this to work.
-
-config KEXEC_SIG_FORCE
-	bool "Require a valid signature in kexec_file_load() syscall"
-	depends on KEXEC_SIG
-	help
-	  This option makes kernel signature verification mandatory for
-	  the kexec_file_load() syscall.
-
-config KEXEC_BZIMAGE_VERIFY_SIG
-	bool "Enable bzImage signature verification support"
-	depends on KEXEC_SIG
-	depends on SIGNED_PE_FILE_VERIFICATION
-	select SYSTEM_TRUSTED_KEYRING
-	help
-	  Enable bzImage signature verification support.
-
-config CRASH_DUMP
-	bool "kernel crash dumps"
-	depends on X86_64 || (X86_32 && HIGHMEM)
-	help
-	  Generate crash dump after being started by kexec.
-	  This should be normally only set in special crash dump kernels
-	  which are loaded in the main kernel with kexec-tools into
-	  a specially reserved region and then later executed after
-	  a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START, or it must be built as a relocatable image
-	  (CONFIG_RELOCATABLE=y).
-	  For more details see Documentation/admin-guide/kdump/kdump.rst
-
-config KEXEC_JUMP
-	bool "kexec jump"
-	depends on KEXEC && HIBERNATION
-	help
-	  Jump between original kernel and kexeced kernel and invoke
-	  code in physical address mode via KEXEC
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool X86_64 || (X86_32 && HIGHMEM)
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
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

