From: akpm@linux-foundation.org
Subject: - x86_powernow_k8_acpi-must-depend-on-acpi.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:45 -0700
Message-ID: <200707290611.l6T6Bjrj011004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410AbXG2GND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adobriyan@sw.ru, akpm@linux-foundation.org, davej@redhat.com, jhoblitt@ifa.hawaii.edu, lenb@kernel.org, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     X86_POWERNOW_K8_ACPI must depend on ACPI
has been removed from the -mm tree.  Its filename was
     x86_powernow_k8_acpi-must-depend-on-acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: X86_POWERNOW_K8_ACPI must depend on ACPI
From: Adrian Bunk <bunk@stusta.de>

This patch fixes the following compile error introduced by
commit e8666b2718fdb5bf0ea7c3126f7e292bbbf2946b and reported
by Alexey Dobriyan:

<--  snip  -->

   CC      arch/i386/kernel/acpi/cstate.o
In file included from arch/i386/kernel/acpi/cstate.c:17:
include/acpi/processor.h:88: error: expected specifier-qualifier-list before 'acpi_integer'

<--  snip  -->

If you select something you must ensure that the dependencies of what
you are selecting are fulfilled.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Cc: Dave Jones <davej@redhat.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/cpufreq/Kconfig~x86_powernow_k8_acpi-must-depend-on-acpi arch/i386/kernel/cpu/cpufreq/Kconfig
--- a/arch/i386/kernel/cpu/cpufreq/Kconfig~x86_powernow_k8_acpi-must-depend-on-acpi
+++ a/arch/i386/kernel/cpu/cpufreq/Kconfig
@@ -92,7 +92,7 @@ config X86_POWERNOW_K8
 config X86_POWERNOW_K8_ACPI
 	bool "ACPI Support"
 	select ACPI_PROCESSOR
-	depends on X86_POWERNOW_K8
+	depends on ACPI && X86_POWERNOW_K8
 	default y
 	help
 	  This provides access to the K8s Processor Performance States via ACPI.
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
