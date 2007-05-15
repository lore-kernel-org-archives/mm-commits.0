From: akpm@linux-foundation.org
Subject: - revert-input-alps-handle-errors-from-input_register_device.patch removed from -mm tree
Date: Mon, 14 May 2007 22:14:27 -0700
Message-ID: <200705150514.l4F5ERVr002082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbXEOFOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@insightbb.com, ejr@EECS.Berkeley.EDU, remi.colinet@free.fr, mm-commits@vger.kernel.org


The patch titled
     revert "Input: ALPS - handle errors from input_register_device()"
has been removed from the -mm tree.  Its filename was
     revert-input-alps-handle-errors-from-input_register_device.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert "Input: ALPS - handle errors from input_register_device()"
From: Andrew Morton <akpm@linux-foundation.org>

f42649e84831efc69d5f621f1c36a39b4e384a99 broke Jason's machine.

Cc: Jason Riedy <ejr@EECS.Berkeley.EDU>
Cc: Dmitry Torokhov <dtor@insightbb.com>
Cc: Remi Colinet <remi.colinet@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/alps.c |   13 ++++---------
 drivers/input/mouse/alps.h |    1 +
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/input/mouse/alps.c~revert-input-alps-handle-errors-from-input_register_device drivers/input/mouse/alps.c
--- a/drivers/input/mouse/alps.c~revert-input-alps-handle-errors-from-input_register_device
+++ a/drivers/input/mouse/alps.c
@@ -424,15 +424,14 @@ int alps_init(struct psmouse *psmouse)
 	struct input_dev *dev1 = psmouse->dev, *dev2;
 	int version;
 
-	priv = kzalloc(sizeof(struct alps_data), GFP_KERNEL);
+	psmouse->private = priv = kzalloc(sizeof(struct alps_data), GFP_KERNEL);
 	dev2 = input_allocate_device();
 	if (!priv || !dev2)
 		goto init_fail;
 
 	priv->dev2 = dev2;
 
-	priv->i = alps_get_model(psmouse, &version);
-	if (!priv->i)
+	if (!(priv->i = alps_get_model(psmouse, &version)))
 		goto init_fail;
 
 	if ((priv->i->flags & ALPS_PASS) && alps_passthrough_mode(psmouse, 1))
@@ -481,8 +480,7 @@ int alps_init(struct psmouse *psmouse)
 	dev2->relbit[LONG(REL_X)] |= BIT(REL_X) | BIT(REL_Y);
 	dev2->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
 
-	if (input_register_device(priv->dev2))
-		goto init_fail;
+	input_register_device(priv->dev2);
 
 	psmouse->protocol_handler = alps_process_byte;
 	psmouse->poll = alps_poll;
@@ -493,11 +491,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
-	psmouse->private = priv;
 	return 0;
 
 init_fail:
-	psmouse_reset(psmouse);
 	input_free_device(dev2);
 	kfree(priv);
 	return -1;
@@ -508,8 +504,7 @@ int alps_detect(struct psmouse *psmouse,
 	int version;
 	const struct alps_model_info *model;
 
-	model = alps_get_model(psmouse, &version);
-	if (!model)
+	if (!(model = alps_get_model(psmouse, &version)))
 		return -1;
 
 	if (set_properties) {
diff -puN drivers/input/mouse/alps.h~revert-input-alps-handle-errors-from-input_register_device drivers/input/mouse/alps.h
--- a/drivers/input/mouse/alps.h~revert-input-alps-handle-errors-from-input_register_device
+++ a/drivers/input/mouse/alps.h
@@ -20,6 +20,7 @@ struct alps_model_info {
 
 struct alps_data {
 	struct input_dev *dev2;		/* Relative device */
+	char name[32];			/* Name */
 	char phys[32];			/* Phys */
 	const struct alps_model_info *i;/* Info */
 	int prev_fin;			/* Finger bit from previous packet */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-config_large_allocs-must-consider-max_order-limit-fix.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
8xx-mpc885ads-pcmcia-support-fix.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
revert-input-alps-handle-errors-from-input_register_device.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
tglx-debug.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
