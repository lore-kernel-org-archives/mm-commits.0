From: akpm@linux-foundation.org
Subject: - dont-compile-the-pmu-power-driver-on-64-bit-powerpc.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:35 -0700
Message-ID: <200707242325.l6ONPZu3006376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757663AbXGXXga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulus@samba.org, cbou@mail.ru, dwmw2@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Don't compile the PMU power driver on 64-bit PowerPC
has been removed from the -mm tree.  Its filename was
     dont-compile-the-pmu-power-driver-on-64-bit-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Don't compile the PMU power driver on 64-bit PowerPC
From: Paul Mackerras <paulus@samba.org>

As reported by Stephen Rothwell, an allmodconfig build on 64-bit
PowerPC reports these errors:

ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!

This fixes the problem by not building pmu_battery.ko on ppc64.  There
are no battery-powered ppc64 machines with an Apple PMU, and we can be
reasonably confident there never will be.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/Kconfig~dont-compile-the-pmu-power-driver-on-64-bit-powerpc drivers/power/Kconfig
--- a/drivers/power/Kconfig~dont-compile-the-pmu-power-driver-on-64-bit-powerpc
+++ a/drivers/power/Kconfig
@@ -38,7 +38,7 @@ config BATTERY_DS2760
 
 config BATTERY_PMU
 	tristate "Apple PMU battery"
-	depends on ADB_PMU
+	depends on PPC32 && ADB_PMU
 	help
 	  Say Y here to expose battery information on Apple machines
 	  through the generic battery class.
_

Patches currently in -mm which might be from paulus@samba.org are

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
git-battery.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
ppc64-sparsemem_vmemmap-support.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
