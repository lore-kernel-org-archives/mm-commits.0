From: akpm@linux-foundation.org
Subject: + memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:59:08 -0700
Message-ID: <200810282213.m9SMDxXO023353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbYJ1WOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 18:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-introduce-charge-commit-cancel-style-of-functions-fix
has been added to the -mm tree.  Its filename is
     memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch

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
Subject: memcg-introduce-charge-commit-cancel-style-of-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/memcontrol.h:105: warning: 'mem_cgroup_try_charge' defined but not used
include/linux/memcontrol.h:111: warning: 'mem_cgroup_commit_charge_swapin' defined but not used
include/linux/memcontrol.h:114: warning: 'mem_cgroup_cancel_charge_swapin' defined but not used
include/linux/memcontrol.h:105: warning: 'mem_cgroup_try_charge' defined but not used
include/linux/memcontrol.h:111: warning: 'mem_cgroup_commit_charge_swapin' defined but not used
include/linux/memcontrol.h:114: warning: 'mem_cgroup_cancel_charge_swapin' defined but not used

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-introduce-charge-commit-cancel-style-of-functions-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-introduce-charge-commit-cancel-style-of-functions-fix
+++ a/include/linux/memcontrol.h
@@ -100,17 +100,18 @@ static inline int mem_cgroup_charge_migr
 	return 0;
 }
 
-static int mem_cgroup_try_charge(struct mm_struct *mm,
+static inline int mem_cgroup_try_charge(struct mm_struct *mm,
 				gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
 	return 0;
 }
 
-static void mem_cgroup_commit_charge_swapin(struct page *page,
+static inline void mem_cgroup_commit_charge_swapin(struct page *page,
 					  struct mem_cgroup *ptr)
 {
 }
-static void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr)
+
+static inline void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

