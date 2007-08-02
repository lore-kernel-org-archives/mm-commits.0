From: akpm@linux-foundation.org
Subject: - mm-migratec-cleanups.patch removed from -mm tree
Date: Thu, 02 Aug 2007 11:21:47 -0700
Message-ID: <200708021821.l72ILmEZ002900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055AbXHBSWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 14:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm/migrate.c: cleanups
has been removed from the -mm tree.  Its filename was
     mm-migratec-cleanups.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: mm/migrate.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- every file should include the headers containing the prototypes for
  its global functions
- make the needlessly global putback_lru_pages() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 --
 mm/migrate.c            |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/migrate.h~mm-migratec-cleanups include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migratec-cleanups
+++ a/include/linux/migrate.h
@@ -26,7 +26,6 @@ static inline int vma_migratable(struct 
 }
 
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
-extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x, unsigned long);
@@ -44,7 +43,6 @@ static inline int vma_migratable(struct 
 
 static inline int isolate_lru_page(struct page *p, struct list_head *list)
 					{ return -ENOSYS; }
-static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
 
diff -puN mm/migrate.c~mm-migratec-cleanups mm/migrate.c
--- a/mm/migrate.c~mm-migratec-cleanups
+++ a/mm/migrate.c
@@ -28,6 +28,7 @@
 #include <linux/mempolicy.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 
 #include "internal.h"
 
@@ -100,7 +101,7 @@ static inline void move_to_lru(struct pa
  *
  * returns the number of pages put back.
  */
-int putback_lru_pages(struct list_head *l)
+static int putback_lru_pages(struct list_head *l)
 {
 	struct page *page;
 	struct page *page2;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
kernel-auditscc-fix-an-off-by-one.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
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
