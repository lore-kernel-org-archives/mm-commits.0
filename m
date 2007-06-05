From: akpm@linux-foundation.org
Subject: + git-input-fixup.patch added to -mm tree
Date: Mon, 04 Jun 2007 23:53:28 -0700
Message-ID: <200706050653.l556rV9M031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbXFEGxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 02:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dtor@mail.ru


The patch titled
     git-input-fixup
has been added to the -mm tree.  Its filename is
     git-input-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-input-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Try to repair conflicts in git-input.patch

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c    |    6 ------
 drivers/input/joydev.c   |    6 ------
 drivers/input/mousedev.c |   18 ------------------
 drivers/input/tsdev.c    |    6 ------
 4 files changed, 36 deletions(-)

diff -puN drivers/input/evdev.c~git-input-fixup drivers/input/evdev.c
--- a/drivers/input/evdev.c~git-input-fixup
+++ a/drivers/input/evdev.c
@@ -700,16 +700,10 @@ static void evdev_disconnect(struct inpu
 		input_close_device(handle);
 		list_for_each_entry(client, &evdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-<<<<<<< HEAD/drivers/input/evdev.c
-		wake_up_interruptible(&evdev->wait);
-	} else
-		evdev_free(evdev);
-=======
 		wake_up_interruptible(&evdev->wait);
 	}
 
 	put_device(&evdev->dev);
->>>>>>> /drivers/input/evdev.c
 }
 
 static const struct input_device_id evdev_ids[] = {
diff -puN drivers/input/joydev.c~git-input-fixup drivers/input/joydev.c
--- a/drivers/input/joydev.c~git-input-fixup
+++ a/drivers/input/joydev.c
@@ -597,16 +597,10 @@ static void joydev_disconnect(struct inp
 		input_close_device(handle);
 		list_for_each_entry(client, &joydev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-<<<<<<< HEAD/drivers/input/joydev.c
-		wake_up_interruptible(&joydev->wait);
-	} else
-		joydev_free(joydev);
-=======
 		wake_up_interruptible(&joydev->wait);
 	}
 
 	put_device(&joydev->dev);
->>>>>>> /drivers/input/joydev.c
 }
 
 static const struct input_device_id joydev_blacklist[] = {
diff -puN drivers/input/mousedev.c~git-input-fixup drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~git-input-fixup
+++ a/drivers/input/mousedev.c
@@ -802,25 +802,7 @@ static void mousedev_disconnect(struct i
 
 	mixdev_remove_device(mousedev);
 	input_unregister_handle(handle);
-<<<<<<< HEAD/drivers/input/mousedev.c
-
-	sysfs_remove_link(&input_class.subsys.kobj, mousedev->name);
-	class_device_destroy(&input_class,
-			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
-	mousedev->exist = 0;
-
-	mixdev_remove_device(mousedev);
-
-	if (mousedev->open) {
-		input_close_device(handle);
-		list_for_each_entry(client, &mousedev->client_list, node)
-			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-		wake_up_interruptible(&mousedev->wait);
-	} else
-		mousedev_free(mousedev);
-=======
 	mousedev_destroy(mousedev);
->>>>>>> /drivers/input/mousedev.c
 }
 
 static const struct input_device_id mousedev_ids[] = {
diff -puN drivers/input/tsdev.c~git-input-fixup drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~git-input-fixup
+++ a/drivers/input/tsdev.c
@@ -477,16 +477,10 @@ static void tsdev_disconnect(struct inpu
 		input_close_device(handle);
 		list_for_each_entry(client, &tsdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
-<<<<<<< HEAD/drivers/input/tsdev.c
-		wake_up_interruptible(&tsdev->wait);
-	} else
-		tsdev_free(tsdev);
-=======
 		wake_up_interruptible(&tsdev->wait);
 	}
 
 	put_device(&tsdev->dev);
->>>>>>> /drivers/input/tsdev.c
 }
 
 static const struct input_device_id tsdev_ids[] = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

document-acked-by.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
git-e1000.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
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
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
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
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
o_cloexec-for-scm_rights-fix.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
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
lguest-the-host-code-borkages.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
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
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
