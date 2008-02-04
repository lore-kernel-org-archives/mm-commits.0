From: akpm@linux-foundation.org
Subject: - add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:55:47 -0800
Message-ID: <200802040355.m143tSjf012700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752AbYBDD4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-64-bit-capability-support-to-the-kernel-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch

This patch was dropped because it was folded into add-64-bit-capability-support-to-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -288,7 +288,7 @@ static char *render_cap_t(const char *he
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
@@ -203,23 +203,20 @@ static inline int cap_from_disk(struct v
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
@@ -232,7 +229,7 @@ static inline int cap_from_disk(struct v
 		bprm->cap_effective = false;
 	}
 
-	for (i=0; i < tocopy; ++i) {
+	for (i = 0; i < tocopy; ++i) {
 		bprm->cap_permitted.cap[i] =
 			le32_to_cpu(caps->data[i].permitted);
 		bprm->cap_inheritable.cap[i] =
@@ -370,11 +367,10 @@ void cap_bprm_apply_creds (struct linux_
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
@@ -498,15 +494,13 @@ int cap_task_post_setuid (uid_t old_ruid
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

origin.patch
kvm-i386-fix.patch
drivers-net-wireless-b43-mainc-needs-ioh.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
timerfd-v3-new-timerfd-api.patch
include-asm-powerpc-nvramh-needs-listh.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
slub-fix-coding-style-violations.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
bufferhead-revert-constructor-removal.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
maps4-rework-task_size-macros.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
page-allocator-clean-up-pcp-draining-functions.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-remove-fastcall-from-mm.patch
page-migraton-handle-orphaned-pages.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
smack-version-11c-simplified-mandatory-access-control-kernel-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
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
deprecate-smbfs-in-favour-of-cifs.patch
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
