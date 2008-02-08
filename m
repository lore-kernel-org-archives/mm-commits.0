From: akpm@linux-foundation.org
Subject: - fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:59 -0800
Message-ID: <200802082017.m18KHeVv010846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYBHUnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:43:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/hfsplus/unicode.c: fix uninitialized var warning
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/hfsplus/unicode.c: fix uninitialized var warning
From: Andrew Morton <akpm@linux-foundation.org>

fs/hfsplus/unicode.c: In function 'hfsplus_hash_dentry':
fs/hfsplus/unicode.c:328: warning: 'dsize' may be used uninitialized in this function

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/unicode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/unicode.c~fs-hfsplus-unicodec-fix-uninitialized-var-warning fs/hfsplus/unicode.c
--- a/fs/hfsplus/unicode.c~fs-hfsplus-unicodec-fix-uninitialized-var-warning
+++ a/fs/hfsplus/unicode.c
@@ -325,7 +325,7 @@ int hfsplus_hash_dentry(struct dentry *d
 	struct super_block *sb = dentry->d_sb;
 	const char *astr;
 	const u16 *dstr;
-	int casefold, decompose, size, dsize, len;
+	int casefold, decompose, size, len;
 	unsigned long hash;
 	wchar_t c;
 	u16 c2;
@@ -336,6 +336,7 @@ int hfsplus_hash_dentry(struct dentry *d
 	astr = str->name;
 	len = str->len;
 	while (len > 0) {
+		int uninitialized_var(dsize);
 		size = asc2unichar(sb, astr, len, &c);
 		astr += size;
 		len -= size;
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
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
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
