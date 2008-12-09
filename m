From: akpm@linux-foundation.org
Subject: + cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:20:23 -0800
Message-ID: <200812090020.mB90KNn4008244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbYLIAUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gowrishankar.m@in.ibm.com, menage@google.com


The patch titled
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch

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
Subject: cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#37: FILE: kernel/cgroup.c:2017:
+		if ((pid = task_pid_vnr(tsk)) > 0)

total: 1 errors, 0 warnings, 17 lines checked

./patches/cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gowrishankar M <gowrishankar.m@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes
+++ a/kernel/cgroup.c
@@ -2014,7 +2014,8 @@ static int pid_array_load(pid_t *pidarra
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
 		if (unlikely(n == npids))
 			break;
-		if ((pid = task_pid_vnr(tsk)) > 0)
+		pid = task_pid_vnr(tsk);
+		if (pid > 0)
 			pidarray[n++] = pid;
 	}
 	cgroup_iter_end(cgrp, &it);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
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
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
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

