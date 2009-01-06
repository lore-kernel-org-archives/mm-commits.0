From: akpm@linux-foundation.org
Subject: - fs-execc-make-do_coredump-void-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:39:27 -0800
Message-ID: <200901062039.n06KdRte032329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZAFUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs-execc-make-do_coredump-void-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-execc-make-do_coredump-void-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-execc-make-do_coredump-void.patch

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
mm-invoke-oom-killer-from-page-fault.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-mmapc-fix-coding-style.patch
mm-check-for-no-mmaps-in-exit_mmap.patch
mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch
mm-hugetlb-get-rid-of-redundant-if-operation.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module.patch
binfmtsh-include-listh.patch
spi_gpio-driver.patch
kprobes-support-probing-module-__exit-function.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
minix-fix-add-links-wrong-position-calculation.patch
fs-execc-make-do_coredump-void.patch
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

