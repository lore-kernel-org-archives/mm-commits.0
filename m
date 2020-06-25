From: akpm@linux-foundation.org
Subject: + mm-utilc-make-vm_memory_committed-more-accurate.patch
 added to -mm tree
Date: Thu, 25 Jun 2020 16:45:33 -0700
Message-ID: <20200625234533.3aXyt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgFYXpf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, willy@infradead.org, tim.c.chen@intel.com, mhocko@suse.com, mgorman@suse.de, kys@microsoft.com, hannes@cmpxchg.org, haiyangz@microsoft.com, dave.hansen@intel.com, andi.kleen@intel.com, feng.tang@intel.com


The patch titled
     Subject: mm/util.c: make vm_memory_committed() more accurate
has been added to the -mm tree.  Its filename is
     mm-utilc-make-vm_memory_committed-more-accurate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-make-vm_memory_committed-more-accurate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-make-vm_memory_committed-more-accurate.patch

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
Subject: mm/util.c: make vm_memory_committed() more accurate

percpu_counter_sum_positive() will provide more accurate info.

As with percpu_counter_read_positive(), in worst case the deviation could
be 'batch * nr_cpus', which is totalram_pages/256 for now, and will be
more when the batch gets enlarged.

Its time cost is about 800 nanoseconds on a 2C/4T platform and 2~3
microseconds on a 2S/36C/72T Skylake server in normal case, and in worst
case where vm_committed_as's spinlock is under severe contention, it costs
30~40 microseconds for the 2S/36C/72T Skylake sever, which should be fine
for its only two users: /proc/meminfo and HyperV balloon driver's status
trace per second.

Link: http://lkml.kernel.org/r/1592725000-73486-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com> # for /proc/meminfo
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-utilc-make-vm_memory_committed-more-accurate
+++ a/mm/util.c
@@ -787,10 +787,15 @@ struct percpu_counter vm_committed_as __
  * balancing memory across competing virtual machines that are hosted.
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
+ *
+ * The time cost of this is very low for small platforms, and for big
+ * platform like a 2S/36C/72T Skylake server, in worst case where
+ * vm_committed_as's spinlock is under severe contention, the time cost
+ * could be about 30~40 microseconds.
  */
 unsigned long vm_memory_committed(void)
 {
-	return percpu_counter_read_positive(&vm_committed_as);
+	return percpu_counter_sum_positive(&vm_committed_as);
 }
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
_

Patches currently in -mm which might be from feng.tang@intel.com are

proc-meminfo-avoid-open-coded-reading-of-vm_committed_as.patch
mm-utilc-make-vm_memory_committed-more-accurate.patch
mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy.patch
