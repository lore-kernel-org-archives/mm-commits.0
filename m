From: akpm@linux-foundation.org
Subject: + fs-execc-make-do_coredump-void-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:09:40 -0800
Message-ID: <200812302309.mBUN9egF018672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbYL3XKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, wangcong@zeuux.org


The patch titled
     fs-execc-make-do_coredump-void-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-execc-make-do_coredump-void-checkpatch-fixes.patch

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
Subject: fs-execc-make-do_coredump-void-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#23: FILE: fs/exec.c:1727:
+void do_coredump(long signr, int exit_code, struct pt_regs * regs)

ERROR: "foo * bar" should be "foo *bar"
#42: FILE: include/linux/binfmts.h:110:
+extern void do_coredump(long signr, int exit_code, struct pt_regs * regs);

total: 2 errors, 0 warnings, 22 lines checked

./patches/fs-execc-make-do_coredump-void.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    2 +-
 include/linux/binfmts.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-make-do_coredump-void-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~fs-execc-make-do_coredump-void-checkpatch-fixes
+++ a/fs/exec.c
@@ -1724,7 +1724,7 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
-void do_coredump(long signr, int exit_code, struct pt_regs * regs)
+void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
diff -puN include/linux/binfmts.h~fs-execc-make-do_coredump-void-checkpatch-fixes include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-execc-make-do_coredump-void-checkpatch-fixes
+++ a/include/linux/binfmts.h
@@ -107,7 +107,7 @@ extern int setup_arg_pages(struct linux_
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
-extern void do_coredump(long signr, int exit_code, struct pt_regs * regs);
+extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
 extern int set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
mm-check-for-no-mmaps-in-exit_mmap-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
fs-execc-make-do_coredump-void-checkpatch-fixes.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

