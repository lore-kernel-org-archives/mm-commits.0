From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-watchdog-fix-spurious-hard-lockups.patch
 removed from -mm tree
Date: Thu, 22 Jun 2017 14:38:32 -0700
Message-ID: <594c38d8.BoHN6gf765OB0FJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753772AbdFVVie (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Kan.liang@intel.com, acme@redhat.com, ak@linux.intel.com, atomlin@redhat.com, babu.moger@oracle.com, dzickus@redhat.com, eranian@google.com, mingo@kernel.org, peterz@infradead.org, prarit@redhat.com, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog_hld.c: fix spurious hard lockups
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-fix-spurious-hard-lockups.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kan Liang <Kan.liang@intel.com>
Subject: kernel/watchdog_hld.c: fix spurious hard lockups

Some users reported spurious NMI watchdog timeouts.

We now have more and more systems where the Turbo range is wide enough
that the NMI watchdog expires faster than the soft watchdog timer that
updates the interrupt tick the NMI watchdog relies on.

This problem was originally added by 58687acba592 ("lockup_detector:
Combine nmi_watchdog and softlockup detector").  Previously the NMI
watchdog would always check jiffies, which were ticking fast enough.  But
now the backing is quite slow so the expire time becomes more sensitive.

For mainline the right fix is to switch the NMI watchdog to reference
cycles, which tick always at the same rate independent of turbo mode.  But
this is requires some complicated changes in perf, which are too difficult
to backport.  Since we need a stable fix too just increase the NMI
watchdog rate here to avoid the spurious timeouts.  This is not an ideal
fix because a 3x as large Turbo range could still fail, but for now that's
not likely.

The right fix for mainline can be found here.
perf/x86/intel: enable CPU ref_cycles for GP counter
perf/x86/intel, watchdog: Switch NMI watchdog to ref cycles on x86
https://patchwork.kernel.org/patch/9779087/
https://patchwork.kernel.org/patch/9779089/

Link: http://lkml.kernel.org/r/20170620213309.30051-1-kan.liang@intel.com
Fixes: 58687acba592 ("lockup_detector: Combine nmi_watchdog and softlockup detector")
Signed-off-by: Kan Liang <Kan.liang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_hld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog_hld.c~kernel-watchdog-fix-spurious-hard-lockups kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~kernel-watchdog-fix-spurious-hard-lockups
+++ a/kernel/watchdog_hld.c
@@ -164,7 +164,7 @@ int watchdog_nmi_enable(unsigned int cpu
 		firstcpu = 1;
 
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
+	wd_attr->sample_period = 3 * hw_nmi_get_sample_period(watchdog_thresh);
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
_

Patches currently in -mm which might be from Kan.liang@intel.com are


