From: akpm@linux-foundation.org
Subject: + usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:10:06 -0800
Message-ID: <200802280110.m1S1A7Il008523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756847AbYB1BKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, tom.leiming@gmail.com


The patch titled
     usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-x86.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
git-v9fs.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
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
