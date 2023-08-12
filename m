Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807EBC0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjHLWFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjHLWFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFD61997
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F1260F60
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA13CC433C8;
        Sat, 12 Aug 2023 22:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877932;
        bh=KIdADqc9telkruB8yoV/GPzvQ315zihvkBdp8GZ55jg=;
        h=Date:To:From:Subject:From;
        b=MXs5a19yMknZBG2ydX+LwpeGJn7eP8FF7QHojU3VgO9ul33g3t6n0UeI73TclJVkL
         XlL13YJQeFfe65yfbPQDpQZR2MIjkvKqOcNtJN2+S5bpciL3p4pYsEj1sadINKUY9J
         3F73rS+hYTMtIJewAQ0eppDuX7wX20c1MF8SMWOA=
Date:   Sat, 12 Aug 2023 15:05:32 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] parisc-kexec-refactor-for-kernel-kconfigkexec.patch removed from -mm tree
Message-Id: <20230812220532.DA13CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: parisc/kexec: refactor for kernel/Kconfig.kexec
has been removed from the -mm tree.  Its filename was
     parisc-kexec-refactor-for-kernel-kconfigkexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: parisc/kexec: refactor for kernel/Kconfig.kexec
Date: Wed, 12 Jul 2023 12:15:40 -0400

The kexec and crash kernel options are provided in the common
kernel/Kconfig.kexec. Utilize the common options and provide
the ARCH_SUPPORTS_ and ARCH_SELECTS_ entries to recreate the
equivalent set of KEXEC and CRASH options.

Link: https://lkml.kernel.org/r/20230712161545.87870-10-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/arch/parisc/Kconfig~parisc-kexec-refactor-for-kernel-kconfigkexec
+++ a/arch/parisc/Kconfig
@@ -339,29 +339,17 @@ config NR_CPUS
 	default "8" if 64BIT
 	default "16"
 
-config KEXEC
-	bool "Kexec system call"
-	select KEXEC_CORE
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
+endmenu
 
-	  It is an ongoing process to be certain the hardware in a machine
-	  shutdown, so do not be surprised if this code does not
-	  initially work for you.
+config ARCH_SUPPORTS_KEXEC
+	def_bool y
 
-config KEXEC_FILE
-	bool "kexec file based system call"
-	select KEXEC_CORE
-	select KEXEC_ELF
-	help
-	  This enables the kexec_file_load() System call. This is
-	  file based and takes file descriptors as system call argument
-	  for kernel and initramfs as opposed to list of segments as
-	  accepted by previous system call.
+config ARCH_SUPPORTS_KEXEC_FILE
+	def_bool y
 
-endmenu
+config ARCH_SELECTS_KEXEC_FILE
+	def_bool y
+	depends on KEXEC_FILE
+	select KEXEC_ELF
 
 source "drivers/parisc/Kconfig"
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

