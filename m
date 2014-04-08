From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:51:28 -0700
Message-ID: <53446150.JI13O/mHunRptnlt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbaDHUva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:51:28 -0700


The patch titled
     Subject: mm: memcg: push !mm handling out to page cache charge function
has been removed from the -mm tree.  Its filename was
     mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: push !mm handling out to page cache charge function

Only page cache charges can happen without an mm context, so push this
special case out of the inner core and into the cache charge function.

An ancient comment explains that the mm can also be NULL in case the task
is currently being migrated, but that is not actually true with the
current case, so just remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-push-mm-handling-out-to-page-cache-charge-function mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-push-mm-handling-out-to-page-cache-charge-function
+++ a/mm/memcontrol.c
@@ -2703,15 +2703,6 @@ static int __mem_cgroup_try_charge(struc
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!*ptr && !mm)
-		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -4038,6 +4029,12 @@ int mem_cgroup_cache_charge(struct page
 		return 0;
 
 	if (!PageSwapCache(page)) {
+		/*
+		 * Page cache insertions can happen without an actual
+		 * task context, e.g. during disk probing on boot.
+		 */
+		if (!mm)
+			memcg = root_mem_cgroup;
 		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
 		if (ret != -ENOMEM)
 			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

