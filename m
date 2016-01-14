From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:29:32 -0800
Message-ID: <5698214c.YomjlxE5YWZscK6Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbcANW3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:29:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, hannes@cmpxchg.org, mhocko@suse.cz, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix
has been removed from the -mm tree.  Its filename was
     vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix.patch

This patch was dropped because it was folded into vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix

Hmmm... We got a race condition since quiet_vmstat touches cpu_stat_off
which may not be allocated early in the bootup sequence. Causes oopses on
boot.

Subject: vmstat: quieting vmstat requires a running system

Do not do anything unless the system is actually running. Otherwise
we may crash on bootup.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle-fix
+++ a/mm/vmstat.c
@@ -1426,6 +1426,9 @@ static void vmstat_update(struct work_st
  */
 void quiet_vmstat(void)
 {
+	if (system_state != SYSTEM_RUNNING)
+		return;
+
 	do {
 		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
 			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-make-vmstat_updater-deferrable-again-and-shut-down-on-idle.patch

