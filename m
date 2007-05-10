From: akpm@linux-foundation.org
Subject: + revert-md-improve-partition-detection-in-md-array.patch added to -mm tree
Date: Wed, 09 May 2007 17:54:29 -0700
Message-ID: <200705100054.l4A0sTXO008412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759264AbXEJAyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 20:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Nicolas.Mailhot@LaPoste.net, neilb@suse.de


The patch titled
     revert "md: improve partition detection in md array"
has been added to the -mm tree.  Its filename is
     revert-md-improve-partition-detection-in-md-array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "md: improve partition detection in md array"
From: Andrew Morton <akpm@linux-foundation.org>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=8461

Cc: Neil Brown <neilb@suse.de>
Cc: Nicolas Mailhot <Nicolas.Mailhot@LaPoste.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   26 ++++++++++++++++++--------
 drivers/md/raid1.c        |    1 +
 drivers/md/raid5.c        |    2 ++
 include/linux/raid/md_k.h |    1 +
 4 files changed, 22 insertions(+), 8 deletions(-)

diff -puN drivers/md/md.c~revert-md-improve-partition-detection-in-md-array drivers/md/md.c
--- a/drivers/md/md.c~revert-md-improve-partition-detection-in-md-array
+++ a/drivers/md/md.c
@@ -3104,7 +3104,6 @@ static int do_md_run(mddev_t * mddev)
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
-	struct block_device *bdev;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -3332,13 +3331,7 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	bdev = bdget_disk(mddev->gendisk, 0);
-	if (bdev) {
-		bd_set_size(bdev, mddev->array_size << 1);
-		blkdev_ioctl(bdev->bd_inode, NULL, BLKRRPART, 0);
-		bdput(bdev);
-	}
-
+	mddev->changed = 1;
 	md_new_event(mddev);
 	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
@@ -3460,6 +3453,7 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->pers = NULL;
 
 			set_capacity(disk, 0);
+			mddev->changed = 1;
 
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -4599,6 +4593,20 @@ static int md_release(struct inode *inod
 	return 0;
 }
 
+static int md_media_changed(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	return mddev->changed;
+}
+
+static int md_revalidate(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	mddev->changed = 0;
+	return 0;
+}
 static struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -4606,6 +4614,8 @@ static struct block_device_operations md
 	.release	= md_release,
 	.ioctl		= md_ioctl,
 	.getgeo		= md_getgeo,
+	.media_changed	= md_media_changed,
+	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
diff -puN drivers/md/raid1.c~revert-md-improve-partition-detection-in-md-array drivers/md/raid1.c
--- a/drivers/md/raid1.c~revert-md-improve-partition-detection-in-md-array
+++ a/drivers/md/raid1.c
@@ -2063,6 +2063,7 @@ static int raid1_resize(mddev_t *mddev, 
 	 */
 	mddev->array_size = sectors>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
 	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
diff -puN drivers/md/raid5.c~revert-md-improve-partition-detection-in-md-array drivers/md/raid5.c
--- a/drivers/md/raid5.c~revert-md-improve-partition-detection-in-md-array
+++ a/drivers/md/raid5.c
@@ -4514,6 +4514,7 @@ static int raid5_resize(mddev_t *mddev, 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -4648,6 +4649,7 @@ static void end_reshape(raid5_conf_t *co
 		conf->mddev->array_size = conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
+		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
diff -puN include/linux/raid/md_k.h~revert-md-improve-partition-detection-in-md-array include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~revert-md-improve-partition-detection-in-md-array
+++ a/include/linux/raid/md_k.h
@@ -201,6 +201,7 @@ struct mddev_s
 	struct mutex			reconfig_mutex;
 	atomic_t			active;
 
+	int				changed;	/* true if we might need to reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
revert-md-improve-partition-detection-in-md-array.patch
