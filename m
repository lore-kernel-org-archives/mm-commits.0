From: akpm@linux-foundation.org
Subject: + powerpc-rtas-msi-support-fix.patch added to -mm tree
Date: Tue, 13 Feb 2007 21:50:28 -0800
Message-ID: <200702140550.l1E5oSxH022726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42474 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXBNFue (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 00:50:34 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1E5oShB019682
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 13 Feb 2007 21:50:29 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     powerpc-rtas-msi-support-fix
has been added to the -mm tree.  Its filename is
     powerpc-rtas-msi-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc-rtas-msi-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support-fix arch/powerpc/platforms/pseries/setup.c
--- a/arch/powerpc/platforms/pseries/setup.c~powerpc-rtas-msi-support-fix
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -64,6 +64,7 @@
 #include <asm/i8259.h>
 #include <asm/udbg.h>
 #include <asm/smp.h>
+#include <asm/msi.h>
 #include <asm/firmware.h>
 
 #include "plpar_wrappers.h"
@@ -237,6 +238,7 @@ static void __init pseries_discover_pic(
 			ppc_md.init_IRQ       = xics_init_IRQ;
 			setup_kexec_cpu_down_xics();
 			smp_init_pseries_xics();
+			msi_rtas_init();
 			return;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
spi-atmel_spi-driver-fix.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
