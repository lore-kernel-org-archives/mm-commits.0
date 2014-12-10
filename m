From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
 removed from -mm tree
Date: Wed, 10 Dec 2014 15:17:11 -0800
Message-ID: <5488d477.UhnC4K5ClLM/17r+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbaLJXRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix

forgot to refresh...

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix
+++ a/mm/memcontrol.c
@@ -5406,7 +5406,7 @@ static void mem_cgroup_clear_mc(void)
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
 
-	atomic_dec(&memcg->moving_account);
+	atomic_dec(&from->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5446,7 +5446,7 @@ static int mem_cgroup_can_attach(struct
 			 * its pages to another memcg.  Then wait for
 			 * already started RCU-only updates to finish.
 			 */
-			atomic_inc(&memcg->moving_account);
+			atomic_inc(&from->moving_account);
 			synchronize_rcu();
 
 			spin_lock(&mc.lock);
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
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

