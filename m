From: akpm@linux-foundation.org
Subject: - ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:42:07 -0700
Message-ID: <200710242142.l9OLg73X014022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbXJXVpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#23: FILE: drivers/usb/serial/ftdi_sio.c:297:
+	speed_t force_baud;	/* if non-zero, force the baud rate to this value */

ERROR: use tabs not spaces
#31: FILE: drivers/usb/serial/ftdi_sio.c:881:
+^I$

ERROR: use tabs not spaces
#39: FILE: drivers/usb/serial/ftdi_sio.c:890:
+^I$

WARNING: line over 80 characters
#111: FILE: drivers/usb/serial/ftdi_sio.c:1956:
+		tty_encode_baud_rate(port->tty, priv->force_baud, priv->force_baud);

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio.c~ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -878,7 +878,7 @@ static __u32 get_ftdi_divisor(struct usb
 		if (div_value == 0) {
 			dbg("%s - Baudrate (%d) requested is not supported", __FUNCTION__,  baud);
 			div_value = ftdi_sio_b9600;
-	                baud = 9600;
+			baud = 9600;
 			div_okay = 0;
 		}
 		break;
@@ -887,7 +887,7 @@ static __u32 get_ftdi_divisor(struct usb
 			div_value = ftdi_232am_baud_to_divisor(baud);
 		} else {
 	                dbg("%s - Baud rate too high!", __FUNCTION__);
-	                baud = 9600;
+			baud = 9600;
 			div_value = ftdi_232am_baud_to_divisor(9600);
 			div_okay = 0;
 		}
@@ -1953,7 +1953,8 @@ static void ftdi_set_termios (struct usb
 	/* Force baud rate if this device requires it, unless it is set to B0. */
 	if (priv->force_baud && ((termios->c_cflag & CBAUD) != B0)) {
 		dbg("%s: forcing baud rate for this device", __FUNCTION__);
-		tty_encode_baud_rate(port->tty, priv->force_baud, priv->force_baud);
+		tty_encode_baud_rate(port->tty, priv->force_baud,
+					priv->force_baud);
 	}
 
 	/* Force RTS-CTS if this device requires it. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
