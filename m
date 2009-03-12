From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-documentation-v5.patch added to -mm tree
Date: Thu, 12 Mar 2009 16:34:35 -0700
Message-ID: <200903122334.n2CNYaku017761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbZCLXkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 19:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, riel@redhat.com, yamamoto@valinux.co.jp


The patch titled
     Memory controller soft limit documentation
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-documentation-v5.patch

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
Subject: Memory controller soft limit documentation
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Soft limits is a new feature for the memory resource controller, something
similar has existed in the group scheduler in the form of shares.  The CPU
controllers interpretation of shares is very different though.  

Soft limits are the most useful feature to have for environments where the
administrator wants to overcommit the system, such that only on memory
contention do the limits become active.  The current soft limits
implementation provides a soft_limit_in_bytes interface for the memory
controller and not for memory+swap controller.  The implementation
maintains an RB-Tree of groups that exceed their soft limit and starts
reclaiming from the group that exceeds this limit by the maximum amount.

Kamezawa-San has another patchset for soft limits, but I don't like the
reclaim logic of watermark based balancing of zones for global memory
cgroup limits.  I also don't like the data structures, a list does not
scale well.  Kamezawa's objection to this patch is the cost of sorting,
which is really negligible, since the updates happen at a fixed interval
(curently four times a second).  I however do like the priority feature in
Kamezawa's patchset.  The feature can be easily adopted to this
incrementally.

TODOs

1. The current implementation maintains the delta from the soft limit
   and pushes back groups to their soft limits, a ratio of delta/soft_limit
   might be more useful
2. It would be nice to have more targetted reclaim (in terms of pages to
   recalim) interface. So that groups are pushed back, close to their soft
   limits.

Tests
-----

I've run two memory intensive workloads with differing soft limits and
seen that they are pushed back to their soft limit on contention.  Their
usage was their soft limit plus additional memory that they were able to
grab on the system.  Soft limit can take a while before we see the
expected results.

The other tests I've run are
1. Deletion of groups while soft limit is in progress in the hierarchy
2. Setting the soft limit to zero and running other groups with non-zero
   soft limits.
3. Setting the soft limit to zero and testing if the mem cgroup is able
   to use available memory


This patch:

Add documentation for the new feature.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   31 ++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memory-controller-soft-limit-documentation-v5 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memory-controller-soft-limit-documentation-v5
+++ a/Documentation/cgroups/memory.txt
@@ -360,7 +360,36 @@ cgroups created below it.
 
 NOTE2: This feature can be enabled/disabled per subtree.
 
-7. TODO
+7. Soft limits
+
+Soft limits allow for greater sharing of memory. The idea behind soft limits
+is to allow control groups to use as much of the memory as needed, provided
+
+a. There is no memory contention
+b. They do not exceed their hard limit
+
+When the system detects memory contention or low memory control groups
+are pushed back to their soft limits. If the soft limit of each control
+group is very high, they are pushed back as much as possible to make
+sure that one control group does not starve the others of memory.
+
+7.1 Interface
+
+Soft limits can be setup by using the following commands (in this example we
+assume a soft limit of 256 megabytes)
+
+# echo 256M > memory.soft_limit_in_bytes
+
+If we want to change this to 1G, we can at any time use
+
+# echo 1G > memory.soft_limit_in_bytes
+
+NOTE1: Soft limits take effect over a long period of time, since they involve
+       reclaiming memory for balancing between memory cgroups
+NOTE2: It is recommended to set the soft limit always below the hard limit,
+       otherwise the hard limit will take precedence.
+
+8. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
memcg-charge-swapcache-to-proper-memcg.patch
memory-controller-soft-limit-documentation-v5.patch
memory-controller-soft-limit-interface-v5.patch
memory-controller-soft-limit-organize-cgroups-v5.patch
memory-controller-soft-limit-reclaim-on-contention-v5.patch

