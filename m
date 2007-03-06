From: akpm@linux-foundation.org
Subject: - unbreak-msi-on-ati-devices-tidy.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:01:16 -0800
Message-ID: <200703060101.l2611GVZ007051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbXCFBBk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, greg@kroah.com, perex@suse.cz, petr@vandrovec.name, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     unbreak-msi-on-ati-devices-tidy
has been removed from the -mm tree.  Its filename was
     unbreak-msi-on-ati-devices-tidy.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: unbreak-msi-on-ati-devices-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/core/hcd-pci.c |    4 ++--
 sound/pci/atiixp.c         |   22 +++++++++-------------
 sound/pci/atiixp_modem.c   |   22 +++++++++-------------
 3 files changed, 20 insertions(+), 28 deletions(-)

diff -puN drivers/usb/core/hcd-pci.c~unbreak-msi-on-ati-devices-tidy drivers/usb/core/hcd-pci.c
--- a/drivers/usb/core/hcd-pci.c~unbreak-msi-on-ati-devices-tidy
+++ a/drivers/usb/core/hcd-pci.c
@@ -140,7 +140,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 		release_region (hcd->rsrc_start, hcd->rsrc_len);
  err2:
 	usb_put_hcd (hcd);
-	pci_disable_msi (dev);
+	pci_disable_msi(dev);
  err1:
 	pci_disable_device (dev);
 	dev_err (&dev->dev, "init %s fail, %d\n", pci_name(dev), retval);
@@ -394,7 +394,7 @@ int usb_hcd_pci_resume (struct pci_dev *
 			"can't re-enable after resume, %d!\n", retval);
 		return retval;
 	}
-	pci_enable_msi (dev);
+	pci_enable_msi(dev);
 	pci_set_master (dev);
 	pci_restore_state (dev);
 
diff -puN sound/pci/atiixp.c~unbreak-msi-on-ati-devices-tidy sound/pci/atiixp.c
--- a/sound/pci/atiixp.c~unbreak-msi-on-ati-devices-tidy
+++ a/sound/pci/atiixp.c
@@ -1475,11 +1475,10 @@ static int snd_atiixp_suspend(struct pci
 	snd_atiixp_aclink_down(chip);
 	snd_atiixp_chip_stop(chip);
 
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_disable_msi(pci);
-	} else {
+	else
 		pci_intx(pci, 0);
-	}
 	pci_disable_device(pci);
 	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
@@ -1501,11 +1500,10 @@ static int snd_atiixp_resume(struct pci_
 		return -EIO;
 	}
 	pci_set_master(pci);
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_enable_msi(pci);
-	} else {
+	else
 		pci_intx(pci, 1);
-	}
 
 	snd_atiixp_aclink_reset(chip);
 	snd_atiixp_chip_start(chip);
@@ -1575,11 +1573,10 @@ static int snd_atiixp_free(struct atiixp
 	if (chip->remap_addr)
 		iounmap(chip->remap_addr);
 	pci_release_regions(chip->pci);
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_disable_msi(chip->pci);
-	} else {
+	else
 		pci_intx(chip->pci, 0);
-	}
 	pci_disable_device(chip->pci);
 	kfree(chip);
 	return 0;
@@ -1631,9 +1628,9 @@ static int __devinit snd_atiixp_create(s
 		return -EIO;
 	}
 
-	if (msi && pci_enable_msi(pci) == 0) {
+	if (msi && pci_enable_msi(pci) == 0)
 		chip->have_msi = 1;
-	}
+
 	if (request_irq(pci->irq, snd_atiixp_interrupt, IRQF_SHARED,
 			card->shortname, chip)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
@@ -1642,9 +1639,8 @@ static int __devinit snd_atiixp_create(s
 	}
 	chip->irq = pci->irq;
 	pci_set_master(pci);
-	if (!chip->have_msi) {
+	if (!chip->have_msi)
 		pci_intx(pci, 1);
-	}
 	synchronize_irq(chip->irq);
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
diff -puN sound/pci/atiixp_modem.c~unbreak-msi-on-ati-devices-tidy sound/pci/atiixp_modem.c
--- a/sound/pci/atiixp_modem.c~unbreak-msi-on-ati-devices-tidy
+++ a/sound/pci/atiixp_modem.c
@@ -1132,11 +1132,10 @@ static int snd_atiixp_suspend(struct pci
 	snd_atiixp_aclink_down(chip);
 	snd_atiixp_chip_stop(chip);
 
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_disable_msi(pci);
-	} else {
+	else
 		pci_intx(pci, 0);
-	}
 	pci_disable_device(pci);
 	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
@@ -1158,11 +1157,10 @@ static int snd_atiixp_resume(struct pci_
 		return -EIO;
 	}
 	pci_set_master(pci);
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_enable_msi(pci);
-	} else {
+	else
 		pci_intx(pci, 1);
-	}
 
 	snd_atiixp_aclink_reset(chip);
 	snd_atiixp_chip_start(chip);
@@ -1218,11 +1216,10 @@ static int snd_atiixp_free(struct atiixp
 		free_irq(chip->irq, chip);
 	if (chip->remap_addr)
 		iounmap(chip->remap_addr);
-	if (chip->have_msi) {
+	if (chip->have_msi)
 		pci_disable_msi(chip->pci);
-	} else {
+	else
 		pci_intx(chip->pci, 0);
-	}
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
@@ -1275,9 +1272,9 @@ static int __devinit snd_atiixp_create(s
 		return -EIO;
 	}
 
-	if (msi && pci_enable_msi(pci) == 0) {
+	if (msi && pci_enable_msi(pci) == 0)
 		chip->have_msi = 1;
-	}
+
 	if (request_irq(pci->irq, snd_atiixp_interrupt, IRQF_SHARED,
 			card->shortname, chip)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
@@ -1286,9 +1283,8 @@ static int __devinit snd_atiixp_create(s
 	}
 	chip->irq = pci->irq;
 	pci_set_master(pci);
-	if (!chip->have_msi) {
+	if (!chip->have_msi)
 		pci_intx(pci, 1);
-	}
 	synchronize_irq(chip->irq);
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
rcu-preemptible-rcu.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-fix-build-fix.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
