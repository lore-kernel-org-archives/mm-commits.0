From: akpm@linux-foundation.org
Subject: - deprecate-smbfs-in-favour-of-cifs.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:05:02 -0800
Message-ID: <200802060704.m1674huV030912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbYBFHGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@kernel.org, jlayton@redhat.com, olecom@flower.upol.cz, sfrench@us.ibm.com, urban@teststation.com, mm-commits@vger.kernel.org


The patch titled
     deprecate smbfs in favour of cifs
has been removed from the -mm tree.  Its filename was
     deprecate-smbfs-in-favour-of-cifs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: deprecate smbfs in favour of cifs
From: Andrew Morton <akpm@linux-foundation.org>

smbfs is a bit buggy and has no maintainer.  Change it to shout at the user on
the first five mount attempts - tell them to switch to CIFS.

Come December we'll mark it BROKEN and see what happens.

[olecom@flower.upol.cz: documentation update]
Cc: Urban Widmark <urban@teststation.com>
Acked-by: Steven French <sfrench@us.ibm.com>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig       |   28 ++++++++++++++--------------
 fs/smbfs/inode.c |    7 +++++++
 2 files changed, 21 insertions(+), 14 deletions(-)

diff -puN fs/Kconfig~deprecate-smbfs-in-favour-of-cifs fs/Kconfig
--- a/fs/Kconfig~deprecate-smbfs-in-favour-of-cifs
+++ a/fs/Kconfig
@@ -1152,7 +1152,7 @@ config BEFS_DEBUG
 	depends on BEFS_FS
 	help
 	  If you say Y here, you can use the 'debug' mount option to enable
-	  debugging output from the driver. 
+	  debugging output from the driver.
 
 config BFS_FS
 	tristate "BFS file system support (EXPERIMENTAL)"
@@ -1263,7 +1263,7 @@ config JFFS2_FS_XATTR
 	  Extended attributes are name:value pairs associated with inodes by
 	  the kernel or by users (see the attr(5) manual page, or visit
 	  <http://acl.bestbits.at/> for details).
-	  
+
 	  If unsure, say N.
 
 config JFFS2_FS_POSIX_ACL
@@ -1274,10 +1274,10 @@ config JFFS2_FS_POSIX_ACL
 	help
 	  Posix Access Control Lists (ACLs) support permissions for users and
 	  groups beyond the owner/group/world scheme.
-	  
+
 	  To learn more about Access Control Lists, visit the Posix ACLs for
 	  Linux website <http://acl.bestbits.at/>.
-	  
+
 	  If you don't know what Access Control Lists are, say N
 
 config JFFS2_FS_SECURITY
@@ -1289,7 +1289,7 @@ config JFFS2_FS_SECURITY
 	  implemented by security modules like SELinux.  This option
 	  enables an extended attribute handler for file security
 	  labels in the jffs2 filesystem.
-	  
+
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
@@ -1835,7 +1835,7 @@ config RPCSEC_GSS_SPKM3
 	  If unsure, say N.
 
 config SMB_FS
-	tristate "SMB file system support (to mount Windows shares etc.)"
+	tristate "SMB file system support (OBSOLETE, please use CIFS)"
 	depends on INET
 	select NLS
 	help
@@ -1858,8 +1858,8 @@ config SMB_FS
 	  General information about how to connect Linux, Windows machines and
 	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
 
-	  To compile the SMB support as a module, choose M here: the module will
-	  be called smbfs.  Most people say N, however.
+	  To compile the SMB support as a module, choose M here:
+	  the module will be called smbfs.  Most people say N, however.
 
 config SMB_NLS_DEFAULT
 	bool "Use a default NLS"
@@ -1891,7 +1891,7 @@ config SMB_NLS_REMOTE
 	  smbmount from samba 2.2.0 or later supports this.
 
 config CIFS
-	tristate "CIFS support (advanced network filesystem for Samba, Window and other CIFS compliant servers)"
+	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
 	help
@@ -1949,16 +1949,16 @@ config CIFS_WEAK_PW_HASH
 	  LANMAN based servers such as OS/2 and Windows 95, but such
 	  mounts may be less secure than mounts using NTLM or more recent
 	  security mechanisms if you are on a public network.  Unless you
-	  have a need to access old SMB servers (and are on a private 
+	  have a need to access old SMB servers (and are on a private
 	  network) you probably want to say N.  Even if this support
 	  is enabled in the kernel build, LANMAN authentication will not be
 	  used automatically. At runtime LANMAN mounts are disabled but
 	  can be set to required (or optional) either in
 	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
-	  option on the mount command. This support is disabled by 
+	  option on the mount command. This support is disabled by
 	  default in order to reduce the possibility of a downgrade
 	  attack.
- 
+
 	  If unsure, say N.
 
 config CIFS_XATTR
@@ -1999,7 +1999,7 @@ config CIFS_DEBUG2
 	   messages in some error paths, slowing performance. This
 	   option can be turned off unless you are debugging
 	   cifs problems.  If unsure, say N.
-	   
+
 config CIFS_EXPERIMENTAL
 	  bool "CIFS Experimental Features (EXPERIMENTAL)"
 	  depends on CIFS && EXPERIMENTAL
@@ -2090,7 +2090,7 @@ config CODA_FS_OLD_API
 	  However this new API is not backward compatible with older
 	  clients. If you really need to run the old Coda userspace
 	  cache manager then say Y.
-	  
+
 	  For most cases you probably want to say N.
 
 config AFS_FS
diff -puN fs/smbfs/inode.c~deprecate-smbfs-in-favour-of-cifs fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~deprecate-smbfs-in-favour-of-cifs
+++ a/fs/smbfs/inode.c
@@ -500,6 +500,13 @@ static int smb_fill_super(struct super_b
 	struct smb_fattr root;
 	int ver;
 	void *mem;
+	static int warn_count;
+
+	if (warn_count < 5) {
+		warn_count++;
+		printk(KERN_EMERG "smbfs is deprecated and will be removed"
+			"from the 2.6.27 kernel.  Please migrate to cifs\n");
+	}
 
 	if (!raw_data)
 		goto out_no_data;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
git-input.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
git-net.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-ipwireless_cs.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xtensa.patch
git-slub.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
md-change-interate_mddev-to-for_each_mddev-fix.patch
md-change-iterate_rdev-to-rdev_for_each-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
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
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
