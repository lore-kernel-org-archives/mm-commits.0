From: akpm@linux-foundation.org
Subject: + mm-shmemc-make-3-functions-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:28 -0700
Message-ID: <200707302247.l6UMlSW8002513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbXG3WsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, hugh@veritas.com


The patch titled
     mm/shmem.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     mm-shmemc-make-3-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/shmem.c: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 ---------------
 mm/shmem.c         |   10 +++++-----
 2 files changed, 5 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-shmemc-make-3-functions-static include/linux/mm.h
--- a/include/linux/mm.h~mm-shmemc-make-3-functions-static
+++ a/include/linux/mm.h
@@ -712,9 +712,6 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new);
-struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-					unsigned long addr);
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
 static inline int shmem_lock(struct file *file, int lock,
@@ -722,18 +719,6 @@ static inline int shmem_lock(struct file
 {
 	return 0;
 }
-
-static inline int shmem_set_policy(struct vm_area_struct *vma,
-				   struct mempolicy *new)
-{
-	return 0;
-}
-
-static inline struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-						 unsigned long addr)
-{
-	return NULL;
-}
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
 
diff -puN mm/shmem.c~mm-shmemc-make-3-functions-static mm/shmem.c
--- a/mm/shmem.c~mm-shmemc-make-3-functions-static
+++ a/mm/shmem.c
@@ -1024,8 +1024,8 @@ static struct page *shmem_swapin_async(s
 	return page;
 }
 
-struct page *shmem_swapin(struct shmem_inode_info *info, swp_entry_t entry,
-			  unsigned long idx)
+static struct page *shmem_swapin(struct shmem_inode_info *info,
+				 swp_entry_t entry, unsigned long idx)
 {
 	struct shared_policy *p = &info->policy;
 	int i, num;
@@ -1326,14 +1326,14 @@ static int shmem_fault(struct vm_area_st
 }
 
 #ifdef CONFIG_NUMA
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	return mpol_set_shared_policy(&SHMEM_I(i)->policy, vma, new);
 }
 
-struct mempolicy *
-shmem_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
+					  unsigned long addr)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long idx;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
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
drivers-scsi-scsi_errorc-should-include.patch
include-linux-kbuild-remove-duplicate-entries.patch
parisc-extern-inline-static-inline.patch
remove-fs-jffs2-ioctlc.patch
drivers-scsi-constantsc-make-2-functions-static.patch
fs-afs-possible-cleanups.patch
ppc-remove-apus-support.patch
lib-ioremapc-should-include-linux-ioh.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
ipc-shmc-make-2-functions-static.patch
kernel-schedc-make-code-static.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
