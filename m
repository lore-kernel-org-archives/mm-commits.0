From: akpm@linux-foundation.org
Subject: [merged] memcg-only-free-spare-array-when-readers-are-done.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:28 -0800
Message-ID: <569e9924.TSnFP5sO1ENyzO6P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maco@google.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: only free spare array when readers are done
has been removed from the -mm tree.  Its filename was
     memcg-only-free-spare-array-when-readers-are-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martijn Coenen <maco@google.com>
Subject: memcg: only free spare array when readers are done

A spare array holding mem cgroup threshold events is kept around
to make sure we can always safely deregister an event and have an
array to store the new set of events in.

In the scenario where we're going from 1 to 0 registered events, the
pointer to the primary array containing 1 event is copied to the spare
slot, and then the spare slot is freed because no events are left.
However, it is freed before calling synchronize_rcu(), which means
readers may still be accessing threshold->primary after it is freed.

Fixed by only freeing after synchronize_rcu().

Signed-off-by: Martijn Coenen <maco@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-only-free-spare-array-when-readers-are-done mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-only-free-spare-array-when-readers-are-done
+++ a/mm/memcontrol.c
@@ -3491,16 +3491,17 @@ static void __mem_cgroup_usage_unregiste
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
-	/* If all events are unregistered, free the spare array */
-	if (!new) {
-		kfree(thresholds->spare);
-		thresholds->spare = NULL;
-	}
 
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */
 	synchronize_rcu();
+
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
 unlock:
 	mutex_unlock(&memcg->thresholds_lock);
 }
_

Patches currently in -mm which might be from maco@google.com are


