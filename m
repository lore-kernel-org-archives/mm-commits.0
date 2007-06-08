From: akpm@linux-foundation.org
Subject: + git-jfs-fix.patch added to -mm tree
Date: Fri, 08 Jun 2007 14:57:42 -0700
Message-ID: <200706082201.l58M1I6c013481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967609AbXFHWBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 18:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@xenotime.net, shaggy@austin.ibm.com


The patch titled
     git-jfs: fix print_hex_dump() calls
has been added to the -mm tree.  Its filename is
     git-jfs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-jfs: fix print_hex_dump() calls
From: Andrew Morton <akpm@linux-foundation.org>

We changed print_hex_dump(), sorry.

Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_imap.c     |    3 ++-
 fs/jfs/jfs_logmgr.c   |   15 +++++++++------
 fs/jfs/jfs_metapage.c |    3 ++-
 fs/jfs/jfs_txnmgr.c   |   14 ++++++++------
 fs/jfs/xattr.c        |    4 ++--
 5 files changed, 23 insertions(+), 16 deletions(-)

diff -puN fs/jfs/jfs_imap.c~git-jfs-fix fs/jfs/jfs_imap.c
--- a/fs/jfs/jfs_imap.c~git-jfs-fix
+++ a/fs/jfs/jfs_imap.c
@@ -891,7 +891,8 @@ int diFree(struct inode *ip)
 	 */
 	if (iagno >= imap->im_nextiag) {
 		printk(KERN_ERR "Dump of imap:\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, imap, 32);
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+				imap, 32, true);
 		jfs_error(ip->i_sb,
 			  "diFree: inum = %d, iagno = %d, nextiag = %d",
 			  (uint) inum, iagno, imap->im_nextiag);
diff -puN fs/jfs/jfs_logmgr.c~git-jfs-fix fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~git-jfs-fix
+++ a/fs/jfs/jfs_logmgr.c
@@ -1627,16 +1627,19 @@ void jfs_flush_journal(struct jfs_log *l
 			if (lp->xflag & COMMIT_PAGE) {
 				struct metapage *mp = (struct metapage *)lp;
 				printk (KERN_ERR "orphan metapage:\n");
-				print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS,
-					       lp, sizeof(struct metapage));
+				print_hex_dump(KERN_ERR, "",
+					DUMP_PREFIX_ADDRESS, 32, 1,
+					lp, sizeof(struct metapage), true);
 				printk (KERN_ERR "page:\n");
-				print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS,
-					       mp->page, sizeof(struct page));
+				print_hex_dump(KERN_ERR, "",
+					DUMP_PREFIX_ADDRESS, 32, 1,
+					mp->page, sizeof(struct page), true);
 			}
 			else {
 				printk (KERN_ERR "orphan tblock:\n");
-				print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS,
-					       lp, sizeof(struct tblock));
+				print_hex_dump(KERN_ERR, "",
+					DUMP_PREFIX_ADDRESS, 32, 1,
+					lp, sizeof(struct tblock), true);
 			}
 		}
 	}
diff -puN fs/jfs/jfs_metapage.c~git-jfs-fix fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~git-jfs-fix
+++ a/fs/jfs/jfs_metapage.c
@@ -473,7 +473,8 @@ add_failed:
 	goto skip;
 dump_bio:
 	printk(KERN_ERR "JFS: dump of bio:\n");
-	print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, bio, sizeof(*bio));
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+			bio, sizeof(*bio), true);
 skip:
 	bio_put(bio);
 	unlock_page(page);
diff -puN fs/jfs/jfs_txnmgr.c~git-jfs-fix fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~git-jfs-fix
+++ a/fs/jfs/jfs_txnmgr.c
@@ -831,15 +831,17 @@ struct tlock *txLock(tid_t tid, struct i
 	if (jfs_ip->fileset != AGGREGATE_I) {
 		printk(KERN_ERR "txLock: trying to lock locked page!");
 		printk(KERN_ERR "ip:\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, ip, sizeof(*ip));
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+				ip, sizeof(*ip), true);
 		printk(KERN_ERR "mp:\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, mp, sizeof(*mp));
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+				mp, sizeof(*mp), true);
 		printk(KERN_ERR "Locker's tblk:\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS,
-			       tid_to_tblock(tid), sizeof(struct tblock));
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+			       tid_to_tblock(tid), sizeof(struct tblock), true);
 		printk(KERN_ERR "Tlock:\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, tlck,
-			       sizeof(*tlck));
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+			       tlck, sizeof(*tlck), true);
 		BUG();
 	}
 	INCREMENT(stattx.waitlock);	/* statistics */
diff -puN fs/jfs/xattr.c~git-jfs-fix fs/jfs/xattr.c
--- a/fs/jfs/xattr.c~git-jfs-fix
+++ a/fs/jfs/xattr.c
@@ -590,8 +590,8 @@ static int ea_get(struct inode *inode, s
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
-		print_hex_dump(KERN_ERR, DUMP_PREFIX_ADDRESS, ea_buf->xattr,
-			       ea_size);
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 32, 1,
+				ea_buf->xattr, ea_size, true);
 		ea_release(inode, ea_buf);
 		rc = -EIO;
 		goto clean_up;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
document-acked-by.patch
x86_64-oops_begin-fix.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-jfs-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
git-selinux-allnoconfig-fix.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
revert-x86_64-mm-cpa-cache-flush.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-mtrr-clean-up-usage_table.patch
git-xfs.patch
git-cryptodev.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
revert-vanishing-ioctl-handler-debugging.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
