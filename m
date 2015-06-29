From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:17:48 -0700
Message-ID: <5591a7ec.WviiMdtB2o65Ef5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbF2URt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:17:49 -0400
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

 arch/tile/Kconfig                         |    3 -
 drivers/edac/mce_amd_inj.c                |   41 --------------------
 drivers/staging/android/lowmemorykiller.c |    4 -
 fs/f2fs/namei.c                           |    4 -
 net/mac802154/cfg.c                       |    5 --
 net/mac802154/iface.c                     |   11 -----
 tools/Makefile                            |    4 -
 7 files changed, 72 deletions(-)

diff -puN arch/tile/Kconfig~linux-next-git-rejects arch/tile/Kconfig
--- a/arch/tile/Kconfig~linux-next-git-rejects
+++ a/arch/tile/Kconfig
@@ -29,11 +29,8 @@ config TILE
 	select HAVE_DEBUG_STACKOVERFLOW
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_CONTEXT_TRACKING
-<<<<<<< HEAD
-=======
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
->>>>>>> linux-next/akpm-base
 	select EDAC_SUPPORT
 
 # FIXME: investigate whether we need/want these options.
diff -puN drivers/edac/mce_amd_inj.c~linux-next-git-rejects drivers/edac/mce_amd_inj.c
--- a/drivers/edac/mce_amd_inj.c~linux-next-git-rejects
+++ a/drivers/edac/mce_amd_inj.c
@@ -17,10 +17,7 @@
 #include <linux/cpu.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
-<<<<<<< HEAD
-=======
 #include <linux/pci.h>
->>>>>>> linux-next/akpm-base
 #include <asm/mce.h>
 #include <asm/irq_vectors.h>
 #include <asm/amd_nb.h>
@@ -36,31 +33,21 @@ static struct dentry *dfs_inj;
 
 static u8 n_banks;
 
-<<<<<<< HEAD
-#define MAX_FLAG_OPT_SIZE	3
-=======
 #define MAX_FLAG_OPT_SIZE	4
->>>>>>> linux-next/akpm-base
 
 enum injection_type {
 	SW_INJ = 0,	/* SW injection, simply decode the error */
 	HW_INJ,		/* Trigger a #MC */
-<<<<<<< HEAD
-=======
 	DFR_INT_INJ,	/* Trigger Deferred error interrupt */
 	THR_INT_INJ,	/* Trigger threshold interrupt */
->>>>>>> linux-next/akpm-base
 	N_INJ_TYPES,
 };
 
 static const char * const flags_options[] = {
 	[SW_INJ] = "sw",
 	[HW_INJ] = "hw",
-<<<<<<< HEAD
-=======
 	[DFR_INT_INJ] = "dfr",
 	[THR_INT_INJ] = "thr",
->>>>>>> linux-next/akpm-base
 	NULL
 };
 
@@ -124,7 +111,6 @@ static int toggle_hw_mce_inject(unsigned
 static int __set_inj(const char *buf)
 {
 	int i;
-<<<<<<< HEAD
 
 	for (i = 0; i < N_INJ_TYPES; i++) {
 		if (!strncmp(flags_options[i], buf, strlen(flags_options[i]))) {
@@ -141,24 +127,6 @@ static ssize_t flags_read(struct file *f
 	char buf[MAX_FLAG_OPT_SIZE];
 	int n;
 
-=======
-
-	for (i = 0; i < N_INJ_TYPES; i++) {
-		if (!strncmp(flags_options[i], buf, strlen(flags_options[i]))) {
-			inj_type = i;
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-static ssize_t flags_read(struct file *filp, char __user *ubuf,
-			  size_t cnt, loff_t *ppos)
-{
-	char buf[MAX_FLAG_OPT_SIZE];
-	int n;
-
->>>>>>> linux-next/akpm-base
 	n = sprintf(buf, "%s\n", flags_options[inj_type]);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, n);
@@ -288,8 +256,6 @@ static void do_inject(void)
 		return;
 	}
 
-<<<<<<< HEAD
-=======
 	if (inj_type == DFR_INT_INJ) {
 		/*
 		 * Ensure necessary status bits for deferred errors:
@@ -303,15 +269,12 @@ static void do_inject(void)
 		i_mce.status &= ~MCI_STATUS_UC;
 	}
 
->>>>>>> linux-next/akpm-base
 	/* prep MCE global settings for the injection */
 	mcg_status = MCG_STATUS_MCIP | MCG_STATUS_EIPV;
 
 	if (!(i_mce.status & MCI_STATUS_PCC))
 		mcg_status |= MCG_STATUS_RIPV;
 
-<<<<<<< HEAD
-=======
 	/*
 	 * For multi node CPUs, logging and reporting of bank 4 errors happens
 	 * only on the node base core. Refer to D18F3x44[NbMcaToMstCpuEn] for
@@ -326,7 +289,6 @@ static void do_inject(void)
 		cpu = get_nbc_for_node(amd_get_nb_id(cpu));
 	}
 
->>>>>>> linux-next/akpm-base
 	get_online_cpus();
 	if (!cpu_online(cpu))
 		goto err;
@@ -421,13 +383,10 @@ static const char readme_msg[] =
 "\t    handle the error. Be warned: might cause system panic if MCi_STATUS[PCC] \n"
 "\t    is set. Therefore, consider setting (debugfs_mountpoint)/mce/fake_panic \n"
 "\t    before injecting.\n"
-<<<<<<< HEAD
-=======
 "\t  - \"dfr\": Trigger Deferred error handled by the deferred error APIC handler \n"
 "\t    if the feature is present in HW.\n"
 "\t  - \"thr\": Trigger Thresholding error handled by the thresholding error \n"
 "\t    APIC handler.\n"
->>>>>>> linux-next/akpm-base
 "\n";
 
 static ssize_t
diff -puN drivers/staging/android/lowmemorykiller.c~linux-next-git-rejects drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~linux-next-git-rejects
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -167,16 +167,12 @@ static unsigned long lowmem_scan(struct
 		 * infrastructure. There is no real reason why the selected
 		 * task should have access to the memory reserves.
 		 */
-<<<<<<< HEAD
-		mark_oom_victim(selected);
-=======
 		mark_tsk_oom_victim(selected);
 		task_unlock(selected);
 		lowmem_print(1, "send sigkill to %d (%s), adj %hd, size %d\n",
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
 		lowmem_deathpending_timeout = jiffies + HZ;
->>>>>>> linux-next/akpm-base
 		send_sig(SIGKILL, selected, 0);
 		rem += selected_tasksize;
 	}
diff -puN fs/f2fs/namei.c~linux-next-git-rejects fs/f2fs/namei.c
--- a/fs/f2fs/namei.c~linux-next-git-rejects
+++ a/fs/f2fs/namei.c
@@ -916,12 +916,8 @@ static int f2fs_rename2(struct inode *ol
 }
 
 #ifdef CONFIG_F2FS_FS_ENCRYPTION
-<<<<<<< HEAD
-static const char *f2fs_encrypted_follow_link(struct dentry *dentry, void **cookie)
-=======
 static const char *f2fs_encrypted_follow_link(struct dentry *dentry,
 						void **cookie)
->>>>>>> linux-next/akpm-base
 {
 	struct page *cpage = NULL;
 	char *caddr, *paddr = NULL;
diff -puN net/mac802154/cfg.c~linux-next-git-rejects net/mac802154/cfg.c
--- a/net/mac802154/cfg.c~linux-next-git-rejects
+++ a/net/mac802154/cfg.c
@@ -195,16 +195,11 @@ ieee802154_set_pan_id(struct wpan_phy *w
 	if (wpan_dev->pan_id == pan_id)
 		return 0;
 
-<<<<<<< HEAD
-	wpan_dev->pan_id = pan_id;
-	return 0;
-=======
 	ret = mac802154_wpan_update_llsec(wpan_dev->netdev);
 	if (!ret)
 		wpan_dev->pan_id = pan_id;
 
 	return ret;
->>>>>>> linux-next/akpm-base
 }
 
 static int
diff -puN net/mac802154/iface.c~linux-next-git-rejects net/mac802154/iface.c
--- a/net/mac802154/iface.c~linux-next-git-rejects
+++ a/net/mac802154/iface.c
@@ -314,16 +314,8 @@ static int mac802154_slave_close(struct
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-<<<<<<< HEAD
-	if (!local->open_count) {
-		flush_workqueue(local->workqueue);
-		hrtimer_cancel(&local->ifs_timer);
-		drv_stop(local);
-	}
-=======
 	if (!local->open_count)
 		ieee802154_stop_device(local);
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
@@ -476,10 +468,7 @@ ieee802154_setup_sdata(struct ieee802154
 		       enum nl802154_iftype type)
 {
 	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
-<<<<<<< HEAD
-=======
 	int ret;
->>>>>>> linux-next/akpm-base
 	u8 tmp;
 
 	/* set some type-dependent values */
diff -puN tools/Makefile~linux-next-git-rejects tools/Makefile
--- a/tools/Makefile~linux-next-git-rejects
+++ a/tools/Makefile
@@ -135,11 +135,7 @@ freefall_clean:
 
 clean: acpi_clean cgroup_clean cpupower_clean hv_clean firewire_clean lguest_clean \
 		perf_clean selftests_clean turbostat_clean usb_clean virtio_clean \
-<<<<<<< HEAD
-		vm_clean net_clean x86_energy_perf_policy_clean tmon_clean freefall_clean
-=======
 		vm_clean net_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean
->>>>>>> linux-next/akpm-base
 
 .PHONY: FORCE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

