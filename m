From: akpm@linux-foundation.org
Subject: [obsolete]
 pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 11 Oct 2017 15:39:00 -0700
Message-ID: <59de9d84.f3V+pZlvnSqBUWc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbdJKWjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gs051095@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#23: 
   5692       1842        192       7726       1e2e    kernel/pid_namespace.o

WARNING: 'implemetation' may be misspelled - perhaps 'implementation'?
#52: 
Replace the current bitmap implemetation for Process ID allocation. 

WARNING: Missing a blank line after declarations
#353: FILE: kernel/pid.c:171:
+		int pid_min = 1;
+		idr_preload(GFP_KERNEL);

WARNING: line over 80 characters
#363: FILE: kernel/pid.c:181:
+		/* Store a null pointer so find_pid_ns does not find             *

total: 0 errors, 4 warnings, 426 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/pid-replace-pid-bitmap-implementation-with-idr-api.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gargi Sharma <gs051095@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes kernel/pid.c
--- a/kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes
+++ a/kernel/pid.c
@@ -168,6 +168,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	for (i = ns->level; i >= 0; i--) {
 		int pid_min = 1;
+
 		idr_preload(GFP_KERNEL);
 		spin_lock_irq(&pidmap_lock);
 
@@ -178,8 +179,9 @@ struct pid *alloc_pid(struct pid_namespa
 		if (idr_get_cursor(&tmp->idr) > RESERVED_PIDS)
 			pid_min = RESERVED_PIDS;
 
-		/* Store a null pointer so find_pid_ns does not find             *
-		 * a partially initialized PID (see below).
+		/*
+		 * Store a null pointer so find_pid_ns does not find a partially
+		 * initialized PID (see below).
 		 */
 		nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
 				      pid_max, GFP_ATOMIC);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
pid-remove-pidhash-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

