From: akpm@linux-foundation.org
Subject: + dmapools-protect-page_list-walk-in-show_pools.patch added to -mm tree
Date: Tue, 23 Jun 2009 09:22:57 -0700
Message-ID: <200906231622.n5NGMvmF030608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbZFWQXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 12:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, willy@linux.intel.com


The patch titled
     dmapools: protect page_list walk in show_pools()
has been added to the -mm tree.  Its filename is
     dmapools-protect-page_list-walk-in-show_pools.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
parisc-remove-obsolete-hw_interrupt_type.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch
dmapools-protect-page_list-walk-in-show_pools.patch

