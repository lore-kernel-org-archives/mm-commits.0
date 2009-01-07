From: akpm@linux-foundation.org
Subject: - cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:07:12 -0800
Message-ID: <200901072307.n07N7CJq025838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762230AbZAGXHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gowrishankar.m@in.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch

This patch was dropped because it was folded into cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch

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
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
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

