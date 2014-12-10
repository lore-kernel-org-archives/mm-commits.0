From: akpm@linux-foundation.org
Subject: [folded-merged]
 exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch removed from -mm
 tree
Date: Wed, 10 Dec 2014 15:23:38 -0800
Message-ID: <5488d5fa.sVuH69mP+QjNQ/vf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaLJXXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atomlin@redhat.com, ebiederm@xmission.com, oleg@redhat.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit-wait-cleanup-the-ptrace_reparented-checks-fix
has been removed from the -mm tree.  Its filename was
     exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

This patch was dropped because it was folded into exit-wait-cleanup-the-ptrace_reparented-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: exit-wait-cleanup-the-ptrace_reparented-checks-fix

don't make me google the C Operator Precedence table

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-wait-cleanup-the-ptrace_reparented-checks-fix kernel/exit.c
--- a/kernel/exit.c~exit-wait-cleanup-the-ptrace_reparented-checks-fix
+++ a/kernel/exit.c
@@ -999,7 +999,7 @@ static int wait_task_zombie(struct wait_
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = ptrace_reparented(p) && thread_group_leader(p) ?
+	state = (ptrace_reparented(p) && thread_group_leader(p)) ?
 		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
fs-proc-use-a-rb-tree-for-the-directory-entries.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch
rtc-omap-add-support-for-pmic_power_en.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch
rtc-ds1374-add-watchdog-support.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch

