From: akpm@linux-foundation.org
Subject: + hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch added to -mm tree
Date: Wed, 28 Jan 2009 11:26:20 -0800
Message-ID: <200901281926.n0SJQK8i000314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbZA1T1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 14:27:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry.Finger@lwfinger.net, deller@gmx.de, elendil@planet.nl, lenb@kernel.org, mjg@redhat.com


The patch titled
     hp-wmi: fix error path in hp_wmi_bios_setup()
has been added to the -mm tree.  Its filename is
     hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch

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
Subject: hp-wmi: fix error path in hp_wmi_bios_setup()
From: Andrew Morton <akpm@linux-foundation.org>

The error-path code can call rfkill_unregister() with a pointer which does
not contain the result of a call to rfkill_register().  It goes BUG().

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12560.

Cc: Frans Pop <elendil@planet.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Reported-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-fix-error-path-in-hp_wmi_bios_setup drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-fix-error-path-in-hp_wmi_bios_setup
+++ a/drivers/platform/x86/hp-wmi.c
@@ -458,9 +458,11 @@ static int __init hp_wmi_bios_setup(stru
 
 	return 0;
 register_wwan_err:
-	rfkill_unregister(bluetooth_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
 register_bluetooth_error:
-	rfkill_unregister(wifi_rfkill);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
 add_sysfs_error:
 	cleanup_sysfs(device);
 	return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
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
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
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

