From: akpm@osdl.org
Subject: - visws-sgivwfb-is-module-needs-exports.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:18 -0800
Message-ID: <200612082014.kB8KEIIl003157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946876AbWLHUOz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     visws: sgivwfb as module needs exports
has been removed from the -mm tree.  Its filename was
     visws-sgivwfb-is-module-needs-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: visws: sgivwfb as module needs exports
From: Randy Dunlap <randy.dunlap@oracle.com>

With CONFIG_FB_SGIVW=m:
WARNING: "sgivwfb_mem_size" [drivers/video/sgivwfb.ko] undefined!
WARNING: "sgivwfb_mem_phys" [drivers/video/sgivwfb.ko] undefined!

(or don't allow FB_SGIVW=m in Kconfig)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mach-visws/setup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/i386/mach-visws/setup.c~visws-sgivwfb-is-module-needs-exports arch/i386/mach-visws/setup.c
--- a/arch/i386/mach-visws/setup.c~visws-sgivwfb-is-module-needs-exports
+++ a/arch/i386/mach-visws/setup.c
@@ -6,6 +6,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 #include <asm/fixmap.h>
 #include <asm/arch_hooks.h>
@@ -142,6 +143,8 @@ void __init time_init_hook(void)
 
 unsigned long sgivwfb_mem_phys;
 unsigned long sgivwfb_mem_size;
+EXPORT_SYMBOL(sgivwfb_mem_phys);
+EXPORT_SYMBOL(sgivwfb_mem_size);
 
 long long mem_size __initdata = 0;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

