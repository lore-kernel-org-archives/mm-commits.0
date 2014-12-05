From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 05 Dec 2014 12:56:09 -0800
Message-ID: <54821be9.Di3v9MG5bE9ZZDvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLEU4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Dec 2014 15:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_drm.c |  124 ------------------------
 drivers/gpu/drm/radeon/radeon_cs.c    |    6 -
 2 files changed, 130 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_drm.c~linux-next-git-rejects drivers/gpu/drm/nouveau/nouveau_drm.c
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -613,29 +613,6 @@ fail_display:
 	return ret;
 }
 
-<<<<<<< HEAD
-int nouveau_pmops_suspend(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int ret;
-
-	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
-	    drm_dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
-		return 0;
-
-	ret = nouveau_do_suspend(drm_dev, false);
-	if (ret)
-		return ret;
-
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int
 nouveau_do_resume(struct drm_device *dev, bool runtime)
 {
@@ -1034,107 +1011,6 @@ nouveau_drm_pci_table[] = {
 	{}
 };
 
-<<<<<<< HEAD
-static int nouveau_pmops_runtime_suspend(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int ret;
-
-	if (nouveau_runtime_pm == 0) {
-		pm_runtime_forbid(dev);
-		return -EBUSY;
-	}
-
-	/* are we optimus enabled? */
-	if (nouveau_runtime_pm == -1 && !nouveau_is_optimus() && !nouveau_is_v1_dsm()) {
-		DRM_DEBUG_DRIVER("failing to power off - not optimus\n");
-		pm_runtime_forbid(dev);
-		return -EBUSY;
-	}
-
-	nv_debug_level(SILENT);
-	drm_kms_helper_poll_disable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
-	nouveau_switcheroo_optimus_dsm();
-	ret = nouveau_do_suspend(drm_dev, true);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_ignore_hotplug(pdev);
-	pci_set_power_state(pdev, PCI_D3cold);
-	drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
-	return ret;
-}
-
-static int nouveau_pmops_runtime_resume(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	struct nvif_device *device = &nouveau_drm(drm_dev)->device;
-	int ret;
-
-	if (nouveau_runtime_pm == 0)
-		return -EINVAL;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	ret = pci_enable_device(pdev);
-	if (ret)
-		return ret;
-	pci_set_master(pdev);
-
-	ret = nouveau_do_resume(drm_dev, true);
-	drm_kms_helper_poll_enable(drm_dev);
-	/* do magic */
-	nvif_mask(device, 0x88488, (1 << 25), (1 << 25));
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_ON);
-	drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
-	nv_debug_level(NORMAL);
-	return ret;
-}
-
-static int nouveau_pmops_runtime_idle(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	struct nouveau_drm *drm = nouveau_drm(drm_dev);
-	struct drm_crtc *crtc;
-
-	if (nouveau_runtime_pm == 0) {
-		pm_runtime_forbid(dev);
-		return -EBUSY;
-	}
-
-	/* are we optimus enabled? */
-	if (nouveau_runtime_pm == -1 && !nouveau_is_optimus() && !nouveau_is_v1_dsm()) {
-		DRM_DEBUG_DRIVER("failing to power off - not optimus\n");
-		pm_runtime_forbid(dev);
-		return -EBUSY;
-	}
-
-	/* if we have a hdmi audio device - make sure it has a driver loaded */
-	if (drm->hdmi_device) {
-		if (!drm->hdmi_device->driver) {
-			DRM_DEBUG_DRIVER("failing to power off - no HDMI audio driver loaded\n");
-			pm_runtime_mark_last_busy(dev);
-			return -EBUSY;
-		}
-	}
-
-	list_for_each_entry(crtc, &drm->dev->mode_config.crtc_list, head) {
-		if (crtc->enabled) {
-			DRM_DEBUG_DRIVER("failing to power off - crtc active\n");
-			return -EBUSY;
-		}
-	}
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_autosuspend(dev);
-	/* we don't want the main rpm_idle to call suspend - we want to autosuspend */
-	return 1;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void nouveau_display_options(void)
 {
 	DRM_DEBUG_DRIVER("Loading Nouveau with parameters:\n");
diff -puN drivers/gpu/drm/radeon/radeon_cs.c~linux-next-git-rejects drivers/gpu/drm/radeon/radeon_cs.c
--- a/drivers/gpu/drm/radeon/radeon_cs.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/radeon_cs.c
@@ -257,11 +257,6 @@ static int radeon_cs_sync_rings(struct r
 	list_for_each_entry(reloc, &p->validated, tv.head) {
 		struct reservation_object *resv;
 
-<<<<<<< HEAD
-		resv = reloc->robj->tbo.resv;
-		r = radeon_semaphore_sync_resv(p->rdev, p->ib.semaphore, resv,
-					       reloc->tv.shared);
-=======
 		if (!p->relocs[i].robj)
 			continue;
 
@@ -269,7 +264,6 @@ static int radeon_cs_sync_rings(struct r
 		r = radeon_sync_resv(p->rdev, &p->ib.sync, resv,
 				     p->relocs[i].tv.shared);
 
->>>>>>> linux-next/akpm-base
 		if (r)
 			return r;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
include-linux-kmemleakh-needs-slabh.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

