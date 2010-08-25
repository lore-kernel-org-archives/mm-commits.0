From: akpm@linux-foundation.org
Subject: + cgroups-fix-api-thinko-fix.patch added to -mm tree
Date: Wed, 25 Aug 2010 14:35:36 -0700
Message-ID: <201008252135.o7PLZaJh017121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab0HYVfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 17:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com, bblum@google.com, lizf@cn.fujitsu.com, menage@google.com, mst@redhat.com, sri@us.ibm.com


The patch titled
     cgroups-fix-api-thinko-fix
has been added to the -mm tree.  Its filename is
     cgroups-fix-api-thinko-fix.patch

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
Subject: cgroups-fix-api-thinko-fix
From: Andrew Morton <akpm@linux-foundation.org>

address reviewer comments

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Ben Blum <bblum@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-api-thinko-fix include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-api-thinko-fix
+++ a/include/linux/cgroup.h
@@ -579,6 +579,7 @@ void cgroup_iter_end(struct cgroup *cgrp
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
+
 static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
 {
 	return cgroup_attach_task_all(current, tsk);
diff -puN kernel/cgroup.c~cgroups-fix-api-thinko-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-api-thinko-fix
+++ a/kernel/cgroup.c
@@ -1798,13 +1798,13 @@ out:
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 {
 	struct cgroupfs_root *root;
-	struct cgroup *cur_cg;
 	int retval = 0;
 
 	cgroup_lock();
 	for_each_active_root(root) {
-		cur_cg = task_cgroup_from_root(from, root);
-		retval = cgroup_attach_task(cur_cg, tsk);
+		struct cgroup *from_cg = task_cgroup_from_root(from, root);
+
+		retval = cgroup_attach_task(from_cg, tsk);
 		if (retval)
 			break;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

