From: akpm@linux-foundation.org
Subject: + mm-vmstat-make-quiet_vmstat-lighter-fix.patch added to -mm tree
Date: Tue, 02 Feb 2016 13:42:31 -0800
Message-ID: <56b122c7.2vTPZt9W0jUUHqNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbcBBVmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 16:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgalbraith@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: cancel pending work of the cpu_stat_off CPU
has been added to the -mm tree.  Its filename is
     mm-vmstat-make-quiet_vmstat-lighter-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-make-quiet_vmstat-lighter-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-make-quiet_vmstat-lighter-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Galbraith <mgalbraith@suse.de>
Subject: mm, vmstat: cancel pending work of the cpu_stat_off CPU

Cancel pending work of the cpu_stat_off CPU.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-make-quiet_vmstat-lighter-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-make-quiet_vmstat-lighter-fix
+++ a/mm/vmstat.c
@@ -1486,25 +1486,25 @@ static void vmstat_shepherd(struct work_
 
 	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
-	for_each_cpu(cpu, cpu_stat_off)
+	for_each_cpu(cpu, cpu_stat_off) {
+		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
+
 		if (need_update(cpu)) {
 			if (cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
-				queue_delayed_work_on(cpu, vmstat_wq,
-					&per_cpu(vmstat_work, cpu), 0);
+				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
 		} else {
 			/*
 			 * Cancel the work if quiet_vmstat has put this
 			 * cpu on cpu_stat_off because the work item might
 			 * be still scheduled
 			 */
-			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
+			cancel_delayed_work(dw);
 		}
-
+	}
 	put_online_cpus();
 
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
