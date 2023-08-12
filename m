Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5826C04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjHLWFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjHLWFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7760319A3
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1646360F60
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0D2C433C7;
        Sat, 12 Aug 2023 22:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877936;
        bh=cXlZHTi0VUcJVJLDr7RzomWSefhjxHFv0ezQGVtG6XQ=;
        h=Date:To:From:Subject:From;
        b=gnPxwzw+x2TPTkGhlO+uJ8Jbu++o2k9inpU2LKmKyCVX5hjZWj8I4CbZGvYHYEK5U
         8H0FD02zSot346J4exjcaXFlrqCzCi6Gvnrp+W+Cn//epSJiq5S+xamXkShOmtvHPp
         8OaeLrX9zFve0XNq4EN+q4PVkNL0TE1pFoiRfva0=
Date:   Sat, 12 Aug 2023 15:05:35 -0700
To:     mm-commits@vger.kernel.org, agordeev@linux.ibm.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-kexec-refactor-for-kernel-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220536.6B0D2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390/kexec: refactor for kernel/Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     s390-kexec-refactor-for-kernel-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: s390/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:43 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-13-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |   69 ++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 46 deletions(-)

--- a/arch/s390/Kconfig~s390-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/s390/Kconfig
@@ -213,6 +213,7 @@ config S390
 	select HAVE_VIRT_CPU_ACCOUNTING_IDLE
 	select IOMMU_HELPER		if PCI
 	select IOMMU_SUPPORT		if PCI
+	select KEXEC
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_GATHER
 	select MMU_GATHER_RCU_TABLE_FREE
@@ -244,6 +245,28 @@ config PGTABLE_LEVELS
 
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
+	def_bool MODULE_SIG_FORMAT
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
@@ -482,36 +505,6 @@ config SCHED_TOPOLOGY
 
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
@@ -733,22 +726,6 @@ config VFIO_AP
 
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

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

