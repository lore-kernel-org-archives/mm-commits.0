Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9EEC001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjHLWF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjHLWFY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C7F1733
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E27620CF
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0626BC433C9;
        Sat, 12 Aug 2023 22:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877926;
        bh=APp3DfTjAw5o0NPcSvrMLjq1aj1h3TMA/vw6eVAoNcg=;
        h=Date:To:From:Subject:From;
        b=IHNhOkZbUkMQpsLEsQu3RZ/lJ4sdNLuF63HvDSmFzUX+C3As5Sk2+KBXeh93gQJjp
         a9zlHqnrouLVZCP+zsOnPiGbw1stfXRzAxmydfCa+v8I0lJHgVXoGvHTWwVxK5ha19
         5YLiuO2l02105V1QA6qZpnoreAWkdqDBJ37DBvA0=
Date:   Sat, 12 Aug 2023 15:05:25 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm-kexec-refactor-for-kernel-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220526.0626BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm/kexec: refactor for kernel/Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     arm-kexec-refactor-for-kernel-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: arm/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:34 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-4-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

--- a/arch/arm/Kconfig~arm-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/arm/Kconfig
@@ -1645,20 +1645,8 @@ config XIP_DEFLATED_DATA
 	  copied, saving some precious ROM space. A possible drawback is a
 	  slightly longer boot delay.
 
-config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on (!SMP || PM_SLEEP_SMP)
-	depends on MMU
-	select KEXEC_CORE
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.
+config ARCH_SUPPORTS_KEXEC
+	def_bool (!SMP || PM_SLEEP_SMP) && MMU
 
 config ATAGS_PROC
 	bool "Export atags in procfs"
@@ -1668,17 +1656,8 @@ config ATAGS_PROC
 	  Should the atags used to boot the kernel be exported in an "atags"
 	  file in procfs. Useful with kexec.
 
-config CRASH_DUMP
-	bool "Build kdump crash kernel (EXPERIMENTAL)"
-	help
-	  Generate crash dump after being started by kexec. This should
-	  be normally only set in special crash dump kernels which are
-	  loaded in the main kernel with kexec-tools into a specially
-	  reserved region and then later executed after a crash by
-	  kdump/kexec. The crash dump kernel must be compiled to a
-	  memory address not used by the main kernel
-
-	  For more details see Documentation/admin-guide/kdump/kdump.rst
+config ARCH_SUPPORTS_CRASH_DUMP
+	def_bool y
 
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address" if !ARCH_MULTIPLATFORM
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

