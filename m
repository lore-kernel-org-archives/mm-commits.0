From: akpm@linux-foundation.org
Subject: [folded] early-platform-driver-v3-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:19:56 -0800
Message-ID: <200902112119.n1BLJvpM021178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328AbZBKVUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:20:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, damm@igel.co.jp, david-b@pacbell.net, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     early-platform-driver-v3-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     early-platform-driver-v3-checkpatch-fixes.patch

This patch was dropped because it was folded into early-platform-driver-v3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: early-platform-driver-v3-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open parenthesis '('
#227: FILE: drivers/base/platform.c:1091:
+			if(pd->id == id)

ERROR: space required before the open parenthesis '('
#245: FILE: drivers/base/platform.c:1109:
+			if(pd->id >= id)

ERROR: code indent should use tabs where possible
#307: FILE: drivers/base/platform.c:1171:
+^I^I        else$

WARNING: suspect code indent for conditional statements (16, 25)
#337: FILE: drivers/base/platform.c:1201:
+		if (k < 0)
+			 break;

WARNING: suspect code indent for conditional statements (16, 25)
#342: FILE: drivers/base/platform.c:1206:
+		if (user_only)
+			 break;

total: 3 errors, 2 warnings, 382 lines checked

./patches/early-platform-driver-v3.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/base/platform.c~early-platform-driver-v3-checkpatch-fixes drivers/base/platform.c
--- a/drivers/base/platform.c~early-platform-driver-v3-checkpatch-fixes
+++ a/drivers/base/platform.c
@@ -1106,7 +1106,7 @@ early_platform_match(struct early_platfo
 
 	list_for_each_entry(pd, &early_platform_device_list, dev.devres_head)
 		if (platform_match(&pd->dev, &epdrv->pdrv->driver))
-			if(pd->id == id)
+			if (pd->id == id)
 				return pd;
 
 	return NULL;
@@ -1124,7 +1124,7 @@ static  __init int early_platform_left(s
 
 	list_for_each_entry(pd, &early_platform_device_list, dev.devres_head)
 		if (platform_match(&pd->dev, &epdrv->pdrv->driver))
-			if(pd->id >= id)
+			if (pd->id >= id)
 				return 1;
 
 	return 0;
@@ -1186,7 +1186,7 @@ static int __init early_platform_driver_
 			if (epdrv->pdrv->probe(match))
 				pr_warning("%s: unable to probe %s early.\n",
 					   class_str, match->name);
-		        else
+			else
 				n++;
 		}
 
@@ -1217,12 +1217,12 @@ int __init early_platform_driver_probe(c
 		k = early_platform_driver_probe_id(class_str, i, nr_probe - n);
 
 		if (k < 0)
-			 break;
+			break;
 
 		n += k;
 
 		if (user_only)
-			 break;
+			break;
 	}
 
 	return n;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch
writeback-fix-break-condition.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-define-arch_want_frame_pointers.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch
early-platform-driver-v3.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_assign_resources-fix.patch
pci-constify-pci_bus_add_devices.patch
cciss-pci-power-management-reset-for-kexec-cleanup.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void-fix.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

