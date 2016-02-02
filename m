From: akpm@linux-foundation.org
Subject: + vmstat-make-vmstat_update-deferrable.patch added to -mm tree
Date: Mon, 01 Feb 2016 22:26:44 -0800
Message-ID: <56b04c24.QTYB80/ewgaA0oJg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcBBG0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:26:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: make vmstat_update deferrable
has been added to the -mm tree.  Its filename is
     vmstat-make-vmstat_update-deferrable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-make-vmstat_update-deferrable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-make-vmstat_update-deferrable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: vmstat: make vmstat_update deferrable

0eb77e988032 ("vmstat: make vmstat_updater deferrable again and shut down
on idle") made vmstat_shepherd deferrable.  vmstat_update itself is still
useing standard timer which might interrupt idle task.  This is possible
because "mm, vmstat: make quiet_vmstat lighter" removed
cancel_delayed_work from the quiet_vmstat.  Change vmstat_work to use
DEFERRABLE_WORK to prevent from pointless wakeups from the idle context.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-make-vmstat_update-deferrable mm/vmstat.c
--- a/mm/vmstat.c~vmstat-make-vmstat_update-deferrable
+++ a/mm/vmstat.c
@@ -1512,7 +1512,7 @@ static void __init start_shepherd_timer(
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		INIT_DELAYED_WORK(per_cpu_ptr(&vmstat_work, cpu),
+		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
 	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmstat-make-quiet_vmstat-lighter.patch
vmstat-make-vmstat_update-deferrable.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

