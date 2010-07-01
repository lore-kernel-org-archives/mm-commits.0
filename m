From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 01 Jul 2010 11:18:15 -0700
Message-ID: <201007011818.o61IIDCs017229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab0GAS3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 14:29:49 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o61ISDjn022640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 1 Jul 2010 11:28:59 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/batman-adv/bat_sysfs.c |   56 -----------------------
 drivers/usb/gadget/f_mass_storage.c    |    8 ---
 2 files changed, 64 deletions(-)

diff -puN drivers/staging/batman-adv/bat_sysfs.c~linux-next-git-rejects drivers/staging/batman-adv/bat_sysfs.c
--- a/drivers/staging/batman-adv/bat_sysfs.c~linux-next-git-rejects
+++ a/drivers/staging/batman-adv/bat_sysfs.c
@@ -244,62 +244,6 @@ static struct bat_attribute *mesh_attrs[
 	NULL,
 };
 
-<<<<<<< HEAD
-static ssize_t transtable_local_read(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buff, loff_t off, size_t count)
-{
-	struct device *dev = to_dev(kobj->parent);
-	struct net_device *net_dev = to_net_dev(dev);
-
-	return hna_local_fill_buffer_text(net_dev, buff, count, off);
-}
-
-static ssize_t transtable_global_read(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buff, loff_t off, size_t count)
-{
-	struct device *dev = to_dev(kobj->parent);
-	struct net_device *net_dev = to_net_dev(dev);
-
-	return hna_global_fill_buffer_text(net_dev, buff, count, off);
-}
-
-static ssize_t originators_read(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buff, loff_t off, size_t count)
-{
-	struct device *dev = to_dev(kobj->parent);
-	struct net_device *net_dev = to_net_dev(dev);
-
-	return orig_fill_buffer_text(net_dev, buff, count, off);
-}
-
-static ssize_t vis_data_read(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buff, loff_t off, size_t count)
-{
-	struct device *dev = to_dev(kobj->parent);
-	struct net_device *net_dev = to_net_dev(dev);
-
-	return vis_fill_buffer_text(net_dev, buff, count, off);
-}
-
-static BAT_BIN_ATTR(transtable_local, S_IRUGO, transtable_local_read, NULL);
-static BAT_BIN_ATTR(transtable_global, S_IRUGO, transtable_global_read, NULL);
-static BAT_BIN_ATTR(originators, S_IRUGO, originators_read, NULL);
-static BAT_BIN_ATTR(vis_data, S_IRUGO, vis_data_read, NULL);
-
-static struct bin_attribute *mesh_bin_attrs[] = {
-	&bat_attr_transtable_local,
-	&bat_attr_transtable_global,
-	&bat_attr_originators,
-	&bat_attr_vis_data,
-	NULL,
-};
-
-=======
->>>>>>> FETCH_HEAD
 int sysfs_add_meshif(struct net_device *dev)
 {
 	struct kobject *batif_kobject = &dev->dev.kobj;
diff -puN drivers/usb/gadget/f_mass_storage.c~linux-next-git-rejects drivers/usb/gadget/f_mass_storage.c
--- a/drivers/usb/gadget/f_mass_storage.c~linux-next-git-rejects
+++ a/drivers/usb/gadget/f_mass_storage.c
@@ -2394,19 +2394,11 @@ reset:
 	fsg->bulk_out_enabled = 1;
 	common->bulk_out_maxpacket = le16_to_cpu(d->wMaxPacketSize);
 	clear_bit(IGNORE_BULK_OUT, &fsg->atomic_bitflags);
-<<<<<<< HEAD
 
 	/* Allocate the requests */
 	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
 		struct fsg_buffhd	*bh = &common->buffhds[i];
 
-=======
-
-	/* Allocate the requests */
-	for (i = 0; i < FSG_NUM_BUFFERS; ++i) {
-		struct fsg_buffhd	*bh = &common->buffhds[i];
-
->>>>>>> FETCH_HEAD
 		rc = alloc_request(common, fsg->bulk_in, &bh->inreq);
 		if (rc)
 			goto reset;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
drivers-cdrom-use-pr_level-checkpatch-fixes.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

