From: akpm@linux-foundation.org
Subject: + git-scsi-misc-revert-st-show-options-currently-set-in-sysfs.patch added to -mm tree
Date: Thu, 13 Mar 2008 11:54:58 -0700
Message-ID: <200803131854.m2DIsweZ027752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbYCMSzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 14:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, Kai.Makisara@kolumbus.fi, greg@kroah.com, kai.makisara@kolumbus.fi, sfr@canb.auug.org.au, tonyj@suse.de


The patch titled
     git-scsi-misc: revert "st: show options currently set in sysfs"
has been added to the -mm tree.  Its filename is
     git-scsi-misc-revert-st-show-options-currently-set-in-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: git-scsi-misc: revert "st: show options currently set in sysfs=
"
=46rom: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 0b65635a7b2cb942896655ff1bf277e6fe9f765d
Author: Kai Makisara <Kai.Makisara@kolumbus.fi>
Date:   Sun Feb 24 22:29:12 2008 +0200

    Show the current binary tape driver and mode options is sysfs. A fi=
le
    (options) is created in each directory in /sys/class/scsi_tape. The=
 files
    contain masks showing the options. The mask bit definitions are the=
 same as
    used when setting the options using the MTSETDRVBUFFER function in =
the
    MTIOCTOP ioctl (defined in include/linux/mtio.h). For example:
    > cat /sys/class/scsi_tape/nst0/options
    0x00000d07
   =20
    [jejb: updated doc with correction from Randy Dunlap]

Because Greg's tree buggered it up.

Cc: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Tony Jones <tonyj@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/st.txt |    7 -----
 drivers/scsi/st.c         |   43 ------------------------------------
 2 files changed, 1 insertion(+), 49 deletions(-)

diff -puN Documentation/scsi/st.txt~git-scsi-misc-revert-st-show-option=
s-currently-set-in-sysfs Documentation/scsi/st.txt
--- a/Documentation/scsi/st.txt~git-scsi-misc-revert-st-show-options-cu=
rrently-set-in-sysfs
+++ a/Documentation/scsi/st.txt
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai M=C3=A4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Sun Feb 24 21:59:07 2008 by kai.makisara
+Last modified: Thu Feb 21 21:54:16 2008 by kai.makisara
=20
=20
 BASICS
@@ -133,11 +133,6 @@ the defaults set by the user. The value=20
 file 'dev' contains the device numbers corresponding to this device. T=
he links
 'device' and 'driver' point to the SCSI device and driver entries.
=20
-Each directory also contains the entry 'options' which shows the curre=
ntly
-enabled driver and mode options. The value in the file is a bit mask w=
here the
-bit definitions are the same as those used with MTSETDRVBUFFER in sett=
ing the
-options.
-
 A link named 'tape' is made from the SCSI device directory to the clas=
s
 directory corresponding to the mode 0 auto-rewind device (e.g., st0).=20
=20
diff -puN drivers/scsi/st.c~git-scsi-misc-revert-st-show-options-curren=
tly-set-in-sysfs drivers/scsi/st.c
--- a/drivers/scsi/st.c~git-scsi-misc-revert-st-show-options-currently-=
set-in-sysfs
+++ a/drivers/scsi/st.c
@@ -4370,46 +4370,6 @@ st_defcompression_show(struct device *de
=20
 DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL=
);
=20
-static ssize_t st_options_show(struct class_device *class_dev, char *b=
uf)
-{
-	struct st_modedef *STm =3D (struct st_modedef *)class_get_devdata(cla=
ss_dev);
-	struct scsi_tape *STp;
-	int i, j, options;
-	ssize_t l =3D 0;
-
-	for (i=3D0; i < st_dev_max; i++) {
-		for (j=3D0; j < ST_NBR_MODES; j++)
-			if (&scsi_tapes[i]->modes[j] =3D=3D STm)
-				break;
-		if (j < ST_NBR_MODES)
-			break;
-	}
-	if (i =3D=3D st_dev_max)
-		return 0;  /* should never happen */
-
-	STp =3D scsi_tapes[i];
-
-	options =3D STm->do_buffer_writes ? MT_ST_BUFFER_WRITES : 0;
-	options |=3D STm->do_async_writes ? MT_ST_ASYNC_WRITES : 0;
-	options |=3D STm->do_read_ahead ? MT_ST_READ_AHEAD : 0;
-	DEB( options |=3D debugging ? MT_ST_DEBUGGING : 0 );
-	options |=3D STp->two_fm ? MT_ST_TWO_FM : 0;
-	options |=3D STp->fast_mteom ? MT_ST_FAST_MTEOM : 0;
-	options |=3D STm->defaults_for_writes ? MT_ST_DEF_WRITES : 0;
-	options |=3D STp->can_bsr ? MT_ST_CAN_BSR : 0;
-	options |=3D STp->omit_blklims ? MT_ST_NO_BLKLIMS : 0;
-	options |=3D STp->can_partitions ? MT_ST_CAN_PARTITIONS : 0;
-	options |=3D STp->scsi2_logical ? MT_ST_SCSI2LOGICAL : 0;
-	options |=3D STm->sysv ? MT_ST_SYSV : 0;
-	options |=3D STp->immediate ? MT_ST_NOWAIT : 0;
-	options |=3D STp->sili ? MT_ST_SILI : 0;
-
-	l =3D snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
-	return l;
-}
-
-CLASS_DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
-
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, i=
nt mode)
 {
 	int i, rew, error;
@@ -4447,9 +4407,6 @@ static int do_create_class_files(struct=20
 		error =3D device_create_file(st_class_member,
 					   &dev_attr_default_compression);
 		if (error) goto out;
-		error =3D class_device_create_file(st_class_member,
-				        &class_device_attr_options);
-		if (error) goto out;
=20
 		if (mode =3D=3D 0 && rew =3D=3D 0) {
 			error =3D sysfs_create_link(&STp->device->sdev_gendev.kobj,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fix=
es.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
drivers-media-video-soc_camerac-reads-return-size_t.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex=
-and-make-it-static.patch
git-selinux.patch
git-sh.patch
git-scsi-misc-revert-st-show-options-currently-set-in-sysfs.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-usb-serial-spcp8x5-driver.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
drivers-usb-core-devioc-suppress-warning-with-64k-page_size.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
revert-acpi-thermal-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.pat=
ch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.pa=
tch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.p=
atch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.=
patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.pa=
tch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fi=
xes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.p=
atch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.p=
atch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fix=
es.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=3Dn-override-with-edd=3Donoff-fix.p=
atch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
