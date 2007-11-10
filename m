From: akpm@linux-foundation.org
Subject: + add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:11:19 -0800
Message-ID: <200711100111.lAA1BKjZ008519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758564AbXKJBMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need consistent spacing around '-' (ctx:WxV)
#72: FILE: fs/proc/array.c:296:
+				  a->cap[(_LINUX_CAPABILITY_U32S-1) -__capi]);
 				                                    ^

ERROR: need spaces around that '=' (ctx:VxV)
#225: FILE: include/linux/capability.h:332:
+	for (__capi=0; __capi<_LINUX_CAPABILITY_U32S; ++__capi)
 	           ^

ERROR: need spaces around that '<' (ctx:VxV)
#225: FILE: include/linux/capability.h:332:
+	for (__capi=0; __capi<_LINUX_CAPABILITY_U32S; ++__capi)
 	                     ^

ERROR: need consistent spacing around '|' (ctx:WxV)
#233: FILE: include/linux/capability.h:338:
+			    |CAP_TO_MASK(CAP_FSETID))
 			    ^

ERROR: need a space after that close brace '}'
#239: FILE: include/linux/capability.h:344:
+# define CAP_EMPTY_SET    {{ 0, 0 }}

ERROR: need a space after that close brace '}'
#240: FILE: include/linux/capability.h:345:
+# define CAP_FULL_SET     {{ ~0, ~0 }}

ERROR: need a space after that close brace '}'
#241: FILE: include/linux/capability.h:346:
+# define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}

ERROR: need a space after that close brace '}'
#242: FILE: include/linux/capability.h:347:
+# define CAP_FS_SET       {{ CAP_FS_MASK_B0, 0 }}

ERROR: need a space after that close brace '}'
#243: FILE: include/linux/capability.h:348:
+# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), 0 }}

ERROR: need space after that ',' (ctx:VxV)
#253: FILE: include/linux/capability.h:358:
+#define cap_raise(c,flag)  ((c).cap[CAP_TO_INDEX(flag)] |= CAP_TO_MASK(flag))
                    ^

ERROR: need space after that ',' (ctx:VxV)
#254: FILE: include/linux/capability.h:359:
+#define cap_lower(c,flag)  ((c).cap[CAP_TO_INDEX(flag)] &= ~CAP_TO_MASK(flag))
                    ^

ERROR: need space after that ',' (ctx:VxV)
#255: FILE: include/linux/capability.h:360:
+#define cap_raised(c,flag) ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))
                     ^

ERROR: need consistent spacing around '|' (ctx:WxB)
#278: FILE: include/linux/capability.h:382:
+	CAP_BOP_ALL(dest, a, b, |);
 	                        ^

WARNING: braces {} are not necessary for single statement blocks
#320: FILE: include/linux/capability.h:413:
+		if (a.cap[__capi] != 0) {
+			return 0;
+		}

ERROR: do not initialise statics to 0 or NULL
#420: FILE: kernel/capability.c:49:
+	static int warned = 0;

ERROR: need spaces around that '=' (ctx:VxV)
#467: FILE: kernel/capability.c:107:
+		for (i=0; i < tocopy; i++) {
 		      ^

WARNING: braces {} are not necessary for single statement blocks
#480: FILE: kernel/capability.c:120:
+		if (copy_to_user(dataptr, kdata, tocopy
+				 * sizeof(struct __user_cap_data_struct))) {
+			return -EFAULT;
+		}

ERROR: do not initialise statics to 0 or NULL
#492: FILE: kernel/capability.c:213:
+	static int warned = 0;

WARNING: braces {} are not necessary for single statement blocks
#527: FILE: kernel/capability.c:250:
+	if (copy_from_user(&kdata, data, tocopy
+			   * sizeof(struct __user_cap_data_struct))) {
 		return -EFAULT;
+	}

ERROR: need spaces around that '=' (ctx:VxV)
#532: FILE: kernel/capability.c:255:
+	for (i=0; i < tocopy; i++) {
 	      ^

WARNING: braces {} are not necessary for single statement blocks
#603: FILE: security/commoncap.c:199:
+	if (size < sizeof(magic_etc)) {
 		return -EINVAL;
+	}

WARNING: braces {} are not necessary for single statement blocks
#620: FILE: security/commoncap.c:207:
+		if (size != XATTR_CAPS_SZ_1) {
+			return -EINVAL;
+		}

WARNING: braces {} are not necessary for single statement blocks
#626: FILE: security/commoncap.c:213:
+		if (size != XATTR_CAPS_SZ_2) {
+			return -EINVAL;
+		}

ERROR: need spaces around that '=' (ctx:VxV)
#641: FILE: security/commoncap.c:228:
+	for (i=0; i < tocopy; ++i) {
 	      ^

total: 18 errors, 6 warnings, 688 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c            |    2 +-
 include/linux/capability.h |   21 ++++++++++-----------
 kernel/capability.c        |    6 +++---
 security/commoncap.c       |   22 ++++++++--------------
 4 files changed, 22 insertions(+), 29 deletions(-)

diff -puN fs/proc/array.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes fs/proc/array.c
--- a/fs/proc/array.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
+++ a/fs/proc/array.c
@@ -293,7 +293,7 @@ static char *render_cap_t(const char *he
 	buffer += sprintf(buffer, "%s", header);
 	CAP_FOR_EACH_U32(__capi) {
 		buffer += sprintf(buffer, "%08x",
-				  a->cap[(_LINUX_CAPABILITY_U32S-1) -__capi]);
+				  a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
 	}
 	return buffer + sprintf(buffer, "\n");
 }
diff -puN include/linux/capability.h~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes include/linux/capability.h
--- a/include/linux/capability.h~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
+++ a/include/linux/capability.h
@@ -329,13 +329,13 @@ typedef struct kernel_cap_struct {
  */
 
 #define CAP_FOR_EACH_U32(__capi)  \
-	for (__capi=0; __capi<_LINUX_CAPABILITY_U32S; ++__capi)
+	for (__capi = 0; __capi < _LINUX_CAPABILITY_U32S; ++__capi)
 
-# define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)             \
-			    |CAP_TO_MASK(CAP_DAC_OVERRIDE)      \
-			    |CAP_TO_MASK(CAP_DAC_READ_SEARCH)   \
-			    |CAP_TO_MASK(CAP_FOWNER)            \
-			    |CAP_TO_MASK(CAP_FSETID))
+# define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
+			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
+			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
+			    | CAP_TO_MASK(CAP_FOWNER)		\
+			    | CAP_TO_MASK(CAP_FSETID))
 
 #if _LINUX_CAPABILITY_U32S != 2
 # error Fix up hand-coded capability macro initializers
@@ -355,9 +355,9 @@ typedef struct kernel_cap_struct {
 # define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
 # define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)
 
-#define cap_raise(c,flag)  ((c).cap[CAP_TO_INDEX(flag)] |= CAP_TO_MASK(flag))
-#define cap_lower(c,flag)  ((c).cap[CAP_TO_INDEX(flag)] &= ~CAP_TO_MASK(flag))
-#define cap_raised(c,flag) ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))
+#define cap_raise(c, flag)  ((c).cap[CAP_TO_INDEX(flag)] |= CAP_TO_MASK(flag))
+#define cap_lower(c, flag)  ((c).cap[CAP_TO_INDEX(flag)] &= ~CAP_TO_MASK(flag))
+#define cap_raised(c, flag) ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))
 
 #define CAP_BOP_ALL(c, a, b, OP)                                    \
 do {                                                                \
@@ -410,9 +410,8 @@ static inline int cap_isclear(const kern
 {
 	unsigned __capi;
 	CAP_FOR_EACH_U32(__capi) {
-		if (a.cap[__capi] != 0) {
+		if (a.cap[__capi] != 0)
 			return 0;
-		}
 	}
 	return 1;
 }
diff -puN kernel/capability.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes kernel/capability.c
--- a/kernel/capability.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
+++ a/kernel/capability.c
@@ -104,7 +104,7 @@ out:
 		struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
 		unsigned i;
 
-		for (i=0; i < tocopy; i++) {
+		for (i = 0; i < tocopy; i++) {
 			kdata[i].effective = pE.cap[i];
 			kdata[i].permitted = pP.cap[i];
 			kdata[i].inheritable = pI.cap[i];
@@ -210,7 +210,7 @@ static inline int cap_set_all(kernel_cap
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
-	static int warned = 0;
+	static int warned;
 	struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
@@ -252,7 +252,7 @@ asmlinkage long sys_capset(cap_user_head
 		return -EFAULT;
 	}
 
-	for (i=0; i < tocopy; i++) {
+	for (i = 0; i < tocopy; i++) {
 		effective.cap[i] = kdata[i].effective;
 		permitted.cap[i] = kdata[i].permitted;
 		inheritable.cap[i] = kdata[i].inheritable;
diff -puN security/commoncap.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes security/commoncap.c
--- a/security/commoncap.c~add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
+++ a/security/commoncap.c
@@ -196,23 +196,20 @@ static inline int cap_from_disk(struct v
 	__u32 magic_etc;
 	unsigned tocopy, i;
 
-	if (size < sizeof(magic_etc)) {
+	if (size < sizeof(magic_etc))
 		return -EINVAL;
-	}
 
 	magic_etc = le32_to_cpu(caps->magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION_1:
-		if (size != XATTR_CAPS_SZ_1) {
+		if (size != XATTR_CAPS_SZ_1)
 			return -EINVAL;
-		}
 		tocopy = VFS_CAP_U32_1;
 		break;
 	case VFS_CAP_REVISION_2:
-		if (size != XATTR_CAPS_SZ_2) {
+		if (size != XATTR_CAPS_SZ_2)
 			return -EINVAL;
-		}
 		tocopy = VFS_CAP_U32_2;
 		break;
 	default:
@@ -225,7 +222,7 @@ static inline int cap_from_disk(struct v
 		bprm->cap_effective = false;
 	}
 
-	for (i=0; i < tocopy; ++i) {
+	for (i = 0; i < tocopy; ++i) {
 		bprm->cap_permitted.cap[i] =
 			le32_to_cpu(caps->data[i].permitted);
 		bprm->cap_inheritable.cap[i] =
@@ -363,11 +360,10 @@ void cap_bprm_apply_creds (struct linux_
 	 * capability rules */
 	if (!is_global_init(current)) {
 		current->cap_permitted = new_permitted;
-		if (bprm->cap_effective) {
+		if (bprm->cap_effective)
 			current->cap_effective = new_permitted;
-		} else {
+		else
 			cap_clear(current->cap_effective);
-		}
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -491,15 +487,13 @@ int cap_task_post_setuid (uid_t old_ruid
 				if (old_fsuid == 0 && current->fsuid != 0) {
 					current->cap_effective =
 						cap_drop_fs_set(
-						    current->cap_effective
-						    );
+						    current->cap_effective);
 				}
 				if (old_fsuid != 0 && current->fsuid == 0) {
 					current->cap_effective =
 						cap_raise_fs_set(
 						    current->cap_effective,
-						    current->cap_permitted
-						    );
+						    current->cap_permitted);
 				}
 			}
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-dvb.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mtd.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-checkpatch-fixes.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fix-up.patch
git-x86-inlining-borkage.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
w1-build-fix.patch
