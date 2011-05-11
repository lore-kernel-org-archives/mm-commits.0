From: akpm@linux-foundation.org
Subject: + compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch added to -mm tree
Date: Wed, 11 May 2011 14:21:07 -0700
Message-ID: <201105112121.p4BLL76K026363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889Ab1EKVVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 17:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cmetcalf@tilera.com


The patch titled
     compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before open square bracket '['
#50: FILE: arch/tile/kernel/compat.c:138:
+#define __SYSCALL(nr, call) [nr] = (call),

ERROR: Macros with complex values should be enclosed in parenthesis
#50: FILE: arch/tile/kernel/compat.c:138:
+#define __SYSCALL(nr, call) [nr] = (call),

ERROR: "foo * bar" should be "foo *bar"
#651: FILE: include/linux/compat.h:372:
+asmlinkage long compat_sys_newstat(const char __user * filename,

ERROR: "foo * bar" should be "foo *bar"
#653: FILE: include/linux/compat.h:374:
+asmlinkage long compat_sys_newlstat(const char __user * filename,

ERROR: "foo * bar" should be "foo *bar"
#659: FILE: include/linux/compat.h:380:
+				    struct compat_stat __user * statbuf);

ERROR: "foo * bar" should be "foo *bar"
#681: FILE: include/linux/compat.h:402:
+asmlinkage long compat_sys_mount(const char __user * dev_name,

ERROR: "foo * bar" should be "foo *bar"
#682: FILE: include/linux/compat.h:403:
+				 const char __user * dir_name,

ERROR: "foo * bar" should be "foo *bar"
#683: FILE: include/linux/compat.h:404:
+				 const char __user * type, unsigned long flags,

ERROR: "foo * bar" should be "foo *bar"
#684: FILE: include/linux/compat.h:405:
+				 const void __user * data);

ERROR: "foo * bar" should be "foo *bar"
#692: FILE: include/linux/compat.h:413:
+				      struct linux_dirent64 __user * dirent,

ERROR: code indent should use tabs where possible
#701: FILE: include/linux/compat.h:422:
+                                             struct file_handle __user *handle,$

WARNING: please, no spaces at the start of a line
#701: FILE: include/linux/compat.h:422:
+                                             struct file_handle __user *handle,$

ERROR: code indent should use tabs where possible
#702: FILE: include/linux/compat.h:423:
+                                             int flags);$

WARNING: please, no spaces at the start of a line
#702: FILE: include/linux/compat.h:423:
+                                             int flags);$

WARNING: line over 80 characters
#713: FILE: include/linux/compat.h:434:
+#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && !defined(CONFIG_NFSD_DEPRECATED)

WARNING: storage class should be at the beginning of the declaration
#720: FILE: include/linux/compat.h:441:
+long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2);

WARNING: space prohibited between function name and open parenthesis '('
#761: FILE: include/linux/compat.h:482:
+asmlinkage long compat_sys_getrlimit (unsigned int resource,

WARNING: space prohibited between function name and open parenthesis '('
#789: FILE: include/linux/compat.h:510:
+asmlinkage long compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,

total: 12 errors, 6 warnings, 771 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/compat-fixes-to-allow-working-with-tile-arch.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN include/linux/compat.h~compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes include/linux/compat.h
--- a/include/linux/compat.h~compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes
+++ a/include/linux/compat.h
@@ -369,11 +369,12 @@ asmlinkage long compat_sys_futimesat(uns
 				     struct compat_timeval __user *t);
 asmlinkage long compat_sys_utimes(const char __user *filename,
 				  struct compat_timeval __user *t);
-asmlinkage long compat_sys_newstat(const char __user * filename,
+asmlinkage long compat_sys_newstat(const char __user *filename,
 				   struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newlstat(const char __user * filename,
+asmlinkage long compat_sys_newlstat(const char __user *filename,
 				    struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newfstatat(unsigned int dfd, const char __user * filename,
+asmlinkage long compat_sys_newfstatat(unsigned int dfd,
+				      const char __user *filename,
 				      struct compat_stat __user *statbuf,
 				      int flag);
 asmlinkage long compat_sys_newfstat(unsigned int fd,
@@ -399,10 +400,11 @@ asmlinkage long compat_sys_io_getevents(
 					struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_io_submit(aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
-asmlinkage long compat_sys_mount(const char __user * dev_name,
-				 const char __user * dir_name,
-				 const char __user * type, unsigned long flags,
-				 const void __user * data);
+asmlinkage long compat_sys_mount(const char __user *dev_name,
+				 const char __user *dir_name,
+				 const char __user *type,
+				 unsigned long flags,
+				 const void __user *data);
 asmlinkage long compat_sys_old_readdir(unsigned int fd,
 				       struct compat_old_linux_dirent __user *,
 				       unsigned int count);
@@ -410,7 +412,7 @@ asmlinkage long compat_sys_getdents(unsi
 				    struct compat_linux_dirent __user *dirent,
 				    unsigned int count);
 asmlinkage long compat_sys_getdents64(unsigned int fd,
-				      struct linux_dirent64 __user * dirent,
+				      struct linux_dirent64 __user *dirent,
 				      unsigned int count);
 asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
 				    unsigned int nr_segs, unsigned int flags);
@@ -419,8 +421,8 @@ asmlinkage long compat_sys_open(const ch
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
-                                             struct file_handle __user *handle,
-                                             int flags);
+					     struct file_handle __user *handle,
+					     int flags);
 asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *outp,
 				    compat_ulong_t __user *exp,
@@ -479,8 +481,8 @@ asmlinkage long compat_sys_setitimer(int
 asmlinkage long compat_sys_times(struct compat_tms __user *tbuf);
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 				     struct compat_rlimit __user *rlim);
-asmlinkage long compat_sys_getrlimit (unsigned int resource,
-				      struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrlimit(unsigned int resource,
+				     struct compat_rlimit __user *rlim);
 asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru);
 asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
 				     unsigned int len,
@@ -507,7 +509,7 @@ asmlinkage long compat_sys_clock_getres(
 asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 					   struct compat_timespec __user *rqtp,
 					   struct compat_timespec __user *rmtp);
-asmlinkage long compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
+asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
 		struct compat_timespec __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-alloc_bootmem_node_nopanic-on-really-needed-path-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
mm-add-alloc_pages_exact_nid-checkpatch-fixes.patch
mm-add-alloc_pages_exact_nid-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
slab-use-numa_no_node.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
tmpfs-implement-xattr-support-for-the-entire-security-namespace-update-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

