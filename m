From: akpm@linux-foundation.org
Subject: +
 mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch added
 to -mm tree
Date: Thu, 25 Jun 2020 16:45:35 -0700
Message-ID: <20200625234535.B14S_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgFYXph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, willy@infradead.org, tim.c.chen@intel.com, mhocko@suse.com, mgorman@suse.de, keescook@chromium.org, hannes@cmpxchg.org, dave.hansen@intel.com, andi.kleen@intel.com, feng.tang@intel.com


The patch titled
     Subject: mm: adjust vm_committed_as_batch according to vm overcommit policy
has been added to the -mm tree.  Its filename is
     mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm: adjust vm_committed_as_batch according to vm overcommit policy

When checking a performance change for will-it-scale scalability mmap test
[1], we found very high lock contention for spinlock of percpu counter
'vm_committed_as':

    94.14%     0.35%  [kernel.kallsyms]         [k] _raw_spin_lock_irqsave
    48.21% _raw_spin_lock_irqsave;percpu_counter_add_batch;__vm_enough_memory;mmap_region;do_mmap;
    45.91% _raw_spin_lock_irqsave;percpu_counter_add_batch;__do_munmap;

Actually this heavy lock contention is not always necessary.  The
'vm_committed_as' needs to be very precise when the strict
OVERCOMMIT_NEVER policy is set, which requires a rather small batch number
for the percpu counter.

So keep 'batch' number unchanged for strict OVERCOMMIT_NEVER policy, and
lift it to 64X for OVERCOMMIT_ALWAYS and OVERCOMMIT_GUESS policies.  Also
add a sysctl handler to adjust it when the policy is reconfigured.

Benchmark with the same testcase in [1] shows 53% improvement on a 8C/16T
desktop, and 2097%(20X) on a 4S/72C/144T server.  We tested with test
platforms in 0day (server, desktop and laptop), and 80%+ platforms shows
improvements with that test.  And whether it shows improvements depends on
if the test mmap size is bigger than the batch number computed.

And if the lift is 16X, 1/3 of the platforms will show improvements,
though it should help the mmap/unmap usage generally, as Michal Hocko
mentioned:

: I believe that there are non-synthetic worklaods which would benefit from
: a larger batch.  E.g.  large in memory databases which do large mmaps
: during startups from multiple threads.

[1] https://lore.kernel.org/lkml/20200305062138.GI5972@shao2-debian/

Link: http://lkml.kernel.org/r/1589611660-89854-4-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1592725000-73486-4-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    2 ++
 include/linux/mman.h |    4 ++++
 kernel/sysctl.c      |    2 +-
 mm/mm_init.c         |   16 +++++++++++++---
 mm/util.c            |   12 ++++++++++++
 5 files changed, 32 insertions(+), 4 deletions(-)

--- a/include/linux/mman.h~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/include/linux/mman.h
@@ -57,8 +57,12 @@ extern struct percpu_counter vm_committe
 
 #ifdef CONFIG_SMP
 extern s32 vm_committed_as_batch;
+extern void mm_compute_batch(void);
 #else
 #define vm_committed_as_batch 0
+static inline void mm_compute_batch(void)
+{
+}
 #endif
 
 unsigned long vm_memory_committed(void);
--- a/include/linux/mm.h~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/include/linux/mm.h
@@ -206,6 +206,8 @@ int overcommit_ratio_handler(struct ctl_
 		loff_t *);
 int overcommit_kbytes_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
+int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
+		loff_t *);
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
--- a/kernel/sysctl.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/kernel/sysctl.c
@@ -2650,7 +2650,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= overcommit_policy_handler,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
--- a/mm/mm_init.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/mm/mm_init.c
@@ -13,6 +13,7 @@
 #include <linux/memory.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
+#include <linux/mman.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
@@ -144,14 +145,23 @@ EXPORT_SYMBOL_GPL(mm_kobj);
 #ifdef CONFIG_SMP
 s32 vm_committed_as_batch = 32;
 
-static void __meminit mm_compute_batch(void)
+void mm_compute_batch(void)
 {
 	u64 memsized_batch;
 	s32 nr = num_present_cpus();
 	s32 batch = max_t(s32, nr*2, 32);
+	unsigned long ram_pages = totalram_pages();
 
-	/* batch size set to 0.4% of (total memory/#cpus), or max int32 */
-	memsized_batch = min_t(u64, (totalram_pages()/nr)/256, 0x7fffffff);
+	/*
+	 * For policy of OVERCOMMIT_NEVER, set batch size to 0.4%
+	 * of (total memory/#cpus), and lift it to 25% for other
+	 * policies to easy the possible lock contention for percpu_counter
+	 * vm_committed_as, while the max limit is INT_MAX
+	 */
+	if (sysctl_overcommit_memory == OVERCOMMIT_NEVER)
+		memsized_batch = min_t(u64, ram_pages/nr/256, INT_MAX);
+	else
+		memsized_batch = min_t(u64, ram_pages/nr/4, INT_MAX);
 
 	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
 }
--- a/mm/util.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/mm/util.c
@@ -746,6 +746,18 @@ int overcommit_ratio_handler(struct ctl_
 	return ret;
 }
 
+int overcommit_policy_handler(struct ctl_table *table, int write, void *buffer,
+		size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		mm_compute_batch();
+
+	return ret;
+}
+
 int overcommit_kbytes_handler(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from feng.tang@intel.com are

proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch
mm-utilc-make-vm_memory_committed-more-accurate.patch
mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch
