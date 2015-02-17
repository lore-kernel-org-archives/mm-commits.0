From: akpm@linux-foundation.org
Subject: + memcg-fix-low-limit-calculation.patch added to -mm tree
Date: Tue, 17 Feb 2015 15:18:07 -0800
Message-ID: <54e3cc2f.s6cPGsKN0Hq0YzLb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbbBQXSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 18:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, js1304@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix low limit calculation
has been added to the -mm tree.  Its filename is
     memcg-fix-low-limit-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-low-limit-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-low-limit-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: fix low limit calculation

A memcg is considered low limited even when the current usage is equal to
the low limit.  This leads to interesting side effects e.g. 
groups/hierarchies with no memory accounted are considered protected and
so the reclaim will emit MEMCG_LOW event when encountering them.

Another and much bigger issue was reported by Joonsoo Kim.  He has hit a
NULL ptr dereference with the legacy cgroup API which even doesn't have
low limit exposed.  The limit is 0 by default but the initial check fails
for memcg with 0 consumption and parent_mem_cgroup() would return NULL if
use_hierarchy is 0 and so page_counter_read would try to dereference NULL.

I suppose that the current implementation is just an overlook because the
documentation in Documentation/cgroups/unified-hierarchy.txt says:

  "The memory.low boundary on the other hand is a top-down allocated
  reserve.  A cgroup enjoys reclaim protection when it and all its
  ancestors are below their low boundaries"

Fix the usage and the low limit comparision in mem_cgroup_low accordingly.

Fixes: 241994ed8649 (mm: memcontrol: default hierarchy interface for memory)
Reported-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-low-limit-calculation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-low-limit-calculation
+++ a/mm/memcontrol.c
@@ -5426,7 +5426,7 @@ bool mem_cgroup_low(struct mem_cgroup *r
 	if (memcg == root_mem_cgroup)
 		return false;
 
-	if (page_counter_read(&memcg->memory) > memcg->low)
+	if (page_counter_read(&memcg->memory) >= memcg->low)
 		return false;
 
 	while (memcg != root) {
@@ -5435,7 +5435,7 @@ bool mem_cgroup_low(struct mem_cgroup *r
 		if (memcg == root_mem_cgroup)
 			break;
 
-		if (page_counter_read(&memcg->memory) > memcg->low)
+		if (page_counter_read(&memcg->memory) >= memcg->low)
 			return false;
 	}
 	return true;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-fix-low-limit-calculation.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

