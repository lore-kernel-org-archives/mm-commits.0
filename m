Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D2FC0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjHLWFq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjHLWF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAA29F
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8CC161169
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C2BC433C8;
        Sat, 12 Aug 2023 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877928;
        bh=OD6R+aYfo//0wAQQW0IUuqKYNn6VLbiNXCvlOhLSJZA=;
        h=Date:To:From:Subject:From;
        b=vXB7+P6cL/QpUOX1NX4Ntsn78kYNtm9pz790XCknUCZG6ftsj3mKcs2vmz2Bf+EJ4
         DdHpB8x3ddHsLepymqkQPWkr1Di8duIBETLZutKDRFld35K1oH1RGZD1OemKLVwa06
         niuCRb+PfM6dcr9Jv2VkLqlOwbPlYMC5BjVlcsak=
Date:   Sat, 12 Aug 2023 15:05:27 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-kexec-refactor-for-kernel-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220528.38C2BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64/kexec: refactor for kernel/Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     arm64-kexec-refactor-for-kernel-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: arm64/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:36 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-6-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |   70 +++++++++++--------------------------------
 1 file changed, 19 insertions(+), 51 deletions(-)

--- a/arch/arm64/Kconfig~arm64-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/arm64/Kconfig
@@ -1461,60 +1461,28 @@ config PARAVIRT_TIME_ACCOUNTING
 
 	  If in doubt, say N here.
 
-config KEXEC
-	depends on PM_SLEEP_SMP
-	select KEXEC_CORE
-	bool "kexec system call"
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-config KEXEC_FILE
-	bool "kexec file based system call"
-	select KEXEC_CORE
-	select HAVE_IMA_KEXEC if IMA
-	help
-	  This is new version of kexec system call. This system call is
-	  file based and takes file descriptors as system call argument
-	  for kernel and initramfs as opposed to list of segments as
-	  accepted by previous system call.
+config ARCH_SUPPORTS_KEXEC
+	def_bool PM_SLEEP_SMP
+
+config ARCH_SUPPORTS_KEXEC_FILE
+	def_bool y
 
-config KEXEC_SIG
-	bool "Verify kernel signature during kexec_file_load() syscall"
+config ARCH_SELECTS_KEXEC_FILE
+	def_bool y
 	depends on KEXEC_FILE
-	help
-	  Select this option to verify a signature with loaded kernel
-	  image. If configured, any attempt of loading a image without
-	  valid signature will fail.
-
-	  In addition to that option, you need to enable signature
-	  verification for the corresponding kernel image type being
-	  loaded in order for this to work.
-
-config KEXEC_IMAGE_VERIFY_SIG
-	bool "Enable Image signature verification support"
-	default y
-	depends on KEXEC_SIG
-	depends on EFI && SIGNED_PE_FILE_VERIFICATION
-	help
-	  Enable Image signature verification support.
-
-comment "Support for PE file signature verification disabled"
-	depends on KEXEC_SIG
-	depends on !EFI || !SIGNED_PE_FILE_VERIFICATION
-
-config CRASH_DUMP
-	bool "Build kdump crash kernel"
-	help
-	  Generate crash dump after being started by kexec. This should
-	  be normally only set in special crash dump kernels which are
-	  loaded in the main kernel with kexec-tools into a specially
-	  reserved region and then later executed after a crash by
-	  kdump/kexec.
+	select HAVE_IMA_KEXEC if IMA
+
+config ARCH_SUPPORTS_KEXEC_SIG
+	def_bool y
+
+config ARCH_SUPPORTS_KEXEC_IMAGE_VERIFY_SIG
+	def_bool y
 
-	  For more details see Documentation/admin-guide/kdump/kdump.rst
+config ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_SIG
+	def_bool y
+
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
 
 config TRANS_TABLE
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

