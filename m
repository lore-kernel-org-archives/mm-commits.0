Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7550C00528
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 20:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGGUMP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjGGUMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 16:12:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F251FF6
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 13:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4754D619EE
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 20:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9950AC433C8;
        Fri,  7 Jul 2023 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688760730;
        bh=nhD0KrrgPu+RykFCM6h3DJTF8XARjnHZhTM99GZpj0Y=;
        h=Date:To:From:Subject:From;
        b=XYAnZCxbfaKNP0HhjE9XCoo2b45hKFDqWFpaX2d9ZM3lYxDSiTzoGOZRUjwgf5XhY
         qAESrDOEAunP3y1WD8HzitH0nZN7TvQCdNeH9gXacRhOvhYHFlT3SB93O7LgNsx/RR
         skuookYItqiMsXQpUkMSB3e9BxqF/m5FZrDA5+rw=
Date:   Fri, 07 Jul 2023 13:12:10 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        sourabhjain@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        geert@linux-m68k.org, agordeev@linux.ibm.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-kexec-refactor-for-kernel-kconfigkexec.patch added to mm-nonmm-unstable branch
Message-Id: <20230707201210.9950AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/kexec: refactor for kernel/Kconfig.kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-kexec-refactor-for-kernel-kconfigkexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-kexec-refactor-for-kernel-kconfigkexec.patch

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
Subject: s390/kexec: refactor for kernel/Kconfig.kexec
Date: Thu, 6 Jul 2023 18:20:26 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec.  Utilize the common options and provide the
ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the equivalent set of
KEXEC and CRASH options.

NOTE: The original Kconfig has a KEXEC_SIG which depends on
MODULE_SIG_FORMAT.  However, attempts to keep the MODULE_SIG_FORMAT
dependency (using the strategy outlined in this series, and other
techniques) results in 'error: recursive dependency detected' on CRYPTO.

Per Alexander Gordeev <agordeev@linux.ibm.com>: "the MODULE_SIG_FORMAT
dependency was introduced with [git commit below] and in fact was not
necessary, since s390 did/does not use mod_check_sig() anyway.

 commit c8424e776b09 ("MODSIGN: Export module signature definitions")

MODULE_SIG_FORMAT is needed to select SYSTEM_DATA_VERIFICATION.  But
SYSTEM_DATA_VERIFICATION is also selected by FS_VERITY*, so dropping
MODULE_SIG_FORMAT does not hurt."

Therefore, the solution is to drop the MODULE_SIG_FORMAT dependency from
KEXEC_SIG.  Still results in equivalent .config files for s390.

Link: https://lkml.kernel.org/r/20230706222027.189117-13-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |   69 ++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 46 deletions(-)

--- a/arch/s390/Kconfig~s390-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/s390/Kconfig
@@ -214,6 +214,7 @@ config S390
 	select HAVE_VIRT_CPU_ACCOUNTING_IDLE
 	select IOMMU_HELPER		if PCI
 	select IOMMU_SUPPORT		if PCI
+	select KEXEC
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_GATHER
 	select MMU_GATHER_RCU_TABLE_FREE
@@ -245,6 +246,28 @@ config PGTABLE_LEVELS
 
 source "kernel/livepatch/Kconfig"
 
+config ARCH_DEFAULT_KEXEC
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_FILE
+	def_bool CRYPTO && CRYPTO_SHA256 && CRYPTO_SHA256_S390
+
+config ARCH_SUPPORTS_KEXEC_SIG
+	def_bool y
+
+config ARCH_HAS_KEXEC_PURGATORY
+	def_bool KEXEC_FILE
+
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
+	help
+	  Refer to <file:Documentation/s390/zfcpdump.rst> for more details on this.
+	  This option also enables s390 zfcpdump.
+	  See also <file:Documentation/s390/zfcpdump.rst>
+
 menu "Processor type and features"
 
 config HAVE_MARCH_Z10_FEATURES
@@ -483,36 +506,6 @@ config SCHED_TOPOLOGY
 
 source "kernel/Kconfig.hz"
 
-config KEXEC
-	def_bool y
-	select KEXEC_CORE
-
-config KEXEC_FILE
-	bool "kexec file based system call"
-	select KEXEC_CORE
-	depends on CRYPTO
-	depends on CRYPTO_SHA256
-	depends on CRYPTO_SHA256_S390
-	help
-	  Enable the kexec file based system call. In contrast to the normal
-	  kexec system call this system call takes file descriptors for the
-	  kernel and initramfs as arguments.
-
-config ARCH_HAS_KEXEC_PURGATORY
-	def_bool y
-	depends on KEXEC_FILE
-
-config KEXEC_SIG
-	bool "Verify kernel signature during kexec_file_load() syscall"
-	depends on KEXEC_FILE && MODULE_SIG_FORMAT
-	help
-	  This option makes kernel signature verification mandatory for
-	  the kexec_file_load() syscall.
-
-	  In addition to that option, you need to enable signature
-	  verification for the corresponding kernel image type being
-	  loaded in order for this to work.
-
 config KERNEL_NOBP
 	def_bool n
 	prompt "Enable modified branch prediction for the kernel by default"
@@ -734,22 +727,6 @@ config VFIO_AP
 
 endmenu
 
-menu "Dump support"
-
-config CRASH_DUMP
-	bool "kernel crash dumps"
-	select KEXEC
-	help
-	  Generate crash dump after being started by kexec.
-	  Crash dump kernels are loaded in the main kernel with kexec-tools
-	  into a specially reserved region and then later executed after
-	  a crash by kdump/kexec.
-	  Refer to <file:Documentation/s390/zfcpdump.rst> for more details on this.
-	  This option also enables s390 zfcpdump.
-	  See also <file:Documentation/s390/zfcpdump.rst>
-
-endmenu
-
 config CCW
 	def_bool y
 
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

