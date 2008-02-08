From: akpm@linux-foundation.org
Subject: - possible-bug-fix-in-ehci-hcd-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 15:49:56 -0800
Message-ID: <200802082349.m18Nnba8020238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967AbYBHXuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 18:50:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy@smile.org.ua, david-b@pacbell.net, greg@kroah.com, sgosne@sequans.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     possible-bug-fix-in-ehci-hcd-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     possible-bug-fix-in-ehci-hcd-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: possible-bug-fix-in-ehci-hcd-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#28: FILE: drivers/usb/host/ehci-q.c:759:
+			struct usb_device_descriptor *desc = &urb->dev->descriptor;

WARNING: line over 80 characters
#32: FILE: drivers/usb/host/ehci-q.c:762:
+			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {

WARNING: braces {} are not necessary for any arm of this statement
#32: FILE: drivers/usb/host/ehci-q.c:762:
+			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {

WARNING: no space between function name and open parenthesis '('
#33: FILE: drivers/usb/host/ehci-q.c:763:
+				info1 |= max_packet (maxp) << 16;

WARNING: line over 80 characters
#35: FILE: drivers/usb/host/ehci-q.c:765:
+				info1 |= 512 << 16;	/* usb2 fixed maxpacket */

total: 0 errors, 5 warnings, 15 lines checked

./patches/possible-bug-fix-in-ehci-hcd.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Shevchenko <andy@smile.org.ua>
Cc: David Brownell <david-b@pacbell.net>
Cc: Gosne Stephane <sgosne@sequans.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-q.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/usb/host/ehci-q.c~possible-bug-fix-in-ehci-hcd-checkpatch-fixes drivers/usb/host/ehci-q.c
--- a/drivers/usb/host/ehci-q.c~possible-bug-fix-in-ehci-hcd-checkpatch-fixes
+++ a/drivers/usb/host/ehci-q.c
@@ -759,11 +759,11 @@ qh_make (
 			struct usb_device_descriptor *desc = &urb->dev->descriptor;
 			info1 |= (EHCI_TUNE_RL_HS << 28);
 			/* Special hook for SQN11x0 */
-			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {
+			if (desc->idVendor == 0x148e &&
+					desc->idProduct == 0x0900)
 				info1 |= max_packet (maxp) << 16;
-			} else {
-				info1 |= 512 << 16;	/* usb2 fixed maxpacket */
-			}
+			else
+				info1 |= 512 << 16; /* usb2 fixed maxpacket */
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
 			info1 |= max_packet (maxp) << 16;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
pppol2tp-fix-printk-warnings.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
possible-bug-fix-in-ehci-hcd-checkpatch-fixes.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
