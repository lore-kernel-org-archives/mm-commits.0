From: akpm@linux-foundation.org
Subject: - pppol2tp-fix-printk-warnings.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:50 -0800
Message-ID: <200802132015.m1DKFoDM011407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbYBMUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pppol2tp: fix printk warnings
has been removed from the -mm tree.  Its filename was
     pppol2tp-fix-printk-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pppol2tp: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/pppol2tp.c: In function `pppol2tp_seq_tunnel_show':
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 4)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 5)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 6)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 7)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 8)
drivers/net/pppol2tp.c:2295: warning: long long unsigned int format, __u64 arg (arg 9)
drivers/net/pppol2tp.c: In function `pppol2tp_seq_session_show':
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 5)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 6)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 7)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 8)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 9)
drivers/net/pppol2tp.c:2328: warning: long long unsigned int format, __u64 arg (arg 10)

Not all platforms implement u64 with unsigned long long.  eg: powerpc.

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pppol2tp.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/net/pppol2tp.c~pppol2tp-fix-printk-warnings drivers/net/pppol2tp.c
--- a/drivers/net/pppol2tp.c~pppol2tp-fix-printk-warnings
+++ a/drivers/net/pppol2tp.c
@@ -2289,10 +2289,12 @@ static void pppol2tp_seq_tunnel_show(str
 		   atomic_read(&tunnel->ref_count) - 1);
 	seq_printf(m, " %08x %llu/%llu/%llu %llu/%llu/%llu\n",
 		   tunnel->debug,
-		   tunnel->stats.tx_packets, tunnel->stats.tx_bytes,
-		   tunnel->stats.tx_errors,
-		   tunnel->stats.rx_packets, tunnel->stats.rx_bytes,
-		   tunnel->stats.rx_errors);
+		   (unsigned long long)tunnel->stats.tx_packets,
+		   (unsigned long long)tunnel->stats.tx_bytes,
+		   (unsigned long long)tunnel->stats.tx_errors,
+		   (unsigned long long)tunnel->stats.rx_packets,
+		   (unsigned long long)tunnel->stats.rx_bytes,
+		   (unsigned long long)tunnel->stats.rx_errors);
 }
 
 static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
@@ -2320,12 +2322,12 @@ static void pppol2tp_seq_session_show(st
 		   jiffies_to_msecs(session->reorder_timeout));
 	seq_printf(m, "   %hu/%hu %llu/%llu/%llu %llu/%llu/%llu\n",
 		   session->nr, session->ns,
-		   session->stats.tx_packets,
-		   session->stats.tx_bytes,
-		   session->stats.tx_errors,
-		   session->stats.rx_packets,
-		   session->stats.rx_bytes,
-		   session->stats.rx_errors);
+		   (unsigned long long)session->stats.tx_packets,
+		   (unsigned long long)session->stats.tx_bytes,
+		   (unsigned long long)session->stats.tx_errors,
+		   (unsigned long long)session->stats.rx_packets,
+		   (unsigned long long)session->stats.rx_bytes,
+		   (unsigned long long)session->stats.rx_errors);
 }
 
 static int pppol2tp_seq_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
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
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
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
