From: akpm@linux-foundation.org
Subject: [alternative-merged] kernel-time-fix-build.patch removed from -mm tree
Date: Tue, 29 Nov 2016 15:32:54 -0800
Message-ID: <583e1026.hAFXxcfnRCjgollR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754678AbcK2Xck (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2016 18:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nico@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/time: fix build
has been removed from the -mm tree.  Its filename was
     kernel-time-fix-build.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/time: fix build

kernel/built-in.o: In function `alarm_handle_timer':
alarmtimer.c:(.text+0x2a3ba): undefined reference to `posix_timer_event'

May or may not be correct...

Cc: Nicolas Pitre <nico@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/posix-stubs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/time/posix-stubs.c~kernel-time-fix-build kernel/time/posix-stubs.c
--- a/kernel/time/posix-stubs.c~kernel-time-fix-build
+++ a/kernel/time/posix-stubs.c
@@ -121,3 +121,8 @@ long clock_nanosleep_restart(struct rest
 	return hrtimer_nanosleep_restart(restart_block);
 }
 #endif
+
+int posix_timer_event(struct k_itimer *timr, int si_private)
+{
+	return 0;
+}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

