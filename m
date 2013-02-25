From: akpm@linux-foundation.org
Subject: [merged] mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:40 -0800
Message-ID: <20130225205240.C9FEC5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:62748 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab3BYUwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:42 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so346785ves.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: handle side-effects in count_vm_numa_events() for !CONFIG_NUMA_BALANCING
has been removed from the -mm tree.  Its filename was
     mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: handle side-effects in count_vm_numa_events() for !CONFIG_NUMA_BALANCING

The current definitions for count_vm_numa_events() is wrong for
!CONFIG_NUMA_BALANCING as the following would miss the side-effect.

	count_vm_numa_events(NUMA_FOO, bar++);

There are no such users of count_vm_numa_events() but this patch fixes it
as it is a potential pitfall.  Ideally both would be converted to static
inline but NUMA_PTE_UPDATES is not defined if !CONFIG_NUMA_BALANCING and
creating dummy constants just to have a static inline would be similarly
clumsy.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/vmstat.h~mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing
+++ a/include/linux/vmstat.h
@@ -85,7 +85,7 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_numa_events(x, y) count_vm_events(x, y)
 #else
 #define count_vm_numa_event(x) do {} while (0)
-#define count_vm_numa_events(x, y) do {} while (0)
+#define count_vm_numa_events(x, y) do { (void)(y); } while (0)
 #endif /* CONFIG_NUMA_BALANCING */
 
 #define __count_zone_vm_events(item, zone, delta) \
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

