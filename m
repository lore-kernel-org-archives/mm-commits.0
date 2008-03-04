From: akpm@linux-foundation.org
Subject: - usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:45 -0800
Message-ID: <200803042009.m24K9jJX026784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765530AbYCDUKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, tom.leiming@gmail.com, mm-commits@vger.kernel.org


The patch titled
     usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#81: FILE: drivers/usb/misc/auerswald.c:287:
+        pauerchainelement_t acep =  urb->context;$

ERROR: use tabs not spaces
#108: FILE: drivers/usb/misc/auerswald.c:863:
+        pauerbuf_t bp =  urb->context;$

ERROR: use tabs not spaces
#117: FILE: drivers/usb/misc/auerswald.c:907:
+        pauerbuf_t    bp  =  urb->context;$

ERROR: use tabs not spaces
#126: FILE: drivers/usb/misc/auerswald.c:984:
+        pauerswald_t cp =  urb->context;$

ERROR: use tabs not spaces
#138: FILE: drivers/usb/misc/ftdi-elan.c:749:
+        struct usb_ftdi *ftdi = urb->context;$

WARNING: no space between function name and open parenthesis '('
#204: FILE: drivers/usb/misc/usbtest.c:204:
+	complete (urb->context);

WARNING: no space between function name and open parenthesis '('
#213: FILE: drivers/usb/misc/usbtest.c:1048:
+		complete (urb->context);

total: 5 errors, 2 warnings, 808 lines checked

./patches/usb-remove-unnecessary-type-casting-of-urb-context.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <greg@kroah.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/auerswald.c |    8 ++++----
 drivers/usb/misc/ftdi-elan.c |    2 +-
 drivers/usb/misc/usbtest.c   |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/usb/misc/auerswald.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
+++ a/drivers/usb/misc/auerswald.c
@@ -284,7 +284,7 @@ static void auerchain_complete (struct u
         int result;
 
         /* get pointer to element and to chain */
-        pauerchainelement_t acep =  urb->context;
+	pauerchainelement_t acep = urb->context;
         pauerchain_t         acp = acep->chain;
 
         /* restore original entries in urb */
@@ -860,7 +860,7 @@ static void auerchar_ctrlwrite_complete 
 /* Completion handler for dummy retry packet */
 static void auerswald_ctrlread_wretcomplete (struct urb * urb)
 {
-        pauerbuf_t bp =  urb->context;
+	pauerbuf_t bp = urb->context;
         pauerswald_t cp;
 	int ret;
 	int status = urb->status;
@@ -904,7 +904,7 @@ static void auerswald_ctrlread_complete 
         unsigned int  serviceid;
         pauerswald_t  cp;
         pauerscon_t   scp;
-        pauerbuf_t    bp  =  urb->context;
+	pauerbuf_t    bp = urb->context;
 	int status = urb->status;
 	int ret;
 
@@ -981,7 +981,7 @@ static void auerswald_int_complete (stru
         int ret;
 	int status = urb->status;
         pauerbuf_t   bp = NULL;
-        pauerswald_t cp =  urb->context;
+	pauerswald_t cp = urb->context;
 
         dbg ("%s called", __FUNCTION__);
 
diff -puN drivers/usb/misc/ftdi-elan.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -746,7 +746,7 @@ static ssize_t ftdi_elan_read(struct fil
 
 static void ftdi_elan_write_bulk_callback(struct urb *urb)
 {
-        struct usb_ftdi *ftdi = urb->context;
+	struct usb_ftdi *ftdi = urb->context;
 	int status = urb->status;
 
 	if (status && !(status == -ENOENT || status == -ECONNRESET ||
diff -puN drivers/usb/misc/usbtest.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
+++ a/drivers/usb/misc/usbtest.c
@@ -201,7 +201,7 @@ found:
 
 static void simple_callback (struct urb *urb)
 {
-	complete (urb->context);
+	complete(urb->context);
 }
 
 static struct urb *simple_alloc_urb (
@@ -1045,7 +1045,7 @@ static void unlink1_callback (struct urb
 		status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status) {
 		urb->status = status;
-		complete (urb->context);
+		complete(urb->context);
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
zlc_setup-handle-jiffies-wraparound-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-alsa-build-fix.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-ocfs2-dlm-dlmdomainc-fix-printk-warning.patch
sh-export-copy-page-to-modules.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-v9fs.patch
git-semaphore-git-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
iommu-parisc-pass-struct-device-to-iommu_alloc_range-checkpatch-fixes.patch
iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits-checkpatch-fixes.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

