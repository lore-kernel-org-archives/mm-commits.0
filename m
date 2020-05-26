From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures]
 mm-utilc-make-vm_memory_committed-more-accurate.patch removed from -mm tree
Date: Tue, 26 May 2020 14:18:31 -0700
Message-ID: <20200526211831.HrglLmcbI%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390009AbgEZVSc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 May 2020 17:18:32 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi.kleen@intel.com, dave.hansen@intel.com, feng.tang@intel.com, hannes@cmpxchg.org, keescook@chromium.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, tim.c.chen@intel.com, willy@infradead.org, ying.huang@intel.com


The patch titled
     Subject: mm/util.c: make vm_memory_committed() more accurate
has been removed from the -mm tree.  Its filename was
     mm-utilc-make-vm_memory_committed-more-accurate.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/util.c: make vm_memory_committed() more accurate

percpu_counter_sum_positive() will provide more accurate info.

As with percpu_counter_read_positive(), in worst case the deviation could
be 'batch * nr_cpus', which is totalram_pages/256 for now, and will be
more when the batch gets enlarged.

Its time cost is about 800 nanoseconds on a 2C/4T platform and 2~3
microseconds on a 2S/36C/72T server in normal case, and in worst case
where vm_committed_as's spinlock is under severe contention, it costs
30~40 microseconds for the 2S/36C/72T sever, which should be fine for its
only two users: /proc/meminfo and HyperV balloon driver's status trace per
second.

Link: http://lkml.kernel.org/r/1589611660-89854-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-utilc-make-vm_memory_committed-more-accurate
+++ a/mm/util.c
@@ -790,7 +790,7 @@ struct percpu_counter vm_committed_as __
  */
 unsigned long vm_memory_committed(void)
 {
-	return percpu_counter_read_positive(&vm_committed_as);
+	return percpu_counter_sum_positive(&vm_committed_as);
 }
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch
