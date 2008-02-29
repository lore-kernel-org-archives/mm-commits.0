From: akpm@linux-foundation.org
Subject: + gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:07:25 -0800
Message-ID: <200802290107.m1T17PGf030359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761890AbYB2BJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bharrosh@panasas.com


The patch titled
     gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes.patch

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
Subject: gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need space after that ',' (ctx:VxV)
#85: FILE: drivers/scsi/gdth.c:2292:
+    ushort cpcount,i, max_sg = scsi_sg_count(scp);
                   ^

ERROR: use tabs not spaces
#100: FILE: drivers/scsi/gdth.c:2305:
+                          cpnow, cpsum, cpcount, scsi_bufflen(scp)));$

ERROR: use tabs not spaces
#109: FILE: drivers/scsi/gdth.c:2528:
+        if (scsi_bufflen(scp)) {$

ERROR: use tabs not spaces
#113: FILE: drivers/scsi/gdth.c:2531:
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),$

ERROR: use tabs not spaces
#122: FILE: drivers/scsi/gdth.c:2678:
+            cmdp->u.raw64.sdlen      = scsi_bufflen(scp);$

ERROR: use tabs not spaces
#131: FILE: drivers/scsi/gdth.c:2695:
+            cmdp->u.raw.sdlen      = scsi_bufflen(scp);$

ERROR: use tabs not spaces
#140: FILE: drivers/scsi/gdth.c:2704:
+        if (scsi_bufflen(scp)) {$

ERROR: use tabs not spaces
#143: FILE: drivers/scsi/gdth.c:2706:
+            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),$

ERROR: use tabs not spaces
#153: FILE: drivers/scsi/gdth.c:3327:
+        if (scsi_bufflen(scp))$

ERROR: use tabs not spaces
#154: FILE: drivers/scsi/gdth.c:3328:
+            pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),$

total: 10 errors, 0 warnings, 141 lines checked

./patches/gdth-remove-gdth-cooked-up-command-accessors.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes
+++ a/drivers/scsi/gdth.c
@@ -2289,7 +2289,7 @@ static void gdth_next(gdth_ha_str *ha)
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
 				    char *buffer, ushort count)
 {
-    ushort cpcount,i, max_sg = scsi_sg_count(scp);
+    ushort cpcount, i, max_sg = scsi_sg_count(scp);
     ushort cpsum,cpnow;
     struct scatterlist *sl;
     char *address;
@@ -2302,7 +2302,7 @@ static void gdth_copy_internal_data(gdth
             unsigned long flags;
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
-                          cpnow, cpsum, cpcount, scsi_bufflen(scp)));
+		   cpnow, cpsum, cpcount, scsi_bufflen(scp)));
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
@@ -2525,10 +2525,10 @@ static int gdth_fill_cache_cmd(gdth_ha_s
             cmdp->u.cache.BlockCnt = blockcnt;
         }
 
-        if (scsi_bufflen(scp)) {
+	if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = (read_write == 1 ?
                 PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);   
-            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
+	    sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -2675,7 +2675,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw64.lun        = l;
             cmdp->u.raw64.bus        = b;
             cmdp->u.raw64.priority   = 0;
-            cmdp->u.raw64.sdlen      = scsi_bufflen(scp);
+	    cmdp->u.raw64.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw64.sense_len  = 16;
             cmdp->u.raw64.sense_data = sense_paddr;
             cmdp->u.raw64.direction  = 
@@ -2692,7 +2692,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw.bus        = b;
             cmdp->u.raw.priority   = 0;
             cmdp->u.raw.link_p     = 0;
-            cmdp->u.raw.sdlen      = scsi_bufflen(scp);
+	    cmdp->u.raw.sdlen      = scsi_bufflen(scp);
             cmdp->u.raw.sense_len  = 16;
             cmdp->u.raw.sense_data = sense_paddr;
             cmdp->u.raw.direction  = 
@@ -2701,9 +2701,9 @@ static int gdth_fill_raw_cmd(gdth_ha_str
             cmdp->u.raw.sg_ranz    = 0;
         }
 
-        if (scsi_bufflen(scp)) {
+	if (scsi_bufflen(scp)) {
             cmndinfo->dma_dir = PCI_DMA_BIDIRECTIONAL;
-            sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
+	    sgcnt = pci_map_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                                cmndinfo->dma_dir);
             if (mode64) {
                 struct scatterlist *sl;
@@ -3324,8 +3324,8 @@ static int gdth_sync_event(gdth_ha_str *
             /* retry */
             return 2;
         }
-        if (scsi_bufflen(scp))
-            pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
+	if (scsi_bufflen(scp))
+	    pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                          cmndinfo->dma_dir);
 
         if (cmndinfo->sense_paddr)
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
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
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
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
gdth-fix-to-internal-commands-execution-checkpatch-fixes.patch
gdth-remove-gdth-cooked-up-command-accessors-checkpatch-fixes.patch
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
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
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

