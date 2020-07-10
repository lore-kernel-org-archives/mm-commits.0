From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch removed from
 -mm tree
Date: Thu, 09 Jul 2020 17:38:41 -0700
Message-ID: <20200710003841.lSswIf_-L%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:38:42 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi.kleen@intel.com, dave.hansen@intel.com, feng.tang@intel.com, hannes@cmpxchg.org, keescook@chromium.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, tim.c.chen@intel.com, willy@infradead.org, ying.huang@intel.com


The patch titled
     Subject: proc/meminfo: avoid open coded reading of vm_committed_as
has been removed from the -mm tree.  Its filename was
     proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: proc/meminfo: avoid open coded reading of vm_committed_as

Patch series "make vm_committed_as_batch aware of vm overcommit policy", v5.

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
enlarge it for not-so-strict OVERCOMMIT_ALWAYS and OVERCOMMIT_GUESS
policies.

Benchmark with the same testcase in [1] shows 53% improvement on a 8C/16T
desktop, and 2097%(20X) on a 4S/72C/144T server.  And for that case,
whether it shows improvements depends on if the test mmap size is bigger
than the batch number computed.

We tested 10+ platforms in 0day (server, desktop and laptop).  If we lift
it to 64X, 80%+ platforms show improvements, and for 16X lift, 1/3 of the
platforms will show improvements.

And generally it should help the mmap/unmap usage,as Michal Hocko
mentioned:

: I believe that there are non-synthetic worklaods which would benefit
: from a larger batch. E.g. large in memory databases which do large
: mmaps during startups from multiple threads.

Note: There are some style complain from checkpatch for patch 3, as sysctl
handler declaration follows the similar format of sibling functions

[1] https://lore.kernel.org/lkml/20200305062138.GI5972@shao2-debian/

patch1: a cleanup for /proc/meminfo
patch2: a preparation patch which also improve the accuracy of
        vm_memory_committed
patch3: main change


This patch (of 3):

Use the existing vm_memory_committed() instead, which is also convenient
for future change.

Link: http://lkml.kernel.org/r/1592725000-73486-1-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1592725000-73486-2-git-send-email-feng.tang@intel.com
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

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/meminfo.c~proc-meminfo-avoid-open-coded-reading-of-vm_committed_as
+++ a/fs/proc/meminfo.c
@@ -41,7 +41,7 @@ static int meminfo_proc_show(struct seq_
 
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = percpu_counter_read_positive(&vm_committed_as);
+	committed = vm_memory_committed();
 
 	cached = global_node_page_state(NR_FILE_PAGES) -
 			total_swapcache_pages() - i.bufferram;
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-utilc-make-vm_memory_committed-more-accurate.patch
mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch
