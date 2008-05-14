From: akpm@linux-foundation.org
Subject: + fix-kobject-fix-kobject_rename-and-config_sysfs.patch added to -mm tree
Date: Tue, 13 May 2008 21:25:18 -0700
Message-ID: <200805140436.m4E4aK4D016336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757129AbYENEhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 00:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, gregkh@suse.de, sfr@canb.auug.org.au


The patch titled
     fix "kobject: Fix kobject_rename and !CONFIG_SYSFS"
has been added to the -mm tree.  Its filename is
     fix-kobject-fix-kobject_rename-and-config_sysfs.patch

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
Subject: fix "kobject: Fix kobject_rename and !CONFIG_SYSFS"
From: Andrew Morton <akpm@linux-foundation.org>

mips allnoconfig:

In file included from include/linux/kobject.h:21,
                 from include/linux/slub_def.h:12,
                 from include/linux/slab.h:123,
                 from include/linux/percpu.h:5,
                 from include/linux/rcupdate.h:39,
                 from include/linux/pid.h:4,
                 from include/linux/sched.h:74,
                 from arch/mips/kernel/asm-offsets.c:13:
include/linux/sysfs.h: In function `sysfs_rename_dir':
include/linux/sysfs.h:141: error: implicit declaration of function `kobject_set_name'
In file included from include/linux/slub_def.h:12,
                 from include/linux/slab.h:123,
                 from include/linux/percpu.h:5,
                 from include/linux/rcupdate.h:39,
                 from include/linux/pid.h:4,
                 from include/linux/sched.h:74,
                 from arch/mips/kernel/asm-offsets.c:13:
include/linux/kobject.h: At top level:
include/linux/kobject.h:74: error: conflicting types for 'kobject_set_name'
include/linux/kobject.h:74: note: a parameter list with an ellipsis can't match an empty parameter name list declaration
include/linux/sysfs.h:141: error: previous implicit declaration of 'kobject_set_name' was here
make[1]: *** [arch/mips/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

We cannot include kobject.h from sysfs.h because kobject.h includes sysfs.h.

Just uninline it (fixes everything, doesn't it?)

lib/kobject.c doesn't seem an appropriate file :(

Please fold this (or similar) into the base patch to avoid breaking bisection.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    6 ++----
 lib/kobject.c         |    8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN include/linux/sysfs.h~fix-kobject-fix-kobject_rename-and-config_sysfs include/linux/sysfs.h
--- a/include/linux/sysfs.h~fix-kobject-fix-kobject_rename-and-config_sysfs
+++ a/include/linux/sysfs.h
@@ -136,10 +136,6 @@ static inline void sysfs_remove_dir(stru
 {
 }
 
-static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
-{
-	return kobject_set_name(kobj, "%s", new_name);
-}
 
 static inline int sysfs_move_dir(struct kobject *kobj,
 				 struct kobject *new_parent_kobj)
@@ -226,6 +222,8 @@ static inline void sysfs_printk_last_fil
 {
 }
 
+int sysfs_rename_dir(struct kobject *kobj, const char *new_name);
+
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
diff -puN lib/kobject.c~fix-kobject-fix-kobject_rename-and-config_sysfs lib/kobject.c
--- a/lib/kobject.c~fix-kobject-fix-kobject_rename-and-config_sysfs
+++ a/lib/kobject.c
@@ -882,6 +882,14 @@ struct kset *kset_create_and_add(const c
 	}
 	return kset;
 }
+
+#ifndef CONFIG_SYSFS
+int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
+{
+	return kobject_set_name(kobj, "%s", new_name);
+}
+#endif
+
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
 EXPORT_SYMBOL(kobject_get);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
git-net.patch
git-net-git-rejects.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
selinux-dopey-hack.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
revert-git-block.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
rndis-switch-to-seq_files-checkpatch-fixes.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
mprotect-prevent-alteration-of-the-pat-bits-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

