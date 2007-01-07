From: akpm@osdl.org
Subject: - i386-fix-another-modpost-warning.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:44 -0800
Message-ID: <200701070758.l077wipH012975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbXAGH6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     i386: fix another modpost warning
has been removed from the -mm tree.  Its filename was
     i386-fix-another-modpost-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix another modpost warning
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warning for i386 if kernel is compiled with
  CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.data: from .data between 'this_cpu' (at offset 0xc05194d0) and 'cpuinfo_op'

o this_cpu pointer should be of type __cpuinitdata.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/common.c~i386-fix-another-modpost-warning arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-fix-another-modpost-warning
+++ a/arch/i386/kernel/cpu/common.c
@@ -54,7 +54,7 @@ static struct cpu_dev __cpuinitdata defa
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
 };
-static struct cpu_dev * this_cpu = &default_cpu;
+static struct cpu_dev * this_cpu __cpuinitdata = &default_cpu;
 
 static int __init cachesize_setup(char *str)
 {
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

scsi-megaraid_mmmbox-init-fix-for-kdump.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch
