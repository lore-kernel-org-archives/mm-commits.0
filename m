Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B836C46CA0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442971AbjLGANu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442120AbjLGANn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26461A5
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:41 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2E2C433CA;
        Thu,  7 Dec 2023 00:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908021;
        bh=LVAtgjhmhAmi7+UfbmGFNWmYuL8ASIzMfJELePIHBbM=;
        h=Date:To:From:Subject:From;
        b=PJD6H7Np6EciD1MvDPQ+shwONdqE5kD0gbn/qatOUoKrZ0DI8i8fe620MeYrN+P/s
         o2oE8t8nbQsjMXP3f1hPH+q1TEM/vBWZK4nhrmIaF8TmiPTaawYf+/+dYpuxl7wt6C
         jvKmBlXUky3uTlHRJnJnt0eeM7hn2k+u1IPtd0SY=
Date:   Wed, 06 Dec 2023 16:13:40 -0800
To:     mm-commits@vger.kernel.org, ignat@cloudflare.com,
        eric_devolder@yahoo.com, agordeev@linux.ibm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch removed from -mm tree
Message-Id: <20231207001341.6E2E2C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/Kconfig.kexec: drop select of KEXEC for CRASH_DUMP
has been removed from the -mm tree.  Its filename was
     kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kernel/Kconfig.kexec: drop select of KEXEC for CRASH_DUMP
Date: Tue, 28 Nov 2023 13:44:57 +0800

Ignat Korchagin complained that a potential config regression was
introduced by commit 89cde455915f ("kexec: consolidate kexec and crash
options into kernel/Kconfig.kexec").  Before the commit, CONFIG_CRASH_DUMP
has no dependency on CONFIG_KEXEC.  After the commit, CRASH_DUMP selects
KEXEC.  That enforces system to have CONFIG_KEXEC=y as long as
CONFIG_CRASH_DUMP=Y which people may not want.

In Ignat's case, he sets CONFIG_CRASH_DUMP=y, CONFIG_KEXEC_FILE=y and
CONFIG_KEXEC=n because kexec_load interface could have security issue if
kernel/initrd has no chance to be signed and verified.

CRASH_DUMP has select of KEXEC because Eric, author of above commit, met a
LKP report of build failure when posting patch of earlier version.  Please
see below link to get detail of the LKP report:

    https://lore.kernel.org/all/3e8eecd1-a277-2cfb-690e-5de2eb7b988e@oracle.com/T/#u

In fact, that LKP report is triggered because arm's <asm/kexec.h> is
wrapped in CONFIG_KEXEC ifdeffery scope.  That is wrong.  CONFIG_KEXEC
controls the enabling/disabling of kexec_load interface, but not kexec
feature.  Removing the wrongly added CONFIG_KEXEC ifdeffery scope in
<asm/kexec.h> of arm allows us to drop the select KEXEC for CRASH_DUMP. 
Meanwhile, change arch/arm/kernel/Makefile to let machine_kexec.o
relocate_kernel.o depend on KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231128054457.659452-1-bhe@redhat.com
Fixes: 89cde455915f ("kexec: consolidate kexec and crash options into kernel/Kconfig.kexec")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Tested-by: Ignat Korchagin <ignat@cloudflare.com>	[compile-time only]
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kexec.h |    4 ----
 arch/arm/kernel/Makefile     |    2 +-
 kernel/Kconfig.kexec         |    1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

--- a/arch/arm/include/asm/kexec.h~kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump
+++ a/arch/arm/include/asm/kexec.h
@@ -2,8 +2,6 @@
 #ifndef _ARM_KEXEC_H
 #define _ARM_KEXEC_H
 
-#ifdef CONFIG_KEXEC
-
 /* Maximum physical address we can use pages from */
 #define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
 /* Maximum address we can reach in physical address mode */
@@ -82,6 +80,4 @@ static inline struct page *boot_pfn_to_p
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* CONFIG_KEXEC */
-
 #endif /* _ARM_KEXEC_H */
--- a/arch/arm/kernel/Makefile~kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump
+++ a/arch/arm/kernel/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_FUNCTION_TRACER)	+= entry-f
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o patch.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o patch.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 # Main staffs in KPROBES are in arch/arm/probes/ .
 obj-$(CONFIG_KPROBES)		+= patch.o insn.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
--- a/kernel/Kconfig.kexec~kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump
+++ a/kernel/Kconfig.kexec
@@ -97,7 +97,6 @@ config CRASH_DUMP
 	depends on ARCH_SUPPORTS_KEXEC
 	select CRASH_CORE
 	select KEXEC_CORE
-	select KEXEC
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
_

Patches currently in -mm which might be from bhe@redhat.com are

kexec_core-change-dependency-of-object-files.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch
riscv-fix-vmallc_start-definition.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

