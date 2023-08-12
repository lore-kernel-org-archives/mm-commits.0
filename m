Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1574EC04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjHLWFw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjHLWFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7E9199A
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E005260BFC
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DEAC433C8;
        Sat, 12 Aug 2023 22:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877935;
        bh=089MpoVSCzvs4HwG/MZe3aeHec3lvjDsQ/a6Y8ysVhY=;
        h=Date:To:From:Subject:From;
        b=tn/1NWmqURmZhYBk9bUiihhR5wjQatHEpMwDHbC0cNysJN6rCsx9Lu7MgDBcjysyp
         X0GVEQ0uow/1pABT9YEYIaJTgBBMvXr9oVBOTDdvcchVSh7UHEoplhtevL0S7p6RCa
         R+/537BsD8rs+taaqQYOs03LE6iQCis4MirQd6rw=
Date:   Sat, 12 Aug 2023 15:05:34 -0700
To:     mm-commits@vger.kernel.org, palmer@rivosinc.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-kexec-refactor-for-kernel-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220535.40DEAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv/kexec: refactor for kernel/Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     riscv-kexec-refactor-for-kernel-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: riscv/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:42 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-12-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |   48 +++++++++++++------------------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

--- a/arch/riscv/Kconfig~riscv-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/riscv/Kconfig
@@ -650,48 +650,30 @@ config RISCV_BOOT_SPINWAIT
 
 	  If unsure what to do here, say N.
 
-config KEXEC
-	bool "Kexec system call"
-	depends on MMU
+config ARCH_SUPPORTS_KEXEC
+	def_bool MMU
+
+config ARCH_SELECTS_KEXEC
+	def_bool y
+	depends on KEXEC
 	select HOTPLUG_CPU if SMP
-	select KEXEC_CORE
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel. It is like a reboot
-	  but it is independent of the system firmware. And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  The name comes from the similarity to the exec system call.
-
-config KEXEC_FILE
-	bool "kexec file based systmem call"
-	depends on 64BIT && MMU
+
+config ARCH_SUPPORTS_KEXEC_FILE
+	def_bool 64BIT && MMU
+
+config ARCH_SELECTS_KEXEC_FILE
+	def_bool y
+	depends on KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
-	select KEXEC_CORE
 	select KEXEC_ELF
-	help
-	  This is new version of kexec system call. This system call is
-	  file based and takes file descriptors as system call argument
-	  for kernel and initramfs as opposed to list of segments as
-	  accepted by previous system call.
-
-	  If you don't know what to do here, say Y.
 
 config ARCH_HAS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 	depends on CRYPTO=y
 	depends on CRYPTO_SHA256=y
 
-config CRASH_DUMP
-	bool "Build kdump crash kernel"
-	help
-	  Generate crash dump after being started by kexec. This should
-	  be normally only set in special crash dump kernels which are
-	  loaded in the main kernel with kexec-tools into a specially
-	  reserved region and then later executed after a crash by
-	  kdump/kexec.
-
-	  For more details see Documentation/admin-guide/kdump/kdump.rst
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
 
 config COMPAT
 	bool "Kernel support for 32-bit U-mode"
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

