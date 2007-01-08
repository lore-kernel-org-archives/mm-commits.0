From: akpm@osdl.org
Subject: + i386-sched_clock-using-init-data-tsc_disable-fix.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:58:51 -0800
Message-ID: <200701082258.l08MwpXe021720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161045AbXAHW7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: sched_clock using init data tsc_disable fix
has been added to the -mm tree.  Its filename is
     i386-sched_clock-using-init-data-tsc_disable-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: sched_clock using init data tsc_disable fix
From: Vivek Goyal <vgoyal@in.ibm.com>

o sched_clock() a non-init function is using init data tsc_disable. This
  is flagged by MODPOST on i386 if CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.data:tsc_disable from .text between 'sched_clock' (at offset 0xc0109d58) and 'tsc_update_callback'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/tsc.c~i386-sched_clock-using-init-data-tsc_disable-fix arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~i386-sched_clock-using-init-data-tsc_disable-fix
+++ a/arch/i386/kernel/tsc.c
@@ -24,7 +24,7 @@
  */
 unsigned int tsc_khz;
 
-int tsc_disable __cpuinitdata = 0;
+int tsc_disable = 0;
 
 #ifdef CONFIG_X86_TSC
 static int __init tsc_setup(char *str)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
make-initkmem_list3-non-init-data-to-fix-modpost-warning.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
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
