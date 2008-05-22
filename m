From: akpm@linux-foundation.org
Subject: + fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch added to -mm tree
Date: Wed, 21 May 2008 23:55:24 -0700
Message-ID: <200805220655.m4M6tOSO022000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757766AbYEVGzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@fieldses.org, dgc@sgi.com, k-makita@np.css.fujitsu.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
has been added to the -mm tree.  Its filename is
     fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix comments.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Chinner <dgc@sgi.com>
Cc: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |   39 +++++++++++++++++----------------------
 include/linux/fs.h |    1 +
 2 files changed, 18 insertions(+), 22 deletions(-)

diff -puN fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix fs/dcache.c
--- a/fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/fs/dcache.c
@@ -120,8 +120,7 @@ static void dentry_iput(struct dentry * 
 }
 
 /*
- * Following dentry_lru_(add|add_tail|del|del_init) is must
- * called with dcache_lock held.
+ * dentry_lru_(add|add_tail|del|del_init) must be called with dcache_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
@@ -245,7 +244,7 @@ repeat:
 unhash_it:
 	__d_drop(dentry);
 kill_it:
-	/* if dentry was on d_lru list delete it from there */
+	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);
 	if (dentry)
@@ -468,11 +467,11 @@ restart:
 			BUG_ON(dentry->d_sb != sb);
 
 			spin_lock(&dentry->d_lock);
-		/*
-		 * If we are honouring the DCACHE_REFERENCED flag and the
-		 * dentry has this flag set, don't free it. Clear the flag
-		 * and put it back on the LRU
-		 */
+			/*
+			 * If we are honouring the DCACHE_REFERENCED flag and
+			 * the dentry has this flag set, don't free it. Clear
+			 * the flag and put it back on the LRU.
+		 	 */
 			if ((flags & DCACHE_REFERENCED)
 				&& (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
@@ -501,10 +500,10 @@ restart:
 			continue;
 		}
 		prune_one_dentry(dentry);
-		/* dentry->d_lock is dropped in prune_one_dentry() */
+		/* dentry->d_lock was dropped in prune_one_dentry() */
 		cond_resched_lock(&dcache_lock);
 	}
-	if ((count == NULL) && (!list_empty(&sb->s_dentry_lru)))
+	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
 	if (count != NULL)
 		*count = cnt;
@@ -515,17 +514,13 @@ restart:
 
 /**
  * prune_dcache - shrink the dcache
- * @count: number of entries to try and free
+ * @count: number of entries to try to free
  *
- * Shrink the dcache. This is done when we need
- * more memory, or simply when we need to unmount
- * something (at which point we need to unuse
- * all dentries).
+ * Shrink the dcache. This is done when we need more memory, or simply when we
+ * need to unmount something (at which point we need to unuse all dentries).
  *
- * This function may fail to free any resources if
- * all the dentries are in use.
+ * This function may fail to free any resources if all the dentries are in use.
  */
- 
 static void prune_dcache(int count)
 {
 	struct super_block *sb;
@@ -548,10 +543,10 @@ restart:
 			continue;
 		sb->s_count++;
 		/* Now, we reclaim unused dentrins with fairness.
-		 * we reclaim them same percentage on each superblocks.
-		 * we calculate number of dentries to scan on this sb
-		 * based on following way, but impelementation is arranged
-		 * to avoid overflow.
+		 * We reclaim them same percentage from each superblock.
+		 * We calculate number of dentries to scan on this sb
+		 * as follows, but the implementation is arranged to avoid
+		 * overflows:
 		 * number of dentries to scan on this sb =
 		 * count * (number of dentries on this sb /
 		 * number of dentries in the machine)
diff -puN include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix include/linux/fs.h
--- a/include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/include/linux/fs.h
@@ -1063,6 +1063,7 @@ struct super_block {
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
semaphore-introduce-down_try-checkpatch-fixes.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
memory-hotplug-fix-early-allocation-handling-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
undeprecate-down_trylock.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
lguest-use-cpu-capability-accessors.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
sfc-correct-and-expand-some-comments.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

