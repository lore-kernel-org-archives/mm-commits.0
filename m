From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-cleanups.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:32 -0700
Message-ID: <200707302247.l6UMlWS6002519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755970AbXG3WsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, clameter@sgi.com


The patch titled
     mm/mempolicy.c: cleanups
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/mempolicy.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- every file should include the headers containing the prototypes for
  its global functions
- make the follosing needlessly global functions static:
  - migrate_to_node()
  - do_mbind()
  - sp_alloc()
  - mpol_rebind_policy()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    6 ------
 mm/mempolicy.c            |   25 ++++++++++++++++---------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicyc-cleanups include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicyc-cleanups
+++ a/include/linux/mempolicy.h
@@ -143,7 +143,6 @@ struct mempolicy *mpol_shared_policy_loo
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
-extern void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *new);
 extern void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
@@ -225,11 +224,6 @@ static inline void numa_default_policy(v
 {
 }
 
-static inline void mpol_rebind_policy(struct mempolicy *pol,
-					const nodemask_t *new)
-{
-}
-
 static inline void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new)
 {
diff -puN mm/mempolicy.c~mm-mempolicyc-cleanups mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-cleanups
+++ a/mm/mempolicy.c
@@ -87,6 +87,7 @@
 #include <linux/migrate.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -108,6 +109,9 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
+static void mpol_rebind_policy(struct mempolicy *pol,
+                               const nodemask_t *newmask);
+
 /* Do sanity checking on a policy */
 static int mpol_check_policy(int mode, nodemask_t *nodes)
 {
@@ -459,7 +463,7 @@ static void mpol_set_task_struct_flag(vo
 }
 
 /* Set the process memory policy */
-long do_set_mempolicy(int mode, nodemask_t *nodes)
+static long do_set_mempolicy(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
@@ -519,8 +523,8 @@ static int lookup_node(struct mm_struct 
 }
 
 /* Retrieve NUMA policy */
-long do_get_mempolicy(int *policy, nodemask_t *nmask,
-			unsigned long addr, unsigned long flags)
+static long do_get_mempolicy(int *policy, nodemask_t *nmask,
+			     unsigned long addr, unsigned long flags)
 {
 	int err;
 	struct mm_struct *mm = current->mm;
@@ -601,7 +605,8 @@ static struct page *new_node_page(struct
  * Migrate pages from one node to a target node.
  * Returns error or the number of pages not migrated.
  */
-int migrate_to_node(struct mm_struct *mm, int source, int dest, int flags)
+static int migrate_to_node(struct mm_struct *mm, int source, int dest,
+			   int flags)
 {
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
@@ -732,8 +737,9 @@ static struct page *new_vma_page(struct 
 }
 #endif
 
-long do_mbind(unsigned long start, unsigned long len,
-		unsigned long mode, nodemask_t *nmask, unsigned long flags)
+static long do_mbind(unsigned long start, unsigned long len,
+		     unsigned long mode, nodemask_t *nmask,
+		     unsigned long flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -1466,8 +1472,8 @@ static void sp_delete(struct shared_poli
 	kmem_cache_free(sn_cache, n);
 }
 
-struct sp_node *
-sp_alloc(unsigned long start, unsigned long end, struct mempolicy *pol)
+static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
+				struct mempolicy *pol)
 {
 	struct sp_node *n = kmem_cache_alloc(sn_cache, GFP_KERNEL);
 
@@ -1645,7 +1651,8 @@ void numa_default_policy(void)
 }
 
 /* Migrate a policy to a different set of nodes */
-void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
 {
 	nodemask_t *mpolmask;
 	nodemask_t tmp;
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
