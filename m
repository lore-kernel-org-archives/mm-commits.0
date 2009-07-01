From: akpm@linux-foundation.org
Subject: [merged] dmapools-protect-page_list-walk-in-show_pools.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:00 -0700
Message-ID: <200907011727.n61HR08a001714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbZGAR1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     dmapools: protect page_list walk in show_pools()
has been removed from the -mm tree.  Its filename was
     dmapools-protect-page_list-walk-in-show_pools.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmapools: protect page_list walk in show_pools()
From: Thomas Gleixner <tglx@linutronix.de>

show_pools() walks the page_list of a pool w/o protection against the list
modifications in alloc/free.  Take pool->lock to avoid stomping into
nirvana.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/dmapool.c~dmapools-protect-page_list-walk-in-show_pools mm/dmapool.c
--- a/mm/dmapool.c~dmapools-protect-page_list-walk-in-show_pools
+++ a/mm/dmapool.c
@@ -86,10 +86,12 @@ show_pools(struct device *dev, struct de
 		unsigned pages = 0;
 		unsigned blocks = 0;
 
+		spin_lock_irq(&pool->lock);
 		list_for_each_entry(page, &pool->page_list, page_list) {
 			pages++;
 			blocks += page->in_use;
 		}
+		spin_unlock_irq(&pool->lock);
 
 		/* per-pool info, no real statistics yet */
 		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch
parisc-remove-obsolete-hw_interrupt_type.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch
clocksource-save-mult_orig-in-clocksource_disable.patch
include-linux-clocksourceh-coding-style-tweaks.patch

