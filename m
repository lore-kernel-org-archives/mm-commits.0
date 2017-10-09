From: akpm@linux-foundation.org
Subject: +
 pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 09 Oct 2017 16:20:07 -0700
Message-ID: <59dc0427.5+Rmc7i74XfAwLXc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754404AbdJIXUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2017 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gs051095@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN arch/powerpc/platforms/cell/spufs/sched.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes arch/powerpc/platforms/cell/spufs/sched.c
diff -puN fs/proc/loadavg.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes fs/proc/loadavg.c
diff -puN include/linux/pid_namespace.h~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes include/linux/pid_namespace.h
diff -puN init/main.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes init/main.c
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
diff -puN kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes kernel/pid_namespace.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
pid-remove-pidhash-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

