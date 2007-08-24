From: akpm@linux-foundation.org
Subject: - kernel-auditscc-fix-an-off-by-one.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:16 -0700
Message-ID: <200708242055.l7OKtGSU013948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbXHXUza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, amy.griffis@hp.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     kernel/auditsc.c: fix an off-by-one
has been removed from the -mm tree.  Its filename was
     kernel-auditscc-fix-an-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/auditsc.c: fix an off-by-one
From: Adrian Bunk <bunk@stusta.de>

This patch fixes an off-by-one in a BUG_ON() spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Amy Griffis <amy.griffis@hp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditsc.c~kernel-auditscc-fix-an-off-by-one kernel/auditsc.c
--- a/kernel/auditsc.c~kernel-auditscc-fix-an-off-by-one
+++ a/kernel/auditsc.c
@@ -2023,7 +2023,7 @@ int __audit_signal_info(int sig, struct 
 		axp->d.next = ctx->aux_pids;
 		ctx->aux_pids = (void *)axp;
 	}
-	BUG_ON(axp->pid_count > AUDIT_AUX_PIDS);
+	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
git-dma.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-netdev-all.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
