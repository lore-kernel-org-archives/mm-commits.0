From: akpm@linux-foundation.org
Subject: + early-platform-driver-v3-checkpatch-fixes.patch added to -mm tree
Date: Wed, 28 Jan 2009 16:53:37 -0800
Message-ID: <200901290053.n0T0rcuD013673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbZA2AyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:54:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, damm@igel.co.jp, david-b@pacbell.net, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org, lethal@linux-sh.org


The patch titled
     early-platform-driver-v3-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     early-platform-driver-v3-checkpatch-fixes.patch

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
@@ -1088,7 +1088,7 @@ early_platform_match(struct early_platfo
 
 	list_for_each_entry(pd, &early_platform_device_list, dev.devres_head)
 		if (platform_match(&pd->dev, &epdrv->pdrv->driver))
-			if(pd->id == id)
+			if (pd->id == id)
 				return pd;
 
 	return NULL;
@@ -1106,7 +1106,7 @@ static  __init int early_platform_left(s
 
 	list_for_each_entry(pd, &early_platform_device_list, dev.devres_head)
 		if (platform_match(&pd->dev, &epdrv->pdrv->driver))
-			if(pd->id >= id)
+			if (pd->id >= id)
 				return 1;
 
 	return 0;
@@ -1168,7 +1168,7 @@ static int __init early_platform_driver_
 			if (epdrv->pdrv->probe(match))
 				pr_warning("%s: unable to probe %s early.\n",
 					   class_str, match->name);
-		        else
+			else
 				n++;
 		}
 
@@ -1199,12 +1199,12 @@ int __init early_platform_driver_probe(c
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

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

