From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-thresholds-for-32b-architectures.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:16 -0800
Message-ID: <563d0acc.iMeYhTWGoSg9zPDF%akpm__46789.1004322611$1446841062$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161895AbbKFURR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ben@decadent.org.uk, hannes@cmpxchg.org, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix thresholds for 32b architectures.
has been removed from the -mm tree.  Its filename was
     memcg-fix-thresholds-for-32b-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: fix thresholds for 32b architectures.

424cdc141380 ("memcg: convert threshold to bytes") has fixed a regression
introduced by 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
where thresholds were silently converted to use page units rather than
bytes when interpreting the user input.

The fix is not complete, though, as properly pointed out by Ben Hutchings
during stable backport review.  The page count is converted to bytes but
unsigned long is used to hold the value which would be obviously not
sufficient for 32b systems with more than 4G thresholds.  The same applies
to usage as taken from mem_cgroup_usage which might overflow.

Let's remove this bytes vs.  pages internal tracking differences and
handle thresholds in page units internally.  Chage mem_cgroup_usage() to
return the value in page units and revert 424cdc141380 because this should
be sufficient for the consistent handling.  mem_cgroup_read_u64 as the
only users of mem_cgroup_usage outside of the threshold handling code is
converted to give the proper in bytes result.  It is doing that already
for page_counter output so this is more consistent as well.

The value presented to the userspace is still in bytes units.

Fixes: 424cdc141380 ("memcg: convert threshold to bytes")
Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures
+++ a/mm/memcontrol.c
@@ -2836,9 +2836,9 @@ static unsigned long tree_stat(struct me
 	return val;
 }
 
-static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
-	u64 val;
+	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
 		val = tree_stat(memcg, MEM_CGROUP_STAT_CACHE);
@@ -2851,7 +2851,7 @@ static inline u64 mem_cgroup_usage(struc
 		else
 			val = page_counter_read(&memcg->memsw);
 	}
-	return val << PAGE_SHIFT;
+	return val;
 }
 
 enum {
@@ -2885,9 +2885,9 @@ static u64 mem_cgroup_read_u64(struct cg
 	switch (MEMFILE_ATTR(cft->private)) {
 	case RES_USAGE:
 		if (counter == &memcg->memory)
-			return mem_cgroup_usage(memcg, false);
+			return (u64)mem_cgroup_usage(memcg, false) * PAGE_SIZE;
 		if (counter == &memcg->memsw)
-			return mem_cgroup_usage(memcg, true);
+			return (u64)mem_cgroup_usage(memcg, true) * PAGE_SIZE;
 		return (u64)page_counter_read(counter) * PAGE_SIZE;
 	case RES_LIMIT:
 		return (u64)counter->limit * PAGE_SIZE;
@@ -3387,7 +3387,6 @@ static int __mem_cgroup_usage_register_e
 	ret = page_counter_memparse(args, "-1", &threshold);
 	if (ret)
 		return ret;
-	threshold <<= PAGE_SHIFT;
 
 	mutex_lock(&memcg->thresholds_lock);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-fs-introduce-mapping_gfp_constraint.patch

