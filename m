From: akpm@linux-foundation.org
Subject: - modules-make-module_address_lookup-safe-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:31 -0800
Message-ID: <200802082012.m18KCCFb010180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762784AbYBHUqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kyle@mcmartin.ca, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix "modules: make module_address_lookup() safe"
has been removed from the -mm tree.  Its filename was
     modules-make-module_address_lookup-safe-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "modules: make module_address_lookup() safe"
From: Andrew Morton <akpm@linux-foundation.org>

Get the constness right, avoid nasty cast.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    4 ++--
 kernel/module.c        |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/module.h~modules-make-module_address_lookup-safe-fix include/linux/module.h
--- a/include/linux/module.h~modules-make-module_address_lookup-safe-fix
+++ a/include/linux/module.h
@@ -449,7 +449,7 @@ static inline void __module_get(struct m
 /* For kallsyms to ask for address resolution.  namebuf should be at
  * least KSYM_NAME_LEN long: a pointer to namebuf is returned if
  * found, otherwise NULL. */
-char *module_address_lookup(unsigned long addr,
+const char *module_address_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
 			    unsigned long *offset,
 			    char **modname,
@@ -519,7 +519,7 @@ static inline void module_put(struct mod
 #define module_name(mod) "kernel"
 
 /* For kallsyms to ask for address resolution.  NULL means not found. */
-static inline char *module_address_lookup(unsigned long addr,
+static inline const char *module_address_lookup(unsigned long addr,
 					  unsigned long *symbolsize,
 					  unsigned long *offset,
 					  char **modname,
diff -puN kernel/module.c~modules-make-module_address_lookup-safe-fix kernel/module.c
--- a/kernel/module.c~modules-make-module_address_lookup-safe-fix
+++ a/kernel/module.c
@@ -2253,7 +2253,7 @@ static const char *get_ksymbol(struct mo
 
 /* For kallsyms to ask for address resolution.  NULL means not found.  Careful
  * not to lock to avoid deadlock on oopses, simply disable preemption. */
-char *module_address_lookup(unsigned long addr,
+const char *module_address_lookup(unsigned long addr,
 			    unsigned long *size,
 			    unsigned long *offset,
 			    char **modname,
@@ -2278,7 +2278,7 @@ char *module_address_lookup(unsigned lon
 		ret = namebuf;
 	}
 	preempt_enable();
-	return (char *)ret;
+	return ret;
 }
 
 int lookup_module_symbol_name(unsigned long addr, char *symname)
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
