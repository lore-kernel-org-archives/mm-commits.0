From: akpm@linux-foundation.org
Subject: + oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:37:00 -0800
Message-ID: <200802122337.m1CNb0Nx028852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbYBLXhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, phil.el@wanadoo.fr, travis@sgi.com


The patch titled
     oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch

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
Subject: oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#24: FILE: drivers/oprofile/buffer_sync.c:497:
+	struct oprofile_cpu_buffer * cpu_buf = &per_cpu(cpu_buffer, cpu);

ERROR: "foo * bar" should be "foo *bar"
#54: FILE: drivers/oprofile/cpu_buffer.c:52:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#63: FILE: drivers/oprofile/cpu_buffer.c:86:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#72: FILE: drivers/oprofile/cpu_buffer.c:103:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#81: FILE: drivers/oprofile/cpu_buffer.c:230:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

ERROR: "foo * bar" should be "foo *bar"
#90: FILE: drivers/oprofile/cpu_buffer.c:257:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

ERROR: "foo * bar" should be "foo *bar"
#97: FILE: drivers/oprofile/cpu_buffer.c:263:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

total: 7 errors, 0 warnings, 102 lines checked

./patches/oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Travis <travis@sgi.com>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c |    2 +-
 drivers/oprofile/cpu_buffer.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
+++ a/drivers/oprofile/buffer_sync.c
@@ -494,7 +494,7 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &per_cpu(cpu_buffer, cpu);
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
 	struct task_struct * new;
 	unsigned long cookie = 0;
diff -puN drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
+++ a/drivers/oprofile/cpu_buffer.c
@@ -49,7 +49,7 @@ int alloc_cpu_buffers(void)
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
@@ -83,7 +83,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -100,7 +100,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		cancel_delayed_work(&b->work);
 	}
@@ -227,7 +227,7 @@ static void oprofile_end_trace(struct op
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
@@ -254,13 +254,13 @@ void oprofile_add_sample(struct pt_regs 
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	log_sample(cpu_buf, pc, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
softlockup-workaround.patch
revert-proc-fix-the-threaded-proc-self.patch
memstick-initial-commit-for-sony-memorystick-support.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
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
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3.patch
sunprc-fix-printk-format-warning-checkpatch-fixes.patch
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
