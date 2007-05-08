From: akpm@linux-foundation.org
Subject: - bt-hack-hack.patch removed from -mm tree
Date: Tue, 08 May 2007 00:10:06 -0700
Message-ID: <200705080710.l487A6O0016127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574AbXEHHKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 03:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth build fix
has been removed from the -mm tree.  Its filename was
     bt-hack-hack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bluetooth build fix
From: Andrew Morton <akpm@linux-foundation.org>

I wonder if this works.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/hci_sysfs.c~bt-hack-hack net/bluetooth/hci_sysfs.c
--- a/net/bluetooth/hci_sysfs.c~bt-hack-hack
+++ a/net/bluetooth/hci_sysfs.c
@@ -322,7 +322,7 @@ int hci_register_sysfs(struct hci_dev *h
 		if (device_create_file(dev, bt_attrs[i]) < 0)
 			BT_ERR("Failed to create device attribute");
 
-	if (sysfs_create_link(&bt_class->subsys.kset.kobj,
+	if (sysfs_create_link(&bt_class->subsys.kobj,
 				&dev->kobj, kobject_name(&dev->kobj)) < 0)
 		BT_ERR("Failed to create class symlink");
 
@@ -333,7 +333,7 @@ void hci_unregister_sysfs(struct hci_dev
 {
 	BT_DBG("%p name %s type %d", hdev, hdev->name, hdev->type);
 
-	sysfs_remove_link(&bt_class->subsys.kset.kobj,
+	sysfs_remove_link(&bt_class->subsys.kobj,
 					kobject_name(&hdev->dev.kobj));
 
 	device_del(&hdev->dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
consolidate-asm-consth-to-linux-consth.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-probe-cleanup.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
cirrusfb-convert-to-generic-boolean.patch
sm501fb-printk-warning-fixes.patch
bt-hack-hack.patch
