From: akpm@linux-foundation.org
Subject: - mm-vmstatc-cleanups.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:12 -0700
Message-ID: <200710162036.l9GKaClC015128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933653AbXJPVe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm/vmstat.c: cleanups
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/vmstat.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make the needlessly global setup_vmstat() static
- remove the unused refresh_vm_stats()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-cleanups mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-cleanups
+++ a/mm/vmstat.c
@@ -353,23 +353,6 @@ void refresh_cpu_vm_stats(int cpu)
 	}
 }
 
-static void __refresh_cpu_vm_stats(void *dummy)
-{
-	refresh_cpu_vm_stats(smp_processor_id());
-}
-
-/*
- * Consolidate all counters.
- *
- * Note that the result is less inaccurate but still inaccurate
- * if concurrent processes are allowed to run.
- */
-void refresh_vm_stats(void)
-{
-	on_each_cpu(__refresh_cpu_vm_stats, NULL, 0, 1);
-}
-EXPORT_SYMBOL(refresh_vm_stats);
-
 #endif
 
 #ifdef CONFIG_NUMA
@@ -865,7 +848,7 @@ static int __cpuinit vmstat_cpuup_callba
 static struct notifier_block __cpuinitdata vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
 
-int __init setup_vmstat(void)
+static int __init setup_vmstat(void)
 {
 	int cpu;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
